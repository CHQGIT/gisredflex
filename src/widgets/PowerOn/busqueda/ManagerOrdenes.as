package widgets.PowerOn.busqueda
{
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;

	public class ManagerOrdenes
	{
		[Bindable]
		public var listaOrdenes:ArrayCollection = new ArrayCollection();
		public var listaOrdenesTimer:ArrayCollection = new ArrayCollection();
		public var listaOrdenesXY:ArrayCollection = new ArrayCollection();
		public var gridOrdenes:DataGrid = new  DataGrid();
		public var eventoTimer:EventoTimer  = new EventoTimer();
		
		public function agregarElemento(objeto:Object):void
		{
			if(eventoTimer.activo)
			{
				listaOrdenesTimer.addItem(objeto);
			}
			else
			{
				listaOrdenes.addItem(objeto);
			}
		}
	}
}