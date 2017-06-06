package widgets.Interrupciones.servicios.interrupciones
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.utils.StringUtil;
	
	import comun.util.zalerta.ZAlerta;
	
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.servicios.BusquedaInterrupcionComun;
	import widgets.Interrupciones.servicios.UtilWhere;
	import widgets.Interrupciones.urls.Urls;

	public class BusquedaInterrupciones
	{
		public var callBackOk:Function;
		public var callBackError:Function;
		
		public var resultado:ArrayCollection;
		
		public function BusquedaInterrupciones()
		{
			
		}
		
		public function obtenerArregloPropiedades():Array{
			var propiedades:Array = new Array();
			propiedades.push("interrupcion_id");
			propiedades.push("vl_clientes_afectados");
			propiedades.push("vl_duracion");
			propiedades.push("gl_alimentador");
			propiedades.push("gl_ssee");
			propiedades.push("gl_clasif_interrupcion_emp");
			propiedades.push("gl_clasif_causa_sec");
			propiedades.push("gl_causa_sec");
			propiedades.push("vl_trafo_interrumpidos");
			propiedades.push("bloque_reposicion_id");
			return propiedades;
		}
		
		/*
		http://gisred.chilquinta.cl:5555/arcgis/rest/services/Interrupciones/Interrupciones_clientes/MapServer/4/query
		*/
		public function buscar(callBackOk:Function,callBackError:Function,arrayPeriodo:ArrayCollection,causa:String):void{
			this.callBackError=callBackError;
			this.callBackOk=callBackOk;
			
			var query:Query = new Query();
			query.outFields=obtenerArregloPropiedades();
			//TODO: hardcodeado por ahora
			query.outSpatialReference= new SpatialReference(102100);
			
			var condicionPeriodo:String=UtilWhere.periodoAWhereInterrupcion(arrayPeriodo);
			
			var condicionCausa:String="";
			
			
			if (causa!=null){
				
				/* TODO: Arreglar...
				if (causa=="Interno + Fuerza Mayor"){
					condicionCausa= " gl_clasif_interrupcion_emp in ('Interno','Fuerza Mayor')";
				}
				else{
					condicionCausa= " gl_clasif_interrupcion_emp in (' "+causa+"')";
				}
				//condicionPeriodo=" and "+condicionCausa;
				condicionPeriodo=" "+condicionCausa;
				*/
			}
			
			// TODO: ACA PONER EL IN de los ids....
			query.where=condicionPeriodo;
			query.returnGeometry = false;
			//query.orderByFields = new Array("nombre asc");
			
			var queryTask:QueryTask = new QueryTask();
			queryTask.showBusyCursor = true;
			
			queryTask.url=Urls.URL_INTERRUPCIONES;
		//	queryTask.token="_zmYF3PlUzzAtyzA9TggDvN6vBP9vX558R7uqN3ajG3sQTevsamsvf3eNFpe47TY";
			queryTask.useAMF=false;
			
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
		}
		
		
		private function onResult(featureSet:FeatureSet, token:Object = null):void
		{
			resultado=new ArrayCollection;
			
			if (featureSet.features.length == 0){
				callBackOk(resultado);
				return;
			}
			
			for (var i:Number=0;i<featureSet.features.length;i++){
				
				var g:Graphic = featureSet.features[i] as Graphic;
				
				var idInterrupcion:String=g.attributes["interrupcion_id"];
				var afectados:Number=Number(g.attributes["vl_clientes_afectados"]);
				var duracion:Number=Number(g.attributes["vl_duracion"]);
				
				var alimentador:String=g.attributes["gl_alimentador"];
				var ssee:String=g.attributes["gl_ssee"];
				var causa1:String=g.attributes["gl_clasif_interrupcion_emp"];
				var causa2:String=g.attributes["gl_clasif_causa_sec"];
				var causa3:String=g.attributes["gl_causa_sec"];
				var transformadoresInterrumpidos:String=g.attributes["vl_trafo_interrumpidos"];
				var bloque:String=g.attributes["bloque_reposicion_id"];
				
				var dtoInterrupcion:DtoInterrupcion=new DtoInterrupcion;
				dtoInterrupcion.idInterrupcion=idInterrupcion;
				dtoInterrupcion.afectados=afectados;
				dtoInterrupcion.duracion=duracion;
				
				dtoInterrupcion.alimentador=alimentador;
				dtoInterrupcion.ssee=ssee;
				dtoInterrupcion.causa1=causa1;
				dtoInterrupcion.causa2=causa2;
				dtoInterrupcion.causa3=causa3;
				dtoInterrupcion.transformadoresInterrumpidos=transformadoresInterrumpidos;
				dtoInterrupcion.bloque=bloque;
				
				resultado.addItem(dtoInterrupcion);
			}
			callBackOk(resultado);
		}
		
		public function buscarPorId(callBackOk:Function,callBackError:Function,queryString:String):void{
			this.callBackError=callBackError;
			this.callBackOk=callBackOk;
			
			var query:Query = new Query();
			var propiedades:Array = new Array();
			propiedades.push("id_interrupcion");
			
			query.outFields=propiedades;
			//TODO: hardcodeado por ahora
			query.outSpatialReference= new SpatialReference(102100);
			
			query.where=queryString;
			query.returnGeometry = false;
			
			var queryTask:QueryTask = new QueryTask();
			queryTask.showBusyCursor = true;

			if (queryString.search("nis=")!=-1){
				queryTask.url=Urls.URL_INTERRUPCIONES_CLIENTES;
				Global.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_CLIENTE;
			}
			else if (queryString.search("sed=")!=-1){
				queryTask.url=Urls.URL_INTERRUPCIONES_SED;
				Global.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_SED;
			}
			else{
				ZAlerta.show("error !!!"+queryString);				
			}
			
			queryTask.useAMF=false;
			
			queryTask.execute(query, new AsyncResponder(onResultOtroWidget, onFaultOtro));
		}
		
		private function onResultOtroWidget(featureSet:FeatureSet, token:Object = null):void
		{
			var ids:ArrayCollection=new ArrayCollection;
			
			if (featureSet.features.length == 0){
				callBackOk(resultado);
				return;
			}
			
			for (var i:Number=0;i<featureSet.features.length;i++){
				
				var g:Graphic = featureSet.features[i] as Graphic;
				
				var idInterrupcion:String=g.attributes["id_interrupcion"];
				
				ids.addItem(idInterrupcion);
			}
			buscarInterrupcionesPorId(ids);
		}
		
		
		private function onFaultOtro(info:Object, token:Object = null):void
		{
			ZAlerta.show("Error otro!!!"+info);
		}
		
		public function buscarInterrupcionesPorId(ids:ArrayCollection):void{
			
			var query:Query = new Query();
			query.outFields=obtenerArregloPropiedades();
			//TODO: hardcodeado por ahora
			query.outSpatialReference= new SpatialReference(102100);
			
			var condicionCausa:String="";
			
			
		/*	if (causa!=null){
				
				 TODO: Arreglar...
				if (causa=="Interno + Fuerza Mayor"){
				condicionCausa= " gl_clasif_interrupcion_emp in ('Interno','Fuerza Mayor')";
				}
				else{
				condicionCausa= " gl_clasif_interrupcion_emp in (' "+causa+"')";
				}
				//condicionPeriodo=" and "+condicionCausa;
				condicionPeriodo=" "+condicionCausa;
			}
			*/
				
			var condicion:String=UtilWhere.idInterrupcionAWhere(ids);
			// TODO: ACA PONER EL IN de los ids....
			query.where=condicion;
			query.returnGeometry = false;
			//query.orderByFields = new Array("nombre asc");
			
			var queryTask:QueryTask = new QueryTask();
			queryTask.showBusyCursor = true;
			
			queryTask.url=Urls.URL_INTERRUPCIONES;
			//	queryTask.token="_zmYF3PlUzzAtyzA9TggDvN6vBP9vX558R7uqN3ajG3sQTevsamsvf3eNFpe47TY";
			queryTask.useAMF=false;
			
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
		}
		
		private function onFault(info:Object, token:Object = null):void
		{
			callBackError("error" +info);
		}
	}
}