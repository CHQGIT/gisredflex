package widgets.Interrupciones.busqueda.muestraPuntos
{
	import com.esri.ags.clusterers.WeightedClusterer;
	import com.esri.ags.clusterers.supportClasses.FlareSymbol;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	
	import mx.collections.ArrayCollection;
	
	import widgets.Interrupciones.global.Global;
	import comun.util.zalerta.ZAlerta;
	import widgets.Interrupciones.servicios.InterrupcionBaseDto;
	
	public class MuestraPuntos
	{
		public static var POR_FRECUENCIA:Number=0;
		public static var POR_DURACION:Number=1;
		
		public function MuestraPuntos()
		{
		}
		
		public static function mostrar(resultadoInterrupciones:ArrayCollection,tipo:Number,agrupado:Boolean):void{
			if (agrupado){
				mostrarAgrupado(resultadoInterrupciones,tipo);
			}
			else{
				mostrarNormal(resultadoInterrupciones,tipo);
			}
		}
		
		public static function mostrarNormal(resultadoInterrupciones:ArrayCollection,tipo:Number):void{
			try{
				Global.graphicsLayer.clear();
				Global.graphicsLayer.visible=true;
				
				var extent:Extent=null;
				
				Global.log("inicio dibujo puntos");
				
				for (var i:Number=0;i<resultadoInterrupciones.length;i++){
					var elemento:InterrupcionBaseDto=resultadoInterrupciones.getItemAt(i) as InterrupcionBaseDto;
					if (elemento==null){
						trace("","error, hay elemento nulo");
						continue;
					}
					
					if (tipo==POR_FRECUENCIA){
						if (elemento.graphicFrecuencia==null){
							continue;
						}
						Global.graphicsLayer.add(elemento.graphicFrecuencia);
					}
					else if (tipo==POR_DURACION){
						if (elemento.graphicDuracion==null){
							continue;
						}
						Global.graphicsLayer.add(elemento.graphicDuracion);
					}
					
					var mapPoint:MapPoint=elemento.graphicFrecuencia.geometry as MapPoint;
				}
				
				Global.log("fin puntos");
				Global.map.extent=extent;
			}
			catch(e:Error){
				ZAlerta.show("error 4"+e.message);
			}
		}
		
		public static function mostrarAgrupado(resultadoInterrupciones:ArrayCollection,tipo:Number):void{
			try{
				Global.graphicsLayer.clear();
				Global.graphicsLayer.visible=true;

				Global.capaSeleccionado.clear();
				Global.capaSeleccionado.visible=true;
				
				Global.graphicsLayerRango1.clear();
				Global.graphicsLayerRango1.visible=true;
				
				Global.graphicsLayerRango2.clear();
				Global.graphicsLayerRango2.visible=true;
				
				Global.graphicsLayerRango3.clear();
				Global.graphicsLayerRango3.visible=true;
				
				var extent:Extent=null;
				
				Global.log("inicio dibujo puntos");
				
				for (var i:Number=0;i<resultadoInterrupciones.length;i++){
					var elemento:InterrupcionBaseDto=resultadoInterrupciones.getItemAt(i) as InterrupcionBaseDto;
					if (elemento==null){
						trace("","error, hay elemento nulo");
						continue;
					}
					
					if (tipo==POR_FRECUENCIA){
						if (elemento.graphicFrecuencia==null){
							continue;
						}
						
						if (elemento.rangoFrecuencia==0){
							Global.graphicsLayerRango1.add(elemento.graphicFrecuencia);
						}
						else if (elemento.rangoFrecuencia==1){
							Global.graphicsLayerRango2.add(elemento.graphicFrecuencia);
						}
						else if (elemento.rangoFrecuencia==2){
							Global.graphicsLayerRango3.add(elemento.graphicFrecuencia);
						}
					}
					else if (tipo==POR_DURACION){
						if (elemento.graphicDuracion==null){
							continue;
						}
						if (elemento.rangoDuracion==0){
							Global.graphicsLayerRango1.add(elemento.graphicDuracion);
						}
						else if (elemento.rangoDuracion==1){
							Global.graphicsLayerRango2.add(elemento.graphicDuracion);
						}
						else if (elemento.rangoDuracion==2){
							Global.graphicsLayerRango3.add(elemento.graphicDuracion);
						}
					}
					
					var mapPoint:MapPoint=elemento.graphicFrecuencia.geometry as MapPoint;
					
					/*if (extent==null){
					extent=new Extent(mapPoint.x,mapPoint.y,mapPoint.x,mapPoint.y,mapPoint.spatialReference);
					}
					else{
					var e:Extent=new Extent(mapPoint.x,mapPoint.y,mapPoint.x,mapPoint.y,mapPoint.spatialReference);
					extent.union(e);		
					}
					*/
				}
				
				
				//verde
				var flareSymbol1:FlareSymbol = crearFlare(0x00ff00);
				
				var cluseter:WeightedClusterer = new WeightedClusterer();
				cluseter.sizeInPixels = 20;
				cluseter.symbol = flareSymbol1;
				
				Global.graphicsLayerRango1.clusterer=cluseter;
				
				// amarillo				
				var flareSymbol2:FlareSymbol = crearFlare(0xffff00);
				
				cluseter = new WeightedClusterer();
				cluseter.sizeInPixels = 20;
				cluseter.symbol = flareSymbol2;
				
				Global.graphicsLayerRango2.clusterer=cluseter;
				
				//rojo
				var flareSymbol3:FlareSymbol = crearFlare(0xff0000);
				
				cluseter = new WeightedClusterer();
				cluseter.sizeInPixels = 20;
				cluseter.symbol = flareSymbol3;
				
				Global.graphicsLayerRango3.clusterer=cluseter;
				
				Global.log("fin puntos");
				Global.map.extent=extent;
			}
			catch(e:Error){
				ZAlerta.show("error 5 "+e.message);
			}
		}
		
		public static function crearFlare(color:Number):FlareSymbol{
			var flareSymbol:FlareSymbol = new FlareSymbol();
			flareSymbol.backgroundAlphas = [0.7,1.0];
			flareSymbol.backgroundColor = color;
//			flareSymbol.backgroundColors = [0x5B8C3E,0xBF2827];
			flareSymbol.borderColor= 0x666666;
			flareSymbol.flareMaxCount=30;
			flareSymbol.flareSizeIncOnRollOver=3;
			flareSymbol.sizes=[20,30];
			//	flareSymbol.textFormat=tf;
			flareSymbol.weights=[30,60];
			return flareSymbol;
		}
	}
}