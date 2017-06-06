package widgets.Interrupciones.wizard.filtros
{
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	
	import spark.components.CheckBox;
	import spark.components.Label;
	
	import widgets.Interrupciones.wizard.pasos.PasoTablaInterrupciones;
	
	public class RendererFiltrosTablaInterrupciones extends HBox
	{			
		public var elementoActual:TipoFiltrosTabla;
		public var componente:PasoTablaInterrupciones;
		
		public function RendererFiltrosTablaInterrupciones()
		{
			super(); 
			this.setStyle("horizontalAlign","left");
			this.setStyle("verticalAlign","middle");
			super.horizontalScrollPolicy = "off";
			super.verticalScrollPolicy = "off";
		}
		
		override protected function createChildren():void
		{		
			commitProperties();
		}
		
		override public function set data(value:Object):void
		{
			this.removeAllChildren();
			super.data=value;
			elementoActual = value as TipoFiltrosTabla;
			elementoActual.check.selected = elementoActual.seleccionado;
			elementoActual.check.addEventListener("click",eventoCheck);
			elementoActual.etiqueta.text = elementoActual.nombre;			
			addChild(elementoActual.check);
			addChild(elementoActual.etiqueta);			
		}
		
		public function eventoCheck(e:MouseEvent):void		
		{
			elementoActual.seleccionado = false;
			componente.filtrar();		
		}
	}
}