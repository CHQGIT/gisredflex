package widgets.IngresoClientes.utilidad
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	import widgets.IngresoClientes.utilidad.urls;
	

	public class cargarCombos
	{
		public var arrayTipoMedidor:ArrayList = new ArrayList;
		public var arrayTecnologiaMedidor:ArrayList = new ArrayList;
		public var arrayTipoPoste:ArrayList = new ArrayList;
		public var arrayTension:ArrayList = new ArrayList;
		public var arrayTipoEmpalme:ArrayList = new ArrayList;
		public var arrayTipoEdificacion:ArrayList = new ArrayList;
		
		public static var token:Object;
		public function cargarCombos()
		{
		}
		/*
		[Bindable] private var ArrayTipoMedidor:ArrayList = new ArrayList;
		[Bindable] private var ArrayTecnologiaMedidor:ArrayList = new ArrayList;
		[Bindable] private var ArrayTension:ArrayList = new ArrayList;
		[Bindable] private var ArrayTipoPoste:ArrayList = new ArrayList;
		[Bindable] private var ArrayTipoEdificacion:ArrayList = new ArrayList;
		 * */
		
		public function cargaTipoMedidor():ArrayList{
			
			arrayTipoMedidor.removeAll();
			// TODO Auto-generated method stub
			var queryTask:QueryTask = new QueryTask();
			queryTask.url = widgets.IngresoClientes.utilidad.urls.URL_TIPO_MEDIDOR;
			queryTask.useAMF = false;
			var query:Query = new Query();
			query.outFields = ["NOMBRE","ID"];
			query.returnGeometry = false;
			query.where = "1=1";
			queryTask.token = token as String;
			query.orderByFields=["NOMBRE","ID"];
			query.returnDistinctValues = true;
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
			
			// add the graphic on the map
			function onResult(featureSet:FeatureSet, token:Object = null):void
			{
				for each (var myGraphic:Graphic in featureSet.features)
				{
					arrayTipoMedidor.addItem({descripcion:myGraphic.attributes['NOMBRE']}); 
					
				}
				
			}
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show("No se pueden obtener los tipos de medidores.  Contáctese con el administrador de GISRED."+ info.toString());
			}
			
			return arrayTipoMedidor;
		}
		
		public function cargaTecnologiaMedidor():ArrayList{
			arrayTecnologiaMedidor.removeAll();
			// TODO Auto-generated method stub
			var queryTask:QueryTask = new QueryTask();
			queryTask.url = widgets.IngresoClientes.utilidad.urls.URL_TECNOLOGIA_MEDIDOR;
			queryTask.useAMF = false;
			queryTask.token = token as String;
			var query:Query = new Query();
			query.outFields = ["nombre","id"];
			query.returnGeometry = false;
			query.where = "1=1";
			query.orderByFields=["nombre"];
			query.returnDistinctValues = true;
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
			
			// add the graphic on the map
			function onResult(featureSet:FeatureSet, token:Object = null):void
			{
				for each (var myGraphic:Graphic in featureSet.features)
				{
					arrayTecnologiaMedidor.addItem({descripcion:myGraphic.attributes['nombre']}); 
					
				}
				
			}
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show("No se pueden obtener los tipos de tecnologia de medidores.  Contáctese con el administrador de GISRED."+ info.toString());
			}
			
			return arrayTecnologiaMedidor;
		}
		
		public function cargaTipoPoste():ArrayList{
			arrayTipoPoste.removeAll();
			// TODO Auto-generated method stub
			var queryTask:QueryTask = new QueryTask();
			queryTask.url = widgets.IngresoClientes.utilidad.urls.URL_TIPO_POSTE;
			queryTask.useAMF = false;
			queryTask.token = token as String;
			var query:Query = new Query();
			query.outFields = ["NOMBRE","ID"];
			query.returnGeometry = false;
			query.where = "1=1";
			query.orderByFields=["NOMBRE"];
			query.returnDistinctValues = true;
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
			
			// add the graphic on the map
			function onResult(featureSet:FeatureSet, token:Object = null):void
			{
				for each (var myGraphic:Graphic in featureSet.features)
				{
					arrayTipoPoste.addItem({descripcion:myGraphic.attributes['NOMBRE']}); 
					
				}
				
			}
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show("No se pueden obtener los tipos de postes.  Contáctese con el administrador de GISRED."+ info.toString());
			}
			
			return arrayTipoPoste;
		}
		
		
		public function cargaTipoTension():ArrayList{
			arrayTension.removeAll();
			// TODO Auto-generated method stub
			var queryTask:QueryTask = new QueryTask();
			queryTask.url = widgets.IngresoClientes.utilidad.urls.URL_TIPO_TENSION;
			queryTask.useAMF = false;
			queryTask.token = token as String;
			var query:Query = new Query();
			query.outFields = ["TIPO","ID"];
			query.returnGeometry = false;
			query.where = "1=1";
			query.orderByFields=["TIPO"];
			query.returnDistinctValues = true;
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
			
			// add the graphic on the map
			function onResult(featureSet:FeatureSet, token:Object = null):void
			{
				for each (var myGraphic:Graphic in featureSet.features)
				{
					arrayTension.addItem({descripcion:myGraphic.attributes['TIPO']}); 
					
				}
				
			}
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show("No se pueden obtener los tipos de tension.  Contáctese con el administrador de GISRED."+ info.toString());
			}
			
			return arrayTension;
		}
		
		
		public function cargaTipoEdificacion():ArrayList{
			arrayTipoEdificacion.removeAll();
			// TODO Auto-generated method stub
			var queryTask:QueryTask = new QueryTask();
			queryTask.url = widgets.IngresoClientes.utilidad.urls.URL_TIPO_EDIFICACION;
			queryTask.useAMF = false;
			queryTask.token = token as String;
			var query:Query = new Query();
			query.outFields = ["tipo","id"];
			query.returnGeometry = false;
			query.where = "1=1";
			query.orderByFields=["tipo"];
			query.returnDistinctValues = true;
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
			
			// add the graphic on the map
			function onResult(featureSet:FeatureSet, token:Object = null):void
			{
				for each (var myGraphic:Graphic in featureSet.features)
				{
					arrayTipoEdificacion.addItem({descripcion:myGraphic.attributes['tipo']}); 
					
				}
				
			}
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show("No se pueden obtener los tipos de edificacion.  Contáctese con el administrador de GISRED."+ info.toString());
			}
			
			return arrayTipoEdificacion;
		}
		public function cargaTipoEmpalme():ArrayList{
			arrayTipoEmpalme.removeAll();
			// TODO Auto-generated method stub
			var queryTask:QueryTask = new QueryTask();
			queryTask.url = widgets.IngresoClientes.utilidad.urls.URL_TIPO_EMPALME;
			queryTask.useAMF = false;
			queryTask.token = token as String;
			var query:Query = new Query();
			query.outFields = ["NOMBRE","ID"];
			query.returnGeometry = false;
			query.where = "1=1";
			query.orderByFields=["NOMBRE"];
			query.returnDistinctValues = true;
			queryTask.execute(query, new AsyncResponder(onResult, onFault));
			
			// add the graphic on the map
			function onResult(featureSet:FeatureSet, token:Object = null):void
			{
				for each (var myGraphic:Graphic in featureSet.features)
				{
					arrayTipoEmpalme.addItem({descripcion:myGraphic.attributes['NOMBRE']}); 
					
				}
				
			}
			function onFault(info:Object, token:Object = null):void
			{
				Alert.show("No se pueden obtener los tipos de empalme.  Contáctese con el administrador de GISRED."+ info.toString());
			}
			
			return arrayTipoEmpalme;
		}
		
	}
}