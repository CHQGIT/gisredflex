package widgets.InterrupcionesClientesSED2.busqueda
{
	import comun.util.zalerta.ZAlerta;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.RadioButton;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import widgets.Buscador.filtros.TipoFiltroBuscador;
	import widgets.Interrupciones.busqueda.filtros.FiltroCausa;
	import widgets.Interrupciones.busqueda.filtros.FiltroPeriodo;
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.principal.Principal;
	import widgets.Interrupciones.wizard.SelectorEtapa;
	import widgets.InterrupcionesClientesSED2.principal.PrincipalClienteSED;

	public class FormularioBusquedaClienteSed extends SkinnableComponent
	{
		private static const horaInicio: String = "00:00:00.000";
		private static const horaFinal: String = "23:59:59.999";
		
		[SkinPart]
		public var buscarInterrupcionButton:Button;
		
		[SkinPart]
		public var botonVerAnteriores:Button;
		
		[SkinPart]
		public var listaTipoResultado:DropDownList;
		
		[SkinPart]
		public var filtroCausa: FiltroCausa;
		
		[SkinPart]
		public var filtroPeriodo: FiltroPeriodo;
	
		[SkinPart]
		public var radioFrecuencia: RadioButton;
		
		[SkinPart]
		public var radioDuracion: RadioButton;
		
	 	public var whereObject: Object;
		public var whereQuery: String;
		
		public var selectorEtapa:SelectorEtapa;
		
		public var principal:PrincipalClienteSED;
		
		public function FormularioBusquedaClienteSed()
		{
			setStyle("skinClass", FormularioBusquedaClienteSedSkin);
			
			this.whereObject = {stringWhere: ""};
		}
		
		override protected function partAdded(partName:String,instance:Object):void{
			
			if (instance==buscarInterrupcionButton){
				buscarInterrupcionButton.addEventListener(MouseEvent.CLICK,buscarInterrupcionButton_clickHandler);
			}
			
			if (instance==listaTipoResultado){
				var tipoResultado:ArrayCollection = new ArrayCollection();
				
				tipoResultado.addItem("Cliente");
				tipoResultado.addItem("SED");
				
				listaTipoResultado.dataProvider=tipoResultado;
				
				listaTipoResultado.selectedIndex=0;
				
				listaTipoResultado.addEventListener(IndexChangeEvent.CHANGE, cambioSeleccionTipoResultado);
			}
			
			if(instance == botonVerAnteriores)
			{
				this.botonVerAnteriores.addEventListener(MouseEvent.CLICK,clickAnteriores);
			}
			
			if(instance == filtroPeriodo)
			{
				filtroPeriodo.callBackFecha=callBackFecha;
				//filtroPeriodo.addEventListener(MouseEvent.CLICK,clickAnteriores);
			}
		}
		
		protected function cambioSeleccionTipoResultado(event: IndexChangeEvent): void
		{
			var indiceNuevo:Number=event.newIndex;
			
			if (indiceNuevo==1){
				filtroCausa.visible=false;
			}
			else{
				filtroCausa.visible=true;
			}
		}
		
		public function callBackOk(resultado:ArrayCollection):void{
		//	Global.principal.mostrarTablaInterrupciones(resultado);
		}
		
		public function callBackError(mensaje:String):void{
			ZAlerta.show("error 33 "+mensaje);
		}
		
		private function esquemaWhereQuery(zona: ArrayCollection,periodoFecha: ArrayCollection): void
		{
		 //	this.filtroZona.generarWhere(zona, this.whereObject);
			this.filtroPeriodo.generarWhere(periodoFecha, this.whereObject);
		}
		
		public function clickAnteriores(e:MouseEvent):void{
			Global.principal.stackPrincipal.selectedIndex=2;
		}
		
		public function callBackFecha():void{
			selectorEtapa.activar(2);
		}
		
		public function buscarInterrupcionButton_clickHandler(e:MouseEvent):void{
			
		}
		
		public function limpiarFiltros():void
		{
			radioFrecuencia.selected = true;
			radioDuracion.selected = false;
			listaTipoResultado.selectedIndex = 0;
			filtroCausa.listaCausaInterrupcion.selectedIndex = 0;
			filtroCausa.visible = true;
			filtroPeriodo.fechaInicio.selectedDate = null;
			filtroPeriodo.fechaFin.selectedDate = null;
			
		}
	}
}