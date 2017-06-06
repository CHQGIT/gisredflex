package widgets.Interrupciones.busqueda.filtroResultados
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	
	import mx.collections.ArrayCollection;
	
	import widgets.Interrupciones.busqueda.resultado.ClasificadorResultados;
	import widgets.Interrupciones.busqueda.resultado.GeneraColores;
	import widgets.Interrupciones.busqueda.resultado.filtroCausaSed.FiltroCausaSed;
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.servicios.InterrupcionBaseDto;
	import widgets.Interrupciones.servicios.InterrupcionPorAlimentadorDto;
	import widgets.Interrupciones.servicios.InterrupcionPorComunaDto;
	import widgets.Interrupciones.servicios.InterrupcionPorSSEEDto;
	import widgets.Interrupciones.servicios.InterrupcionPorZonaDto;
	
	public class FiltroResultados
	{
		public var resultadoOriginal:ArrayCollection;
		public var tipo:Number;
		
		public function FiltroResultados()
		{
		}
		
		public function procesar(resultadoInterrupciones:ArrayCollection,mapNisStringAGraphics:Object,tipo:Number):void{
			this.tipo=tipo;
			
			resultadoOriginal=new ArrayCollection;
			
			var borde:SimpleLineSymbol=new SimpleLineSymbol("solid",0x000000,1,1);
			
			var generaColores:GeneraColores=new GeneraColores;
			
			for (var i:Number=0;i<resultadoInterrupciones.length;i++){
				// cambia segun el tipo
				var elemento:InterrupcionBaseDto=resultadoInterrupciones.getItemAt(i) as InterrupcionBaseDto;
				var g:Graphic=mapNisStringAGraphics[""+elemento.id] as Graphic;
				// todo: ver que hacer con los que no tienen punto....
				// duracion			
				var colorDuracion:Number=generaColores.obtenerColorDuracion(elemento.duracionNis);
				var categoriaDuracion:Number=generaColores.obtenerCategoriaDuracion(elemento.duracionNis);
				//	var simboloDuracion:SimpleMarkerSymbol=new SimpleMarkerSymbol("circle", 7,colorDuracion,1,0,0,0,borde);
				var simboloDuracion:SimpleMarkerSymbol=new SimpleMarkerSymbol("circle", 7,colorDuracion);
				if (g!=null){
					g.symbol=simboloDuracion;
				}
				elemento.graphicDuracion=g;
				elemento.rangoDuracion=categoriaDuracion;
				
				// frecuencia
				var colorFrecuencia:Number=generaColores.obtenerColorFrecuencia(elemento.frecuenciaNis);
				var categoriaFrecuencia:Number=generaColores.obtenerCategoriaFrecuencia(elemento.frecuenciaNis);
				//var simboloFrecuencia:SimpleMarkerSymbol=new SimpleMarkerSymbol("circle", 7,colorFrecuencia,1,0,0,0,borde);
				var simboloFrecuencia:SimpleMarkerSymbol=new SimpleMarkerSymbol("circle", 7,colorFrecuencia);
				
				if (g!=null){
					var gf:Graphic=new Graphic(g.geometry,simboloFrecuencia);
					elemento.graphicFrecuencia=gf;
					elemento.rangoFrecuencia=categoriaFrecuencia;
				}
				resultadoOriginal.addItem(elemento);
			}
		}
		
		public function generarCategoriasSegunFiltro():ArrayCollection{
			var resultado:ArrayCollection=new ArrayCollection;
			resultado.addItem("Todos");
			if (tipo==ClasificadorResultados.TIPO_INTERRUPCION){
				return resultado;
			}
			
			for (var i:Number=0;i<resultadoOriginal.length;i++){
				
				var campo:String="";
				if (tipo==ClasificadorResultados.TIPO_ZONA){
					var elementoZona:InterrupcionPorZonaDto=resultadoOriginal.getItemAt(i) as InterrupcionPorZonaDto;
					campo=elementoZona.zona;
				}
				else if (tipo==ClasificadorResultados.TIPO_SSEE){
					var elementoSSEE:InterrupcionPorSSEEDto=resultadoOriginal.getItemAt(i) as InterrupcionPorSSEEDto;
					campo=elementoSSEE.ssee;
				}
				else if (tipo==ClasificadorResultados.TIPO_COMUNA){
					var elementoComuna:InterrupcionPorComunaDto=resultadoOriginal.getItemAt(i) as InterrupcionPorComunaDto;
					campo=elementoComuna.comuna;
				}
				else if (tipo==ClasificadorResultados.TIPO_ALIMENTADOR){
					var elementoAlimentador:InterrupcionPorAlimentadorDto=resultadoOriginal.getItemAt(i) as InterrupcionPorAlimentadorDto;
					campo=elementoAlimentador.alimentador;
				}	
				
				if (resultado.contains(campo)){
					continue;
				}
				resultado.addItem(campo);
				
			}
			
			return resultado;
		}
		
		public function filtrarPorCampo(campoFiltro:String):ArrayCollection{
			Global.log("campo "+campoFiltro);
			if (campoFiltro=="Todos"){
				return resultadoOriginal;
			}
			var resultado:ArrayCollection=new ArrayCollection;
			
			for (var i:Number=0;i<resultadoOriginal.length;i++){
				
				var campo:String="";
				if (tipo==ClasificadorResultados.TIPO_ZONA){
					var elementoZona:InterrupcionPorZonaDto=resultadoOriginal.getItemAt(i) as InterrupcionPorZonaDto;
					campo=elementoZona.zona;
					
					if (campoFiltro==campo){
						resultado.addItem(elementoZona);
					}
				}
				else if (tipo==ClasificadorResultados.TIPO_SSEE){
					var elementoSSEE:InterrupcionPorSSEEDto=resultadoOriginal.getItemAt(i) as InterrupcionPorSSEEDto;
					campo=elementoSSEE.ssee;
					
					if (campoFiltro==campo){
						resultado.addItem(elementoSSEE);
					}
				}
				else if (tipo==ClasificadorResultados.TIPO_COMUNA){
					var elementoComuna:InterrupcionPorComunaDto=resultadoOriginal.getItemAt(i) as InterrupcionPorComunaDto;
					campo=elementoComuna.comuna;
					
					if (campoFiltro==campo){
						resultado.addItem(elementoComuna);
					}
				}
				else if (tipo==ClasificadorResultados.TIPO_ALIMENTADOR){
					var elementoAlimentador:InterrupcionPorAlimentadorDto=resultadoOriginal.getItemAt(i) as InterrupcionPorAlimentadorDto;
					campo=elementoAlimentador.alimentador;
					
					if (campoFiltro==campo){
						resultado.addItem(elementoAlimentador);
					}
				}	
			}
			return resultado;
		}
	
		public function filtrarPorCampoCausa(campoFiltro:String,map:Object):ArrayCollection{
			
			var resultado:ArrayCollection=new ArrayCollection;
			
			Global.log("resultado original "+resultadoOriginal);
			
			if (resultadoOriginal!=null){
				Global.log("resultado original "+resultadoOriginal.length);
			}
			
			for (var i:Number=0;i<resultadoOriginal.length;i++){
				
				var interrupcionBase:InterrupcionBaseDto=resultadoOriginal.getItemAt(i) as InterrupcionBaseDto;
				
				var agregar:Boolean=false;
				
				if (map[FiltroCausaSed.CAUSA_INTERNO]==true && interrupcionBase.causa=="Interna"){
					agregar=true;	
				}
				if (map[FiltroCausaSed.CAUSA_EXTERNO]==true && interrupcionBase.causa=="Externa"){
					agregar=true;	
				}
				if (map[FiltroCausaSed.CAUSA_FUERZA_MAYOR]==true && interrupcionBase.causa=="Fuerza Mayor"){
					agregar=true;	
				}
				
				if (!agregar){
					Global.log("sin causa...."+interrupcionBase.causa);
					continue;
				}
				
				if (campoFiltro=="Todos"){
					resultado.addItem(interrupcionBase);
					continue;
				}
				
				var campo:String="";
				
				if (tipo==ClasificadorResultados.TIPO_ZONA){
					var elementoZona:InterrupcionPorZonaDto=resultadoOriginal.getItemAt(i) as InterrupcionPorZonaDto;
					campo=elementoZona.zona;
					
					if (campoFiltro==campo){
						resultado.addItem(elementoZona);
					}
				}
				else if (tipo==ClasificadorResultados.TIPO_SSEE){
					var elementoSSEE:InterrupcionPorSSEEDto=resultadoOriginal.getItemAt(i) as InterrupcionPorSSEEDto;
					campo=elementoSSEE.ssee;
					
					if (campoFiltro==campo){
						resultado.addItem(elementoSSEE);
					}
				}
				else if (tipo==ClasificadorResultados.TIPO_COMUNA){
					var elementoComuna:InterrupcionPorComunaDto=resultadoOriginal.getItemAt(i) as InterrupcionPorComunaDto;
					campo=elementoComuna.comuna;
					
					if (campoFiltro==campo){
						resultado.addItem(elementoComuna);
					}
				}
				else if (tipo==ClasificadorResultados.TIPO_ALIMENTADOR){
					var elementoAlimentador:InterrupcionPorAlimentadorDto=resultadoOriginal.getItemAt(i) as InterrupcionPorAlimentadorDto;
					campo=elementoAlimentador.alimentador;
					
					if (campoFiltro==campo){
						resultado.addItem(elementoAlimentador);
					}
				}	
			}
			Global.log("resultados "+resultado);
			Global.log("resultados "+resultado.length);
			return agrupar(resultado);
		}
		
		public function agrupar(datos:ArrayCollection):ArrayCollection{

			var map:Array=new Array;
			
			var seDebeAgrupar:Boolean=false;
			var i:Number=0;
			
			var aBorrar:ArrayCollection=null;
			
			for (i=0;i<datos.length;i++){
			
				var interrupcionBase:InterrupcionBaseDto=datos.getItemAt(i) as InterrupcionBaseDto;
				
				aBorrar=new ArrayCollection;
				
				for (var j:Number=i+1;j<datos.length;j++){
					var otraInterrupcion:InterrupcionBaseDto=datos.getItemAt(j) as InterrupcionBaseDto;
					
					if (interrupcionBase.id==otraInterrupcion.id){
						aBorrar.addItem(interrupcionBase);
						aBorrar.addItem(otraInterrupcion);
					}
				}
			
				if (aBorrar.length>0){
					map[i]=aBorrar;
					seDebeAgrupar=true;
				}
			}
			
			if (!seDebeAgrupar){
				return datos;
			}
			
			var copia:ArrayCollection=new ArrayCollection;
			
			for (i=0;i<datos.length;i++){
				copia.addItem(datos.getItemAt(i));
			}
			
			for(i=copia.length-1;i>=0;i--) {

				if (map[i]==null){
					continue;
				}

				aBorrar=map[i];
				
				var dtoSuma:InterrupcionBaseDto=sumar(aBorrar);
				
				copia[i]=dtoSuma;
				
				for (var z:Number=0;z<aBorrar.length;z++){
					var indice:Number=copia.getItemIndex(aBorrar[z]);
					
					if (indice==-1){
						continue;
					}
					
					copia.removeItemAt(indice);
				}
			}
			
			return copia;
		}
		
		public function sumar(datos:ArrayCollection):InterrupcionBaseDto{

			var dto:InterrupcionBaseDto;
			
			if (tipo==ClasificadorResultados.TIPO_ZONA){
				dto=new InterrupcionPorZonaDto;
			}
			
			if (tipo==ClasificadorResultados.TIPO_COMUNA){
				dto=new InterrupcionPorComunaDto;
			}
			
			if (tipo==ClasificadorResultados.TIPO_SSEE){
				dto=new InterrupcionPorSSEEDto;
			}
			
			if (tipo==ClasificadorResultados.TIPO_ALIMENTADOR){
				dto=new InterrupcionPorAlimentadorDto;
			}
			
			var generaColores:GeneraColores=new GeneraColores;
			var geometry:Geometry=null;
			
			for(var i:Number=0;i<datos.length;i++) {
				var interrupcion:InterrupcionBaseDto=datos.getItemAt(i) as InterrupcionBaseDto;
							
				if (i==0){
					dto.frecuenciaNis=interrupcion.frecuenciaNis;
					dto.duracionNis=interrupcion.duracionNis;
					dto.id=interrupcion.id;
					geometry=interrupcion.graphicDuracion.geometry;
						
					if (tipo==ClasificadorResultados.TIPO_ZONA){
						(dto as InterrupcionPorZonaDto).zona=(interrupcion as InterrupcionPorZonaDto).zona;
					}
					
					if (tipo==ClasificadorResultados.TIPO_ALIMENTADOR){
						(dto as InterrupcionPorAlimentadorDto).alimentador=(interrupcion as InterrupcionPorAlimentadorDto).alimentador;
					}
					
					if (tipo==ClasificadorResultados.TIPO_COMUNA){
						(dto as InterrupcionPorComunaDto).comuna=(interrupcion as InterrupcionPorComunaDto).comuna;
					}
					
					if (tipo==ClasificadorResultados.TIPO_SSEE){
						(dto as InterrupcionPorSSEEDto).ssee=(interrupcion as InterrupcionPorSSEEDto).ssee;
					}
					
					continue;
				}
				
				dto.frecuenciaNis=dto.frecuenciaNis+interrupcion.frecuenciaNis;
				dto.duracionNis=dto.duracionNis+interrupcion.duracionNis;
			}

			var colorDuracion:Number=generaColores.obtenerColorDuracion(dto.duracionNis);
			var categoriaDuracion:Number=generaColores.obtenerCategoriaDuracion(dto.duracionNis);
			
			var colorFrecuencia:Number=generaColores.obtenerColorFrecuencia(dto.frecuenciaNis);
			var categoriaFrecuencia:Number=generaColores.obtenerCategoriaFrecuencia(dto.frecuenciaNis);

			var borde:SimpleLineSymbol=new SimpleLineSymbol("solid",0x000000,1,1);
			
			/*
			var simboloDuracion:SimpleMarkerSymbol=new SimpleMarkerSymbol("circle", 7,colorDuracion,1,0,0,0,borde);
			var simboloFrecuencia:SimpleMarkerSymbol=new SimpleMarkerSymbol("circle", 7,colorFrecuencia,1,0,0,0,borde);
			*/
			
			var simboloDuracion:SimpleMarkerSymbol=new SimpleMarkerSymbol("circle", 7,colorDuracion);
			var simboloFrecuencia:SimpleMarkerSymbol=new SimpleMarkerSymbol("circle", 7,colorFrecuencia);
			
			var gf:Graphic=new Graphic(geometry,simboloFrecuencia);
			
			dto.graphicFrecuencia=gf;
			dto.rangoFrecuencia=categoriaFrecuencia;
			
			gf=new Graphic(geometry,simboloDuracion);
			
			dto.graphicDuracion=gf;
			dto.rangoDuracion=categoriaDuracion;
			
			return dto;
		}
	}
}
