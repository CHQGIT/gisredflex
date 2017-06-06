package widgets.PowerOn.busqueda
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import flash.globalization.DateTimeFormatter;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	import widgets.PowerOn.GlobalPowerOn;
	import widgets.PowerOn.urls.Urls;

	public class BusquedaDatosOrdenPorCliente
	{
		public var dateFormatter:DateTimeFormatter;
		public var orden:Object;
		
		public function BusquedaDatosOrdenPorCliente()
		{
			this.dateFormatter=new DateTimeFormatter("dd/MM/yy '-' HH:mm");
		}
		
		public function ejecutar(orden:Object):void
		{
			this.orden = orden;
			var idOrden:String = orden.attributes["id_orden"];
			var ordenTask:QueryTask = new QueryTask();
			ordenTask.url = Urls.POWERON_ORDENES;
			ordenTask.useAMF = false;
			var ordenQ:Query = new Query();
			ordenQ.outFields = ["*"];
			ordenQ.returnGeometry = false;
			ordenQ.where = "id_orden = '" + idOrden +
				"' and id_owned NOT IN (1, 170, 228)" +
				" and estado_orden IN  ('arrived','dispatched','en_route','in_progress','new','ready','suspended')";
			ordenTask.execute(ordenQ, new AsyncResponder(resultOrden, faultOrden));
		}
		
		private function resultOrden(setOrdenes:FeatureSet, token:Object = null):void  
		{   
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
			
			setOrdenes.features[0].attributes["afectado"] = "Cliente";
			setOrdenes.features[0].attributes["clientes_transformador"] = "-";
			setOrdenes.features[0].attributes["total_afectados"] = 1;
			setOrdenes.features[0].attributes["nis"] =  orden.attributes["nis"];			
			GlobalPowerOn.managerOrdenes.agregarElemento(setOrdenes.features[0].attributes);
		}
		
		private function faultOrden(info:Object, token:Object = null):void
		{  
			Alert.show("No se pudo cargar el set de Ordenes:\n"+ info.toString());
		}
	}
}