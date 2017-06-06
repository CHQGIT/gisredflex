package widgets.Interrupciones.wizard.pasos
{
	import mx.collections.ArrayCollection;
	
	import spark.components.DropDownList;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import comun.util.zalerta.ZAlerta;
	
	import widgets.Interrupciones.busqueda.filtros.FiltroCausa;
	import widgets.Interrupciones.busqueda.filtros.FiltroPeriodo;
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.servicios.BusquedaInterrupcionComun;
	import widgets.Interrupciones.wizard.SelectorEtapa;

	public class PasoFiltrosBasicosInterrupciones extends SkinnableComponent
	{
		[SkinPart(required=true)]
		public var filtroPeriodo: FiltroPeriodo;
		
		[SkinPart]
		public var listaTipoResultado:DropDownList;
		
		public var selectorEtapa:SelectorEtapa;
		
		[SkinPart (required="true")]
		public var filtroCausa: FiltroCausa;
		
		public var recalcular:Boolean=true;
		
		public function PasoFiltrosBasicosInterrupciones()
		{
			setStyle("skinClass",SkinPasoFiltrosBasicosInterrupciones);
		}
		
		override protected function partAdded(partName:String,instance:Object):void{
			if(instance == filtroPeriodo)
			{
				filtroPeriodo.callBackFecha=callBackFecha;
			}
			
			if (instance==listaTipoResultado){
				var tipoResultado:ArrayCollection = new ArrayCollection();
				
				tipoResultado.addItem("Cliente");
				tipoResultado.addItem("SED");
				
				listaTipoResultado.dataProvider=tipoResultado;
				
				listaTipoResultado.selectedIndex=0;
				
				listaTipoResultado.addEventListener(IndexChangeEvent.CHANGE, cambioSeleccionTipoResultado);
				
				Global.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_CLIENTE;
			}
		}
		
		protected function cambioSeleccionTipoResultado(event: IndexChangeEvent): void
		{
			var indiceNuevo:Number=event.newIndex;
			
			if (indiceNuevo==0){
				Global.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_CLIENTE;
			}
			else if (indiceNuevo==1){
				Global.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_SED;
			}
			recalcular=true;
		}
		
		public function callBackFecha():void{
			selectorEtapa.activar(2);
			recalcular=true;
		}
		
		public function valido():Boolean{
			return filtroPeriodo.valido();
		}
		
		public function limpiarFiltros():void
		{
			filtroPeriodo.fechaInicio.selectedDate = null;
			filtroPeriodo.fechaFin.selectedDate = null;
			listaTipoResultado.selectedIndex = 0;
		}
	}
}