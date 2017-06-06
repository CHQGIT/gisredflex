package widgets.Interrupciones.busqueda.filtros
{
	import mx.collections.ArrayCollection;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.componentesComunes.ComponenteDosListas;
	import comun.util.zalerta.ZAlerta;
	import widgets.Interrupciones.servicios.BuscarComuna;

	public class FiltroComuna extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var componenteDosListas:ComponenteDosListas;
		
		public function FiltroComuna()
		{
			setStyle("skinClass", FiltroComunaSkin);
		}
		
		public function cargarTipos():void{
			var buscarComuna:BuscarComuna=new BuscarComuna;
			buscarComuna.buscar(callBackOk,callBackError);
		}
		
		public function callBackOk(resultado:ArrayCollection):void{
			componenteDosListas.elementoSeleccionar.dataProvider = resultado;
		}
		
		public function callBackError(mensaje:String):void{
			ZAlerta.show("error 2xxx"+mensaje);
		}
		
		public function guardarDatoComuna(): ArrayCollection
		{
			var datoComuna: ArrayCollection = new ArrayCollection;
			
			datoComuna = this.componenteDosListas.mostrarElementosSeleccionados();
			return datoComuna;
		}
	}
}