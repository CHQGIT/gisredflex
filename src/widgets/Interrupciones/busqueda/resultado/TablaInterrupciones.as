package widgets.Interrupciones.busqueda.resultado
{
	import mx.collections.ArrayCollection;
	import mx.containers.ViewStack;
	
	import spark.components.DropDownList;
	import spark.components.NavigatorContent;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import comun.util.zalerta.ZAlerta;
	
	import widgets.Interrupciones.busqueda.FiltrosSeleccionadosBusqueda;
	import widgets.Interrupciones.busqueda.resultado.TablaInterrupcionesSkin;
	import widgets.Interrupciones.busqueda.resultado.porClienteSED.InterrupcionesPorClienteSED;
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.servicios.BusquedaInterrupcionComun;
	import widgets.Interrupciones.servicios.BusquedaInterrupcionesPorAlimentador;
	import widgets.Interrupciones.servicios.BusquedaInterrupcionesPorComuna;
	import widgets.Interrupciones.servicios.BusquedaInterrupcionesPorSSEE;
	import widgets.Interrupciones.servicios.BusquedaInterrupcionesPorZona;

	public class TablaInterrupciones extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var interrupcionesPorZona:InterrupcionesPorClienteSED;
		
		[SkinPart(required="true")]
		public var interrupcionesPorSSEE: InterrupcionesPorClienteSED;
		
		[SkinPart(required="true")]
		public var interrupcionesPorComuna: InterrupcionesPorClienteSED;
		
		[SkinPart(required="true")]
		public var interrupcionesPorAlimentador: InterrupcionesPorClienteSED;
		
		[SkinPart(required="true")]
		public var navigatorContentZona: NavigatorContent;
		
		[SkinPart(required="true")]
		public var navigatorContentSSEE: NavigatorContent;
		
		[SkinPart(required="true")]
		public var navigatorContentAlimentador: NavigatorContent;
		
		[SkinPart(required="true")]
		public var navigatorContentComuna: NavigatorContent;
		
		[SkinPart]
		public var comboNav:DropDownList;
		
		[SkinPart]
		public var stackResultados:ViewStack;
		
		public var filtrosSeleccionadosBusqueda:FiltrosSeleccionadosBusqueda;
		
		public function TablaInterrupciones()
		{
			setStyle("skinClass", TablaInterrupcionesSkin);
		}
		
		override protected function partAdded(partName: String, instance: Object): void{
			if(comboNav == instance){
				comboNav.addEventListener(IndexChangeEvent.CHANGE,onComboBoxChange);
			}
			
			if (instance==interrupcionesPorZona){
				interrupcionesPorZona.tipoFiltro=InterrupcionesPorClienteSED.TIPO_FILTRO_ZONA;
				
			}
			
			if (instance==interrupcionesPorSSEE){
				interrupcionesPorSSEE.tipoFiltro=InterrupcionesPorClienteSED.TIPO_FILTRO_SSEE;
			}
			
			if (instance==interrupcionesPorComuna){
				interrupcionesPorComuna.tipoFiltro=InterrupcionesPorClienteSED.TIPO_FILTRO_COMUNA;
			}
			
			if (instance==interrupcionesPorAlimentador){
				interrupcionesPorAlimentador.tipoFiltro=InterrupcionesPorClienteSED.TIPO_FILTRO_ALIMENTADOR;
			}
		}
		
		public function buscar(filtrosSeleccionadosBusqueda:FiltrosSeleccionadosBusqueda):void{
			this.filtrosSeleccionadosBusqueda=filtrosSeleccionadosBusqueda;
			
			if (filtrosSeleccionadosBusqueda.arrayZona.length>0){
				this.interrupcionesPorZona.stackFiltros.selectedIndex = 0;

				Global.log("iniciando busqueda interrupciones por zona");
				
				var busquedaInterrupcionesPorZona:BusquedaInterrupcionesPorZona=new BusquedaInterrupcionesPorZona();
				busquedaInterrupcionesPorZona.buscar(callBackOkZona,callBackError1,
					filtrosSeleccionadosBusqueda,
					BusquedaInterrupcionComun.TIPO_BUSQUEDA_ZONA,false);
				
				this.interrupcionesPorZona.query=busquedaInterrupcionesPorZona.busquedaInterrupcionComun.query.where;
			}
			else
			{
				this.interrupcionesPorZona.stackFiltros.selectedIndex = 2;
			}
			
			if (filtrosSeleccionadosBusqueda.arraySSEE.length>0){
				this.interrupcionesPorSSEE.stackFiltros.selectedIndex = 0;
				
				var busquedaInterrupcionesPorSSEE: BusquedaInterrupcionesPorSSEE = new BusquedaInterrupcionesPorSSEE();
				busquedaInterrupcionesPorSSEE.buscar(callBackOkSSEE, callBackError1,
					filtrosSeleccionadosBusqueda,
					BusquedaInterrupcionComun.TIPO_BUSQUEDA_SSEE,false);
				
				this.interrupcionesPorSSEE.query=busquedaInterrupcionesPorSSEE.busquedaInterrupcionComun.query.where;
			}
			else
			{
				this.interrupcionesPorSSEE.stackFiltros.selectedIndex = 2;
			}
			
			if (filtrosSeleccionadosBusqueda.arrayComuna.length>0){
				this.interrupcionesPorComuna.stackFiltros.selectedIndex = 0;
				
				var busquedaInterrupcionesPorComuna: BusquedaInterrupcionesPorComuna = new BusquedaInterrupcionesPorComuna();
				busquedaInterrupcionesPorComuna.buscar(callBackOkComuna, callBackError3,
					filtrosSeleccionadosBusqueda,
					BusquedaInterrupcionComun.TIPO_BUSQUEDA_COMUNA,false);
				
				this.interrupcionesPorComuna.query=busquedaInterrupcionesPorComuna.busquedaInterrupcionComun.query.where;
			}
			else
			{
				this.interrupcionesPorComuna.stackFiltros.selectedIndex = 2;
			}
			
			if (filtrosSeleccionadosBusqueda.arrayAlimentador.length>0){
				this.interrupcionesPorAlimentador.stackFiltros.selectedIndex = 0;
				
				var busquedaInterrupcionesPorAlimentador: BusquedaInterrupcionesPorAlimentador = new BusquedaInterrupcionesPorAlimentador();
				busquedaInterrupcionesPorAlimentador.buscar(callBackOkAlimentador, callBackError4, 
					filtrosSeleccionadosBusqueda,
					BusquedaInterrupcionComun.TIPO_BUSQUEDA_ALIMENTADOR,false);
				
				this.interrupcionesPorAlimentador.query=busquedaInterrupcionesPorAlimentador.busquedaInterrupcionComun.query.where;
			}
			else
			{
				this.interrupcionesPorAlimentador.stackFiltros.selectedIndex = 2;
			}
		}
		
		public function onComboBoxChange(e:IndexChangeEvent):void{
			stackResultados.selectedIndex = comboNav.selectedIndex;
		}
		
		public function callBackOkAlimentador(r: ArrayCollection): void
		{
			this.navigatorContentAlimentador.label="Resultado Por Alimentador ("+r.length+")";
			interrupcionesPorAlimentador.mostrarDatos(r);
			
			var busquedaInterrupcionesPorAlimentador:BusquedaInterrupcionesPorAlimentador=new BusquedaInterrupcionesPorAlimentador();
			
			busquedaInterrupcionesPorAlimentador.buscar(callBackOkAlimentadorPrimerBloque,callBackError5,
				filtrosSeleccionadosBusqueda,
				BusquedaInterrupcionComun.TIPO_BUSQUEDA_ZONA,true);

		}
		
		public function callBackOkComuna(r: ArrayCollection): void
		{
			this.navigatorContentComuna.label="Resultado Por Comuna ("+r.length+")";
			interrupcionesPorComuna.mostrarDatos(r);
			
			var busquedaInterrupcionesPorComuna: BusquedaInterrupcionesPorComuna = new BusquedaInterrupcionesPorComuna();
			busquedaInterrupcionesPorComuna.buscar(callBackOkComunaPrimerBloque, callBackError6,
				filtrosSeleccionadosBusqueda,
				BusquedaInterrupcionComun.TIPO_BUSQUEDA_COMUNA,true);
			
		}
		
		public function callBackOkZona(r:ArrayCollection):void{
			Global.log("ok, busqueda de zonas, antes de mostrar tabla");
			this.navigatorContentZona.label="Resultado Por Zona ("+r.length+")";
			interrupcionesPorZona.mostrarDatos(r);
			
			var busquedaInterrupcionesPorZona:BusquedaInterrupcionesPorZona=new BusquedaInterrupcionesPorZona();

			busquedaInterrupcionesPorZona.buscar(callBackOkZonaPrimerBloque,callBackError7,
				filtrosSeleccionadosBusqueda,
				BusquedaInterrupcionComun.TIPO_BUSQUEDA_ZONA,true);
		}
		
		public function callBackOkSSEE(r: ArrayCollection): void
		{
			this.navigatorContentSSEE.label="Resultado Por SSEE ("+r.length+")";
			interrupcionesPorSSEE.mostrarDatos(r);
			
			var busquedaInterrupcionesPorSSEE: BusquedaInterrupcionesPorSSEE = new BusquedaInterrupcionesPorSSEE();
			busquedaInterrupcionesPorSSEE.buscar(callBackOkSSEEPrimerBloque, callBackError8,
				filtrosSeleccionadosBusqueda,
				BusquedaInterrupcionComun.TIPO_BUSQUEDA_SSEE,true);
			
		}
		
		public function callBackOkZonaPrimerBloque(r:ArrayCollection):void{
			Global.log("ok, busqueda de zonas, antes de mostrar tabla");
			this.navigatorContentZona.label="Resultado Por Zona ("+r.length+")";
			interrupcionesPorZona.mostrarDatosPrimerBloque(r);
		}
		
		public function callBackOkAlimentadorPrimerBloque(r:ArrayCollection):void{
			Global.log("ok, busqueda de zonas, antes de mostrar tabla");
			this.navigatorContentZona.label="Resultado Por Zona ("+r.length+")";
			interrupcionesPorAlimentador.mostrarDatosPrimerBloque(r);
		}
		
		
		public function callBackOkSSEEPrimerBloque(r:ArrayCollection):void{
			Global.log("ok, busqueda de zonas, antes de mostrar tabla");
			this.navigatorContentZona.label="Resultado Por Zona ("+r.length+")";
			interrupcionesPorSSEE.mostrarDatosPrimerBloque(r);
		}
		
		public function callBackOkComunaPrimerBloque(r:ArrayCollection):void{
			Global.log("ok, busqueda de zonas, antes de mostrar tabla");
			this.navigatorContentZona.label="Resultado Por Zona ("+r.length+")";
			interrupcionesPorComuna.mostrarDatosPrimerBloque(r);
		}
		
		public function callBackError1(mensaje:String):void{
			Global.log("error");
			ZAlerta.show("error c1  "+mensaje);
		}
		
		public function callBackError2(mensaje:String):void{
			Global.log("error");
			ZAlerta.show("error c2  "+mensaje);
		}
		
		public function callBackError3(mensaje:String):void{
			Global.log("error");
			ZAlerta.show("error c3  "+mensaje);
		}
		
		public function callBackError4(mensaje:String):void{
			Global.log("error");
			ZAlerta.show("error c4  "+mensaje);
		}
		
		public function callBackError5(mensaje:String):void{
			Global.log("error");
			ZAlerta.show("error c5  "+mensaje);
		}
		
		public function callBackError6(mensaje:String):void{
			Global.log("error");
			ZAlerta.show("error c6  "+mensaje);
		}
		
		public function callBackError7(mensaje:String):void{
			Global.log("error");
			ZAlerta.show("error c7  "+mensaje);
		}
		
		public function callBackError8(mensaje:String):void{
			Global.log("error");
			ZAlerta.show("error c8  "+mensaje);
		}
	}
}