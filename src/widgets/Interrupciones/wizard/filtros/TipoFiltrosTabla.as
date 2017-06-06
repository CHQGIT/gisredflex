package widgets.Interrupciones.wizard.filtros
{
	import mx.controls.CheckBox;
	
	import spark.components.Label;
	
	public class TipoFiltrosTabla
	{		
		public var nombre:String;
		public var seleccionado:Boolean;
				
		public var check:CheckBox;
		public var etiqueta:Label;
		
		public function TipoFiltrosTabla()
		{
			seleccionado = true;		
			check = new CheckBox();
			etiqueta = new Label();
		}
	}
}