package widgets.PowerOn.busqueda
{
	import com.esri.ags.Graphic;
	
	import flash.events.MouseEvent;
	
	import flashx.textLayout.elements.BreakElement;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import widgets.PowerOn.GlobalPowerOn;

	public class BusquedaEventoMapaTabla
	{
		public var punto:Graphic;
		public var idOrden:String;
		public var nis:String;
		public var sed:String;
		
		public function BusquedaEventoMapaTabla(punto:Graphic,idOrden:String,nis:String,sed:String)
		{
			this.punto = punto;
			this.idOrden = idOrden;
			this.nis = nis;
			this.sed = sed;
			
			punto.addEventListener(MouseEvent.CLICK,eventoPuntoMapa);
		}
		
		public function eventoPuntoMapa(e:MouseEvent):void
		{
			var listaTabla:ArrayCollection = GlobalPowerOn.managerOrdenes.gridOrdenes.dataProvider as ArrayCollection;
			var indice:Number = -1;
			var contador:Number = -1;
			
			for each(var obj:Object in listaTabla)
			{
				contador ++;
				if(obj["id_orden"] == idOrden && obj["nis"] == nis && obj["id_trafo"] == sed)
				{
					indice = contador;
					break;
				}
			}
			
			if(indice == -1) 
				return;
			
			GlobalPowerOn.managerOrdenes.gridOrdenes.selectedIndex = indice;
			GlobalPowerOn.managerOrdenes.gridOrdenes.scrollToIndex(indice);
		}
	}
}