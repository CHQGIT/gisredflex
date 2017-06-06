package widgets.PowerOn.busqueda
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import comun.util.ZExportarTablaXLSUtil;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	import mx.rpc.AsyncResponder;
	import mx.utils.ObjectUtil;
	import mx.utils.UIDUtil;
	
	import spark.events.IndexChangeEvent;
	
	import widgets.PowerOn.GlobalPowerOn;
	import widgets.PowerOn.busqueda.BusquedaCliente;
	import widgets.PowerOn.busqueda.ManagerOrdenes;
	import widgets.PowerOn.busqueda.Ordenes;
	import widgets.PowerOn.conversion.ConversionXY;
	import widgets.PowerOn.urls.Urls;
	
	public class BusquedaEventoMapa
	{
		public var gridOrdenes:DataGrid;
		public var utilXY:UtilXYOrden;
		public var listaXY:ArrayCollection;
		
		public var nis:String;
		public var sed:String;
		public var idOrden:String;
		
		public function BusquedaEventoMapa(gridOrdenes:DataGrid)
		{
			this.gridOrdenes = gridOrdenes;
		}
		
		public function ejecturar(tipoAfectado:String):void
		{
			var orden:Object = gridOrdenes.selectedItem;
			this.idOrden =  orden["id_orden"];
			this.nis =  orden["nis"];
			this.sed =  orden["id_trafo"];
			
			listaXY = GlobalPowerOn.managerOrdenes.listaOrdenesXY;
			utilXY = buscarXYOrden();
			GlobalPowerOn.capaSeleccionado.clear();
			
			if(utilXY == null)
			{
				Alert.show("Elemento no tiene una ubicación registrada","Error");
				return;
			}
			if(tipoAfectado == "Cliente")
			{
				dibujaFigura("circle");
			}
			else if(tipoAfectado == "Transformador")
			{
				dibujaFigura("triangle");
			}
			else if(tipoAfectado == "Origen Falla")
			{
				dibujaFigura("diamond");
			}
		}
		
		public function dibujaFigura(tipo:String):void
		{
			var colorClick:Number=0x0000ff;
			var colorSelecc:SimpleMarkerSymbol = new SimpleMarkerSymbol(tipo, 20, colorClick);
			var puntoSelecc:Graphic = new Graphic(utilXY.geometria, colorSelecc);

			var evento:BusquedaEventoMapaTabla = new BusquedaEventoMapaTabla(puntoSelecc,idOrden,nis,null);
			var mapPoint:MapPoint=puntoSelecc.geometry as MapPoint;
			GlobalPowerOn.map.centerAt(mapPoint);
			
			GlobalPowerOn.capaSeleccionado.add(puntoSelecc);
			GlobalPowerOn.map.extent=null;
			
			puntoSelecc.addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
			puntoSelecc.addEventListener(MouseEvent.MOUSE_OUT,eliminarMensaje);
		}
		
		public function eliminarMensaje(e:MouseEvent):void
		{
			GlobalPowerOn.map.infoWindow.hide();
		}
		
		public function mouseOver(e:MouseEvent):void
		{
			var mensaje:String = "ID ORDEN:" +idOrden;
			mensaje = nis != null ? mensaje +" || NIS:"+ nis : mensaje;
			mensaje = sed != null ? mensaje +" || SED:"+ sed : mensaje;
			
			GlobalPowerOn.map.infoWindow.label= mensaje; 
			GlobalPowerOn.map.infoWindow.closeButtonVisible = false;
			GlobalPowerOn.map.infoWindow.show(GlobalPowerOn.map.toMapFromStage(e.stageX +10, e.stageY ));  
		}
		
		public function buscarXYOrden():UtilXYOrden
		{			
			for each(var xy:UtilXYOrden in listaXY)
			{				
				if(xy.idOrden == idOrden && xy.nis == nis && xy.sed == sed )
					return xy;
			}
			return null;
		}
	}
}