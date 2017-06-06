package widgets.PowerOn.busqueda
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import flash.events.MouseEvent;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	import widgets.PowerOn.GlobalPowerOn;
	import widgets.PowerOn.urls.Urls;

	public class BusquedaUbicacionCliente
	{
		public var nis:String;
		public var idOrden:String;
		public var orden:Object;
		
		public function ejecutar(orden:Object):void{
			this.orden = orden;
			this.nis = orden.attributes["ARCGIS.DBO.CLIENTES_XY_006.nis"];
			this.idOrden = orden.attributes["id_orden"];
			var shapeTask:QueryTask = new QueryTask();
			shapeTask.showBusyCursor = true;
			shapeTask.url = Urls.CLIENTES;
			shapeTask.useAMF = false;
			
			var shape:Query = new Query();
			shape.returnGeometry = true;
			shape.outFields = ["*"];
			shape.where = "ARCGIS.DBO.CLIENTES_XY_006.nis = " + nis; 
			shapeTask.execute(shape, new AsyncResponder(resultPunto, faultPunto));
		}
		
		private function resultPunto(puntoSet:FeatureSet, token:Object = null):void  
		{   
			var extent:Extent=null;
			var puntoCliente:Graphic = puntoSet.features[0];
			
			var colorFrecuencia:Number=0xff48000;
			var colorCliente:SimpleMarkerSymbol = new SimpleMarkerSymbol("circle", 20, colorFrecuencia);
			
			if(puntoCliente != null)
			{				
				puntoCliente=new Graphic(puntoCliente.geometry,colorCliente);
				puntoCliente.addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
				puntoCliente.addEventListener(MouseEvent.MOUSE_OUT,eliminarMensaje);
				var evento:BusquedaEventoMapaTabla = new BusquedaEventoMapaTabla(puntoCliente,idOrden,nis,null);
				GlobalPowerOn.capaClientes.add(puntoCliente);				
				GlobalPowerOn.map.extent=extent;
				
				// SE AGREGAN PUNTOS PARA EVENTO CLICK EN TABLA.
				var xyOrden:UtilXYOrden = new UtilXYOrden(puntoCliente.geometry,idOrden,nis,null);
				GlobalPowerOn.managerOrdenes.listaOrdenesXY.addItem(xyOrden);
			}
		}
		
		public function eliminarMensaje(e:MouseEvent):void
		{
			GlobalPowerOn.map.infoWindow.hide();
		}
			
		public function mouseOver(e:MouseEvent):void
		{
			GlobalPowerOn.map.infoWindow.label= "ID ORDEN:" +idOrden+ "  NIS:" + nis;
			GlobalPowerOn.map.infoWindow.closeButtonVisible = false;
			GlobalPowerOn.map.infoWindow.show(GlobalPowerOn.map.toMapFromStage(e.stageX +10, e.stageY));  
		}
		
		public function faultPunto(info:Object, token:Object = null):void  
		{  
			Alert.show("No se pudo dibujar Cliente en el mapa:\n"+ info.toString());  
		}
	}
}