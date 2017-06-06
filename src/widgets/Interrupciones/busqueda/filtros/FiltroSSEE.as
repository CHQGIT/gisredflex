package widgets.Interrupciones.busqueda.filtros
{
	import mx.collections.ArrayCollection;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.componentesComunes.ComponenteDosListas;
	import comun.util.zalerta.ZAlerta;
	import widgets.Interrupciones.servicios.BuscarSSEE;

	public class FiltroSSEE extends SkinnableComponent
	{	
		[SkinPart]
		public var componenteDosListas:ComponenteDosListas;

		public function FiltroSSEE()
		{
			setStyle("skinClass", FiltroSSEESkin);
		}
		
		/*public function generarWhere(): String
		{
			var resultado: String = "";
			
			if(this.sseeTxt.text != "")
			{
				resultado = "ssee = '" + this.sseeTxt.text + "'";
			}
			
			return resultado;
		}*/
		
		public function cargarTipos():void{
			var buscarSSE:BuscarSSEE=new BuscarSSEE;
			buscarSSE.buscar(callBackOk,callBackError);
		}
		
		public function callBackOk(resultado:ArrayCollection):void{
			componenteDosListas.elementoSeleccionar.dataProvider = resultado;
		}
		
		public function callBackError(mensaje:String):void{
			ZAlerta.show("error 3"+mensaje);
		}
		
		public function guardarDatoSSEE(): ArrayCollection
		{
			var datoSSEE: ArrayCollection = new ArrayCollection;
			
			datoSSEE = this.componenteDosListas.mostrarElementosSeleccionados();
			
			return datoSSEE;
		}
	}
}