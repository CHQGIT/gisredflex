package widgets.PowerOn.busqueda
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectUtil;
	
	import widgets.PowerOn.GlobalPowerOn;

	public class EventoTimer
	{
		public var timer:Timer;
		public var activo:Boolean = false;
		public var funcionCargar:Function = new Function;
		
		public function iniciarTimer():void
		{
			trace("<<<<<<<<<< iniciando timer");
			timer = new Timer(200000); // milisegundos .
			timer.addEventListener(TimerEvent.TIMER, listenerTimer);
			timer.start();
		}
		
		public function apagarTimer():void
		{
			timer.stop();
		}
		
		public function listenerTimer(e:TimerEvent):void
		{
			trace("this.activo  " + this.activo );
			GlobalPowerOn.managerOrdenes.listaOrdenesTimer = new ArrayCollection;
			this.activo = true;
			var busquedaCliente:BusquedaCliente=new BusquedaCliente();
			busquedaCliente.listarClientes();
		}
		
		public function validarListas():void
		{
			GlobalPowerOn.managerOrdenes.listaOrdenesTimer.addItem(null);
			if(!activo)
				return;

			var resultado:int = ObjectUtil.compare(GlobalPowerOn.managerOrdenes.listaOrdenesTimer,GlobalPowerOn.managerOrdenes.listaOrdenes,0); 
			if(resultado != 0)
			{
				funcionCargar(null);
			}else
			{
				trace("no hay cambios.");
			}
		}
	}
}