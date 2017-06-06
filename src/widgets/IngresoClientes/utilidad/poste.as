package widgets.IngresoClientes.utilidad
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.FeatureLayer;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;

	public class poste
	{
	
		public static var geom_ubicacionNuevoPoste:MapPoint;
		public static var myPoste:FeatureLayer = new FeatureLayer(urls.URL_CREAR_POSTES,null,cargarCombos.token as String);
		public static var rotulo:String;
		public static var tipo_poste:String;
		public static var tipo_tension:String; 
		public static var x_poste:Number; 
		public static var y_poste:Number; 
		
		
		public function poste()
		{
			
		}
		
		public function crearNuevoPoste(rotulo:String, tipoPoste:String, tipoTension:String, geomNuevoPoste:Graphic):void{
			
				
				var adds:Array=new Array;
				
				var nuevoPoste:* = new Object;
				nuevoPoste["ROTULO"]=rotulo;				
				nuevoPoste["TIPO_POSTE"]= tipoPoste;
				nuevoPoste["TIPO_TENSION"]= tipoTension;
				nuevoPoste["empresa"]= 'chilquinta';
				//nuevoPoste["X"]= anexo2;
				//nuevoPoste["Y"]= tipoEdificacion;
				
				
				
				//se agrega el punto del cliente con sus datos.
				var graficoEditadoActual:Graphic=new Graphic(geom_ubicacionNuevoPoste,null,nuevoPoste);
				adds[0]=graficoEditadoActual; 
				
				myPoste.applyEdits(adds,null,null, false,new AsyncResponder(onResult, onFault));
				function onResult():void
				{
					Alert.show("Poste agregado");
				}
				
				function onFault(info:Object, token:Object = null):void
				{
					Alert.show("Error al agregar nuevo poste "+info.toString());
				}
				
			
		}
	}
}