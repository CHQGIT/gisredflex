package widgets.Interrupciones.busqueda.filtros
{
	import spark.components.RadioButton;
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.servicios.UtilWhere;

	public class FiltroTipoResultado extends SkinnableComponent
	{
		[SkinPart]
		public var cantidadDetenciones: RadioButton;
		[SkinPart]
		public var tiempoDetenciones: RadioButton;
		
		public function FiltroTipoResultado()
		{
			setStyle("skinClass", FiltroTipoResultadoSkin);
		}
		
		override protected function partAdded(partName:String, instance:Object): void{}
		
		public function guardarDatosTipoResultado(): String
		{
			
			var valorTipoResultado: String = "";
			
			if(this.cantidadDetenciones.selected)
			{
				valorTipoResultado = this.cantidadDetenciones.label;
			}
			
			if(this.tiempoDetenciones.selected)
			{
				valorTipoResultado = this.tiempoDetenciones.label;
			}
			
			return valorTipoResultado;
		}
		
		public function generarWhere(dato: String, whereObject: Object): void
		{
			if(dato.length != 0)
			{
				whereObject.stringWhere = UtilWhere.comprobarDatoVacioWhere(whereObject.stringWhere); 
				whereObject.stringWhere += "(tipo_resultado = '" + dato.toString() + "')";
			}
		}
	}
}