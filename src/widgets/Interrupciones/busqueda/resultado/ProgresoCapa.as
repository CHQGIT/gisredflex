package widgets.Interrupciones.busqueda.resultado
{
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import spark.components.Button;
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.servicios.busquedaGeometria.BusquedaClientes;

	public class ProgresoCapa extends SkinnableComponent
	{
		[SkinPart]
		public var cancelarBtn: Button;
		[SkinPart]
		public var volverBtn: Button;
		
		public function ProgresoCapa()
		{
			setStyle("skinClass", ProgresoCapaSkin);
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(instance == cancelarBtn)
			{
				cancelarBtn.addEventListener(MouseEvent.CLICK, cancelarBtn_clickHandler);
			}
			
			if(instance == volverBtn)
			{
				volverBtn.addEventListener(MouseEvent.CLICK, volverBtn_clickHandler);
			}
		}
		
		protected function volverBtn_clickHandler(event: MouseEvent): void
		{
			Global.principal.mostrarTablaInterrupcionesDesdeCarga();
		}
		
		protected function cancelarBtn_clickHandler(event: MouseEvent): void
		{
			Global.principal.mostrarTablaInterrupcionesDesdeCarga();
		}
		
		public function cargarClientes(ids:ArrayCollection):void{
			var buscarClientes:BusquedaClientes=new BusquedaClientes();
			buscarClientes.buscar(callBackOk,callBackError,ids);
		}
		
		public function callBackOk(resultado:ArrayCollection):void{
			Global.graphicsLayer.visible=true;
			var sms:SimpleMarkerSymbol=new SimpleMarkerSymbol("diamond", 15,0xff0000,0.7);
			
			var extentActual:Extent=new Extent;
			var extentMaximo:Extent=new Extent;
			
			for (var i:Number=0;i<resultado.length;i++){
				var g:Graphic=resultado[i] as Graphic;
				g.symbol =  sms;
				var mp:MapPoint=g.geometry as MapPoint;
				Global.graphicsLayer.add(g);
				
				if (i==0){
			//		extent.xmin=mp.x-100;
			//		extent=mp.extent;
				}
				/*else{
					extent=extent.union(mp.extent);
				}
				*/
			}
		//	Global.map.extent=extent;
		}
		
		public function callBackError(mensaje:String):void{
			Alert.show("","error "+mensaje);
		}
	}
}