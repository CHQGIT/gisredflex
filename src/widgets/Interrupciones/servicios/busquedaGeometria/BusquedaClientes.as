package widgets.Interrupciones.servicios.busquedaGeometria
{
	import widgets.Interrupciones.urls.Urls;
	
	public class BusquedaClientes extends BusquedaGeometriaPaginada
	{
		public function BusquedaClientes()
		{
			super("ARCGIS.DBO.CLIENTES_XY_006.nis",Urls.URL_CLIENTES_MAPA);
		}
	}
}
