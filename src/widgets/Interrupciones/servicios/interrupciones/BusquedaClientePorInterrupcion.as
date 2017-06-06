package widgets.Interrupciones.servicios.interrupciones
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	
	import widgets.Interrupciones.servicios.UtilWhere;
	import widgets.Interrupciones.urls.Urls;

	public class BusquedaClientePorInterrupcion
	{
		public var callBackOk:Function;
		public var callBackError:Function;
		
		public var resultado:ArrayCollection;
		
		public function BusquedaInterrupciones()
		{
			
		}
		
		public function buscar(callBackOk:Function,callBackError:Function,idInterrupcion:String):void{
			this.callBackError=callBackError;
			this.callBackOk=callBackOk;
			
			var propiedades:Array = new Array();
			propiedades.push("interrupcion_id");
			propiedades.push("vl_clientes_afectados");
			propiedades.push("vl_duracion");
			
			var query:Query = new Query();
			query.outFields=propiedades;
			//TODO: hardcodeado por ahora
			query.outSpatialReference= new SpatialReference(102100);
			
			var condicionPeriodo:String=UtilWhere.periodoAWhereInterrupcion(arrayPeriodo);
			
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
				
				var dtoInterrupcion:DtoInterrupcion=new DtoInterrupcion;
				dtoInterrupcion.idInterrupcion=idInterrupcion;
				dtoInterrupcion.afectados=afectados;
				dtoInterrupcion.duracion=duracion;
				
				resultado.addItem(dtoInterrupcion);
			}
			callBackOk(resultado);
		}
		
		private function onFault(info:Object, token:Object = null):void
		{
			callBackError("error" +info);
		}
	}
}