package widgets.Buscador.filtros
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.ClassFactory;
	
	import spark.collections.Sort;
	import spark.collections.SortField;
	import spark.components.Button;
	import spark.components.List;
	import spark.components.TabBar;
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	
	import widgets.Buscador.BuscadorWidget;

	public class FiltrosBuscador extends SkinnableComponent
	{			
		[SkinPart(required="true")]
		public var grillaAnios:DataGrid;
		
		[SkinPart(required="true")]
		public var columnaAnios:DataGridColumn;
		
		[SkinPart(required="true")]
		public var grillaCausa:DataGrid;
		
		[SkinPart(required="true")]
		public var columnaCausa:DataGridColumn;
		
		[SkinPart(required="true")]
		public var grillaClasificacion:DataGrid;
		
		[SkinPart(required="true")]
		public var columnaClasificacion:DataGridColumn;
		
		[SkinPart(required="true")]
		public var todoAnios:CheckBox;
		
		[SkinPart(required="true")]
		public var todoCausa:CheckBox;
		
		[SkinPart(required="true")]
		public var todoClasificacion:CheckBox;
		
		public var buscador:BuscadorWidget;
		public var renderAnio:ClassFactory;
		public var renderCausa:ClassFactory;
		public var renderClasificacion:ClassFactory;
		
		public function FiltrosBuscador()
		{
			super();
			setStyle("skinClass", SkinFiltrosBuscador);
			
			renderAnio = new ClassFactory(RendererFiltrosBuscador);
			renderAnio.properties = {componente:this};		
			
			renderCausa = new ClassFactory(RendererFiltrosBuscador);
			renderCausa.properties = {componente:this};	
			
			renderClasificacion = new ClassFactory(RendererFiltrosBuscador);
			renderClasificacion.properties = {componente:this};	
		}
		
		public function iniciarComponente(buscador:BuscadorWidget):void
		{
			this.buscador = buscador;	
			
			columnaAnios.itemRenderer = renderAnio;
			columnaCausa.itemRenderer = renderCausa;
			columnaClasificacion.itemRenderer = renderClasificacion;
			
			todoAnios.addEventListener("click",seleccionarTodos);
			todoCausa.addEventListener("click",seleccionarTodos);
			todoClasificacion.addEventListener("click",seleccionarTodos);
			
			iniciarCheckAnio();
			iniciarCheckCausa();
			iniciarCheckClasificacion();					
		}
		
		public function limpiarComponente():void
		{
			todoAnios.selected = true;
			todoCausa.selected = true;
			todoClasificacion.selected = true;
			
			grillaAnios.dataProvider = new ArrayCollection;
			grillaCausa.dataProvider = new ArrayCollection;
			grillaClasificacion.dataProvider = new ArrayCollection;
		}
		
		public function iniciarCheckAnio():void										 
		{	
			var listaCheckAnios:ArrayCollection = new ArrayCollection();						
			var elementos:ArrayCollection = buscador.datagridResultado.dataProvider as ArrayCollection;			
			var aniosDisponibles:ArrayCollection = new ArrayCollection;
			var aniosValidador:ArrayCollection = new ArrayCollection;
			for each(var objeto:Object in elementos)
			{
				var anio:int = new Number(objeto["anio"].toString());	
				var validador:int = aniosValidador.getItemIndex(anio);
				if(validador == -1)
				{
					var anioValido:TipoFiltroBuscador = new TipoFiltroBuscador();
					anioValido.anio = anio;
					anioValido.esAnio = true;
					aniosDisponibles.addItem(anioValido);
					aniosValidador.addItem(anio);
					buscador.checksAnio[anioValido.anio] = anioValido.check;
					buscador.checksAnio[anioValido.anio].selected = anioValido.seleccionado;					
				}							
			}
			
			var dataSortField:SortField = new SortField();
			dataSortField.name = "anio";
			dataSortField.numeric = true;
			dataSortField.descending = false;
			
			var numericDataSort:Sort = new Sort();			
			numericDataSort.fields = [dataSortField];
			aniosDisponibles.sort = numericDataSort;
			aniosDisponibles.refresh();						
			grillaAnios.dataProvider = aniosDisponibles;
		}

		public function iniciarCheckCausa():void
		{
			var listaCheckCausa:ArrayCollection = new ArrayCollection();						
			var elementos:ArrayCollection = buscador.datagridResultado.dataProvider as ArrayCollection;			
			var causasDisponibles:ArrayCollection = new ArrayCollection;
			var causasValidor:ArrayCollection = new ArrayCollection;
			
			for each(var objeto:Object in elementos)
			{
				var causa:String = objeto["descripcion"].toString();	
				var validador:int = causasValidor.getItemIndex(causa);			
				if(validador == -1)
				{
					var causaValido:TipoFiltroBuscador = new TipoFiltroBuscador();
					causaValido.nombre = causa;
					causaValido.esAnio = false;
					causasDisponibles.addItem(causaValido);
					causasValidor.addItem(causaValido.nombre);
					buscador.checksCausa[causaValido.nombre] = causaValido.check;
					buscador.checksCausa[causaValido.nombre].selected = causaValido.seleccionado;					
				}							
			}
			
			grillaCausa.dataProvider = causasDisponibles;
		}
		
		public function iniciarCheckClasificacion():void
		{			
			var listaCheckClasificacion:ArrayCollection = new ArrayCollection();						
			var elementos:ArrayCollection = buscador.datagridResultado.dataProvider as ArrayCollection;			
			var clasificacionDisponibles:ArrayCollection = new ArrayCollection;
			var clasificacionValidor:ArrayCollection = new ArrayCollection;
			
			for each(var objeto:Object in elementos)
			{
				var clasificacion:String = objeto["clasificacion"].toString();	
				var validador:int = clasificacionValidor.getItemIndex(clasificacion);			
				if(validador == -1)
				{
					var clasificacionValido:TipoFiltroBuscador = new TipoFiltroBuscador();
					clasificacionValido.nombre = clasificacion;
					clasificacionValido.esAnio = false;
					clasificacionDisponibles.addItem(clasificacionValido);
					clasificacionValidor.addItem(clasificacion);
					buscador.checksClasificacion[clasificacionValido.nombre] = clasificacionValido.check;
					buscador.checksClasificacion[clasificacionValido.nombre].selected = clasificacionValido.seleccionado;					
				}							
			}
			
			grillaClasificacion.dataProvider = clasificacionDisponibles;
		}
		
		public function filtrar():void
		{
			buscador.listaBusqueda.filterFunction = null;
			buscador.listaBusqueda.filterFunction = buscador.filtro; 
			buscador.listaBusqueda.refresh();
		}
		
		public function seleccionarTodos(e:MouseEvent):void
		{
			var checkSeleccionado:CheckBox = (e.target as CheckBox);
			var seleccionado:String = checkSeleccionado.id;
			var estado:Boolean = checkSeleccionado.selected;
			trace("seleccionado " + seleccionado);
			trace("estado " + estado);
			trace("todoClasificacion.id " + todoClasificacion.id);
			
			var listaElementos:ArrayCollection = new ArrayCollection;
			if(seleccionado == todoAnios.id)
			{
				listaElementos = grillaAnios.dataProvider as ArrayCollection;
			}
			if(seleccionado == todoCausa.id)
			{
				listaElementos = grillaCausa.dataProvider as ArrayCollection;
			}
			if(seleccionado == todoClasificacion.id)
			{
				listaElementos = grillaClasificacion.dataProvider as ArrayCollection;
			}
			
			for each(var objeto:TipoFiltroBuscador in listaElementos)
			{
				objeto.seleccionado = estado;
				objeto.check.selected = estado;
			}
			
			filtrar(); 
		}
	
	}
}