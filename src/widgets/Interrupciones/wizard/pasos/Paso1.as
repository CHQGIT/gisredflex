package widgets.Interrupciones.wizard.pasos
{
	import flash.events.Event;
	
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.wizard.SelectorEtapa;
	
	public class Paso1 extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var botonClienteSed:ToggleButton;
		
		[SkinPart(required="true")]
		public var botonInterrupciones:ToggleButton;
		
		public var selectorEtapa:SelectorEtapa;
		
		public function Paso1()
		{
			setStyle("skinClass",SkinPaso1);
		}
		
		override protected function partAdded(partName:String, instance:Object):void { 
			
			super.partAdded(partName, instance); 
			
			if(instance == botonClienteSed){
				botonClienteSed.addEventListener("click",clickClienteSed);
			}
			
			if(instance == botonInterrupciones){
				botonInterrupciones.addEventListener("click",clickInterrupciones);
			}
		}
		
		public function clickClienteSed(e:Event):void{
			botonInterrupciones.selected=false;
			selectorEtapa.activar(2);
		}
		
		public function clickInterrupciones(e:Event):void{
			botonClienteSed.selected=false;
			selectorEtapa.activar(2);
		}
		
		public function seleccionClienteSed():Boolean{
			return botonClienteSed.selected==true;
		}
		
		public function seleccionInterrupciones():Boolean{
			return botonInterrupciones.selected==true;
		}
	}
}