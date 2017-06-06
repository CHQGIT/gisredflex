package widgets.Interrupciones.busqueda.resultado.filtroCausaSed
{
	import flash.events.Event;
	
	import spark.components.CheckBox;
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.global.Global;
	import comun.util.zalerta.ZAlerta;

	public class FiltroCausaSed extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var checkExterno:CheckBox;
		
		[SkinPart(required="true")]
		public var checkInterno:CheckBox;
		
		[SkinPart(required="true")]
		public var checkFuerzaMayor:CheckBox;
		
		public var callbackCambio:Function;
		
		public static var CAUSA_EXTERNO:Number=0;
		public static var CAUSA_INTERNO:Number=1;
		public static var CAUSA_FUERZA_MAYOR:Number=2;
		
		public function FiltroCausaSed()
		{
			setStyle("skinClass", FiltroCausaSedSkin);
		}
		
		override protected function partAdded(partName: String, instance: Object): void
		{
			if(instance == checkExterno)
			{
				checkExterno.addEventListener(Event.CHANGE, cambioExterno);
			}	
			
			if(instance == checkInterno)
			{
				checkInterno.addEventListener(Event.CHANGE, cambioInterno);
			}	
			
			if(instance == checkFuerzaMayor)
			{
				checkFuerzaMayor.addEventListener(Event.CHANGE, cambioFuerzaMayor);
			}
		}
			
		protected function cambioExterno(event:Event):void
		{
			if (callbackCambio!=null){
				callbackCambio(recolectarEstado());
			}
		}
		
		protected function cambioInterno(event:Event):void
		{
			if (callbackCambio!=null){
				callbackCambio(recolectarEstado());
			}
		}
		
		protected function cambioFuerzaMayor(event:Event):void
		{
			if (callbackCambio!=null){
				callbackCambio(recolectarEstado());
			}
		}
		
		public function recolectarEstado():Object{
			var r:Object=new Object();
			
			r[CAUSA_EXTERNO]=checkExterno.selected;
			r[CAUSA_INTERNO]=checkInterno.selected;
			r[CAUSA_FUERZA_MAYOR]=checkFuerzaMayor.selected;

			return r;
		}
		
		public function chequearTodos():void{
			checkExterno.selected=true;
			checkInterno.selected=true;
			checkFuerzaMayor.selected=true;
		}
	}
}