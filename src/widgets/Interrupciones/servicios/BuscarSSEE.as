package widgets.Interrupciones.servicios
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	
	import widgets.Interrupciones.componentesComunes.DtoObjetoLista;
	import widgets.Interrupciones.urls.Urls;

	public class BuscarSSEE
	{
		public var resultado:ArrayCollection;
		
		public var callBackOk:Function;
		public var callBackError:Function;
		
		public function BuscarSSEE()
		{
		}
		
		public function buscar(callBackOk:Function,callBackError:Function):void{
			this.callBackError=callBackError;
			this.callBackOk=callBackOk;
			
			var propiedades:Array = new Array();
			propiedades.push("id_ssee");
			propiedades.push("nombre");
			
			var query:Query = new Query();
			query.outFields=propiedades;
			//TODO: hardcodeado por ahora
			query.outSpatialReference= new SpatialReference(102100);
			
			// TODO: ACA PONER EL IN de los ids....
			var w:String="1=1";
			query.where=w;
			
			query.returnGeometry = false;
			query.orderByFields = new Array("nombre asc");
			
			var queryTask:QueryTask = new QueryTask();
			queryTask.showBusyCursor = true;
			//queryTask.token=Principal.
			queryTask.url=Urls.URL_SSEE;
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
				
				var idSee:Number=Number(g.attributes["id_ssee"]);
				var nombre:String=g.attributes["nombre"];
				
				var dtoObjetoLista:DtoObjetoLista=new DtoObjetoLista;
				dtoObjetoLista.idTipo=idSee;
				dtoObjetoLista.valor=nombre;
				
				resultado.addItem(dtoObjetoLista);
			}
			callBackOk(resultado);
		}
		
		private function onFault(info:Object, token:Object = null):void
		{
			callBackError("error" +info);
		}
	}
}