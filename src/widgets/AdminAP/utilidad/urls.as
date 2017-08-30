package widgets.AdminAP.utilidad
{
	public class urls
	{
		public static var URL_CONSUMOS:String = "http://gisred.chilquinta/arcgis/rest/services/GESTION_AP/AP_ANALISIS/MapServer/1";
		public static var URL_CONSUMOS_TEORICOS:String = "http://gisred.chilquinta/arcgis/rest/services/GESTION_AP/AP_ANALISIS/MapServer/2";
		public static var URL_CONSUMOS_FACTURADOS:String = "http://gisred.chilquinta/arcgis/rest/services/GESTION_AP/AP_ANALISIS/MapServer/3";
		public static var URL_CONSUMO_ANUAL:String = "http://gisred.chilquinta/arcgis/rest/services/GESTION_AP/AP_ANALISIS/MapServer/4";
		public static var URL_MEDIDOR:String = "http://gisred.chilquinta/arcgis/rest/services/AP_Municipal/AP_MUNICIPAL/FeatureServer/3";
		public static var URL_TRAMOS:String = "http://gisred.chilquinta/arcgis/rest/services/AP_Municipal/AP_MUNICIPAL/FeatureServer/2";
		public static var URL_LUMINARIAS:String = "http://gisred.chilquinta/arcgis/rest/services/AP_Municipal/AP_MUNICIPAL/FeatureServer/1";
		public static var ndo:String; 
		
		public function urls()
		{
			
		}
		
		public static function setndo_(s:String):void{
			ndo = s;
		}
	}
}