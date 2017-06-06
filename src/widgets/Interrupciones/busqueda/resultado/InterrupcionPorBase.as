package widgets.Interrupciones.busqueda.resultado
{
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.busqueda.filtroResultados.FiltroResultados;

	public class InterrupcionPorBase extends SkinnableComponent
	{
		public var filtroResultados:FiltroResultados;
		
		public function InterrupcionPorBase()
		{
			filtroResultados=new FiltroResultados;
		}
	}
}