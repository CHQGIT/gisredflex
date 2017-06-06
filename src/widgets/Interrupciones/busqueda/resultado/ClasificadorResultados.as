package widgets.Interrupciones.busqueda.resultado
{
	import com.esri.ags.Graphic;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import comun.util.zalerta.ZAlerta;
	import widgets.Interrupciones.servicios.InterrupcionBaseDto;
	import widgets.Interrupciones.servicios.InterrupcionPorAlimentadorDto;
	import widgets.Interrupciones.servicios.InterrupcionPorComunaDto;
	import widgets.Interrupciones.servicios.InterrupcionPorSSEEDto;
	import widgets.Interrupciones.servicios.InterrupcionPorZonaDto;

	public class ClasificadorResultados
	{
		public var datosClasificados:Dictionary;
		public var clavesCombo:ArrayCollection;
		public var primeraZona:String;
		
		public static var TIPO_ZONA:Number=0;
		public static var TIPO_SSEE:Number=1;
		public static var TIPO_COMUNA:Number=2;
		public static var TIPO_ALIMENTADOR:Number=3;
		
		public static var TIPO_INTERRUPCION:Number=4;
		
		public function ClasificadorResultados()
		{
		}
		
		public function clasificar(resultadoInterrupciones:ArrayCollection,mapNisStringAGraphics:Object,tipo:Number):void{
			
			datosClasificados=new Dictionary;
			
			var listaZona:ArrayCollection=new ArrayCollection;
			
			clavesCombo=new ArrayCollection;
			
			primeraZona=null;
			
			var borde:SimpleLineSymbol=new SimpleLineSymbol("solid",0x000000,1,1);
			
			var generaColores:GeneraColores=new GeneraColores;
			
		//	ZAlerta.show("tipo "+tipo);
			
			for (var i:Number=0;i<resultadoInterrupciones.length;i++){
				// cambia segun el tipo 
				var elemento:InterrupcionBaseDto=resultadoInterrupciones.getItemAt(i) as InterrupcionBaseDto;
				
				var g:Graphic=mapNisStringAGraphics[""+elemento.id] as Graphic;
				
				// todo: ver que hacer con los que no tienen punto....
				
				var clave:String="";
				
				if (tipo==TIPO_ZONA){
					var elementoZona:InterrupcionPorZonaDto=resultadoInterrupciones.getItemAt(i) as InterrupcionPorZonaDto;
					clave=elementoZona.zona;
				}
				else if (tipo==TIPO_SSEE){
					var elementoSSEE:InterrupcionPorSSEEDto=resultadoInterrupciones.getItemAt(i) as InterrupcionPorSSEEDto;
					clave=elementoSSEE.ssee;
				}
				else if (tipo==TIPO_COMUNA){
					var elementoComuna:InterrupcionPorComunaDto=resultadoInterrupciones.getItemAt(i) as InterrupcionPorComunaDto;
					clave=elementoComuna.comuna;
				}
				else if (tipo==TIPO_ALIMENTADOR){
					var elementoAlimentador:InterrupcionPorAlimentadorDto=resultadoInterrupciones.getItemAt(i) as InterrupcionPorAlimentadorDto;
					clave=elementoAlimentador.alimentador;
				}
				
				// duracion			
				var colorDuracion:Number=generaColores.obtenerColorDuracion(elemento.duracionNis);
				var categoriaDuracion:Number=generaColores.obtenerCategoriaDuracion(elemento.duracionNis);
				var simboloDuracion:SimpleMarkerSymbol=new SimpleMarkerSymbol("circle", 7,colorDuracion,1,0,0,0,borde);
				
				if (g!=null){
					g.symbol=simboloDuracion;
				}
				
				elemento.graphicDuracion=g;
				elemento.rangoDuracion=categoriaDuracion;

				// frecuencia
				var colorFrecuencia:Number=generaColores.obtenerColorFrecuencia(elemento.frecuenciaNis);
				var categoriaFrecuencia:Number=generaColores.obtenerCategoriaFrecuencia(elemento.frecuenciaNis);
				var simboloFrecuencia:SimpleMarkerSymbol=new SimpleMarkerSymbol("circle", 7,colorFrecuencia,1,0,0,0,borde);
				
				if (g!=null){
					var gf:Graphic=new Graphic(g.geometry,simboloFrecuencia);
					elemento.graphicFrecuencia=gf;
					elemento.rangoFrecuencia=categoriaFrecuencia;
				}
				
				if(datosClasificados["TODOS"] == null){
					datosClasificados["TODOS"]=new ArrayCollection;
					
					clavesCombo.addItem("TODOS");
				}
				datosClasificados["TODOS"].addItem(elemento);
				
				// cambia segun el tipo...
				if (datosClasificados[clave]==null){
					datosClasificados[clave]=new ArrayCollection;
					clavesCombo.addItem(clave);
				}
				datosClasificados[clave].addItem(elemento);
				
				if (primeraZona==null){
					primeraZona="TODOS";
				}
			}
		}
	}
}