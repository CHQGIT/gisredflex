package widgets.PowerOn.busqueda
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import mx.controls.Alert;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncResponder;
	
	import widgets.Interrupciones.global.Global;
	import widgets.PowerOn.principal.PrincipalPowerOn;
	
	public class Ordenes
	{		
		private var dateFormatter:DateFormatter;
		private var principalPowerOn:PrincipalPowerOn;
		private var fechaformateada:Date;
		private var clientes_transformador:Number;
		private var i:Number;
		private var flag:Boolean = false;
		
		public function Ordenes(dateFormatter:DateFormatter, principalPowerOn:PrincipalPowerOn)
		{
			this.dateFormatter = dateFormatter;
			this.principalPowerOn = principalPowerOn;
		}
		
		protected function listarOrdenes():void
		{
			var origenTask:QueryTask = new QueryTask();
			origenTask.url = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Interrupciones/Interrupciones_clientes/MapServer/6";
			origenTask.showBusyCursor = true;
			origenTask.useAMF = false;
			var origen:Query = new Query();
			
			origen.outFields = ["*"];
			origen.returnGeometry = false;
			origen.where = "id_owned NOT IN (1, 170, 228) " +
				"and estado_orden IN  ('arrived','dispatched','en_route','in_progress','new','ready','suspended')";
			
			origenTask.execute(origen, new AsyncResponder(resultOrigen, faultOrigen));
		}
		
		function resultOrigen(setOrigen:FeatureSet, token:Object = null):void
		{
			for(var y:Number = 0; y < setOrigen.features.length; y++){
				flag = false;
				for each (var o:Object in Global.ordenes.listaOrdenes)
				{
					if (o.id_orden == setOrigen.features[y].attributes["id_orden"])
					{
						flag = true;
					}
				}
				
				if(flag == true){
					principalPowerOn.selIndex.text = principalPowerOn.selIndex.text + "-!-";
				} else {
					fechaformateada = new Date(setOrigen.features[y].attributes["fecha_creacion"]);
					setOrigen.features[y].attributes["fecha_creacion"] = dateFormatter.format(fechaformateada);
					
					fechaformateada = new Date(setOrigen.features[y].attributes["fecha_despacho"]);
					setOrigen.features[y].attributes["fecha_despacho"] = dateFormatter.format(fechaformateada);
					
					fechaformateada = new Date(setOrigen.features[y].attributes["fecha_asignacion"]);
					setOrigen.features[y].attributes["fecha_asignacion"] = dateFormatter.format(fechaformateada);
					
					fechaformateada = new Date(setOrigen.features[y].attributes["fecha_ruta"]);
					setOrigen.features[y].attributes["fecha_ruta"] = dateFormatter.format(fechaformateada);
					
					fechaformateada = new Date(setOrigen.features[y].attributes["fecha_llegada"]);
					setOrigen.features[y].attributes["fecha_llegada"] = dateFormatter.format(fechaformateada);
					
					fechaformateada = new Date(setOrigen.features[y].attributes["fc_termino_t"]);
					setOrigen.features[y].attributes["fc_termino_t"] = dateFormatter.format(fechaformateada);
					
					fechaformateada = new Date(setOrigen.features[y].attributes["fc_cierre"]);
					setOrigen.features[y].attributes["fc_cierre"] = dateFormatter.format(fechaformateada);
					
					fechaformateada = new Date(setOrigen.features[y].attributes["fc_ult_modif"]);
					setOrigen.features[y].attributes["fc_ult_modif"] = dateFormatter.format(fechaformateada);
					
					setOrigen.features[y].attributes["afectado"] = "Origen Falla";							
					
					Global.ordenes.listaOrdenes.addItem(setOrigen.features[y].attributes);	
					principalPowerOn.selIndex.text = principalPowerOn.selIndex.text + " O-";
				}
			}
		}
		
		function faultOrigen(info:Object, token:Object = null):void
		{  
			Alert.show("No se pudo cargar los datos"+ info.toString());
		}
	}
}