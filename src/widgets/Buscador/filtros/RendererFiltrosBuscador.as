package widgets.Buscador.filtros
{
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	
	import spark.components.CheckBox;
	import spark.components.Label;

	public class RendererFiltrosBuscador extends HBox
	{			
		public var elementoActual:TipoFiltroBuscador;
		public var componente:FiltrosBuscador;
		
		public function RendererFiltrosBuscador()
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
			elementoActual = value as TipoFiltroBuscador;
			elementoActual.check.selected = elementoActual.seleccionado;
			elementoActual.check.addEventListener("click",eventoCheck);
			elementoActual.etiqueta.text = elementoActual.esAnio ? elementoActual.anio +"" : elementoActual.nombre;			
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