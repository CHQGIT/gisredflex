package widgets.PowerOn.busqueda
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	import widgets.PowerOn.GlobalPowerOn;
	import widgets.PowerOn.urls.Urls;

	public class BusquedaCliente
	{
		public function BusquedaCliente(){
		}
		
		public function listarClientes():void
		{
			// Realizamos Consulta a tabla Clientes...
			var clienteTask:QueryTask = new QueryTask();
			clienteTask.url = Urls.POWERON_CLIENTES;
			
			clienteTask.useAMF = false;
			
			var cliente:Query = new Query();
			cliente.outFields = ["*"];
			cliente.returnGeometry = false;
			cliente.where = "1=1";
			clienteTask.execute(cliente, new AsyncResponder(clienteResult, clienteFault));
		}
		
		private function clienteResult(featureSet:FeatureSet, token:Object = null):void  
		{   	
			trace("1<<<<<<<<<<<<< exito cliente");
			GlobalPowerOn.managerOrdenes.listaOrdenesXY = new ArrayCollection; // limpiar para nueva busqueda..
			for (var i:Number=0; i < featureSet.features.length; i++){
				// Usando Id_Orden de tabla Clientes, buscamos las Órdenes...
				var busquedaDatosOrden:BusquedaDatosOrdenPorCliente=new BusquedaDatosOrdenPorCliente;
				busquedaDatosOrden.ejecutar(featureSet.features[i]);
				
				// Usando NIS de la tabla Clientes, buscamos los puntos sobre el mapa... 
				var busquedaUbicacionCliente:BusquedaUbicacionCliente=new BusquedaUbicacionCliente();
				busquedaUbicacionCliente.ejecutar(featureSet.features[i]);
			}
			
			var busquedaTransformadores:BusquedaTransformadores=new BusquedaTransformadores;
			busquedaTransformadores.ejecutar();
		}  
		
		private function clienteFault(info:Object, token:Object = null):void  
		{
			Alert.show("No se pudo cargar los datos en Clientes:\n"+ info.toString());

			var busquedaTransformadores:BusquedaTransformadores=new BusquedaTransformadores;
			busquedaTransformadores.ejecutar();
		}
	}
}