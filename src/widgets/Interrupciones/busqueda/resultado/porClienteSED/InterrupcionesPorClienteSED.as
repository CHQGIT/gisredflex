package widgets.Interrupciones.busqueda.resultado.porClienteSED
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.supportClasses.FeatureEditResults;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.ViewStack;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.rpc.AsyncResponder;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.Image;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import comun.util.zalerta.ZAlerta;
	
	import widgets.Interrupciones.busqueda.filtroResultados.FiltroResultados;
	import widgets.Interrupciones.busqueda.muestraPuntos.MuestraPuntos;
	import widgets.Interrupciones.busqueda.resultado.exportarExcel.ExportarExcel;
	import widgets.Interrupciones.busqueda.resultado.filtroCausaSed.FiltroCausaSed;
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.servicios.InterrupcionBaseDto;
	import widgets.Interrupciones.servicios.busquedaGeometria.BusquedaClientes;
	import widgets.Interrupciones.servicios.busquedaGeometria.BusquedaSED;
	
	public class InterrupcionesPorClienteSED extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var tablaInterrupciones:DataGrid;
		
		[SkinPart(required="true")]
		public var botonVerFrecuencia:Button;
		
		[SkinPart(required="true")]
		public var botonVerDuracion:Button;
		
		[SkinPart(required="true")]
		public var botonVerFrecuenciaAgrupado:Button;
		
		[SkinPart(required="true")]
		public var botonVerDuracionAgrupado:Button;
		
		[SkinPart(required="true")]
		public var botonVerInterrupcion:Button;
		
		[SkinPart(required="true")]
		public var comboZona:DropDownList;
		
		[SkinPart(required="true")]
		public var stackFiltros: ViewStack;
		
		[SkinPart(required="true")]
		public var imagenExcel: Image;
		
		[SkinPart(required="true")]
		public var filtroCausaSed: FiltroCausaSed;
		
		[SkinPart(required="true")]
		public var columnaDuracion: DataGridColumn;
		
		[SkinPart(required="true")]
		public var columnaFrecuencia: DataGridColumn;
		
		private var resultadoInterrupciones:ArrayCollection;
		
		public var muestraPuntos:MuestraPuntos;
		public var filtroResultados:FiltroResultados;
		
		public var tipoResultados:Number;
		
		public var tipoFiltro:String;
		
		public var query:String;
		
		public static var TIPO_FILTRO_ZONA:String="TIPO_FILTRO_ZONA";
		public static var TIPO_FILTRO_SSEE:String="TIPO_FILTRO_SSEE";
		public static var TIPO_FILTRO_COMUNA:String="TIPO_FILTRO_COMUNA";
		public static var TIPO_FILTRO_ALIMENTADOR:String="TIPO_FILTRO_ALIMENTADOR";
		
		public function InterrupcionesPorClienteSED()
		{
			setStyle("skinClass", SkinInterrupcionesPorClienteSED);
			filtroResultados=new FiltroResultados;
		}
		
		override protected function partAdded(partName: String, instance: Object): void
		{
			if(instance == imagenExcel)	{
				imagenExcel.addEventListener(MouseEvent.CLICK, exportarXLS_clickHandler);
			}
			
			if(instance == botonVerFrecuencia){
				botonVerFrecuencia.addEventListener(MouseEvent.CLICK, verFrecuencia);
			}
			
			if(instance == botonVerDuracion){
				botonVerDuracion.addEventListener(MouseEvent.CLICK, verDuracion);
			}
			
			if(instance == botonVerFrecuenciaAgrupado){
				botonVerFrecuenciaAgrupado.addEventListener(MouseEvent.CLICK, verFrecuenciaAgrupado);
			}
			
			if(instance == botonVerDuracionAgrupado){
				botonVerDuracionAgrupado.addEventListener(MouseEvent.CLICK, verDuracionAgrupado);
			}
			
			if(instance == comboZona){
				comboZona.addEventListener(IndexChangeEvent.CHANGE, cambioSeleccionCombo);
			}
			
			if(instance == stackFiltros){
				stackFiltros.selectedIndex = 0;
			}
			
			if(instance == tablaInterrupciones)	{
				tablaInterrupciones.addEventListener(Event.CHANGE, tablaInterrupciones_clickHandler);
			}
			
			if (instance==filtroCausaSed){
				filtroCausaSed.callbackCambio=cambioFiltroCausaSed;
			}
			
			if (instance==botonVerInterrupcion){
				botonVerInterrupcion.addEventListener(MouseEvent.CLICK, verInterrupcion);
			}
		}
		
		protected function tablaInterrupciones_clickHandler(event: Event): void
		{
			Global.capaSeleccionado.clear();
			var indiceSeleccionado: int = event.target.selectedIndex;
			var lista:ArrayCollection=tablaInterrupciones.dataProvider as ArrayCollection;
			
			var elementoSeleccionado:InterrupcionBaseDto=lista.getItemAt(indiceSeleccionado) as InterrupcionBaseDto;
			var g:Graphic=elementoSeleccionado.graphicDuracion;
			var mapPoint:MapPoint=g.geometry as MapPoint;
			
			var simboloDuracion:SimpleMarkerSymbol=new SimpleMarkerSymbol("circle", 15,0x0000ff,1);
			
			var nuevo:Graphic=new Graphic(mapPoint,simboloDuracion);
			
			Global.capaSeleccionado.add(nuevo);
			Global.map.centerAt(mapPoint);
		}
		
		protected function verFrecuencia(event: MouseEvent): void
		{
			mostrarGrafico(MuestraPuntos.POR_FRECUENCIA,false);
		}
		
		protected function verDuracion(event: MouseEvent): void{
			mostrarGrafico(MuestraPuntos.POR_DURACION,false);	
		}
		
		protected function verFrecuenciaAgrupado(event: MouseEvent): void
		{
			mostrarGrafico(MuestraPuntos.POR_FRECUENCIA,true);
		}
		
		protected function verDuracionAgrupado(event: MouseEvent): void{
			mostrarGrafico(MuestraPuntos.POR_DURACION,true);	
		}
		
		public function mostrarGrafico(tipo:Number,agrupado:Boolean):void{
			try{
				Global.graphicsLayerRango1.clear();
				Global.graphicsLayerRango2.clear();
				Global.graphicsLayerRango3.clear();
				Global.graphicsLayer.clear();
				Global.graphicsLayer.visible=true;
				
				var elementos:ArrayCollection=tablaInterrupciones.dataProvider as ArrayCollection;
				MuestraPuntos.mostrar(elementos,tipo,agrupado);
			}
			catch(e:Error){
				ZAlerta.show("mostrando "+e.message);
			}
		}
		
		public function mostrarDatos(r:ArrayCollection):void{
			
			if (Global.tipoBusquedaCliente()){
				this.filtroCausaSed.visible=false;
			}
			else if (Global.tipoBusquedaSed()){
				this.filtroCausaSed.visible=true;	
			}
			
			this.resultadoInterrupciones=r;
			
			if (this.resultadoInterrupciones.length <= 0){
				this.stackFiltros.selectedIndex = 2;
				return;
			}
			
			var arrayNis:ArrayCollection=new ArrayCollection;
			var columna:DataGridColumn;
			
			for (var i:Number=0;i<r.length;i++){
				var elemento:InterrupcionBaseDto=r.getItemAt(i) as InterrupcionBaseDto;
				arrayNis.addItem(elemento.id);
			}
			
			if (Global.tipoBusquedaCliente()){
				var busquedaCliente:BusquedaClientes=new BusquedaClientes();
				busquedaCliente.buscar(clientesOk,clientesError,arrayNis);
				columna = tablaInterrupciones.columns[0] as DataGridColumn;
				columna.headerText = "Nis";
			}
			else if (Global.tipoBusquedaSed()){
				var busquedaSed:BusquedaSED=new BusquedaSED();
				busquedaSed.buscar(clientesOk,clientesError,arrayNis);
				columna = tablaInterrupciones.columns[0] as DataGridColumn;
				columna.headerText = "SED";
			}
			
			this.stackFiltros.selectedIndex = 1;
		}
		
		public function mostrarDatosPrimerBloque(r:ArrayCollection):void{
			
			var o:Object=new Object;
			
			for (var j:Number=0;j<r.length;j++){
				var elemento2:InterrupcionBaseDto =r.getItemAt(j) as InterrupcionBaseDto;
				
				o[elemento2.id]=elemento2.frecuenciaNis;
			}
			
			
			for (var i:Number=0;i<this.resultadoInterrupciones.length;i++){
				
				var elemento1:InterrupcionBaseDto =this.resultadoInterrupciones.getItemAt(i) as InterrupcionBaseDto;
				elemento1.frecuenciaNis=o[elemento1.id];				
			}
		}
		
		protected function cambioSeleccionCombo(event:IndexChangeEvent):void{
			var clave:String=this.comboZona.dataProvider.getItemAt(event.newIndex) as String;
			
			if (Global.tipoBusquedaCliente()){
				var resultados:ArrayCollection=this.filtroResultados.filtrarPorCampo(clave);
				this.tablaInterrupciones.dataProvider=resultados;
			}
			else if (Global.tipoBusquedaSed()){
				var map:Object=this.filtroCausaSed.recolectarEstado();
				this.tablaInterrupciones.dataProvider=this.filtroResultados.agrupar(this.filtroResultados.filtrarPorCampoCausa(clave,map));
			}
		}
		
		protected function volverClickHandler(event: MouseEvent): void{
			Global.principal.mostrarFiltros();
		}
		
		public function clientesOk(mapNisStringAGraphics:Object):void{
			try{
				if (this.resultadoInterrupciones.length==0){
					this.comboZona.dataProvider=new ArrayCollection;
					this.tablaInterrupciones.dataProvider=new ArrayCollection;
					return;
				}
				filtroResultados.procesar(this.resultadoInterrupciones,mapNisStringAGraphics,this.tipoResultados);
				comboZona.dataProvider=filtroResultados.generarCategoriasSegunFiltro();
				comboZona.selectedIndex=0;
				if (Global.tipoBusquedaCliente()){
					this.tablaInterrupciones.dataProvider=this.filtroResultados.filtrarPorCampo("Todos");
				}
				else if (Global.tipoBusquedaSed()){
					this.tablaInterrupciones.dataProvider=this.filtroResultados.agrupar(this.filtroResultados.filtrarPorCampo("Todos"));
				}
				
				if (this.filtroCausaSed.visible){
					this.filtroCausaSed.chequearTodos();
				}
			}
			catch(e:Error){
				ZAlerta.show("error en interrupciones por cliente sed  "+e.message);		
			}
		}
		
		public function clientesError(mensaje:String):void{
			ZAlerta.show("error en interrpcliente "+mensaje);
		}
		
		private function agregarEnCapa(r:ArrayCollection):void{
			var adds:Array=new Array;
			
			for (var i:Number=0;i<r.length;i++){
				
				var nuevosAtributos:* = new Object;
				
				nuevosAtributos["ARCGIS.DBO.CLIENTES_XY_006.OBJECTID"]=i;
				nuevosAtributos["ARCGIS.DBO.CLIENTES_XY_006.nis"]=i;
				nuevosAtributos["ARCGIS.DBO.INTERRUPCIONES_CLIENTES_GRAF_FREC.NIS"]=i;
				nuevosAtributos["ARCGIS.DBO.INTERRUPCIONES_CLIENTES_GRAF_FREC.VALOR"]=i;
				nuevosAtributos["ARCGIS.DBO.INTERRUPCIONES_CLIENTES_GRAF_FREC.OBJECTID"]=i;
				
				var graficoEditadoActual:Graphic=new Graphic(new MapPoint(),null,nuevosAtributos);
				adds[i]=graficoEditadoActual;    
			}
			Global.capaFrecuencia.applyEdits(adds,null,null, false,new AsyncResponder(onResult, onFault));
			
			function onResult(item:FeatureEditResults, token:Object = null):void
			{
				if (item.addResults==null||item.addResults.length==0){
					ZAlerta.show("nulo");
				}
				else if (item.addResults != null && item.addResults[0]["success"] == true){
					ZAlerta.show("Luminaria agregada");
				}else{
					ZAlerta.show("Error al editar nuevo elemento "+item.addResults[0]);
				}
			}
			
			function onFault(info:Object, token:Object = null):void
			{
				ZAlerta.show("Error al editar nuevo elemento "+info.toString());
			}
		}
		
		public function cambioFiltroCausaSed(map:Object):void{
			var tipo:String=this.comboZona.selectedItem as String;
			this.tablaInterrupciones.dataProvider=this.filtroResultados.filtrarPorCampoCausa(tipo, map);
		}
		
		protected function exportarXLS_clickHandler(event: MouseEvent): void
		{
			var resultado:ArrayCollection = tablaInterrupciones.dataProvider as ArrayCollection;
			ExportarExcel.exportar(resultado, "DatosZona");				
		}
		
		protected function verInterrupcion(event: MouseEvent): void{
		
			if (tablaInterrupciones.selectedIndex==-1){
				return;
			}
			
			var seleccionado:InterrupcionBaseDto=tablaInterrupciones.selectedItem as InterrupcionBaseDto;
			var queryFinal:String;
			
			if (Global.tipoBusquedaCliente()){
				queryFinal=this.query +" and nis='"+seleccionado.id+"'";
			}
			else if (Global.tipoBusquedaSed()){
				queryFinal=this.query +" and sed='"+seleccionado.id+"'";
			}
			
			Global.baseWidget.iniciarWidgetInterrupciones(queryFinal);
		}
		
		public function limpiarResultados():void{
			tablaInterrupciones.dataProvider = null;
		}
	}
}

