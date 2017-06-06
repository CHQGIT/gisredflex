package widgets.Interrupciones.busqueda.filtros
{
	import mx.collections.ArrayCollection;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.componentesComunes.ComponenteDosListas;
	import comun.util.zalerta.ZAlerta;
	import widgets.Interrupciones.servicios.BuscarAlimentador;

	public class FiltroAlimentador extends SkinnableComponent
	{
		[SkinPart]
		public var componenteDosListas: ComponenteDosListas;
		
		public function FiltroAlimentador()
		{
			setStyle("skinClass", FiltroAlimentadorSkin);
		}
		
		public function cargarTipos(): void
		{
			var buscarAlimentador: BuscarAlimentador = new BuscarAlimentador;
			buscarAlimentador.buscar(callBackOk, callBackError);
		}
		
		public function callBackOk(resultado:ArrayCollection):void{
			this.componenteDosListas.elementoSeleccionar.dataProvider = resultado;
		}
		
		public function callBackError(mensaje:String):void{
			ZAlerta.show("error 1"+mensaje);
		}
		
		public function guardarDatoAlimentador(): ArrayCollection
		{
			var datoAlimentador: ArrayCollection = new ArrayCollection;
			
			datoAlimentador = this.componenteDosListas.mostrarElementosSeleccionados();
			
			return datoAlimentador;
		}
	}
}