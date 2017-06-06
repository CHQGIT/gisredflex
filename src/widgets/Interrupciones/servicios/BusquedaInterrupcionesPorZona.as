package widgets.Interrupciones.servicios
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	
	import mx.collections.ArrayCollection;
	
	import widgets.Interrupciones.busqueda.FiltrosSeleccionadosBusqueda;
	import widgets.Interrupciones.global.Global;
	
	public class BusquedaInterrupcionesPorZona
	{
		public var resultado:ArrayCollection;
		
		public var callBackOk:Function;
		public var callBackError:Function;
		
		public var busquedaInterrupcionComun:BusquedaInterrupcionComun;
		
		public function BusquedaInterrupcionesPorZona()
		{
			busquedaInterrupcionComun=new BusquedaInterrupcionComun;
		}
		
		public function buscar(callBackOk:Function,callBackError:Function,
							   filtrosSeleccionadosBusqueda:FiltrosSeleccionadosBusqueda,
							   tipoBusqueda:Number,bloqueUno:Boolean):void{
			
			this.callBackError=callBackError;
			this.callBackOk=callBackOk;
			
			busquedaInterrupcionComun.busquedaAgrupada(onResult,
				onFault,
				filtrosSeleccionadosBusqueda,
				BusquedaInterrupcionComun.TIPO_BUSQUEDA_ZONA,bloqueUno);
		}
		
		private function onResult(featureSet:FeatureSet, token:Object = null):void
		{
			Global.log("resultados!!!"+featureSet.features.length);
			resultado=new ArrayCollection;
			
			if (featureSet.features.length == 0){
				callBackOk(resultado);
				return;
			}

			var mostrado:Boolean=false;
			for (var i:Number=0;i<featureSet.features.length;i++){
			
				var g:Graphic = featureSet.features[i] as Graphic;
				
				var frecuenciaNis:Number=Number(g.attributes["frecuenciaNis"]);
				var duracionNis:Number=Number(g.attributes["duracionNis"]);
				var zona:String=g.attributes["zona"];
				var id:Number;
				var causa:String=null;
				
				if (Global.tipoBusquedaCliente()){
					id=Number(g.attributes["nis"]);
				}
				else if (Global.tipoBusquedaSed()){
					id=Number(g.attributes["sed"]);
					causa=g.attributes["tipo_emp"];
				}

				var interrupcionDto:InterrupcionPorZonaDto=new InterrupcionPorZonaDto;
				interrupcionDto.frecuenciaNis=frecuenciaNis;
				interrupcionDto.duracionNis=duracionNis;
				interrupcionDto.zona=zona;
				interrupcionDto.id=id;
				interrupcionDto.causa=causa;
				
				resultado.addItem(interrupcionDto);
				
			}
			callBackOk(resultado);
		}
		
		private function onFault(info:Object, token:Object = null):void
		{
			callBackError("error" +info);
		}
	}
}