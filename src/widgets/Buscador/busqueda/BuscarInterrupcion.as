package widgets.Buscador.busqueda
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.components.IdentityManager;
	import com.esri.ags.events.IdentityManagerEvent;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.events.FlexEvent;
	import mx.rpc.AsyncResponder;
	
	import spark.components.CheckBox;
	import spark.components.RadioButton;
	import spark.components.TextInput;
	import spark.events.IndexChangeEvent;
	import spark.formatters.DateTimeFormatter;
	
	import comun.util.ZExportarTablaXLSUtil;
	import comun.util.zalerta.ZAlerta;
	
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.urls.Urls;
	
	public class BuscarInterrupcion
	{
		public var radioCliente:RadioButton;
		public var radioSED:RadioButton;
		public var textoBusqueda:TextInput;
		public var listaBusqueda:ArrayCollection;
		public var dateFormatter:DateTimeFormatter;
		
		public function BuscarInterrupcion(radioCliente:RadioButton,radioSED:RadioButton,textoBusqueda:TextInput,
										   listaBusqueda:ArrayCollection,dateFormatter:DateTimeFormatter)
		{
			this.radioCliente = radioCliente; 
			this.radioSED = radioSED;
			this.textoBusqueda = textoBusqueda;
			this.listaBusqueda = listaBusqueda;
			this.dateFormatter = dateFormatter;
		}
		
		public function buscar():void
		{
			if((radioCliente.selected == false && radioSED.selected == false) || textoBusqueda.text == "")
			{
				Alert.show("Atención:\nEl campo búsqueda no puede estar vacío y \ndebe seleccionar Cliente o SED.");
			} else {
				
				Global.capaSeleccionado.clear();
				listaBusqueda.removeAll();
				
				if(radioCliente.selected == true){
					//BUSQUEDA DE CLIENTE SEGUN NIS....
					var clienteTask:QueryTask = new QueryTask();
					clienteTask.url = Urls.URL_INTERRUPCIONES_CLIENTES;
					clienteTask.useAMF = false;
					clienteTask.showBusyCursor = true;
					var cliente:Query = new Query();
					
					cliente.outFields = ["*"];
					cliente.returnGeometry = false;
					cliente.where = "nis = " + textoBusqueda.text;
					clienteTask.execute(cliente, new AsyncResponder(clienteResult, errorCliente));
					
					//DIBUJAR CLIENTE SEGUN NIS....
					var clientePuntoTask:QueryTask = new QueryTask();
					clientePuntoTask.url = Urls.URL_CLIENTES_MAPA;
					clientePuntoTask.useAMF = false;
					
					var clientePunto:Query = new Query();
					clientePunto.outFields = ["*"];
					clientePunto.returnGeometry = true;
					clientePunto.where = "CLIENTES_DATA_DATOS_006.nis = " + textoBusqueda.text;
					
					clientePuntoTask.execute(clientePunto, new AsyncResponder(clientePuntoResult, clientePuntoFault));
					
					function clientePuntoResult(clientePuntoSet:FeatureSet, token:Object = null):void  
					{   
						if (clientePuntoSet.features==null){
							return;
						}
						
						if (clientePuntoSet.features.length==0){
							return;
						}
						var extent:Extent=null;
						var puntoSelecc:Graphic = clientePuntoSet.features[0];
						var colorClick:Number=0x0000ff;
						var colorSelecc:SimpleMarkerSymbol = new SimpleMarkerSymbol("circle", 15, colorClick);
						puntoSelecc = new Graphic(puntoSelecc.geometry, colorSelecc);
						puntoSelecc.addEventListener(MouseEvent.MOUSE_OVER,mouseOverNIS);
						puntoSelecc.addEventListener(MouseEvent.MOUSE_OUT,eliminarMensaje);
						var mapPoint:MapPoint=puntoSelecc.geometry as MapPoint;
						Global.map.centerAt(mapPoint);
						Global.capaSeleccionado.add(puntoSelecc);
						Global.log("fin puntos");
						Global.map.extent=extent;
					}
					
					function clientePuntoFault(info:Object, token:Object = null):void
					{  
						Alert.show("No se pudo cargar Cliente en el Mapa:\n"+ info.toString());
					}
					
				} else {
					//BUSQUEDA DE SED SEGUN SED....
					var sedTask:QueryTask = new QueryTask();
					sedTask.url = Urls.URL_INTERRUPCIONES_SED;
					sedTask.useAMF = false;
					sedTask.showBusyCursor = true;
					var sed:Query = new Query();
					
					sed.outFields = ["*"];
					sed.returnGeometry = false;
					sed.where = "sed = " + textoBusqueda.text;
					sedTask.execute(sed, new AsyncResponder(sedResult, errorSed));
					
					//DIBUJAR SED SEGUN SED....
					var sedPuntoTask:QueryTask = new QueryTask();
					sedPuntoTask.url = Urls.URL_SED;
					sedPuntoTask.useAMF = false;
					
					var sedPunto:Query = new Query();
					sedPunto.outFields = ["SHAPE"];
					sedPunto.returnGeometry = false;
					sedPunto.where = "codigo = " + textoBusqueda.text;					
					sedPuntoTask.execute(sedPunto, new AsyncResponder(sedPuntoResult, sedPuntoFault));
					
					function sedPuntoResult(sedPuntoSet:FeatureSet, token:Object = null):void  
					{   
						var extent:Extent=null;
						var puntoSelecc:Graphic = sedPuntoSet.features[0];
						
						if (puntoSelecc==null){
							return;
						}
						
						var colorClick:Number=0x0000ff;
						var colorSelecc:SimpleMarkerSymbol = new SimpleMarkerSymbol("triangle", 20, colorClick);
						puntoSelecc = new Graphic(puntoSelecc.geometry, colorSelecc);
						puntoSelecc.addEventListener(MouseEvent.MOUSE_OVER,mouseOverSED);
						puntoSelecc.addEventListener(MouseEvent.MOUSE_OUT,eliminarMensaje);
						var mapPoint:MapPoint=puntoSelecc.geometry as MapPoint;
						Global.map.centerAt(mapPoint);
						Global.capaSeleccionado.add(puntoSelecc);
						Global.log("fin puntos");
						Global.map.extent=extent;
					}
					
					function sedPuntoFault(info:Object, token:Object = null):void
					{  
						Alert.show("No se pudo cargar SED en el Mapa:\n"+ info.toString());
					}
				}
			}
		}
		
		public function mouseOverNIS(e:MouseEvent):void
		{
			Global.map.infoWindow.label= "NIS:" + textoBusqueda.text;
			Global.map.infoWindow.closeButtonVisible = false;
			Global.map.infoWindow.show(Global.map.toMapFromStage(e.stageX, e.stageY));			
		}
		
		public function mouseOverSED(e:MouseEvent):void
		{
			Global.map.infoWindow.label= "SED:" + textoBusqueda.text;
			Global.map.infoWindow.closeButtonVisible = false;
			Global.map.infoWindow.show(Global.map.toMapFromStage(e.stageX +10, e.stageY));  
		}
		
		private function clienteResult(busquedaSet:FeatureSet, token:Object = null):void // NIS
		{
			trace("busquedaSet.features.length " + busquedaSet.features.length);
			for (var i:Number=0; i < busquedaSet.features.length; i++){
				busquedaSet.features[i].attributes["fecha_inicio"] = dateFormatter.format(new Date(busquedaSet.features[i].attributes["fecha_inicio"]));	
				busquedaSet.features[i].attributes["fecha_fin"] = dateFormatter.format(new Date(busquedaSet.features[i].attributes["fecha_fin"]));
				busquedaSet.features[i].attributes["duracion"] = convertToHHMMSS(busquedaSet.features[i].attributes["duracion"]);
				busquedaSet.features[i].attributes["anio"] = busquedaSet.features[i].attributes["fecha_inicio"].substr(6,4) as String;
				listaBusqueda.addItem(busquedaSet.features[i].attributes);
			}
			realizarConsultaColumnaTipo();
		}
		
		private function errorCliente(info:Object, token:Object = null):void
		{
			Alert.show("No se encontraron resultados","errorCliente");
		}
		
		private function sedResult(busquedaSet:FeatureSet, token:Object = null):void // SEED
		{
			trace("busquedaSet.features.length "  + busquedaSet.features.length);
			for (var i:Number=0; i < busquedaSet.features.length; i++){
				busquedaSet.features[i].attributes["fecha_inicio"] = dateFormatter.format(new Date(busquedaSet.features[i].attributes["fecha_inicio"]));	
				busquedaSet.features[i].attributes["fecha_fin"] = dateFormatter.format(new Date(busquedaSet.features[i].attributes["fecha_fin"]));
				busquedaSet.features[i].attributes["duracion"] = convertToHHMMSS(busquedaSet.features[i].attributes["duracion"]);
				busquedaSet.features[i].attributes["anio"] = busquedaSet.features[i].attributes["fecha_inicio"].substr(6,4) as String;
				listaBusqueda.addItem(busquedaSet.features[i].attributes);
			}
			realizarConsultaColumnaTipo();
		}
		
		private function realizarConsultaColumnaTipo():void
		{
			if(listaBusqueda.length == 0)
			{
				Alert.show("No se encontraron resultados");
				return;
			}
			
			var idsInterrupcion:String = "(";
			for each(var objeto:Object in listaBusqueda)
			{
				idsInterrupcion += objeto["id_interrupcion"] +",";
			}
			idsInterrupcion = idsInterrupcion.substr(0,idsInterrupcion.length -1);
			idsInterrupcion += ")";
			
			
			var clienteTask:QueryTask = new QueryTask();
			clienteTask.url = Urls.URL_INTERRUPCIONES_TIPO;
			clienteTask.useAMF = false;
			clienteTask.showBusyCursor = true;
			var cliente:Query = new Query();
			
			cliente.outFields = ["interrupcion_id,vl_trafo_interrumpidos"];
			cliente.returnGeometry = false;
			cliente.where = "interrupcion_id in " + idsInterrupcion+"";			
			clienteTask.execute(cliente, new AsyncResponder(traerConsultaTipoExito, errorTipoInterrupcion));  
		}
		
		public function traerConsultaTipoExito(set:FeatureSet, token:Object = null):void
		{								
			var elementos:ArrayCollection = listaBusqueda;				
			for each(var objeto:Object in elementos)
			{					
				var idInterrupcion:String = objeto["id_interrupcion"]+"";
				for each(var objeto2:Object in set.attributes)
				{
					if(objeto2["interrupcion_id"] == idInterrupcion)
					{							
						var cantidad:Number = new Number(objeto2["vl_trafo_interrumpidos"]);
						objeto["tipoFalla"] = cantidad > 1 ? "Transformador" : cantidad == 1 ? "Cliente" : "-";
					}
				}											
			}				
		}
		
		public function eliminarMensaje(e:MouseEvent):void
		{
			Global.map.infoWindow.hide();
		}
		
		private function errorSed(info:Object, token:Object = null):void
		{
			Alert.show("No se encontraron resultados","errorSed");
		}
		
		private function errorTipoInterrupcion(info:Object, token:Object = null):void
		{
			Alert.show("No se pudo cargar tipo interrupción:\n"+ info.toString());
		}
		
		private function convertToHHMMSS($seconds:Number):String
		{
			var s:Number = $seconds % 60;
			var m:Number = Math.floor(($seconds % 3600 ) / 60);
			var h:Number = Math.floor($seconds / (60 * 60));
			
			var hourStr:String = (h == 0) ? "" : h + " hr ";
			var minuteStr:String = m + " min ";
			
			return hourStr + minuteStr
		}
	}
}