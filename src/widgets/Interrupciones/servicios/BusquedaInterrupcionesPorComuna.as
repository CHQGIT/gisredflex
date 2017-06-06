package widgets.Interrupciones.servicios
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	
	import mx.collections.ArrayCollection;
	
	import widgets.Interrupciones.busqueda.FiltrosSeleccionadosBusqueda;
	import widgets.Interrupciones.global.Global;

	public class BusquedaInterrupcionesPorComuna
	{
		public var resultado: ArrayCollection;
		
		public var callBackOn: Function;
		public var callBackError: Function;
		
		public var busquedaInterrupcionComun:BusquedaInterrupcionComun;
		
		public function BusquedaInterrupcionesPorComuna(){
			busquedaInterrupcionComun=new BusquedaInterrupcionComun;
		}
		
		public function buscar(callBackOn: Function, callBackError: Function, 
							   filtrosSeleccionadosBusqueda:FiltrosSeleccionadosBusqueda,
							   tipoResultado:Number,bloqueUno:Boolean):void
		{
			this.callBackOn = callBackOn;
			this.callBackError = callBackError;
			
			busquedaInterrupcionComun.busquedaAgrupada(onResult,
				onFault,
				filtrosSeleccionadosBusqueda,
				BusquedaInterrupcionComun.TIPO_BUSQUEDA_COMUNA,bloqueUno);
		}
		
		private function onResult(featureSet: FeatureSet, token:Object = null): void
		{
			var resultado: ArrayCollection = new ArrayCollection;
			
			if(featureSet.features.length == 0)
			{
				callBackOn(resultado);
				return;
			}
			
			var mostrado: Boolean = false;
			
			for(var pos:Number = 0; pos < featureSet.features.length; pos++)
			{
				var g:Graphic = featureSet.features[pos] as Graphic;
				
				var frecuenciaNis:Number=Number(g.attributes["frecuenciaNis"]);
				var duracionNis:Number=Number(g.attributes["duracionNis"]);
				var nis: Number = Number(g.attributes["nis"]);
				var comuna:String =  g.attributes["comuna"];
				var causa:String=null;
				
				var id:Number;
				if (Global.tipoBusquedaCliente()){
					id=Number(g.attributes["nis"]);
				}
				else if (Global.tipoBusquedaSed()){
					id=Number(g.attributes["sed"]);
					causa=g.attributes["tipo_emp"];
				}
			
				var interrupcionDto:InterrupcionPorComunaDto=new InterrupcionPorComunaDto;
				interrupcionDto.frecuenciaNis=frecuenciaNis;
				interrupcionDto.duracionNis=duracionNis;
				interrupcionDto.comuna=comuna;
				interrupcionDto.id=id;
				interrupcionDto.causa=causa;
				
				resultado.addItem(interrupcionDto);
			}
			callBackOn(resultado);
		}
		
		private function onFault(info:Object, token:Object = null):void
		{
			callBackError("error" +info);
		}
	}
}