package widgets.Interrupciones.busqueda.filtros
{
	import mx.collections.ArrayCollection;
	
	import spark.components.DropDownList;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;

	public class FiltroCausa extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var listaCausaInterrupcion: DropDownList;
		
		private var nombreCausaInterrupcion: String;
		private static const VALOR_PREDETERMINADO: String = "Total";
		private var contador_total: int = 0;
		
		public function FiltroCausa()
		{
			setStyle("skinClass", FiltroCausaSkin);
		}
		
		override protected function partAdded(partName:String, instance:Object): void
		{
			if(instance == listaCausaInterrupcion)
			{
				this.ingresarValoresCausaInterrupcion();
				
				this.listaCausaInterrupcion.addEventListener(IndexChangeEvent.CHANGE, listaCausaInterrupcion_changeHandler);
				this.nombreCausaInterrupcion = FiltroCausa.VALOR_PREDETERMINADO;
			}
		}
		
		protected function listaCausaInterrupcion_changeHandler(event: IndexChangeEvent): void
		{
			var elementoSeleccionado: String = this.listaCausaInterrupcion.selectedItem as String;
			
			if(this.nombreCausaInterrupcion == FiltroCausa.VALOR_PREDETERMINADO && this.contador_total == 0)
			{
				this.agregarElementoLista(this.nombreCausaInterrupcion);
				this.contador_total++;
			}
			
			this.nombreCausaInterrupcion = elementoSeleccionado;
		}
		
		private function ingresarValoresCausaInterrupcion(): void
		{
			var posibleCausaInterrupcion: ArrayCollection = new ArrayCollection;
			posibleCausaInterrupcion.addItem("Total");
			posibleCausaInterrupcion.addItem("Externo");
			posibleCausaInterrupcion.addItem("Interna");
			posibleCausaInterrupcion.addItem("Fuerza Mayor");
			posibleCausaInterrupcion.addItem("Interno + Fuerza Mayor");
			
			this.listaCausaInterrupcion.dataProvider = posibleCausaInterrupcion;
			this.listaCausaInterrupcion.selectedIndex=0;
		}
		
		private function agregarElementoLista(nombreElemento: String): void
		{
			var posibleCausaInterrupcion: ArrayCollection = this.listaCausaInterrupcion.dataProvider as ArrayCollection;
			
			posibleCausaInterrupcion.addItem(nombreElemento);
			
			this.listaCausaInterrupcion.dataProvider = posibleCausaInterrupcion;
		}
		
		public function obtenerCausa():String{
			return this.listaCausaInterrupcion.selectedItem as String;
		}
	}
}