package widgets.PowerOn.busqueda
{
	import com.esri.ags.FeatureSet;
	import com.esri.ags.Graphic;
	import com.esri.ags.geometry.Extent;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.tasks.QueryTask;
	import com.esri.ags.tasks.supportClasses.Query;
	
	import flash.events.MouseEvent;
	import flash.globalization.DateTimeFormatter;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncResponder;
	
	import widgets.PowerOn.GlobalPowerOn;
	import widgets.PowerOn.urls.Urls;
	
	public class BusquedaOrdenes
	{
		public var dateFormatter:DateTimeFormatter;
		public var idOrden:String;
		
		public function BusquedaOrdenes()
		{
			this.dateFormatter=new DateTimeFormatter("dd/MM/yy '-' HH:mm");
		}
		
		public function ejecutar():void{
			var i:Number;
			
			var origenTask:QueryTask = new QueryTask();
			origenTask.url = Urls.POWERON_ORDENES;
			origenTask.showBusyCursor = true;
			origenTask.useAMF = false;
			var origen:Query = new Query();
			
			origen.outFields = ["*"];
			origen.returnGeometry = false;
			origen.where = "id_owned NOT IN (1, 170, 228) " +
				"and estado_orden IN  ('arrived','dispatched','en_route','in_progress','new','ready','suspended')";
			
			origenTask.execute(origen, new AsyncResponder(resultOrigen, faultOrigen));
			
		}
		
		public function resultOrigen(setOrigen:FeatureSet, token:Object = null):void
		{
			var flag:Boolean = false;
			
			for(var y:Number = 0; y < setOrigen.features.length; y++){
				flag = false;
				var listasValidacion:ArrayCollection = GlobalPowerOn.managerOrdenes.eventoTimer.activo ?
					GlobalPowerOn.managerOrdenes.listaOrdenesTimer : GlobalPowerOn.managerOrdenes.listaOrdenes;
				
				for each (var o:Object in listasValidacion)
				{
					if (o.id_orden == setOrigen.features[y].attributes["id_orden"])
					{
						flag = true;
					}
				}
				
				if (flag ==true){
					continue;
				}
				
				if (setOrigen.features[y].attributes["fecha_creacion"] != '-2208988800000'){
					setOrigen.features[y].attributes["fecha_creacion"] = dateFormatter.format(new Date(setOrigen.features[y].attributes["fecha_creacion"]));	
				} else {
					setOrigen.features[y].attributes["fecha_creacion"] = "-";
				}
				
				if (setOrigen.features[y].attributes["fecha_despacho"] != '-2208988800000'){
					setOrigen.features[y].attributes["fecha_despacho"] = dateFormatter.format(new Date(setOrigen.features[y].attributes["fecha_despacho"]));	
				} else {
					setOrigen.features[y].attributes["fecha_despacho"] = "-";
				}
				
				if (setOrigen.features[y].attributes["fecha_asignacion"] != '-2208988800000'){
					setOrigen.features[y].attributes["fecha_asignacion"] = dateFormatter.format(new Date(setOrigen.features[y].attributes["fecha_asignacion"]));	
				} else {
					setOrigen.features[y].attributes["fecha_asignacion"] = "-";
				}
				
				if (setOrigen.features[y].attributes["fecha_ruta"] != '-2208988800000'){
					setOrigen.features[y].attributes["fecha_ruta"] = dateFormatter.format(new Date(setOrigen.features[y].attributes["fecha_ruta"]));	
				} else {
					setOrigen.features[y].attributes["fecha_ruta"] = "-";
				}
				
				if (setOrigen.features[y].attributes["fecha_llegada"] != '-2208988800000'){
					setOrigen.features[y].attributes["fecha_llegada"] = dateFormatter.format(new Date(setOrigen.features[y].attributes["fecha_llegada"]));	
				} else {
					setOrigen.features[y].attributes["fecha_llegada"] = "-";
				}
				
				if (setOrigen.features[y].attributes["fc_termino_t"] != '-2208988800000'){
					setOrigen.features[y].attributes["fc_termino_t"] = dateFormatter.format(new Date(setOrigen.features[y].attributes["fc_termino_t"]));	
				} else {
					setOrigen.features[y].attributes["fc_termino_t"] = "-";
				}
				
				if (setOrigen.features[y].attributes["fc_cierre"] != '-2208988800000'){
					setOrigen.features[y].attributes["fc_cierre"] = dateFormatter.format(new Date(setOrigen.features[y].attributes["fc_cierre"]));	
				} else {
					setOrigen.features[y].attributes["fc_cierre"] = "-";
				}
				
				if (setOrigen.features[y].attributes["fc_ult_modif"] != '-2208988800000'){
					setOrigen.features[y].attributes["fc_ult_modif"] = dateFormatter.format(new Date(setOrigen.features[y].attributes["fc_ult_modif"]));	
				} else {
					setOrigen.features[y].attributes["fc_ult_modif"] = "-";
				}
				
				setOrigen.features[y].attributes["afectado"] = "Origen Falla";							
				GlobalPowerOn.managerOrdenes.agregarElemento(setOrigen.features[y].attributes);	
				
				var x1:Number=Number(setOrigen.features[y].attributes["max_x"]);
				var y1:Number=Number(setOrigen.features[y].attributes["max_y"]);
				
				x1=x1/100.0;
				y1=y1/100.0;
				
				var transformada:Coordenada=CONVERT_XY(x1, y1);
				
				transformada.x= transformada.x * 20037508.34 / 180;
				transformada.y = Math.log(Math.tan((90 + transformada.y) * Math.PI / 360)) / (Math.PI / 180);							
				transformada.y = transformada.y * 20037508.34 / 180;
				
				setOrigen.features[y].attributes["x"]=transformada.x;
				setOrigen.features[y].attributes["y"]=transformada.y;
				
				var colorFrecuencia:Number=0x00ff000;
				var colorCliente:SimpleMarkerSymbol = new SimpleMarkerSymbol("diamond", 20, colorFrecuencia);
				
				var extent:Extent=null;
				var puntoOrigenFalla:Graphic = new Graphic(new MapPoint(transformada.x,transformada.y, GlobalPowerOn.map.spatialReference),colorCliente);
				idOrden = setOrigen.features[y].attributes["id_orden"];
				
				var evento:BusquedaEventoMapaTabla = new BusquedaEventoMapaTabla(puntoOrigenFalla,idOrden,null,null);
				puntoOrigenFalla.addEventListener(MouseEvent.MOUSE_OVER,mouseOver);
				puntoOrigenFalla.addEventListener(MouseEvent.MOUSE_OUT,eliminarMensaje);
				// SE AGREGAN PUNTOS PARA EVENTO CLICK EN TABLA.
				var xyOrden:UtilXYOrden = new UtilXYOrden(puntoOrigenFalla.geometry,idOrden,null,null);
				GlobalPowerOn.managerOrdenes.listaOrdenesXY.addItem(xyOrden);
				
				GlobalPowerOn.capaOrigenFalla.add(puntoOrigenFalla);				
				GlobalPowerOn.map.extent=extent;
			}
			
			GlobalPowerOn.managerOrdenes.eventoTimer.validarListas();
		}
		
		public function faultOrigen(info:Object, token:Object = null):void
		{  
			Alert.show("No se pudo cargar los datos"+ info.toString());
		}
		
		public function CONVERT_XY(ValorX:Number , ValorY:Number):Coordenada  //(ByVal ValorX, ByVal ValorY)
		{
			
			var aMayor:Number;
			var bMenor:Number;
			var Exentricidad:Number;
			var Exentricidad2:Number;
			var e2:Number;
			var C:Number;
			var fiRadian:Number
			var Fi:Number;
			var Ni:Number;
			var a:Number;
			var A1:Number;
			var A2:Number;
			var J2:Number;
			var J4:Number;
			var J6:Number;
			var Alfa:Number;
			var Beta:Number;
			var Gamma:Number;
			var BFi:Number;
			var b:Number;
			var Zeta:Number;
			var xi:Number;
			var Eta:Number;
			var SenHXi:Number;
			var DeltaLamda:Number;
			var Tau:Number;
			var Huso:int;
			var FX:Number;
			var FY:Number;
			var XExtern:Number;
			var YExtern:Number;
			var MeridianoCentral:Number;
			var YSurEcuador:Number;
			
			FX = -183.101;
			FY = -371.613;
			
			XExtern = ValorX + FX;
			YExtern = ValorY + FY;
			
			Huso = 19;			
			aMayor = 6378137;
			bMenor = 6356752.314;
			Exentricidad = (Math.sqrt(aMayor * aMayor - bMenor * bMenor) / aMayor);
			Exentricidad2 = Math.sqrt(aMayor * aMayor - bMenor * bMenor) / bMenor;
			e2 = (Exentricidad2 * Exentricidad2);
			C = (aMayor * aMayor) / bMenor;
			MeridianoCentral = 6 * Huso - 183;
			YSurEcuador = YExtern - 10000000;
			Fi = YSurEcuador / (6366197.724 * 0.9996);
			Ni = C / (Math.pow((1 + e2 * Math.cos(Fi) * Math.cos(Fi)), (1 / 2))) * 0.9996;
			a = (XExtern - 500000) / Ni;
			A1 = Math.sin(2 * Fi);
			A2 = A1 * Math.cos(Fi) * Math.cos(Fi); //revisar
			J2 = Fi + A1 / 2;
			J4 = (3 * J2 + A2) / 4;
			J6 = (5 * J4 + A2 * (Math.cos(Fi) * Math.cos(Fi))) / 3;
			Alfa = (3 / 4) * e2;
			Beta = (5 / 3) * Alfa * Alfa;
			Gamma = (35 / 27) * Alfa * Alfa * Alfa;
			BFi = 0.9996 * C * (Fi - (Alfa * J2) + (Beta * J4) - (Gamma * J6));
			b = (YSurEcuador - BFi) / Ni;
			Zeta = ((e2 * a * a)/ 2) * (Math.cos(Fi) * Math.cos(Fi));
			xi = a * (1 - (Zeta / 3));
			Eta = b * (1 - Zeta) + Fi;
			
			SenHXi = (Math.exp(xi) - Math.exp(-xi)) / 2;
			
			DeltaLamda = Math.atan(SenHXi / Math.cos(Eta));
			Tau = Math.atan(Math.cos(DeltaLamda) * Math.tan(Eta));
			fiRadian = Fi + (1 + e2 * Math.pow(Math.cos(Fi), 2) - (3 / 2) * e2 * Math.sin(Fi) * Math.cos(Fi) * (Tau - Fi)) * (Tau - Fi);
			
			var c:Coordenada=new Coordenada;
			c.x= DeltaLamda / Math.PI * 180 + MeridianoCentral;
			c.y= fiRadian / Math.PI * 180;	
			
			return c;
		}
		
		public function eliminarMensaje(e:MouseEvent):void
		{
			GlobalPowerOn.map.infoWindow.hide();
		}
		
		public function mouseOver(e:MouseEvent):void
		{
			GlobalPowerOn.map.infoWindow.label= "ID ORDEN:" +idOrden;; 
			GlobalPowerOn.map.infoWindow.closeButtonVisible = false;
			GlobalPowerOn.map.infoWindow.show(GlobalPowerOn.map.toMapFromStage(e.stageX +10, e.stageY ));  
		}
	}
}