package widgets.Interrupciones.servicios.busquedaGeometria
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	
	import comun.util.zalerta.ZAlerta;
	
	import widgets.Interrupciones.global.Global;

	public class BusquedaGeometriaPaginada
	{
		public var resultado:Object;
		
		public var callBackOk:Function;
		public var callBackError:Function;
		
		public static var MAXIMO_RESULTADOS_POR_LLAMADA:Number=1000;
		
		protected var numeroPaginas:Number=0;
		protected var paginaActual:Number=0;
		protected var paginas:Object;
		
		public var campoBuscar:String;
		public var urlServicio:String;
		
		public function BusquedaGeometriaPaginada(campoBuscar:String,urlServicio:String)
		{
			this.campoBuscar=campoBuscar;
			this.urlServicio=urlServicio;
		}
		
		public function buscar(callBackOk:Function,callBackError:Function,ids:ArrayCollection):void{
			this.callBackError=callBackError;
			this.callBackOk=callBackOk;
			
			paginas=new Object;
			numeroPaginas=(int)(ids.length/MAXIMO_RESULTADOS_POR_LLAMADA)+1;
			
			var resto:Number=(ids.length%MAXIMO_RESULTADOS_POR_LLAMADA);
			
			if (resto==0){
				numeroPaginas--;	
			}
			
			Global.log("paginacion!!!");
			Global.log("numero paginas: "+numeroPaginas);
			Global.log("resto: "+resto);
			
			var paginaIteracion:Number=0;
			
			for (var i:Number=0;i<ids.length;i++){
				var arreglo:ArrayCollection=paginas["pagina"+paginaIteracion];
				
				if (arreglo==null){
					arreglo=new ArrayCollection;
					paginas["pagina"+paginaIteracion]=arreglo;
				}
				
				arreglo.addItem(ids.getItemAt(i));
				
				if (arreglo.length==MAXIMO_RESULTADOS_POR_LLAMADA){
					paginaIteracion++;
				}
			}
			
			paginaActual=0;
			
			resultado=new Object;
			llamarPagina(paginas["pagina"+0]);
		}
		
		private function llamarPagina(idsPagina:ArrayCollection):void{
			var propiedades:Array = new Array();
			
			propiedades.push(campoBuscar);
			
			var query:Query = new Query();
			query.outFields=propiedades;
			//TODO: hardcodeado por ahora
			query.outSpatialReference= new SpatialReference(102100);
			
			var w:String="";
			w=campoBuscar+" in (";
			
			for (var i:Number=0;i<idsPagina.length;i++){
				if (i==0){
					w+="'"+idsPagina[i]+"'";
				}
				else{
					w+=",'"+idsPagina[i]+"'";
				}
			}
			w+=")";
			
			if (idsPagina.length==0){
				w=campoBuscar+" in ('-1')";
			}
			query.where=w;
			
			query.returnGeometry = true;
			
			var queryTask:QueryTask = new QueryTask();
			queryTask.showBusyCursor = true;
			
			//queryTask.url=Urls.URL_CLIENTES;
			queryTask.url=this.urlServicio;
			queryTask.useAMF=false;
			
			Global.log("antes llamada servicio");
			queryTask.execute(query, new AsyncResponder(onResultPagina, onFaultPagina));
		}
		
		private function onResultPagina(featureSet:FeatureSet, token:Object = null):void
		{
			if (featureSet.features.length == 0){
				callBackOk(resultado);
				return;
			}
			
			for (var i:Number=0;i<featureSet.features.length;i++){
				
				var g:Graphic = featureSet.features[i] as Graphic;
				
				var nis:Number=Number(g.attributes[campoBuscar]);
				
				resultado[""+nis]=g;
			}
			
			paginaActual++;
			
			Global.log("en llamada pagina actual: "+paginaActual+" numero de paginas: "+numeroPaginas);
			
			if (paginaActual<numeroPaginas){
				llamarPagina(paginas["pagina"+paginaActual]);
				return;
			}
			
			Global.log("llamo callback!!!");
			
			callBackOk(resultado);
		}
		
		private function onFaultPagina(info:Object, token:Object = null):void
		{
			Global.log("error servicio"+info);
			callBackError("error" +info);
		}
	}
}