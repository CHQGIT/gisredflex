package widgets.Interrupciones.wizard
{
	import flash.events.MouseEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import comun.principal.IPrincipal;
	import comun.wizard.ControlPasoWizard;
	
	public class SelectorEtapa extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var paso1:ControlPasoWizard;
		
		[SkinPart(required="true")]
		public var paso2:ControlPasoWizard;
		
		[SkinPart(required="true")]
		public var paso3:ControlPasoWizard;
		
		public var pasos:Array=new Array;
		
		public var principal:IPrincipal;
		
		public function SelectorEtapa()
		{
			setStyle("skinClass", SelectorEtapaSkin);
		}
		
		override protected function partAdded(partName:String, instance:Object):void { 
			super.partAdded(partName, instance); 
			
			if(instance == paso1){
				paso1.addEventListener(MouseEvent.CLICK,clickPaso1);
				pasos[1]=paso1;
			}
			
			if(instance == paso2){
				paso2.addEventListener(MouseEvent.CLICK,clickPaso2);
				pasos[2]=paso2;
			}
			
			if(instance == paso3){
				paso3.addEventListener(MouseEvent.CLICK,clickPaso3);
				pasos[3]=paso3;
			}
		}
		
		public function activar(etapa:Number):void{
			var pasoActual:ControlPasoWizard=pasos[etapa] as ControlPasoWizard;
			pasoActual.fijarEstado(ControlPasoWizard.ACTIVO);
		}
		
		public function desactivar(etapa:Number):void{
			var pasoActual:ControlPasoWizard=pasos[etapa] as ControlPasoWizard;
			pasoActual.fijarEstado(ControlPasoWizard.INACTIVO);
		}
		
		public function seleccionar(etapa:Number):void{
			deseleccionarPasoSeleccionado();
			
			var pasoActual:ControlPasoWizard=pasos[etapa] as ControlPasoWizard;
			pasoActual.fijarEstado(ControlPasoWizard.SELECCIONADO);
		}
		
		public function clickPaso1(e:MouseEvent):void{
			clickEnPaso(1);
		}
		
		public function clickPaso2(e:MouseEvent):void{
			
			clickEnPaso(2);
		}
		
		public function clickPaso3(e:MouseEvent):void{
			clickEnPaso(3);
		}
		
		public function clickEnPaso(indicePaso:Number):void{
			var pasoActual:ControlPasoWizard=pasos[indicePaso] as ControlPasoWizard;
			
			if (pasoActual.estadoInactivo()){
				return;
			}
			
			if (pasoActual.estadoSeleccionado()){
				return;
			}
			
			deseleccionarPasoSeleccionado();
			
			pasoActual.fijarEstado(ControlPasoWizard.SELECCIONADO);
			
			principal.mostrarPaso(indicePaso);
		}
		
		public function deseleccionarPasoSeleccionado():void{
			for (var i:Number=1;i<=3;i++){
				var pasoSeleccionado:ControlPasoWizard=pasos[i] as ControlPasoWizard;
				
				if (pasoSeleccionado.estadoSeleccionado()){
					pasoSeleccionado.fijarEstado(ControlPasoWizard.ACTIVO);
				}
			}
		}
	}
}