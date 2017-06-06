package widgets.PowerOn.busqueda
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import flash.globalization.DateTimeFormatter;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	import comun.util.zalerta.ZAlerta;
	
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.servicios.BusquedaTipos;
	import widgets.PowerOn.GlobalPowerOn;

	public class BusquedaDatosOrdenPorTransformador
	{
		public var dateFormatter:DateTimeFormatter;
		
		public function BusquedaDatosOrdenPorTransformador()
		{
			this.dateFormatter=new DateTimeFormatter("dd/MM/yy '-' HH:mm");
			
		}
		
		public function onResultX(r:ArrayCollection):void{
			ZAlerta.show("ok");

		}
		
		public function onFaultX(mensaje:String):void{
			ZAlerta.show("error");
		}
		
		
		public function ejecutar(objeto:Object):void{
			//var busquedaTipos:BusquedaTipos=new BusquedaTipos;
			//busquedaTipos.buscar( onResultX, onFaultX );
			
			var idOrden:String = objeto.attributes["id_orden"];
			var ordenTransTask:QueryTask = new QueryTask();
			//ordenTransTask.url = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Interrupciones/Interrupciones_clientes/MapServer/6";
			ordenTransTask.url = "http://gisred.chilquinta/arcgis/rest/services/Interrupciones/Interrupciones_clientes/MapServer/6";
			ordenTransTask.useAMF = false;
			var ordenTrans:Query = new Query();
			
			ordenTrans.outFields = ["*"];
			ordenTrans.returnGeometry = false;
			ordenTrans.where = "id_orden = '" + idOrden + 
				"' and id_owned NOT IN (1, 170, 228)" +
				" and estado_orden IN  ('arrived','dispatched','en_route','in_progress','new','ready','suspended')";
			//sacar columna tipo orden
			ordenTransTask.execute(ordenTrans, new AsyncResponder(resultOrdenTrans, faultOrdenTrans));
		}
		
		private function resultOrdenTrans(setOrdenes:FeatureSet, token:Object = null):void  
		{   
			var total_clientes_afectados:Number;
			
			if (setOrdenes.features[0].attributes["fecha_creacion"] != '-2208988800000'){
				setOrdenes.features[0].attributes["fecha_creacion"] = dateFormatter.format(new Date(setOrdenes.features[0].attributes["fecha_creacion"]));	
			} else {
				setOrdenes.features[0].attributes["fecha_creacion"] = "-";
			}
			
			if (setOrdenes.features[0].attributes["fecha_despacho"] != '-2208988800000'){
				setOrdenes.features[0].attributes["fecha_despacho"] = dateFormatter.format(new Date(setOrdenes.features[0].attributes["fecha_despacho"]));	
			} else {
				setOrdenes.features[0].attributes["fecha_despacho"] = "-";
			}
			
			if (setOrdenes.features[0].attributes["fecha_asignacion"] != '-2208988800000'){
				setOrdenes.features[0].attributes["fecha_asignacion"] = dateFormatter.format(new Date(setOrdenes.features[0].attributes["fecha_asignacion"]));	
			} else {
				setOrdenes.features[0].attributes["fecha_asignacion"] = "-";
			}
			
			if (setOrdenes.features[0].attributes["fecha_ruta"] != '-2208988800000'){
				setOrdenes.features[0].attributes["fecha_ruta"] = dateFormatter.format(new Date(setOrdenes.features[0].attributes["fecha_ruta"]));	
			} else {
				setOrdenes.features[0].attributes["fecha_ruta"] = "-";
			}
			
			if (setOrdenes.features[0].attributes["fecha_llegada"] != '-2208988800000'){
				setOrdenes.features[0].attributes["fecha_llegada"] = dateFormatter.format(new Date(setOrdenes.features[0].attributes["fecha_llegada"]));	
			} else {
				setOrdenes.features[0].attributes["fecha_llegada"] = "-";
			}
			
			if (setOrdenes.features[0].attributes["fc_termino_t"] != '-2208988800000'){
				setOrdenes.features[0].attributes["fc_termino_t"] = dateFormatter.format(new Date(setOrdenes.features[0].attributes["fc_termino_t"]));	
			} else {
				setOrdenes.features[0].attributes["fc_termino_t"] = "-";
			}
			
			if (setOrdenes.features[0].attributes["fc_cierre"] != '-2208988800000'){
				setOrdenes.features[0].attributes["fc_cierre"] = dateFormatter.format(new Date(setOrdenes.features[0].attributes["fc_cierre"]));	
			} else {
				setOrdenes.features[0].attributes["fc_cierre"] = "-";
			}
			
			if (setOrdenes.features[0].attributes["fc_ult_modif"] != '-2208988800000'){
				setOrdenes.features[0].attributes["fc_ult_modif"] = dateFormatter.format(new Date(setOrdenes.features[0].attributes["fc_ult_modif"]));	
			} else {
				setOrdenes.features[0].attributes["fc_ult_modif"] = "-";
			}
			
			setOrdenes.features[0].attributes["afectado"] = "Transformador";
			
			var countTotalAfectadosTask:QueryTask = new QueryTask();
			//countTotalAfectadosTask.url = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Interrupciones/Interrupciones_clientes/MapServer/7";
			countTotalAfectadosTask.url = "http://gisred.chilquinta/arcgis/rest/services/Interrupciones/Interrupciones_clientes/MapServer/7";
			countTotalAfectadosTask.useAMF = false;
			countTotalAfectadosTask.showBusyCursor = true;
			
			var countTotalAfectados:Query = new Query();
			countTotalAfectados.outFields = ["*"];
			countTotalAfectados.returnGeometry = false;
			countTotalAfectados.where = "id_orden = '" + setOrdenes.features[0].attributes["id_orden"] + "'";
			countTotalAfectadosTask.executeForCount(countTotalAfectados, new AsyncResponder(onCountResult, onCountFault));
			
			function onCountResult(total:Number, token:XMLList = null):void
			{
				setOrdenes.features[0].attributes["total_afectados"] = total;					
			}
			function onCountFault(info:Object, token:Object = null):void
			{
				Alert.show("No se pudo cargar total afectados:\n"+ info.toString());
			}
			
			countTotalAfectadosTask.execute(countTotalAfectados, new AsyncResponder(onCountClientesResult, onCountClientesFault));
			
			function onCountClientesResult(setCountClientes:FeatureSet, token:Object = null):void
			{
				total_clientes_afectados = 0;
				for (var i:Number=0; i < setCountClientes.features.length; i++){
					var countTotalClientesTask:QueryTask = new QueryTask();
					var idTrafo:String = setCountClientes.features[i].attributes["id_trafo"];
					//countTotalClientesTask.url = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Chilquinta_006/ClientesV2/MapServer/0";
					countTotalClientesTask.url = "http://gisred.chilquinta/arcgis/rest/services/Chilquinta_006/ClientesV2/MapServer/0";
					countTotalClientesTask.useAMF = false;
					countTotalClientesTask.showBusyCursor = true;
					
					var countTotalClientes:Query = new Query();
					countTotalClientes.outFields = ["*"];
					countTotalClientes.returnGeometry = false;
					//countTotalClientes.where = "codigo_subestacion = " + idTrafo;
					countTotalClientes.where = "ARCGIS.dbo.CLIENTES_DATA_DATOS_006.resp_id_sed = " + idTrafo;
					
					countTotalClientesTask.executeForCount(countTotalClientes, new AsyncResponder(onCountClientesResult, onCountClientesFault));
					
					function onCountClientesResult(total:Number, token:XMLList = null):void
					{
						total_clientes_afectados = total_clientes_afectados + total;
						setOrdenes.features[0].attributes["clientes_afectados"] = total_clientes_afectados;
						setOrdenes.features[0].attributes["id_trafo"] = idTrafo; //<-- andress
					}
					function onCountClientesFault(info:Object, token:Object = null):void
					{
						Alert.show("No se pudo cargar total clientes afectados:\n"+ info.toString());
					}
				}		
			}
			function onCountClientesFault(info:Object, token:Object = null):void
			{
				Alert.show("No se pudo cargar total clientes afectados:\n"+ info.toString());
			}
			
			GlobalPowerOn.managerOrdenes.agregarElemento(setOrdenes.features[0].attributes);				
		}
		
		private function faultOrdenTrans(info:Object, token:Object = null):void
		{  
			Alert.show("No se pudo cargar el set de Ordenes:\n"+ info.toString());
		}
	}
}