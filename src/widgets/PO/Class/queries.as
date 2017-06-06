package widgets.PO.Class
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.events.QueryEvent;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	import com.esri.ags.tasks.supportClasses.StatisticDefinition;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncResponder;
	
	import widgets.PO.urls.Urls;

	
	public class queries
	{
		[Bindable]public var arrayClientesOrdenes:ArrayCollection = new ArrayCollection;
		[Bindable]public var arraySED:ArrayCollection = new ArrayCollection;
		public var graphicLayer:GraphicsLayer = new GraphicsLayer;
		public var map:Map;
		[Bindable]public var CantClientes:int = new int;
		
		public var Feature:FeatureSet =  new FeatureSet;
		
		public function queries()
		{
			
		}
		
		public function consultaClientesyOrdenes():void{
			arrayClientesOrdenes.removeAll();
			// TODO Auto-generated method stub
			var queryTask:QueryTask = new QueryTask();
			queryTask.url = widgets.PO.urls.Urls.PO_CLIENTES;
			queryTask.useAMF = false;
			var query:Query = new Query();
			query.outFields = ["*"];
			query.returnGeometry = true;
			query.where = "1=1";
			//queryTask.token = token as String;
			
			
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
			
			// add the graphic on the map
			function onResult(featureSet:FeatureSet, token:Object = null):void
			{
				for(var k:int=0;k<featureSet.features.length;k++)
				{
					var recordGraphic:Graphic = featureSet.features[k];
					
					//FECHA_RECEPCION:dateFormatter.format(new Date(recordGraphic.attributes["FECHA_RECEPCION"])),
					var dateFormatter:DateFormatter = new DateFormatter;
					dateFormatter.formatString = "DD/MM/YYYY L:NN A";
						
					arrayClientesOrdenes.addItem({OBJECTID:recordGraphic.attributes["ARCGIS.dbo.POWERON_CLIENTES.ObjectID"], 
						NIS:recordGraphic.attributes["ARCGIS.dbo.POWERON_CLIENTES.nis"],
						ID_INCIDENCIA:recordGraphic.attributes["ARCGIS.dbo.POWERON_CLIENTES.id_incidencia"], 
						TIPO_EQUIPO:recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.tipo_equipo"],
						ID_ORDEN:recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.id_orden"],
						ESTADO_ORDEN:recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.estado_orden"],
						F_CREACION:dateFormatter.format(new Date(recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.fecha_creacion"])),
						F_MODIFICACION:dateFormatter.format(new Date(recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.fc_ult_modif"])),
						F_CIERRE:dateFormatter.format(new Date(recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.fc_cierre"])),
						TIPO:String("CLIENTE"),						
						gra:recordGraphic });
					
				}
				
			}
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show("No se pueden obtener los tipos de medidores.  Contáctese con el administrador de GISRED."+ info.toString());
			}
			
		
		
		}
		public function ConsultaClientes(DGCli:int):FeatureSet
		{
			
			// TODO Auto-generated method stub
			var queryTaskOrden:QueryTask = new QueryTask();
			queryTaskOrden.showBusyCursor = true;
			
			queryTaskOrden.url= widgets.PO.urls.Urls.PO_CLIENTES;
			queryTaskOrden.useAMF=false;
			
			var querycentral:Query = new Query();
		//	querycentral.outSpatialReference= map.spatialReference;
			querycentral.returnGeometry=true;
			
			
			querycentral.where="ARCGIS.dbo.POWERON_CLIENTES.nis=" + DGCli;
			
			
			queryTaskOrden.execute(querycentral, new AsyncResponder(onResult, onFault));
			
			function onResult(featureSet:FeatureSet, token:Object = null):void
			{
				
				Feature = featureSet;
			//	map.zoomTo(featureSet.features[0].geometry);				
			//	map.level = 16;		
				
				
			}
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show(info.toString(), "Zoom de cliente con problemas");
			}
			return Feature;
			
		}
		
		public function ConsultaTrafo(DGTra:int):FeatureSet
		{
			
			// TODO Auto-generated method stub
			var queryTaskOrden:QueryTask = new QueryTask();
			queryTaskOrden.showBusyCursor = true;
			
			queryTaskOrden.url= widgets.PO.urls.Urls.PO_SED;
			queryTaskOrden.useAMF=false;
			
			var querycentral:Query = new Query();
			//	querycentral.outSpatialReference= map.spatialReference;
			querycentral.returnGeometry=true;
			
			
			querycentral.where="ARCGIS.DBO.SED_006.codigo=" + DGTra;
			
			
			queryTaskOrden.execute(querycentral, new AsyncResponder(onResult, onFault));
			
			function onResult(featureSet:FeatureSet, token:Object = null):void
			{
				
				Feature = featureSet;
				//	map.zoomTo(featureSet.features[0].geometry);				
				//	map.level = 16;		
				
				
			}
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show(info.toString(), "Zoom de trafo con problemas");
			}
			return Feature;
			
		}
		
		
		public function consultaSED():void {
		
			// TODO Auto-generated method stub
			var queryTask:QueryTask = new QueryTask();
			queryTask.url = widgets.PO.urls.Urls.PO_SED;
			queryTask.useAMF = false;
			var query:Query = new Query();
			query.outFields = ["*"];
			query.returnGeometry = true;
			query.where = "1=1";
			//queryTask.token = token as String;
			
			
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
			
			// add the graphic on the map
			function onResult(featureSet:FeatureSet, token:Object = null):void
			{
				for(var k:int=0;k<featureSet.features.length;k++)
				{
					var recordGraphic:Graphic = featureSet.features[k];
					
					//FECHA_RECEPCION:dateFormatter.format(new Date(recordGraphic.attributes["FECHA_RECEPCION"])),
					var dateFormatter:DateFormatter = new DateFormatter;
					dateFormatter.formatString = "DD/MM/YYYY L:NN A";
					
					arrayClientesOrdenes.addItem({OBJECTID:recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.OBJECTID"], 
						ID_ORDEN:recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.id_orden"],
						ID_INCIDENCIA:recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.id_incidencia"], 
						TIPO_EQUIPO:recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.tipo_equipo"],
						ID_ORDEN:recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.id_orden"],
						ESTADO_ORDEN:recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.estado_orden"],
						F_CREACION:dateFormatter.format(new Date(recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.fecha_creacion"])),
						F_MODIFICACION:dateFormatter.format(new Date(recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.fc_ult_modif"])),
						F_CIERRE:dateFormatter.format(new Date(recordGraphic.attributes["ARCGIS.DBO.POWERON_ORDENES.fc_cierre"])),
						TIPO:String("SED"),
						CODIGO:recordGraphic.attributes["ARCGIS.DBO.SED_006.codigo"],
						gra:recordGraphic });
					
					arraySED.addItem({CODIGO:recordGraphic.attributes["ARCGIS.DBO.SED_006.codigo"]});
					
				}
		//Alert.show(arraySED.length.toString());
				
			}
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show("No se pueden obtener los tipos de medidores.  Contáctese con el administrador de GISRED."+ info.toString());
			}
			
		}
		
		public function cantClientes():void
		{
			
			//Alert.show(arraySED.length.toString());
			for(var k:int=0;k<arraySED.length;k++)
			{
				var queryTask:QueryTask = new QueryTask();
				queryTask.url = "http://143.47.57.116/arcgis/rest/services/Chilquinta_006/ClientesV2/MapServer/0";
				queryTask.useAMF = false;
				
			
			
			 	var statisticalQuery:Query = new Query();
			
				var statDef:StatisticDefinition = new StatisticDefinition;
				statDef.onStatisticField = "ARCGIS.dbo.CLIENTES_DATA_DATOS_006.nis";				
				statDef.outStatisticFieldName = "NIS_SUM";
				statDef.statisticType = StatisticDefinition.TYPE_COUNT;			
					
				statisticalQuery.outStatistics = [statDef];			
				statisticalQuery.where = "ARCGIS.dbo.CLIENTES_DATA_DATOS_006.resp_id_sed = " + arraySED[k];
				statisticalQuery.outSpatialReference = map.spatialReference;
				statisticalQuery.returnGeometry = false;
			
				queryTask.execute(statisticalQuery,new AsyncResponder(onResult, onFault));
		
				function onResult(event:QueryEvent):void
				{
					Alert.show("HOLA");
					CantClientes = CantClientes + event.featureSet.attributes.length;
				}
				function onFault(info:Object, token:Object = null):void
				{
					Alert.show("No se pueden obtener los tipos de medidores.  Contáctese con el administrador de GISRED."+ info.toString());
				}
				
			}
		}
		
	}
}