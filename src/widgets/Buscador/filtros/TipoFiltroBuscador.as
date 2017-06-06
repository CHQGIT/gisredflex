package widgets.Buscador.filtros
{
	import mx.controls.CheckBox;
	
	import spark.components.Label;

	public class TipoFiltroBuscador
	{		
		public var nombre:String;
		public var esAnio:Boolean;		
		public var seleccionado:Boolean;
		
		public var anio:Number;
		public var check:CheckBox;
		public var etiqueta:Label;
		
		public function TipoFiltroBuscador()
		{
			seleccionado = true;		
			check = new CheckBox();
			etiqueta = new Label();
		}
	}
}