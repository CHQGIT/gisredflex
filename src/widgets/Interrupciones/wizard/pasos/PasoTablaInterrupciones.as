package widgets.Interrupciones.wizard.pasos
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.events.IdentityManagerEvent;
	
	import comun.util.zalerta.ZAlerta;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import widgets.Interrupciones.busqueda.FiltrosSeleccionadosBusqueda;
	import widgets.Interrupciones.busqueda.resultado.exportarExcel.ExportarExcel;
	import widgets.Interrupciones.componentesComunes.DtoObjetoLista;
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.principal.Principal;
	import widgets.Interrupciones.servicios.BusquedaInterrupcionComun;
	import widgets.Interrupciones.servicios.InterrupcionBaseDto;
	import widgets.Interrupciones.servicios.interrupciones.BusquedaInterrupciones;
	import widgets.Interrupciones.servicios.interrupciones.DtoInterrupcion;
	import widgets.Interrupciones.wizard.filtros.*;

	public class PasoTablaInterrupciones extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var tablaInterrupciones:DataGrid;
		
		[SkinPart(required="true")]
		public var botonVerDetalle:Button;
		
		[SkinPart(required="true")]
		public var imagenExcel:Image;
		
		[Bindable]
		public var checksAlimentador:Object = new Object;
		
		[Bindable]
		public var checksSSEE:Object = new Object;
		
		[Bindable]
		public var checksClasificacion1:Object = new Object;
		
		[Bindable]
		public var checksClasificacion2:Object = new Object;
		
		[Bindable]
		public var checksClasificacion3:Object = new Object;
		
		public var busquedaInterrupciones:BusquedaInterrupciones;
		public var principal:Principal;
		public var interrupcionSeleccionada:DtoInterrupcion;
		
		//VARIABLES NECESARIAS PARA LOS FILTROS...
		[SkinPart(required="true")]
		public var listaAlimentador:DataGrid;
		
		[SkinPart(required="true")]
		public var columnAlimentador:DataGridColumn;
		
		[SkinPart(required="true")]
		public var listaSSEE:DataGrid;
		
		[SkinPart(required="true")]
		public var columnSSEE:DataGridColumn;
		
		[SkinPart(required="true")]
		public var listaClasificacion1:DataGrid;
		
		[SkinPart(required="true")]
		public var columnClasif1:DataGridColumn;
		
		[SkinPart(required="true")]
		public var listaClasificacion2:DataGrid;
		
		[SkinPart(required="true")]
		public var columnClasif2:DataGridColumn;
		
		[SkinPart(required="true")]
		public var listaClasificacion3:DataGrid;
		
		[SkinPart(required="true")]
		public var columnClasif3:DataGridColumn;
		
		[SkinPart(required="true")]
		public var todoAlimentador:CheckBox;
		
		[SkinPart(required="true")]
		public var todoSSEE:CheckBox;
		
		[SkinPart(required="true")]
		public var todoClasificacion1:CheckBox;
		
		[SkinPart(required="true")]
		public var todoClasificacion2:CheckBox;
		
		[SkinPart(required="true")]
		public var todoClasificacion3:CheckBox;
		
		public var buscador:PasoTablaInterrupciones;
		public var renderAlimentador:ClassFactory;
		public var renderSSEE:ClassFactory;
		public var renderClasificacion1:ClassFactory;
		public var renderClasificacion2:ClassFactory;
		public var renderClasificacion3:ClassFactory;

		[Bindable]
		public var listaBusqueda:ArrayCollection = new ArrayCollection();
		
		public function PasoTablaInterrupciones()
		{
			setStyle("skinClass",SkinPasoTablaInterrupciones);
			
			busquedaInterrupciones = new BusquedaInterrupciones();
			listaBusqueda = new ArrayCollection;
		}
		
		override protected function partAdded(partName:String,instance:Object):void{
			if(instance == botonVerDetalle)
			{
				botonVerDetalle.addEventListener(MouseEvent.CLICK,clickVerDetalle);
			}
			
			if(instance == imagenExcel)
			{
				imagenExcel.addEventListener(MouseEvent.CLICK,clickExcelInterrupciones);
			}
		}
		
		public function clickVerDetalle(e:MouseEvent):void{
			
			if (tablaInterrupciones.selectedIndex==-1){
				ZAlerta.show("se debe seleccionar elemento en la tabla");
				return;
			}
			
			var indiceSeleccionado:Number=tablaInterrupciones.selectedIndex;
			var dtoInterrupcion:DtoInterrupcion=tablaInterrupciones.selectedItem as DtoInterrupcion;
			
			var fsb:FiltrosSeleccionadosBusqueda=new FiltrosSeleccionadosBusqueda;
			fsb.ordenResultados=FiltrosSeleccionadosBusqueda.ORDEN_DURACION;

			fsb.idInterrupcion=dtoInterrupcion.idInterrupcion;
			
			interrupcionSeleccionada=dtoInterrupcion;
			
			var busquedaInterrupcionComun:BusquedaInterrupcionComun = new BusquedaInterrupcionComun;
			busquedaInterrupcionComun.busquedaAgrupada(busquedaOk,busquedaError,fsb,BusquedaInterrupcionComun.TIPO_BUSQUEDA_POR_INTERRUPCION,false);
		}
		
		public function buscarSegunPeriodoCausa(arrayPeriodo:ArrayCollection,causa:String):void{
			busquedaInterrupciones.buscar(okInterrupciones,errorInterrupciones,arrayPeriodo,causa);			
		}
		
		public function okInterrupciones(r: ArrayCollection): void
		{
			if (r==false){
				return;
			}
			
			listaBusqueda = r
			principal.stackPrincipal.selectedIndex=1;
			listaBusqueda.filterFunction = filtro;
			tablaInterrupciones.dataProvider = listaBusqueda;
			
			buscador = this;
			
			renderAlimentador = new ClassFactory(RendererFiltrosTablaInterrupciones);
			renderAlimentador.properties = {componente:this};		
			
			renderSSEE = new ClassFactory(RendererFiltrosTablaInterrupciones);
			renderSSEE.properties = {componente:this};	
			
			renderClasificacion1 = new ClassFactory(RendererFiltrosTablaInterrupciones);
			renderClasificacion1.properties = {componente:this};	
			
			renderClasificacion2 = new ClassFactory(RendererFiltrosTablaInterrupciones);
			renderClasificacion2.properties = {componente:this};
			
			renderClasificacion3 = new ClassFactory(RendererFiltrosTablaInterrupciones);
			renderClasificacion3.properties = {componente:this};

			iniciarComponente();
			
			this.principal.pasoFiltrosBasicosInterrupciones.recalcular=false;
		}
		
		public function errorInterrupciones(mensaje:String):void{
			ZAlerta.show("error 54 "+mensaje);
		}
		
		private function busquedaOk(featureSet: FeatureSet, token:Object = null): void
		{
			
			var resultado: ArrayCollection = new ArrayCollection;
			
			if(featureSet.features.length == 0)
			{
				ZAlerta.show("no se encuentran interrupciones");
			//	callBackOk(resultado);
				return;
			}
			
			var mostrado: Boolean = false;
			
			for(var pos:Number = 0; pos < featureSet.features.length; pos++)
			{
				var g:Graphic = featureSet.features[pos] as Graphic;
				var frecuenciaNis:Number=Number(g.attributes["frecuenciaNis"]);
				var duracionNis:Number=Number(g.attributes["duracionNis"]);
				
				var causa:String=null;
				
				var id:Number;
				if (Global.tipoBusquedaCliente()){
					id=Number(g.attributes["nis"]);
				}
				
				else if (Global.tipoBusquedaSed()){
					id=Number(g.attributes["sed"]);
					causa=g.attributes["tipo_emp"];
				}
				
				var interrupcionDto:InterrupcionBaseDto=new InterrupcionBaseDto;
				interrupcionDto.frecuenciaNis=frecuenciaNis;
				interrupcionDto.duracionNis=duracionNis;
				interrupcionDto.id=id;
				interrupcionDto.causa=causa;
				
				resultado.addItem(interrupcionDto);
			}
			
			principal.selectorEtapa.activar(3);
			
			principal.pasoResultadoInterrupciones.interrupciones.mostrarDatos(resultado);
			principal.selectorEtapa.seleccionar(3);
			principal.irAPaso3Interrupciones();
			
			principal.pasoResultadoInterrupciones.interrupciones.filtroCausaSed.visible=false;
			
			principal.pasoResultadoInterrupciones.mostrarInterrupcionSeleccionada(this.interrupcionSeleccionada);
		}
		
		private function busquedaError(info:Object, token:Object = null):void
		{
			ZAlerta.show("error xxx "+info);
			//callBackError("error" +info);
		}
		
		public function buscarSegunIdInterrupcion(query:String):void{
			var bi:BusquedaInterrupciones=new BusquedaInterrupciones();
			bi.buscarPorId(okInterrupciones,errorInterrupciones,query);
		}
		
		protected function listaCausaInterrupcion_changeHandler(event: IndexChangeEvent): void
		{
	
		}
		
		public function filtro(item:Object):Boolean
		{

			if(checksAlimentador != null && !checksAlimentador[item.alimentador].selected){
				return false;
			}
			
			if(checksSSEE != null && !checksSSEE[item.ssee].selected){
				return false;
			}
			
			if(checksClasificacion1 != null && !checksClasificacion1[item.causa1].selected){
				return false;
			}
			
			if(checksClasificacion2 != null && !checksClasificacion2[item.causa2].selected){
				return false;
			}
			
			if(checksClasificacion3 != null && !checksClasificacion3[item.causa3].selected){
				return false;
			}
			
			return true;
		}
		
		public function clickExcelInterrupciones(e:MouseEvent):void{
			var arrayCollection:ArrayCollection=tablaInterrupciones.dataProvider as ArrayCollection;
			ExportarExcel.exportarInterrupcion(arrayCollection, "Interrupciones");			
		}
		
		public function limpiarTablaInterrupciones():void
		{
			tablaInterrupciones.dataProvider = null;
		}
		
		//PROCEDIMIENTOS RELACIONADOS A LOS FILTROS ============================================================================================
		
		public function iniciarComponente():void
		{
			
			columnAlimentador.itemRenderer = renderAlimentador;
			columnSSEE.itemRenderer = renderSSEE;
			columnClasif1.itemRenderer = renderClasificacion1;
			columnClasif2.itemRenderer = renderClasificacion2;
			columnClasif3.itemRenderer = renderClasificacion3;
			
			todoAlimentador.addEventListener("click", seleccionarTodos);
			todoSSEE.addEventListener("click", seleccionarTodos);
			todoClasificacion1.addEventListener("click", seleccionarTodos);
			todoClasificacion2.addEventListener("click", seleccionarTodos);
			todoClasificacion3.addEventListener("click", seleccionarTodos);
			
			iniciarCheckAlimentador();
			
		}
		
		public function limpiarComponente():void
		{
			todoAlimentador.selected = true;
			todoSSEE.selected = true;
			todoClasificacion1.selected = true;
			todoClasificacion2.selected = true;
			todoClasificacion3.selected = true;
			
			listaAlimentador.dataProvider = new ArrayCollection;
			listaSSEE.dataProvider = new ArrayCollection;
			listaClasificacion1.dataProvider = new ArrayCollection;
			listaClasificacion2.dataProvider = new ArrayCollection;
			listaClasificacion3.dataProvider = new ArrayCollection;
		}
		
		public function iniciarCheckAlimentador():void										 
		{	
			var listaCheckAlimentador:ArrayCollection = new ArrayCollection();						
			var elementos:ArrayCollection = tablaInterrupciones.dataProvider as ArrayCollection;			
			var alimentadoresDisponibles:ArrayCollection = new ArrayCollection;
			var alimentadorValidador:ArrayCollection = new ArrayCollection;
			
			for each(var objeto:DtoInterrupcion in elementos)
			{
				
				var alimentador:String = objeto.alimentador;
				var validador:int = alimentadorValidador.getItemIndex(alimentador);
				
				if(validador == -1)
				{
					var alimentadorValido:TipoFiltrosTabla = new TipoFiltrosTabla();
					alimentadorValido.nombre = alimentador;
					alimentadoresDisponibles.addItem(alimentadorValido);
					alimentadorValidador.addItem(alimentador);
					checksAlimentador[alimentadorValido.nombre] = alimentadorValido.check;
					checksAlimentador[alimentadorValido.nombre].selected = alimentadorValido.seleccionado;					
				}							
			}
			
			listaAlimentador.dataProvider = alimentadoresDisponibles;
			iniciarCheckSSEE();
		}
		
		public function iniciarCheckSSEE():void
		{
			var listaCheckSSEE:ArrayCollection = new ArrayCollection();						
			var elementos:ArrayCollection = tablaInterrupciones.dataProvider as ArrayCollection;			
			var sseeDisponibles:ArrayCollection = new ArrayCollection;
			var sseeValidor:ArrayCollection = new ArrayCollection;
			
			for each(var objeto:DtoInterrupcion in elementos)
			{
				var ssee:String = objeto.ssee;	
				var validador:int = sseeValidor.getItemIndex(ssee);			
				if(validador == -1)
				{
					var sseeValido:TipoFiltrosTabla = new TipoFiltrosTabla();
					sseeValido.nombre = ssee;
					sseeDisponibles.addItem(sseeValido);
					sseeValidor.addItem(sseeValido.nombre);
					checksSSEE[sseeValido.nombre] = sseeValido.check;
					checksSSEE[sseeValido.nombre].selected = sseeValido.seleccionado;					
				}							
			}
			
			listaSSEE.dataProvider = sseeDisponibles;
			iniciarCheckClasificacion1();
		}
		
		public function iniciarCheckClasificacion1():void
		{			
			var listaCheckClasificacion:ArrayCollection = new ArrayCollection();						
			var elementos:ArrayCollection = tablaInterrupciones.dataProvider as ArrayCollection;			
			var clasificacionDisponibles:ArrayCollection = new ArrayCollection;
			var clasificacionValidor:ArrayCollection = new ArrayCollection;
			
			for each(var objeto:DtoInterrupcion in elementos)
			{
				var clasificacion:String = objeto.causa1;	
				var validador:int = clasificacionValidor.getItemIndex(clasificacion);			
				if(validador == -1)
				{
					var clasificacionValido:TipoFiltrosTabla = new TipoFiltrosTabla();
					clasificacionValido.nombre = clasificacion;
					clasificacionDisponibles.addItem(clasificacionValido);
					clasificacionValidor.addItem(clasificacion);
					checksClasificacion1[clasificacionValido.nombre] = clasificacionValido.check;
					checksClasificacion1[clasificacionValido.nombre].selected = clasificacionValido.seleccionado;					
				}							
			}
			
			listaClasificacion1.dataProvider = clasificacionDisponibles;
			iniciarCheckClasificacion2();
		}
		
		public function iniciarCheckClasificacion2():void
		{			
			var listaCheckClasificacion:ArrayCollection = new ArrayCollection();						
			var elementos:ArrayCollection = tablaInterrupciones.dataProvider as ArrayCollection;			
			var clasificacionDisponibles:ArrayCollection = new ArrayCollection;
			var clasificacionValidor:ArrayCollection = new ArrayCollection;
			
			for each(var objeto:DtoInterrupcion in elementos)
			{
				var clasificacion:String = objeto.causa2;	
				var validador:int = clasificacionValidor.getItemIndex(clasificacion);			
				if(validador == -1)
				{
					var clasificacionValido:TipoFiltrosTabla = new TipoFiltrosTabla();
					clasificacionValido.nombre = clasificacion;
					clasificacionDisponibles.addItem(clasificacionValido);
					clasificacionValidor.addItem(clasificacion);
					checksClasificacion2[clasificacionValido.nombre] = clasificacionValido.check;
					checksClasificacion2[clasificacionValido.nombre].selected = clasificacionValido.seleccionado;					
				}							
			}
			
			listaClasificacion2.dataProvider = clasificacionDisponibles;
			iniciarCheckClasificacion3();
		}
		
		public function iniciarCheckClasificacion3():void
		{			
			var listaCheckClasificacion:ArrayCollection = new ArrayCollection();						
			var elementos:ArrayCollection = tablaInterrupciones.dataProvider as ArrayCollection;			
			var clasificacionDisponibles:ArrayCollection = new ArrayCollection;
			var clasificacionValidor:ArrayCollection = new ArrayCollection;
			
			for each(var objeto:DtoInterrupcion in elementos)
			{
				var clasificacion:String = objeto.causa3;	
				var validador:int = clasificacionValidor.getItemIndex(clasificacion);			
				if(validador == -1)
				{
					var clasificacionValido:TipoFiltrosTabla = new TipoFiltrosTabla();
					clasificacionValido.nombre = clasificacion;
					clasificacionDisponibles.addItem(clasificacionValido);
					clasificacionValidor.addItem(clasificacion);
					checksClasificacion3[clasificacionValido.nombre] = clasificacionValido.check;
					checksClasificacion3[clasificacionValido.nombre].selected = clasificacionValido.seleccionado;					
				}							
			}
			
			listaClasificacion3.dataProvider = clasificacionDisponibles;
		}
		
		public function filtrar():void
		{
			listaBusqueda.filterFunction = null;
			listaBusqueda.filterFunction = filtro; 
			listaBusqueda.refresh();
		}
		
		public function seleccionarTodos(e:MouseEvent):void
		{
			var checkSeleccionado:CheckBox = (e.target as CheckBox);
			var seleccionado:String = checkSeleccionado.id;
			var estado:Boolean = checkSeleccionado.selected;
			var listaElementos:ArrayCollection = new ArrayCollection;
			
			if(seleccionado == todoAlimentador.id)
			{
				listaElementos = listaAlimentador.dataProvider as ArrayCollection;
			}
			if(seleccionado == todoSSEE.id)
			{
				listaElementos = listaSSEE.dataProvider as ArrayCollection;
			}
			if(seleccionado == todoClasificacion1.id)
			{
				listaElementos = listaClasificacion1.dataProvider as ArrayCollection;
			}
			if(seleccionado == todoClasificacion2.id)
			{
				listaElementos = listaClasificacion2.dataProvider as ArrayCollection;
			}
			if(seleccionado == todoClasificacion3.id)
			{
				listaElementos = listaClasificacion3.dataProvider as ArrayCollection;
			}
			
			for each(var objeto:TipoFiltrosTabla in listaElementos)
			{
				objeto.seleccionado = estado;
				objeto.check.selected = estado;
			}
			
			filtrar(); 
		}
	}
}