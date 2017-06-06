package widgets.Interrupciones.servicios
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	
	import widgets.Interrupciones.urls.Urls;
	
	public class BusquedaTipos
	{
		public var resultado:ArrayCollection;
		
		public var callBackOk:Function;
		public var callBackError:Function;
		
		public function BusquedaTipos()
		{
		}
		
		public function buscar(callBackOk:Function,callBackError:Function):void{
			this.callBackOk=callBackOk;
			this.callBackError=callBackError;
			
			var propiedades:Array = new Array();
		 	propiedades.push("nombre");
			propiedades.push("minimo");
			propiedades.push("maximo");
			propiedades.push("OBJECTID");
			 
			var query:Query = new Query();
			query.outFields=propiedades;
			
			//TODO: hardcodeado por ahora
			query.outSpatialReference= new SpatialReference(102100);
			
			var w:String="1=1";
			query.where=w;
			
			query.returnGeometry = false;
			
			var queryTask:QueryTask = new QueryTask();
			queryTask.showBusyCursor = true;
			
			queryTask.url=Urls.URL_RANGOS;
			queryTask.useAMF=false;
			
		 	query.orderByFields=["OBJECTID"];
			
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
		}
		
		private function onResult(featureSet:FeatureSet, token:Object = null):void
		{
			resultado=new ArrayCollection;
			
			if (featureSet.features.length == 0){
				callBackOk(resultado);
				return;
			}
			
			var i:Number=0;
			
			for (i=0;i<featureSet.features.length;i++){
				
				var g:Graphic = featureSet.features[i] as Graphic;
				
				var nombre:String=g.attributes["nombre"];
				var minimo:Number=Number(g.attributes["minimo"]);
				var maximo:Number=Number(g.attributes["maximo"]);
				var objectId:Number=Number(g.attributes["OBJECTID"]);
			
				var rangoDto:RangoDto=new RangoDto;
				rangoDto.nombre=nombre;
				rangoDto.minimo=minimo;
				rangoDto.maximo=maximo;
				rangoDto.objectId=objectId;
				
				resultado.addItem(rangoDto);
			}
			
			
			var categoriaActual:Number=0;
			var primero:RangoDto;
			
			for (i=0;i<resultado.length;i++){
				primero=resultado.getItemAt(i) as RangoDto;
				
				if (primero.nombre=="cantidad_frecuencia"){
					continue;
				}
			
				primero.categoria=categoriaActual;
				categoriaActual++;				
			}
			
			categoriaActual=0;
			
			for (i=0;i<resultado.length;i++){
				primero=resultado.getItemAt(i) as RangoDto;
				
				if (primero.nombre=="duracion_tiempo"){
					continue;
				}
				
				primero.categoria=categoriaActual;
				categoriaActual++;				
			}

			callBackOk(resultado);
		}
		
		private function onFault(info:Object, token:Object = null):void
		{
			callBackError("error " +info + "token "+token);
		}
	}
}