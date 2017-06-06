package widgets.Interrupciones.busqueda
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.busqueda.filtros.FiltroPeriodo;
	import widgets.Interrupciones.global.Global;
	import comun.util.zalerta.ZAlerta;
	import widgets.Interrupciones.servicios.BusquedaInterrupcionComun;

	public class FormularioBusquedaInterrupcion extends SkinnableComponent
	{
		[SkinPart(required=true)]
		public var buscarClienteSedBtn: Button;
		
		[SkinPart(required=true)]
		public var volverMenuPrincipalBtn: Button;
		
		[SkinPart(required=true)]
		public var filtroPeriodo: FiltroPeriodo;

		[SkinPart(required=true)]
		public var listaTipoResultado:DropDownList;
		
		public var whereObject: Object;
		
		public var whereQuery: String;
		
		private var numeroResultadoSeleccionado: String;
		
		public function FormularioBusquedaInterrupcion()
		{
			setStyle("skinClass", FormularioBusquedaInterrupcionSkin);
			
		 	this.whereObject = {stringWhere: ""};
		}
		
		override protected function partAdded(partName:String, instance:Object): void
		{
			if(instance == buscarClienteSedBtn)
			{
				this.buscarClienteSedBtn.addEventListener(MouseEvent.CLICK, buscarClienteSedBtn_clickHandler);
			}
			
			if(instance == volverMenuPrincipalBtn)
			{
				this.volverMenuPrincipalBtn.addEventListener(MouseEvent.CLICK, volverMenuPrincipalBtn_clickHandler);
			}
			
			if (instance==listaTipoResultado){
				var tipoResultado:ArrayCollection = new ArrayCollection();
				
				tipoResultado.addItem("Cliente");
				tipoResultado.addItem("SED");
				
				listaTipoResultado.dataProvider=tipoResultado;
				
				listaTipoResultado.selectedIndex=0;
			}
		}
		
		/*** EVENTOS DEL MOUSE ***/
		protected function buscarClienteSedBtn_clickHandler(event: MouseEvent): void
		{
			// GUARDA LOS DA S QUE FUERON SELECCIONADOS EN EL FORMULARIO
			var arrayPeriodoFecha: ArrayCollection = this.filtroPeriodo.guardarDatoTiempo();
			
			if(arrayPeriodoFecha == null)
			{
				return; 
			}
			
			var stringTipoResultado:String=this.listaTipoResultado.selectedItem;
			
			if (stringTipoResultado==null){
				ZAlerta.show("Debe seleccionar un tipo de resultado");
				return;
			}
			
			var filtrosSeleccionadosBusqueda:FiltrosSeleccionadosBusqueda=new FiltrosSeleccionadosBusqueda;
			
			if (stringTipoResultado=="Cliente"){
				Global.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_CLIENTE;
				filtrosSeleccionadosBusqueda.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_CLIENTE;
			}
			else if (stringTipoResultado=="SED"){
				Global.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_SED;
				filtrosSeleccionadosBusqueda.tipoResultadosBusqueda=BusquedaInterrupcionComun.TIPO_RESULTADO_BUSQUEDA_CLIENTE;
			}
		
			filtrosSeleccionadosBusqueda.arrayPeriodoFecha=arrayPeriodoFecha;
			Global.principal.mostrarTablaInterrupciones(filtrosSeleccionadosBusqueda);
		}
		
		protected function volverMenuPrincipalBtn_clickHandler(event: MouseEvent): void
		{
			Global.principal.mostrarPrincipal();
		}
		
		private function esquemaWhereQuery(tipoResultado: String, zona: ArrayCollection, tipoInterrupcion: ArrayCollection, periodoFecha: ArrayCollection): void
		{
			this.filtroPeriodo.generarWhere(periodoFecha, whereObject);
		}
	}
}