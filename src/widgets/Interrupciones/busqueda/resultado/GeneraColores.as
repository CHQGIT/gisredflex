package widgets.Interrupciones.busqueda.resultado
{
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.servicios.RangoDto;

	public class GeneraColores
	{
		public function GeneraColores()
		{
		}
		
		public function obtenerColorFrecuencia(valorFrecuencia:Number):Number{
			var categoria:Number=-1;
			
			for (var i:Number=0;i<Global.rangos.length;i++){
				var rango:RangoDto=Global.rangos.getItemAt(i) as RangoDto;
				
				if (rango.nombre!="cantidad_frecuencia"){
					continue;
				}
				
				if (valorFrecuencia>rango.minimo && valorFrecuencia<=rango.maximo){
					categoria=rango.categoria;
				}
			}
			
			if (categoria==0){
				return 0x00A33A;
			}
			if (categoria==1){
				return 0xEEF411;
			}
			if (categoria==2){
				return 0xCC0000;
			}
			return 0x000000;
		}
		
		public function obtenerCategoriaFrecuencia(valorFrecuencia:Number):Number{
			var categoria:Number=-1;
			
			for (var i:Number=0;i<Global.rangos.length;i++){
				var rango:RangoDto=Global.rangos.getItemAt(i) as RangoDto;
				
				if (rango.nombre!="cantidad_frecuencia"){
					continue;
				}
				
				if (valorFrecuencia>rango.minimo && valorFrecuencia<=rango.maximo){
					categoria=rango.categoria;
				}
			}
			
			return categoria;
		}
		
		
		public function obtenerColorDuracion(valorDuracion:Number):Number{
			var categoria:Number=-1;
			for (var i:Number=0;i<Global.rangos.length;i++){
				var rango:RangoDto=Global.rangos.getItemAt(i) as RangoDto;
				if (rango.nombre!="duracion_tiempo"){
					continue;
				}
				if (valorDuracion>rango.minimo && valorDuracion<=rango.maximo){
					categoria=rango.categoria;
				}
			}
			if (categoria==0){
				return 0x00A33A;
			}
			if (categoria==1){
				return 0xEEF411;
			}
			if (categoria==2){
				return 0xCC0000;
			}
			return 0x000000;
		}
		
		public function obtenerCategoriaDuracion(valorDuracion:Number):Number{
			var categoria:Number=-1;
			
			for (var i:Number=0;i<Global.rangos.length;i++){
				var rango:RangoDto=Global.rangos.getItemAt(i) as RangoDto;
				
				if (rango.nombre!="duracion_tiempo"){
					continue;
				}
				
				if (valorDuracion>rango.minimo && valorDuracion<=rango.maximo){
					categoria=rango.categoria;
				}
			}
			
			return categoria;
		}
	}
}