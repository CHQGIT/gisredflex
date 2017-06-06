package widgets.PowerOn.busqueda
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import flash.events.MouseEvent;
	import flash.globalization.DateTimeFormatter;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	import widgets.Interrupciones.global.Global;
	import widgets.PowerOn.GlobalPowerOn;
	import widgets.PowerOn.urls.Urls;

	public class BusquedaUbicacionTrafo
	{
		
		public var dateFormatter:DateTimeFormatter;
		public var idTrafo:String;
		public var idOrden:String;
		public var orden:Object;

		public function BusquedaUbicacionTrafo()
		{
			this.dateFormatter=new DateTimeFormatter("dd/MM/yy '-' HH:mm");
		}
		
		public function ejecutar(orden:Object):void{
			this.orden = orden;
			this.idOrden = orden.attributes["id_orden"];
			var transauxTask:QueryTask = new QueryTask();
			transauxTask.url = Urls.POWERON_TRANSFORMADORES;
			transauxTask.useAMF = false;
			
			var transaux:Query = new Query();
			transaux.outFields = ["*"];
			transaux.returnGeometry = false;
			transaux.where = "id_orden = '" +idOrden + "'";
			transauxTask.execute(transaux, new AsyncResponder(transauxResult, transauxFault));
		}
		
		private function transauxResult(transauxSet:FeatureSet, token:Object = null):void  
		{
			for (var j:Number=0; j < transauxSet.features.length; j++){ 
				var shapeTransTask:QueryTask = new QueryTask();
				shapeTransTask.showBusyCursor = true;
				shapeTransTask.url =  Urls.SED;
				shapeTransTask.useAMF = false;
				
				var shapeTrans:Query = new Query();
				shapeTrans.returnGeometry = true;
				shapeTrans.outFields = ["*"];
				idTrafo =  transauxSet.features[j].attributes["id_trafo"];
				shapeTrans.where = "codigo = " + transauxSet.features[j].attributes["id_trafo"] ;
				shapeTransTask.execute(shapeTrans, new AsyncResponder(resultPuntoTrans, faultPuntoTrans));
			}
		}
		
		private function resultPuntoTrans(puntotransSet:FeatureSet, token:Object = null):void  
		{   			
			var extent:Extent=null;
			var puntoTransformador:Graphic = puntotransSet.features[0];
			var colorTrans:Number=0xff0000;
			var colorTransformador:SimpleMarkerSymbol = new SimpleMarkerSymbol("triangle", 20, colorTrans);
			
			if(puntoTransformador != null)
			{			
				puntoTransformador = new Graphic(puntoTransformador.geometry, colorTransformador);
				var evento:BusquedaEventoMapaTabla = new BusquedaEventoMapaTabla(puntoTransformador,idOrden,null,idTrafo);
				puntoTransformador.addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
				puntoTransformador.addEventListener(MouseEvent.MOUSE_OUT,eliminarMensaje);
				GlobalPowerOn.capaTransformadores.add(puntoTransformador);
				GlobalPowerOn.map.extent=extent;
				
				// SE AGREGAN PUNTOS PARA EVENTO CLICK EN TABLA.
				var xyOrden:UtilXYOrden = new UtilXYOrden(puntoTransformador.geometry,idOrden,null,idTrafo);
				GlobalPowerOn.managerOrdenes.listaOrdenesXY.addItem(xyOrden);
			}
		}
		
		public function eliminarMensaje(e:MouseEvent):void
		{
			GlobalPowerOn.map.infoWindow.hide();
		}
		
		public function mouseOver(e:MouseEvent):void
		{
			GlobalPowerOn.map.infoWindow.label= "ID ORDEN:" +idOrden + "  SED:" + idTrafo; 
			GlobalPowerOn.map.infoWindow.closeButtonVisible = false;
			GlobalPowerOn.map.infoWindow.show(GlobalPowerOn.map.toMapFromStage(e.stageX +10, e.stageY ));  
		}
		
		private function faultPuntoTrans(info:Object, token:Object = null):void  
		{  
			Alert.show("No se pudo dibujar Transformador en el mapa:\n"+ info.toString());  
		}
		
		private function transauxFault(info:Object, token:Object = null):void  
		{  
			Alert.show("No se pudo cargar los datos"+ info.toString());  
		}
	}
}