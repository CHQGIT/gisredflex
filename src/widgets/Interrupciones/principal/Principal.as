package widgets.Interrupciones.principal
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.ViewStack;
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import comun.principal.IPrincipal;
	import comun.util.zalerta.ZAlerta;
	
	import widgets.Interrupciones.busqueda.FiltrosSeleccionadosBusqueda;
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.servicios.BusquedaTipos;
	import widgets.Interrupciones.wizard.SelectorEtapa;
	import widgets.Interrupciones.wizard.pasos.PasoFiltrosBasicosInterrupciones;
	import widgets.Interrupciones.wizard.pasos.PasoResultadoInterrupciones;
	import widgets.Interrupciones.wizard.pasos.PasoTablaInterrupciones;
	
	public class Principal extends SkinnableComponent implements IPrincipal
	{
		[SkinPart(required="true")]
		public var stackPrincipal:ViewStack; 
		
		[SkinPart(required="true")]
		public var selectorEtapa:SelectorEtapa; 	
		
		[SkinPart(required="true")]
		public var pasoFiltrosBasicosInterrupciones:PasoFiltrosBasicosInterrupciones;
		
		[SkinPart(required="true")]
		public var pasoTablaInterrupciones:PasoTablaInterrupciones;
		
		[SkinPart(required="true")]
		public var pasoResultadoInterrupciones:PasoResultadoInterrupciones;
		
		public function Principal()
		{
			setStyle("skinClass", PrincipalSkin);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationComplete);
		}
		
		public function creationComplete(e:FlexEvent):void{
		 	var busquedaTipos:BusquedaTipos = new BusquedaTipos();
			busquedaTipos.buscar(okInterrupciones,errorInterrupciones);
			
			selectorEtapa.seleccionar(1);
		}
		
		public function okInterrupciones(r:ArrayCollection):void{
			Global.rangos=r;
		}
		
		public function errorInterrupciones(mensaje:String):void{
			ZAlerta.show("error 44 "+mensaje);
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(instance == stackPrincipal)
			{
				stackPrincipal.selectedIndex = 0;
			}
		}
		
		public function mostrarPrincipal(): void
		{
			stackPrincipal.selectedIndex = 0;
		}
		
		public function mostrarTablaInterrupciones(filtrosSeleccionadosBusqueda:FiltrosSeleccionadosBusqueda):void{
			stackPrincipal.selectedIndex=6;
		}
		
		public function mostrarTablaInterrupcionesDesdeCarga():void{
			stackPrincipal.selectedIndex=2;
		}

		public function mostrarFiltros():void{
			stackPrincipal.selectedIndex = 0;
		}
		
		public function mostrarFormBusquedaClienteSed(): void
		{
			stackPrincipal.selectedIndex = 4;
		}
		
		public function mostrarProgresoCapa(ids:ArrayCollection): void
		{
			stackPrincipal.selectedIndex = 3;
			// particionar arreglo en bloques...
		}
		
		public function clickMenuLog(e:MouseEvent):void{
			stackPrincipal.selectedIndex = 5;
		}
		
		public function mostrarPaso(indicePaso:Number):void{
			if (indicePaso==1){
				irAPaso1();
			}
			else if (indicePaso==2){
				
				if (Global.rangos==null){
					var busquedaTipos:BusquedaTipos=new BusquedaTipos();
					busquedaTipos.buscar(okInterrupciones,errorInterrupciones);
				}
				
				irAPaso2Interrupciones();
			}
			else if (indicePaso==3){
				irAPaso3Interrupciones();
			}
		}
		
		public function irAPaso1():void{
			stackPrincipal.selectedIndex=0;
			if (!pasoFiltrosBasicosInterrupciones.valido()){
				selectorEtapa.desactivar(2);
				selectorEtapa.desactivar(3);
			}
		}
		
		public function irAPaso2ClienteSed():void{
			stackPrincipal.selectedIndex = 2;
		}
		
		public function irAPaso2Interrupciones():void{
			
			stackPrincipal.selectedIndex = 1;
			
			if (pasoFiltrosBasicosInterrupciones.recalcular){
				var arrayPeriodoFecha: ArrayCollection = pasoFiltrosBasicosInterrupciones.filtroPeriodo.guardarDatoTiempo();
				var causa:String=pasoFiltrosBasicosInterrupciones.filtroCausa.obtenerCausa();
				pasoTablaInterrupciones.buscarSegunPeriodoCausa(arrayPeriodoFecha,causa);
			}
			
		}
		
		public function irAPaso3Interrupciones():void{
			stackPrincipal.selectedIndex = 2;
		}
		
		public function mostrarInterrupcion(query:String):void{
			pasoTablaInterrupciones.buscarSegunIdInterrupcion(query);
		}
		
		public function reiniciarWidget():void{
			stackPrincipal.selectedIndex = 1;
			selectorEtapa.seleccionar(1);
			selectorEtapa.desactivar(2);
			selectorEtapa.desactivar(3);
			mostrarPaso(1);
			pasoFiltrosBasicosInterrupciones.limpiarFiltros();
			pasoTablaInterrupciones.limpiarTablaInterrupciones();
			pasoResultadoInterrupciones.limpiarResultados();
		}
	}
}