package widgets.AdminLectores.utilidad
{
	public class urls
	{
		/*public static var URL_TIPO_MEDIDOR:String="http://gisred.chilquinta.cl:5555/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/7";
		public static var URL_TECNOLOGIA_MEDIDOR:String = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/11/";
		public static var URL_TIPO_TENSION:String = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/5";
		public static var URL_TIPO_POSTE:String = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/4";
		public static var URL_TIPO_EDIFICACION:String = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/6";
		public static var URL_TIPO_EMPALME:String = "http://gisred.chilquinta.cl:5555/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/10";
		
		
		public static var URL_DIRECCIONES:String = "http://gisred.chilquinta/arcgis/rest/services/Cartografia/DMPS/MapServer/0";
		public static var URL_ROTULOS:String = "http://gisred.chilquinta/arcgis/rest/services/Chilquinta_006/Nodos_006/MapServer/0";
		*/
		public static var URL_LECTURAS:String = "http://gisred.chilquinta/arcgis/rest/services/Varios/Ingreso_Lectores/FeatureServer/0";
		public static var URL_LECTURAS_DYN:String = "http://gisred.chilquinta/arcgis/rest/services/Varios/Ingreso_Lectores/MapServer";
		public static var URL_INGRESOSEXTERNOS:String = "http://gisred.chilquinta/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer";
		/*public static var URL_CREAR_POSTES:String="http://gisred.chilquinta/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/1";
		public static var URL_CREAR_DIRECCION:String="http://gisred.chilquinta/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/2"
		public static var URL_CREAR_UNION_CDP:String="http://gisred.chilquinta/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/3"
		*/	
		public static var ndo:String; 
		
		public function urls()
		{
			
		}
		
		public static function setndo_(s:String):void{
			ndo = s;
		}
	}
}