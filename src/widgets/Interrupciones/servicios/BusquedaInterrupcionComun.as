package widgets.Interrupciones.servicios
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	import com.esri.ags.tasks.supportClasses.StatisticDefinition;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	
	import widgets.Interrupciones.busqueda.FiltrosSeleccionadosBusqueda;
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.urls.Urls;

	public class BusquedaInterrupcionComun
	{
		public static var TIPO_BUSQUEDA_ZONA:Number=0;
		public static var TIPO_BUSQUEDA_ALIMENTADOR:Number=1;
		public static var TIPO_BUSQUEDA_SSEE:Number=2;
		public static var TIPO_BUSQUEDA_COMUNA:Number=3;
		public static var TIPO_BUSQUEDA_POR_INTERRUPCION:Number=4;
		
		public static var TIPO_RESULTADO_BUSQUEDA_CLIENTE:Number=0;
		public static var TIPO_RESULTADO_BUSQUEDA_SED:Number=1;
		
		public var query:Query;
		
		public function BusquedaInterrupcionComun()
		{
		}
		
		public  function busquedaAgrupada(onResult: Function, onFault: Function, filtrosSeleccionadosBusqueda:FiltrosSeleccionadosBusqueda,tipoBusqueda:Number,bloqueUno:Boolean):void{
			var otraCondicion:String="";
			var propiedad:String="";
			
			var arrayPeriodo:ArrayCollection=filtrosSeleccionadosBusqueda.arrayPeriodoFecha;
			var listaZona:ArrayCollection;
			
			if (tipoBusqueda==TIPO_BUSQUEDA_ZONA){
				listaZona=filtrosSeleccionadosBusqueda.arrayZona;
				otraCondicion=UtilWhere.zonaAWhere(listaZona);
				propiedad="zona";
			}

			else if (tipoBusqueda==TIPO_BUSQUEDA_ALIMENTADOR){
				listaZona=filtrosSeleccionadosBusqueda.arrayAlimentador;
				otraCondicion=UtilWhere.alimentadorWhere(listaZona);
				propiedad="alimentador";
			}
			
			else if (tipoBusqueda==TIPO_BUSQUEDA_SSEE){
				listaZona=filtrosSeleccionadosBusqueda.arraySSEE;
				otraCondicion=UtilWhere.sseeAWhere(listaZona);
				propiedad="ssee";
			}
			else if (tipoBusqueda==TIPO_BUSQUEDA_COMUNA){
				listaZona=filtrosSeleccionadosBusqueda.arrayComuna;
				otraCondicion=UtilWhere.comunaWhere(listaZona);
				propiedad="comuna";
			}
			else if (tipoBusqueda==TIPO_BUSQUEDA_POR_INTERRUPCION){
				otraCondicion=" id_interrupcion = '"+filtrosSeleccionadosBusqueda.idInterrupcion+"'";
				propiedad="id_interrupcion";
			}
			
			var campoOrden:String="";
			
			if (filtrosSeleccionadosBusqueda.ordenResultados==FiltrosSeleccionadosBusqueda.ORDEN_DURACION){
				campoOrden="duracionNis DESC";
			}
			else if (filtrosSeleccionadosBusqueda.ordenResultados==FiltrosSeleccionadosBusqueda.ORDEN_FRECUENCIA){
				campoOrden="frecuenciaNis DESC";
			}
			
			var causa:String=null;
			
			if (Global.tipoBusquedaCliente()){
				causa=filtrosSeleccionadosBusqueda.generarCausa();
			}
			else if(Global.tipoBusquedaSed()){
				causa=null;
			}
			
			Global.log("causa: "+causa);
			busqueda(onResult,onFault,propiedad,arrayPeriodo,otraCondicion,campoOrden,causa,bloqueUno);
		}
		
		private  function busqueda(onResult: Function, onFault: Function,propiedad:String,arrayPeriodo:ArrayCollection,otraCondicion:String,campoOrden:String,causa:String,bloqueUno:Boolean):void{
			var propiedades:Array = new Array();
			propiedades.push("duracion");
			propiedades.push("nis");
			
			if (Global.tipoResultadosBusqueda==TIPO_RESULTADO_BUSQUEDA_SED){
				propiedades.push("tipo_emp");
			}
			
			if (bloqueUno){
				propiedades.push("bloque");
			}
			
			propiedades.push(propiedad);
			
			query=new Query;
			
			query.outFields=propiedades;
			//TODO: hardcodeado por ahora
			query.outSpatialReference= new SpatialReference(102100);
			query.returnGeometry=false;
			
			var condiciones:ArrayCollection=new ArrayCollection;
			
			var condicionPeriodo:String=UtilWhere.periodoAWhere(arrayPeriodo);
			
			if (condicionPeriodo!=null){
				condiciones.addItem(condicionPeriodo);
			}
			
			if (otraCondicion!=null){
				condiciones.addItem(otraCondicion);
			}
			
			if (causa!=null){
				condiciones.addItem(causa);
			}
			
			if (bloqueUno){
				condiciones.addItem("bloque='1'");
			}
			
			query.where = UtilWhere.concatenaCondiciones(condiciones);
			
			var statsDef1:StatisticDefinition=null;
			var statsDef2:StatisticDefinition=null;
			var queryTask:QueryTask=null;
			
			if (Global.tipoResultadosBusqueda==TIPO_RESULTADO_BUSQUEDA_CLIENTE){
				statsDef1 = new StatisticDefinition();
				statsDef1.onStatisticField = "nis";
				statsDef1.outStatisticFieldName = "frecuenciaNis";
				statsDef1.statisticType = StatisticDefinition.TYPE_COUNT;
				
				statsDef2 = new StatisticDefinition();
				statsDef2.onStatisticField = "duracion";
				statsDef2.outStatisticFieldName = "duracionNis";
				statsDef2.statisticType = StatisticDefinition.TYPE_SUMMATION;
				
				query.groupByFieldsForStatistics = [propiedad, "nis"];
				query.outStatistics = [ statsDef1,statsDef2];
				query.outFields=[propiedad,"nis"];
			    query.orderByFields=[campoOrden];
				
				queryTask = new QueryTask();
				queryTask.showBusyCursor = true;
				
				queryTask.url=Urls.URL_INTERRUPCIONES_CLIENTES;
				queryTask.useAMF=false;
				
				Global.log("antes de query "+campoOrden);
				
				queryTask.execute(query, new AsyncResponder(onResult, onFault));
			}
			else if (Global.tipoResultadosBusqueda==TIPO_RESULTADO_BUSQUEDA_SED){
				statsDef1 = new StatisticDefinition();
				statsDef1.onStatisticField = "sed";
				statsDef1.outStatisticFieldName = "frecuenciaNis";
				statsDef1.statisticType = StatisticDefinition.TYPE_COUNT;
				
				statsDef2 = new StatisticDefinition();
				statsDef2.onStatisticField = "duracion";
				statsDef2.outStatisticFieldName = "duracionNis";
				statsDef2.statisticType = StatisticDefinition.TYPE_SUMMATION;
				
				query.groupByFieldsForStatistics = [propiedad, "sed","tipo_emp"];
				query.outStatistics = [ statsDef1,statsDef2];
				query.outFields=[propiedad,"sed","tipo_emp"];
		    	query.orderByFields=[campoOrden];
				
				queryTask  = new QueryTask();
				queryTask.showBusyCursor = true;
				
				queryTask.url=Urls.URL_INTERRUPCIONES_SED;
				queryTask.useAMF=false;
				queryTask.execute(query, new AsyncResponder(onResult, onFault));
			}
		}
	}
}