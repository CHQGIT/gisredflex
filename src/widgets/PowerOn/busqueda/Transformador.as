package widgets.PowerOn.busqueda
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import mx.controls.Alert;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncResponder;
	
	import widgets.Interrupciones.global.Global;
	import widgets.PowerOn.principal.PrincipalPowerOn;
	
	public class Transformador
	{
		private var dateFormatter:DateFormatter;
		private var principalPowerOn:PrincipalPowerOn;
		private var fechaformateada:Date;
		private var clientes_transformador:Number;
			
		public function Transformador(dateFormatter:DateFormatter, principalPowerOn:PrincipalPowerOn)
		{
			this.dateFormatter = dateFormatter;
			this.principalPowerOn = principalPowerOn; 
		}
		
		public function listarTransformadores():void
		{
			// Realizamos Consulta a tabla Transformadores...
			var transformadoresTask:QueryTask = new QueryTask();
			transformadoresTask.url = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Interrupciones/Interrupciones_clientes/MapServer/7";
			transformadoresTask.useAMF = false;
			transformadoresTask.showBusyCursor = true;
			
			var transformadores:Query = new Query();
			transformadores.outFields = ["id_orden"];
			transformadores.returnDistinctValues = true;
			transformadores.returnGeometry = false;
			transformadores.where = "1=1";
			transformadoresTask.execute(transformadores, new AsyncResponder(transformadoresResult, transformadoresFault));  
		}	
		
		public function transformadoresResult(transformadoresSet:FeatureSet, token:Object = null):void  
		{   					
			for (var i:Number=0; i < transformadoresSet.features.length; i++){
				
				// Usando Id_Orden de tabla Transformadores, buscamos las Órdenes...
				var ordenTransTask:QueryTask = new QueryTask();
				ordenTransTask.url = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Interrupciones/Interrupciones_clientes/MapServer/6";
				ordenTransTask.useAMF = false;
				var ordenTrans:Query = new Query();
				
				ordenTrans.outFields = ["*"];
				ordenTrans.returnGeometry = false;
				ordenTrans.where = "id_orden = '" + transformadoresSet.features[i].attributes["id_orden"] + 
					"' and id_owned NOT IN (1, 170, 228)" +
					" and estado_orden IN  ('arrived','dispatched','en_route','in_progress','new','ready','suspended')";
				
				ordenTransTask.execute(ordenTrans, new AsyncResponder(resultOrdenTrans, faultOrdenTrans));
				
				
				var transauxTask:QueryTask = new QueryTask();
				transauxTask.url = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Interrupciones/Interrupciones_clientes/MapServer/7";
				transauxTask.useAMF = false;
				
				var transaux:Query = new Query();
				transaux.outFields = ["*"];
				transaux.returnGeometry = false;
				transaux.where = "id_orden = '" + transformadoresSet.features[i].attributes["id_orden"] + "'";
				transauxTask.execute(transaux, new AsyncResponder(transauxResult, transauxFault));
				
			}
		}
		
		public function transformadoresFault(info:Object, token:Object = null):void  
		{
			Alert.show("No se pudo cargar los datos"+ info.toString());  
		}
		
		public function resultOrdenTrans(setOrdenes:FeatureSet, token:Object = null):void  
		{   
			fechaformateada = new Date(setOrdenes.features[0].attributes["fecha_creacion"]);
			setOrdenes.features[0].attributes["fecha_creacion"] = dateFormatter.format(fechaformateada);
			
			fechaformateada = new Date(setOrdenes.features[0].attributes["fecha_despacho"]);
			setOrdenes.features[0].attributes["fecha_despacho"] = dateFormatter.format(fechaformateada);
			
			fechaformateada = new Date(setOrdenes.features[0].attributes["fecha_asignacion"]);
			setOrdenes.features[0].attributes["fecha_asignacion"] = dateFormatter.format(fechaformateada);
			
			fechaformateada = new Date(setOrdenes.features[0].attributes["fecha_ruta"]);
			setOrdenes.features[0].attributes["fecha_ruta"] = dateFormatter.format(fechaformateada);
			
			fechaformateada = new Date(setOrdenes.features[0].attributes["fecha_llegada"]);
			setOrdenes.features[0].attributes["fecha_llegada"] = dateFormatter.format(fechaformateada);
			
			fechaformateada = new Date(setOrdenes.features[0].attributes["fc_termino_t"]);
			setOrdenes.features[0].attributes["fc_termino_t"] = dateFormatter.format(fechaformateada);
			
			fechaformateada = new Date(setOrdenes.features[0].attributes["fc_cierre"]);
			setOrdenes.features[0].attributes["fc_cierre"] = dateFormatter.format(fechaformateada);
			
			fechaformateada = new Date(setOrdenes.features[0].attributes["fc_ult_modif"]);
			setOrdenes.features[0].attributes["fc_ult_modif"] = dateFormatter.format(fechaformateada);
			
			setOrdenes.features[0].attributes["afectado"] = "Transformador";
			principalPowerOn.listaOrdenes.addItem(setOrdenes.features[0].attributes);
			principalPowerOn.selIndex.text = principalPowerOn.selIndex.text + " T-";							
		}
		
		public function faultOrdenTrans(info:Object, token:Object = null):void
		{  
			Alert.show("No se pudo cargar los datos"+ info.toString());
		}
		
		public function transauxResult(transauxSet:FeatureSet, token:Object = null):void  
		{
			for (var j:Number=0; j < transauxSet.features.length; j++){
				// Usando ID_TRAFO de la tabla TRANSFORMADORES, buscamos los puntos sobre el mapa... 
				var shapeTransTask:QueryTask = new QueryTask();
				shapeTransTask.showBusyCursor = true;
				shapeTransTask.url = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Chilquinta_006/Chilquinta/MapServer/0";
				shapeTransTask.useAMF = false;
				
				var shapeTrans:Query = new Query();
				shapeTrans.returnGeometry = true;
				shapeTrans.outFields = ["*"];
				shapeTrans.where = "codigo = " + transauxSet.features[j].attributes["id_trafo"] 
				shapeTransTask.execute(shapeTrans, new AsyncResponder(resultPuntoTrans, faultPuntoTrans));

			}
			var idx:Number = 0;
			//selIndex.text = selIndex.text + j + " - ";
			for each (var o:Object in principalPowerOn.listaOrdenes)
			{
				if(o.id_orden == transformadoresSet.features[i].attributes["id_orden"]){
					principalPowerOn.listaOrdenes[idx].total_afectos = j;
				}
				idx++;
			}
		}
		
		public function transauxFault(info:Object, token:Object = null):void  
		{  
			Alert.show("No se pudo cargar los datos"+ info.toString());  
		}
		
		public function resultPuntoTrans(puntotransSet:FeatureSet, token:Object = null):void  
		{   									
			var extent:Extent=null;
			var puntoTransformador:Graphic = puntotransSet.features[0];
			
			var colorTrans:Number=0xff0000;
			var colorTransformador:SimpleMarkerSymbol = new SimpleMarkerSymbol("triangle", 20, colorTrans);
			
			puntoTransformador=new Graphic(puntoTransformador.geometry,colorTransformador);
			
			Global.graphicsLayer.add(puntoTransformador);
			Global.log("fin puntos");
			Global.map.extent=extent;
			
		}  
		
		public function faultPuntoTrans(info:Object, token:Object = null):void  
		{  
			Alert.show("No se pudo cargar los datos"+ info.toString());  
		}
		
	}
}