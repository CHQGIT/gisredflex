package widgets.Interrupciones.busqueda.filtros
{
	import mx.collections.ArrayCollection;
	
	import spark.components.DropDownList;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import comun.util.zalerta.ZAlerta;

	public class FiltroNumeroResultado extends SkinnableComponent
	{
		[SkinPart]
		public var listaNumeroResultado: DropDownList;
		
		private var _numeroResultadoSeleccionado: String;
		
		public function FiltroNumeroResultado()
		{
			setStyle("skinClass", FiltroNumeroResultadoSkin);
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			this._numeroResultadoSeleccionado = "";
			
			if(instance == this.listaNumeroResultado)
			{
				this.ingresarValoresNumeroResultado();
				this.listaNumeroResultado.addEventListener(IndexChangeEvent.CHANGE, listaNumeroResultado_changeHandler);
			}
		}
		
		/*** EVENTO DE DROPDOWNLIST ***/
		protected function listaNumeroResultado_changeHandler(event: IndexChangeEvent): void
		{
			this._numeroResultadoSeleccionado = "" + this.listaNumeroResultado.selectedItem.Cantidad_Resultado;
		}
		
		/*** DECLARACION DE VALORES PARA LOS CONTROLES ***/
		private function ingresarValoresNumeroResultado(): void
		{
			var elementosNumeroResultado: ArrayCollection = new ArrayCollection;
			
			elementosNumeroResultado.addItem({Cantidad_Resultado: "100"});
			elementosNumeroResultado.addItem({Cantidad_Resultado: "200"});
			elementosNumeroResultado.addItem({Cantidad_Resultado: "500"});
			elementosNumeroResultado.addItem({Cantidad_Resultado: "1000"});
			
			this.listaNumeroResultado.dataProvider = elementosNumeroResultado;
		}
		
		/*** ALMACENA LOS DATOS QUE SE INGRESARON EN EL FORMULARIO ***/
		public function guardarDatosNumeroResultado(): String
		{
			var valorNumeroResultado: String = this._numeroResultadoSeleccionado;
			
			if(valorNumeroResultado == "")
			{
				ZAlerta.show("Debe ingresar la cantidad de resultados que quiere generar.");
				valorNumeroResultado = null;
			}
			
			return valorNumeroResultado;
		}
	}
}