package widgets.AdminLectores.utilidad
{
	
	
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.layers.FeatureLayer;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	import widgets.AdminLectores.utilidad.cargarCombos;
	
	
	

	public class direccion
	{
		public static var validaDireccion:String;
		public static var geom_ubicacionNuevaDireccion:MapPoint;
		public static var myDireccion:FeatureLayer = new FeatureLayer(urls.URL_CREAR_DIRECCION,null,cargarCombos.token as String)
		public static var calleSelected:String;
		public static var segmentoid:int;
		public static var smsDir:SimpleMarkerSymbol;
		public function direccion()
		{
		}
		
		public function crearNuevaDireccion(calle:String, numero:String, anexo1:String, anexo2:String, tipoEdificacion:String, graNuevaDireccion:Graphic):void{
			
			
			var adds:Array=new Array;
			
			var nuevaDireccion:* = new Object;
			nuevaDireccion["CALLE"]=calle;				
			nuevaDireccion["NUMERO"]= numero;
			nuevaDireccion["ANEXO1"]= anexo1;
			nuevaDireccion["ANEXO2"]= anexo2;
			nuevaDireccion["TIPO_EDIFICACION"]= tipoEdificacion;
			nuevaDireccion["empresa"] ='chilquinta';
			
			
			
			//se agrega el punto del cliente con sus datos.
			var graficoEditadoActual:Graphic=new Graphic(geom_ubicacionNuevaDireccion,null,nuevaDireccion);
			adds[0]=graficoEditadoActual; 
			
			myDireccion.applyEdits(adds,null,null, false,new AsyncResponder(onResult, onFault));
			function onResult():void
			{
				Alert.show("Direccion agregada");
				
				
			}
			
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show("Error al agregar nueva direccion "+info.toString());
			}
			
		}
		
		
		
		public function setSMS(sms:SimpleMarkerSymbol):void{
			smsDir = sms;
		}
		
	}
}