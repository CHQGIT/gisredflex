package widgets.PowerOn
{
	import com.esri.ags.Map;
	import com.esri.ags.layers.FeatureLayer;
	import com.esri.ags.layers.GraphicsLayer;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Panel;
	
	import widgets.PowerOn.busqueda.ManagerOrdenes;
	import widgets.PowerOn.busqueda.Ordenes;
	import widgets.PowerOn.principal.PrincipalPowerOn;
	
	public class GlobalPowerOn
	{
		
		public static var principalPowerOn:PrincipalPowerOn;
		
		public static var graphicsLayer:GraphicsLayer;
		public static var capaSeleccionado:GraphicsLayer;
		public static var map:Map;
		public static var rangos:ArrayCollection;
		public static var tipoResultadosBusqueda:Number;
		
		public static var graphicsLayerRango1:GraphicsLayer;
		public static var graphicsLayerRango2:GraphicsLayer;
		public static var graphicsLayerRango3:GraphicsLayer;
		
		public static var capaClientes:GraphicsLayer;
		public static var capaOrigenFalla:GraphicsLayer;
		public static var capaTransformadores:GraphicsLayer;
		public static var capaOrdenes:GraphicsLayer;
		
		public static var capaFrecuencia:FeatureLayer;
		
		public static var baseWidget:Object;
		
		public static var managerOrdenes:ManagerOrdenes = new ManagerOrdenes;
		
		public function GlobalPowerOn()
		{
		}
		
		public static function limpiarYOcultarCapas():void{
			if (graphicsLayer){
				graphicsLayer.visible=false;
				graphicsLayer.clear();
			}
			
			if (capaSeleccionado){
				capaSeleccionado.visible=false;
				capaSeleccionado.clear();
			}
			
			if (graphicsLayerRango1){
				graphicsLayerRango1.visible=false;
				graphicsLayerRango1.clear();
			}
			
			if (graphicsLayerRango2){
				graphicsLayerRango2.visible=false;
				graphicsLayerRango2.clear();
			}
			
			if (graphicsLayerRango3){
				graphicsLayerRango3.visible=false;
				graphicsLayerRango3.clear();
			}
			
			if (capaFrecuencia){
				capaFrecuencia.visible=false;
				capaFrecuencia.clear();
			}
			
			if (capaClientes){
				capaClientes.visible=false;
				capaClientes.clear();
			}
			
			if(capaOrigenFalla){
				capaOrigenFalla.visible = false;
				capaOrigenFalla.clear();
			}
			
			if (capaTransformadores){
				capaTransformadores.visible=false;
				capaTransformadores.clear();
			}
			
			if (capaOrdenes){
				capaOrdenes.visible=false;
				capaOrdenes.clear();
			}
		}
		
		public static function ocultarCapas():void{
			if (graphicsLayer){
				graphicsLayer.visible=false;
			}
			
			if (capaSeleccionado){
				capaSeleccionado.visible=false;
			}
			
			if (graphicsLayerRango1){
				graphicsLayerRango1.visible=false;
			}
			
			if (graphicsLayerRango2){
				graphicsLayerRango2.visible=false;
			}
			
			if (graphicsLayerRango3){
				graphicsLayerRango3.visible=false;
			}
			
			if (capaFrecuencia){
				capaFrecuencia.visible=false;
			}
			
			if (capaClientes){
				capaClientes.visible=false;
			}
			
			if (capaTransformadores){
				capaTransformadores.visible=false;
			}
			
			if (capaOrdenes){
				capaOrdenes.visible=false;
			}
			
			if(capaOrigenFalla){
				capaOrigenFalla.visible = false;
			}
		}
		
		
		public static function mostrarCapas():void{
			if (graphicsLayer){
				graphicsLayer.visible=true;
			}
			
			if (capaSeleccionado){
				capaSeleccionado.visible=true;
			}
			
			if (graphicsLayerRango1){
				graphicsLayerRango1.visible=true;
			}
			
			if (graphicsLayerRango2){
				graphicsLayerRango2.visible=true;
			}
			
			if (graphicsLayerRango3){
				graphicsLayerRango3.visible=true;
			}
			
			if (capaFrecuencia){
				capaFrecuencia.visible=true;
			}
			
			if (capaClientes){
				capaClientes.visible=true;
			}
			
			if (capaTransformadores){
				capaTransformadores.visible=true;
			}
			
			if (capaOrdenes){
				capaOrdenes.visible=true;
			}
			
			if(capaOrigenFalla){
				capaOrigenFalla.visible = true;
			}
		}
	}
}

 