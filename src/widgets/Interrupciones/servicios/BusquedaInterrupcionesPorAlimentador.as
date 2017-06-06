package widgets.Interrupciones.servicios
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	
	import mx.collections.ArrayCollection;
	
	import widgets.Interrupciones.busqueda.FiltrosSeleccionadosBusqueda;
	import widgets.Interrupciones.global.Global;
	
	public class BusquedaInterrupcionesPorAlimentador
	{
		public var resultado: ArrayCollection;
		
		public var callBackOk: Function;
		public var callBackError: Function;
		
		public var busquedaInterrupcionComun:BusquedaInterrupcionComun;
		
		public function BusquedaInterrupcionesPorAlimentador(){
			busquedaInterrupcionComun=new BusquedaInterrupcionComun;
		}
		
		public function buscar(callBackOk: Function, callBackError: Function, 
							   filtrosSeleccionadosBusqueda:FiltrosSeleccionadosBusqueda,
							   tipoBusqueda:Number,bloqueUno:Boolean):void
		{
			this.callBackOk = callBackOk;
			this.callBackError = callBackError;
	
			busquedaInterrupcionComun.busquedaAgrupada(onResult,
				onFault,
				filtrosSeleccionadosBusqueda,
				tipoBusqueda,bloqueUno);
		}
		
		private function onResult(featureSet: FeatureSet, token:Object = null): void
		{
			var resultado: ArrayCollection = new ArrayCollection;
			
			if(featureSet.features.length == 0)
			{
				callBackOk(resultado);
				return;
			}
			
			var mostrado: Boolean = false;
			
			for(var pos:Number = 0; pos < featureSet.features.length; pos++)
			{
				var g:Graphic = featureSet.features[pos] as Graphic;
				
				var frecuenciaNis:Number=Number(g.attributes["frecuenciaNis"]);
				var duracionNis:Number=Number(g.attributes["duracionNis"]);
				var alimentador:String=g.attributes["alimentador"];
				var nis:Number=Number(g.attributes["nis"]);
				var sumaBloque:Number=Number(g.attributes["sumaBloque"]);
				
				if (sumaBloque>1){
					frecuenciaNis=frecuenciaNis-(sumaBloque-1);
				}
				
				var causa:String=null;
				
				var id:Number;
				if (Global.tipoBusquedaCliente()){
					id=Number(g.attributes["nis"]);
				}
				else if (Global.tipoBusquedaSed()){
					id=Number(g.attributes["sed"]);
					causa=g.attributes["tipo_emp"];
				}
				
				var interrupcionDto:InterrupcionPorAlimentadorDto=new InterrupcionPorAlimentadorDto;
				interrupcionDto.frecuenciaNis=frecuenciaNis;
				interrupcionDto.duracionNis=duracionNis;
				interrupcionDto.alimentador=alimentador;
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