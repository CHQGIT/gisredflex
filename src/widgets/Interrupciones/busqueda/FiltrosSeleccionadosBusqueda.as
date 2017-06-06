package widgets.Interrupciones.busqueda
{
	import mx.collections.ArrayCollection;

	public class FiltrosSeleccionadosBusqueda
	{
		public var tipoResultadosBusqueda:Number;
		public var ordenResultados:Number;
		
		public var arrayPeriodoFecha: ArrayCollection;
		public var arrayZona: ArrayCollection; 
		public var arraySSEE: ArrayCollection;
		public var arrayComuna: ArrayCollection;
		public var arrayAlimentador: ArrayCollection;
		
		public var idInterrupcion:String;
		
		public var causa:String;
		
		public static var ORDEN_FRECUENCIA:Number=0;
		public static var ORDEN_DURACION:Number=1;
		
		public function FiltrosSeleccionadosBusqueda()
		{
		}
		
		public function generarCausa():String{
			if (causa==null)
				return null;
			
			if (causa=="Interno + Fuerza Mayor"){
				return " tipo_emp in ('Interno','Fuerza Mayor') ";
			}
			else if (causa=="Total"){
				return null;			
			}
			else{
				return " tipo_emp in ('"+causa+"') ";
			}
		}
	}
}