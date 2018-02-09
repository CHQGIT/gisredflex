package widgets.IngresoClientes.utilidad
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.Geometry;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.layers.FeatureLayer;
	
	import mx.controls.Alert;
	import mx.core.INavigatorContent;
	import mx.rpc.AsyncResponder;
	
	import widgets.IngresoClientes.IngresoClientes;
	

	public class cliente
	{
		public static var nombre_direccionCliente:String;
		public static var numero_direccionCliente:int;
		public static var id_direccionCliente:int;
		public static var id_rotulo:Number;
		public static var numero_rotulo:String;
		public static var tipo_direccionCliente:String;
		
		public static var geom_ubicacionCliente:MapPoint;
		public static var geom_ubicacionPoste:MapPoint;
		public static var geom_ubicacionDireccion:MapPoint;
		
		
		public var myCustomer:FeatureLayer = new FeatureLayer(urls.URL_ADD_CLIENTE,null,cargarCombos.token as String);
		public var myLineCP:FeatureLayer = new FeatureLayer(urls.URL_CREAR_UNION_CDP,null,cargarCombos.token as String);
		public function cliente()
		{
			
		}
		
		public function addCliente(
			nis:int,
			medidor:int, 
			tipoEmpalme:String, 
			tipoMedidor:String, 
			tipoTecnologia:String, 
			os:int, 
			idPosteCamara:int, 
			existenciaPosteCamara:String,
			idDireccion:int, 
			existenciaDireccion:String,
			geoCliente:Graphic,
			geoLineaDireccion:Graphic,
			geoLineaRotulo:Graphic):void {
			
			
			var adds:Array=new Array;
			
			var nuevaPoligono:* = new Object;
			nuevaPoligono["TIPO_DIRECCION"]=existenciaDireccion;				
			nuevaPoligono["ID_DIRECCION"]= idDireccion;
			nuevaPoligono["NIS"]= nis;
			nuevaPoligono["NUMERO_MEDIDOR"]= medidor;
			nuevaPoligono["TIPO_EMPALME"]= tipoEmpalme;
			nuevaPoligono["TIPO_MEDIDOR"]=tipoMedidor;			
			nuevaPoligono["TIPO_TECNOLOGIA"]=tipoTecnologia
			nuevaPoligono["TIPO_POSTE_CAMARA"]=existenciaPosteCamara;
			nuevaPoligono["OS"]= os;
			nuevaPoligono["ID_POSTE_CAMARA"]= idPosteCamara;
			nuevaPoligono["empresa"]='Chilquinta'
			
			
			//se agrega el punto del cliente con sus datos.
			var graficoEditadoActual:Graphic=new Graphic(geom_ubicacionCliente,null,nuevaPoligono);
			adds[0]=graficoEditadoActual; 
			
			myCustomer.applyEdits(adds,null,null, false,new AsyncResponder(onResult, onFault));
			function onResult():void
			{
				Alert.show("Cliente agregado");
				
				//agregar lineas 
				//agregarLineas(nis,idDireccion,rotulo,idPoste);
			}
			
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show("Error al agregar solicitud "+info.toString());
			}
			
			
		}//add cliente close
		
		public function agregarLineaCP(id_poste:int, rotulo:String, nis:int):void{
			var polyline:Polyline=new Polyline([[geom_ubicacionCliente, geom_ubicacionPoste]],new SpatialReference(102100));
			
			var adds:Array=new Array;
			
			var nuevaPoligono:* = new Object;
			nuevaPoligono["ID_POSTE"]=id_poste;				
			nuevaPoligono["NIS"]= nis;
			nuevaPoligono["ROTULO"]= rotulo;
			nuevaPoligono["ID_DIRECCION"]= 0;
			
			
			
			//se agrega el punto del cliente con sus datos.
			var graficoEditadoActual:Graphic=new Graphic(polyline,null,nuevaPoligono);
			adds[0]=graficoEditadoActual; 
			
			myLineCP.applyEdits(adds,null,null,false,new AsyncResponder(onResult, onFault));
			function onResult():void
			{
				//Alert.show("Linea CP agregada");
				
			}
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show("Error al agregar linea CP "+info.toString());
			}
			
			
		}
		
		public function agregarLineaCD(id_direccion:int, nis:int):void{
			var polyline:Polyline=new Polyline([[geom_ubicacionCliente, geom_ubicacionDireccion]],new SpatialReference(102100));
			
			var adds:Array=new Array;
			
			var nuevaPoligono:* = new Object;
			nuevaPoligono["ID_POSTE"]=0;				
			nuevaPoligono["NIS"]= nis;
			nuevaPoligono["ROTULO"]= null;
			nuevaPoligono["ID_DIRECCION"]= id_direccion;
			
			
			
			//se agrega el punto del cliente con sus datos.
			var graficoEditadoActual:Graphic=new Graphic(polyline,null,nuevaPoligono);
			adds[0]=graficoEditadoActual; 
			
			myLineCP.applyEdits(adds,null,null,false,new AsyncResponder(onResult, onFault));
			function onResult():void
			{
				//Alert.show("Linea CD agregada");
				
			}
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show("Error al agregar linea CD "+info.toString());
			}
			
			
		}
		
		
		
	}//class cliente close
	
}// package utilidad close