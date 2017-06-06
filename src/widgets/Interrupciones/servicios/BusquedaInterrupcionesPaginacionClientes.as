package widgets.Interrupciones.servicios
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	
	import widgets.Interrupciones.urls.Urls;

	public class BusquedaInterrupcionesPaginacionClientes
	{
		public var resultado:ArrayCollection;
		
		public var callBackOk:Function;
		public var callBackError:Function;
		
		public function BusquedaInterrupcionesPaginacionClientes()
		{
		}
		
		public function buscar(callBackOk:Function,callBackError:Function,whereZona:String,whereTiempo:String,whereTipo:String):void{
			this.callBackError=callBackError;
			this.callBackOk=callBackOk;
			
			var query:Query = new Query();
			
			var propiedades:Array = new Array();
			propiedades.push("nis");
			query.outFields=propiedades;
			
			var whereFinal:String="";
			
			if (whereZona!=null && whereZona!=""){
				whereFinal=whereZona;	
			}
			
			if (whereFinal!=""){
				if (whereTiempo!=null && whereTiempo!=""){
					whereFinal+=" and "+whereTiempo;
				}
			}
			else{
				whereFinal=whereTiempo;
			}
			
			if (whereFinal!=""){
				if (whereTipo!=null && whereTipo!=""){
					whereFinal+=" and "+whereTipo;
				}
			}
			else{
				whereFinal=whereTipo;
			}
			
			query.where=whereFinal;
			query.returnDistinctValues=false;
			
			var queryTask:QueryTask = new QueryTask();
			queryTask.showBusyCursor = true;
			
			queryTask.url=Urls.URL_INTERRUPCIONES_CLIENTES;
			queryTask.useAMF=false;
			
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
		}
		
		private function onResult(featureSet:FeatureSet, token:Object = null):void
		{
			resultado=new ArrayCollection;
			
			if (featureSet.features.length == 0){
				callBackOk(resultado);
				return;
			}
			
			for (var i:Number=0;i<featureSet.features.length;i++){
				
				var g:Graphic = featureSet.features[i] as Graphic;
				
				var nis:Number=Number(g.attributes["nis"]);
				
				resultado.addItem(nis);
			}
			callBackOk(resultado);
		}
		
		public function onFault(info:Object, token:Object = null):void
		{
			callBackError("error" +info);
		}
	}
}