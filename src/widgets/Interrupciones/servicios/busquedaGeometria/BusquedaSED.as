package widgets.Interrupciones.servicios.busquedaGeometria
{
	import widgets.Interrupciones.urls.Urls;
	 
	public class BusquedaSED extends BusquedaGeometriaPaginada
	{
		
		public function BusquedaSED()
		{
			super("codigo",Urls.URL_SED);
		}
	}
}
