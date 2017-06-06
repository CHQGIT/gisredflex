package widgets.PowerOn.busqueda
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	import widgets.PowerOn.urls.Urls;
	
	public class BusquedaTransformadores
	{
		public function BusquedaTransformadores()
		{
		}
		
		public function ejecutar():void{
			// Realizamos Consulta a tabla Transformadores...
			var transformadoresTask:QueryTask = new QueryTask();
			transformadoresTask.url = Urls.POWERON_TRANSFORMADORES;
			transformadoresTask.useAMF = false;
			transformadoresTask.showBusyCursor = true;
			
			var transformadores:Query = new Query();
			transformadores.outFields = ["id_orden"];
			transformadores.returnDistinctValues = true;
			transformadores.returnGeometry = false;
			transformadores.where = "1=1";
			transformadoresTask.execute(transformadores, new AsyncResponder(transformadoresResult, transformadoresFault));	
		}
		
		private function transformadoresResult(transformadoresSet:FeatureSet, token:Object = null):void  
		{   		
			trace("2<<<<<<<<<<< tranformadores " + transformadoresSet.features.length);
			for (var i:Number=0; i < transformadoresSet.features.length; i++){
				
				// Usando Id_Orden de tabla Transformadores, buscamos las Órdenes...
				var busquedaDatosOrdenPorTransformador:BusquedaDatosOrdenPorTransformador=new BusquedaDatosOrdenPorTransformador();
				busquedaDatosOrdenPorTransformador.ejecutar(transformadoresSet.features[i]);
				
				// Usando id_trafo de Transformadores buscamos el punto en el mapa...
				var busquedaUbicacion:BusquedaUbicacionTrafo=new BusquedaUbicacionTrafo();
				busquedaUbicacion.ejecutar(transformadoresSet.features[i]);
			}

			var busquedaOrdenes:BusquedaOrdenes=new BusquedaOrdenes();
			busquedaOrdenes.ejecutar();
		}  
		
		private function transformadoresFault(info:Object, token:Object = null):void  
		{
			Alert.show("No se pudo cargar los datos de Transformadores:\n"+ info.toString());
			var busquedaOrdenes:BusquedaOrdenes=new BusquedaOrdenes();
			busquedaOrdenes.ejecutar();
		}
	}
}