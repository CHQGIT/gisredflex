package widgets.Interrupciones.wizard.pasos
{
	import flash.events.MouseEvent;
	
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.busqueda.filtros.FiltroAlimentador;
	import widgets.Interrupciones.busqueda.filtros.FiltroComuna;
	import widgets.Interrupciones.busqueda.filtros.FiltroSSEE;
	import widgets.Interrupciones.busqueda.filtros.FiltroZona;
	import widgets.InterrupcionesClientesSED2.principal.PrincipalClienteSED;

	public class FiltroAvanzadoClienteSed extends SkinnableComponent
	{
		[SkinPart]
		public var filtroAlimentador: FiltroAlimentador;
		
		[SkinPart]
		public var filtroSSEE: FiltroSSEE;
		
		[SkinPart]
		public var filtroComuna: FiltroComuna;
		
		[SkinPart]
		public var filtroZona: FiltroZona;
		
		[SkinPart]
		public var buscarInterrupcionButton:Button;
		
		public var principal:PrincipalClienteSED;
		
		public function FiltroAvanzadoClienteSed()
		{
			setStyle("skinClass", SkinFiltroAvanzadoClienteSed);
			addEventListener(FlexEvent.CREATION_COMPLETE,creadoCompletamente);
		}
		
		public function creadoCompletamente(e:FlexEvent):void{
			this.filtroSSEE.cargarTipos();
			this.filtroAlimentador.cargarTipos();
			this.filtroComuna.cargarTipos();
			this.filtroZona.cargarTipos();
		}
		
		override protected function partAdded(partName:String,instance:Object):void{
			if (instance==filtroSSEE){
		
			}
			
			if(instance == filtroAlimentador)
			{
			
			}
			
			if(instance == filtroComuna)
			{
				
			}
			
			if(instance == filtroZona)
			{
			
			}
			
			if (instance==buscarInterrupcionButton){
				buscarInterrupcionButton.addEventListener(MouseEvent.CLICK,clickBuscarInterrupciones);
			}
		}
		
		public function clickBuscarInterrupciones(e:MouseEvent):void{
			principal.buscarClienteSed();
		}
		
		public function limpiarFiltros():void
		{
			this.filtroAlimentador.componenteDosListas.elementosSeleccionados.dataProvider = null;
			this.filtroComuna.componenteDosListas.elementosSeleccionados.dataProvider = null;
			this.filtroSSEE.componenteDosListas.elementosSeleccionados.dataProvider = null;
			this.filtroZona.componenteDosListas.elementosSeleccionados.dataProvider = null;
		}
	}
}