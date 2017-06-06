package comun.wizard
{
	import mx.containers.ViewStack;
	
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;

	public class ControlPasoWizard extends SkinnableComponent
	{
		[SkinPart(required=true)]
		public var circuloInactivo: Image;
		
		[SkinPart(required=true)]
		public var circuloNormal: Image;
			
		[SkinPart(required=true)]
		public var circuloSeleccionado: Image;
		
		[SkinPart(required=true)]
		public var etiqueta1: Label;
		
		[SkinPart(required=true)]
		public var etiqueta2: Label;
		
		[SkinPart(required=true)]
		public var etiquetaNumeroPasoInactivo: Label;
		
		[SkinPart(required=true)]
		public var etiquetaNumeroPasoNormal: Label;
		
		[SkinPart(required=true)]
		public var etiquetaNumeroPasoSeleccionado: Label;
		
		[SkinPart(required=true)]
		public var stack:ViewStack;
		
		public var textoEtiqueta:String;

		public var textoNumeroPaso:String;
		
		public static var INACTIVO:Number=0;
		public static var ACTIVO:Number=1;
		public static var SELECCIONADO:Number=2;
		
		public function ControlPasoWizard()
		{
			setStyle("skinClass", SkinControlPasoWizard);
		}
		
		override protected function partAdded(partName:String, instance:Object):void { 
			
			super.partAdded(partName, instance); 
			var partes:Array=null;
			
			if(instance == etiqueta1){
				partes=textoEtiqueta.split(" ");
				etiqueta1.text=partes[0];
			}
			
			if(instance == etiqueta2){
				partes=textoEtiqueta.split(" ");
				etiqueta2.text=partes[1];
			}
			
			if(instance == etiquetaNumeroPasoNormal){
				etiquetaNumeroPasoNormal.text=textoNumeroPaso;
			}
			
			if(instance == etiquetaNumeroPasoSeleccionado){
				etiquetaNumeroPasoSeleccionado.text=textoNumeroPaso;
			}
			
			if(instance == etiquetaNumeroPasoInactivo){
				etiquetaNumeroPasoInactivo.text=textoNumeroPaso;
			}
		}
		
		public function fijarEstado(nuevoEstado:Number):void{
			stack.selectedIndex=nuevoEstado;
		}
		
		public function estadoInactivo():Boolean{
			return stack.selectedIndex==ControlPasoWizard.INACTIVO;
		}
			
		public function estadoActivo():Boolean{
			return stack.selectedIndex==ControlPasoWizard.ACTIVO;
		}
		
		public function estadoSeleccionado():Boolean{
			return stack.selectedIndex==ControlPasoWizard.SELECCIONADO;
		}
	}
}