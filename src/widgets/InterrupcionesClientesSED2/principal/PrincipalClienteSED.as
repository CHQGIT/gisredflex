package widgets.InterrupcionesClientesSED2.principal
{
	import mx.collections.ArrayCollection;
	import mx.containers.ViewStack;
	import mx.events.FlexEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import comun.principal.IPrincipal;
	import comun.util.zalerta.ZAlerta;
	
	import widgets.Interrupciones.busqueda.FiltrosSeleccionadosBusqueda;
	import widgets.Interrupciones.busqueda.resultado.TablaInterrupciones;
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.servicios.BusquedaInterrupcionComun;
	import widgets.Interrupciones.servicios.BusquedaTipos;
	import widgets.Interrupciones.wizard.SelectorEtapa;
	import widgets.Interrupciones.wizard.pasos.FiltroAvanzadoClienteSed;
	import widgets.InterrupcionesClientesSED2.busqueda.FormularioBusquedaClienteSed;
	
	public class PrincipalClienteSED  extends SkinnableComponent implements IPrincipal
	{
		[SkinPart]
		public var formularioBusquedaClienteSed:FormularioBusquedaClienteSed;
		
		[SkinPart]
		public var filtroAvanzadoClienteSed:FiltroAvanzadoClienteSed;
		
		[SkinPart]
		public var selectorEtapa:SelectorEtapa;
		
		[SkinPart]
		public var tablaInterrupcionesClienteSed:TablaInterrupciones;
		
		[SkinPart(required="true")]
		public var stackPrincipal:ViewStack; 
		
		public var filtrosSeleccionadosBusqueda:FiltrosSeleccionadosBusqueda;
		
		public function PrincipalClienteSED()
		{
			setStyle("skinClass", PrincipalClienteSEDSkin);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationComplete);
		}
		
		public function creationComplete(e:FlexEvent):void{
			var busquedaTipos:BusquedaTipos=new BusquedaTipos();
			busquedaTipos.buscar(okInterrupciones,errorInterrupciones);
			
			selectorEtapa.seleccionar(1);
		}
		
		public function okInterrupciones(r:ArrayCollection):void{
			Global.rangos=r;
		}
		
		public function errorInterrupciones(mensaje:String):void{
			ZAlerta.show("error 441 "+mensaje);
		}
		
		public function buscarClienteSed():void{
	
			var arrayPeriodoFecha: ArrayCollection = formularioBusquedaClienteSed.filtroPeriodo.guardarDatoTiempo();
			var arrayZona: ArrayCollection = filtroAvanzadoClienteSed.filtroZona.guardarDatoZona();
			var arraySSEE: ArrayCollection = filtroAvanzadoClienteSed.filtroSSEE.guardarDatoSSEE();
			var arrayComuna: ArrayCollection = filtroAvanzadoClienteSed.filtroComuna.guardarDatoComuna();
			var arrayAlimentador: ArrayCollection = filtroAvanzadoClienteSed.filtroAlimentador.guardarDatoAlimentador();
			
			if(arrayPeriodoFecha == null)
			{
				ZAlerta.show("Debe seleccionar un periodo");
				return; 
			}
			
			var stringTipoResultado:String=formularioBusquedaClienteSed.listaTipoResultado.selectedItem;
			
			if (stringTipoResultado==null){
				ZAlerta.show("Debe seleccionar un tipo de resultado");
				return;
			}
			
			filtrosSeleccionadosBusqueda=new FiltrosSeleccionadosBusqueda;
			
			if (stringTipoResultado=="Cliente"){
				Global.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_CLIENTE;
				filtrosSeleccionadosBusqueda.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_CLIENTE;
			}
			else if (stringTipoResultado=="SED"){
				Global.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_SED;
				filtrosSeleccionadosBusqueda.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_SED;
			}
			
			filtrosSeleccionadosBusqueda.arrayAlimentador=arrayAlimentador;
			filtrosSeleccionadosBusqueda.arrayComuna=arrayComuna;
			filtrosSeleccionadosBusqueda.arraySSEE=arraySSEE;
			filtrosSeleccionadosBusqueda.arrayZona=arrayZona;
			filtrosSeleccionadosBusqueda.arrayPeriodoFecha=arrayPeriodoFecha;
			
			if (formularioBusquedaClienteSed.radioDuracion.selected){
				filtrosSeleccionadosBusqueda.ordenResultados=FiltrosSeleccionadosBusqueda.ORDEN_DURACION;
			}
			else if (formularioBusquedaClienteSed.radioFrecuencia.selected){
				filtrosSeleccionadosBusqueda.ordenResultados=FiltrosSeleccionadosBusqueda.ORDEN_FRECUENCIA;
			}
			
			var causa:String=formularioBusquedaClienteSed.filtroCausa.listaCausaInterrupcion.selectedItem;
			
			filtrosSeleccionadosBusqueda.causa=causa;

			selectorEtapa.activar(3);
			selectorEtapa.seleccionar(3);
			mostrarTablaInterrupcionesClienteSed(filtrosSeleccionadosBusqueda);
		}
		
		public function mostrarPaso(indicePaso:Number):void{
			if (indicePaso==1){
				stackPrincipal.selectedIndex=0;
			}
			else if (indicePaso==2){
				stackPrincipal.selectedIndex=1;
			}
			else if (indicePaso==3){
				stackPrincipal.selectedIndex=2;
			}
		}
		
		public function mostrarTablaInterrupcionesClienteSed(filtrosSeleccionadosBusqueda:FiltrosSeleccionadosBusqueda):void{
			stackPrincipal.selectedIndex = 2;
			tablaInterrupcionesClienteSed.buscar(filtrosSeleccionadosBusqueda);
		}
		
		public function reiniciarWidget():void
		{
			stackPrincipal.selectedIndex = 0;
			selectorEtapa.seleccionar(1);
			selectorEtapa.desactivar(2);
			selectorEtapa.desactivar(3);
			mostrarPaso(1);
			formularioBusquedaClienteSed.limpiarFiltros();
			filtroAvanzadoClienteSed.limpiarFiltros();
			
		}
	}
}