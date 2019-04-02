package widgets.AdminLectores.utilidad
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
	
	import widgets.AdminLectores.utilidad.cargarCombos;
	

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
		public var token:Object;
		
		public var myCustomer:FeatureLayer = new FeatureLayer(urls.URL_DENUNCIOS_INGRESAR,null,token as String);
		public var myLineCP:FeatureLayer = new FeatureLayer(urls.URL_CREAR_UNION_CDP,null,token as String);
		public function cliente()
		{
			
		}
		
		public function addCliente(
			nis:int,
			medidor:int, 
			marca_modelo:String,
			direccion:String, 
			tipo_denuncio:String, 
			comuna:String, 
			empresa:String,
			id_poste:String,
			id_direccion:String,
			comentario:String,
			geoCliente:MapPoint):void {
			
			
			var adds:Array=new Array;
			
			var nuevaPoligono:* = new Object;
			nuevaPoligono["nis"]=nis;				
			nuevaPoligono["medidor"]= medidor;
			nuevaPoligono["marca_modelo"]= marca_modelo;
			nuevaPoligono["direccion"]= direccion;
			nuevaPoligono["tipo_denuncio"]= tipo_denuncio;
			nuevaPoligono["comuna"]=comuna;			
			//nuevaPoligono["empresa"]=empresa
			nuevaPoligono["id_poste"]=id_poste;
			nuevaPoligono["id_direccion"]= id_direccion;
			nuevaPoligono["comentario"]= comentario;
			nuevaPoligono["x"]= geoCliente.x;
			nuevaPoligono["y"]= geoCliente.y;
			
			/*Alert.show("nis:" + nis + " med " +medidor + " mar-mo " + marca_modelo + " dir " + direccion + " tipo_denuncio" +
				tipo_denuncio + " comuna " +  comuna + " empresa " + empresa + " id_post " + id_poste + " idDir: " + 
				id_direccion + " comentario: "+ comentario + " " + geoCliente.x);
			*/
			
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