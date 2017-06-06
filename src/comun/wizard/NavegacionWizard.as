package comun.wizard
{
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.principal.Principal;
	
	public class NavegacionWizard extends SkinnableComponent 
	{
		[SkinPart(required="true")]
		public var botonAnterior:Button;
		
		[SkinPart(required="true")]
		public var botonCalcular:Button;
		
		[SkinPart(required="true")]
		public var botonSiguiente:Button;
		
		public var principal:Principal;
		
		public function NavegacionWizard()
		{
			setStyle("skinClass", SkinNavegacionWizard);
		}
		
		override protected function partAdded(partName:String, instance:Object):void { 
			
			super.partAdded(partName, instance); 
			
			if(instance == botonAnterior){
			//	botonAnterior.addEventListener("click",clickAnterior);
			}
			
			if(instance == botonCalcular){
			//	botonCalcular.addEventListener("click",clickInterrupciones);
			}
			
			if(instance == botonSiguiente){
				botonSiguiente.addEventListener("click",clickSiguiente);
			}
		}
		
		public function activarBotones(estadoAnterior:Boolean,estadoCalcular:Boolean,estadoSiguiente:Boolean):void{
			botonAnterior.enabled=estadoAnterior;
			botonCalcular.enabled=estadoCalcular;
			botonSiguiente.enabled=estadoSiguiente;
		}
		
		public function clickSiguiente(e:MouseEvent):void{
		//	principal.paso2ClienteSed();
		}
	}
}