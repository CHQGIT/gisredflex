package comun.util.zalerta
{
	import flash.display.Sprite;
	import flash.events.EventPhase;
	import flash.events.MouseEvent;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.events.FlexEvent;
	import mx.managers.ISystemManager;
	import mx.managers.PopUpManager;
	import mx.rpc.Fault;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	
	public class ZAlerta extends SkinnableComponent
	{
		[SkinPart]
		public var titulo:Label;
		[SkinPart]
		public var mensaje:Label;
		[SkinPart]
		public var cerrar:Button;
		
		public var textoMensaje:String;
		
		public var alertActual:ZAlerta;
		
		public function ZAlerta()
		{
			setStyle("skinClass",ZAlertaSkin);
		}
		
		override protected function partAdded(partName:String,instance:Object):void{
			if(mensaje == instance){
				mensaje.text=textoMensaje;
			}
			if (instance==cerrar){
				cerrar.addEventListener(MouseEvent.CLICK,buttonClickListener);
			}
		}
		
		public function buttonClickListener(e:MouseEvent):void{
			PopUpManager.removePopUp(this);
		}
		
		static public function show(mensaje:String,info:Object=null,fault:Fault=null):void{
			
			var parent:Sprite = null;
			
			var sm:ISystemManager = ISystemManager(FlexGlobals.topLevelApplication.systemManager);
			var mp:Object = sm.getImplementation("mx.managers::IMarshalSystemManager");
			
			if (mp && mp.useSWFBridge())
				parent = Sprite(sm.getSandboxRoot());
			else
				parent = Sprite(FlexGlobals.topLevelApplication);
			
			var alertActual:ZAlerta=new ZAlerta();
			alertActual.textoMensaje=mensaje;
			alertActual.addEventListener(FlexEvent.CREATION_COMPLETE, static_creationCompleteHandler);
			PopUpManager.addPopUp(alertActual, parent, true);
		}
		
		private static function static_creationCompleteHandler(event:FlexEvent):void
		{
			if (event.target is IFlexDisplayObject && event.eventPhase == EventPhase.AT_TARGET)
			{
				var alert:ZAlerta = ZAlerta(event.target);
				alert.removeEventListener(FlexEvent.CREATION_COMPLETE, static_creationCompleteHandler);
				
				alert.setActualSize(alert.getExplicitOrMeasuredWidth(),
					alert.getExplicitOrMeasuredHeight());
				PopUpManager.centerPopUp(IFlexDisplayObject(alert));
			}
		}
	}
}