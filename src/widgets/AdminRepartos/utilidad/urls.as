package widgets.AdminRepartos.utilidad
{
	public class urls
	{
			
		//interna
		public static var URL_TIPO_MEDIDOR:String="https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/7";
		public static var URL_TECNOLOGIA_MEDIDOR:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/11/";
		public static var URL_TIPO_TENSION:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/5";
		public static var URL_TIPO_POSTE:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/4";
		public static var URL_TIPO_EDIFICACION:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/6";
		public static var URL_TIPO_EMPALME:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/10";
		
		
		public static var URL_DIRECCIONES:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Cartografia/DMPS/MapServer/0";
		public static var URL_ROTULOS:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Chilquinta_006/Nodos_006/MapServer/0";
		
		public static var URL_ADD_CLIENTE:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/0";
		public static var URL_CREAR_POSTES:String="https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/1";
		public static var URL_CREAR_DIRECCION:String="https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/2"
		public static var URL_CREAR_UNION_CDP:String="https://gisredint.chilquinta.cl//arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/3"
		public static var URL_CALLES:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/MapaBase/MapServer/2";
		public static var URL_INGRESOEXTERNO_DYN = "https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/MapServer";
		
		public static var URL_LECTURAS:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_movil_lectores/FeatureServer/0";
		public static var URL_LECTURAS_DYN:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_movil_lectores/MapServer";
		public static var URL_INGRESOSEXTERNOS:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer";
		public static var URL_LECTURA_INSPECCION:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_movil_lectores/FeatureServer/0";
		public static var URL_LISTADO_INSPECTORES:String="https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_movil_lectores/FeatureServer/1";
		public static var URL_LECTURAS_DETALLE:String="https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_movil_lectores/FeatureServer/2";
		
		public static var URL_COMUNAS:String="https://gisredint.chilquinta.cl/arcgis/rest/services/MapaBase/MapServer/4";
		/*public static var URL_CREAR_UNION_CDP:String="https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Ingreso_externo_nuevo/FeatureServer/3"
		*/	
		public static var URL_DENUNCIOS_INGRESAR:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/CNR/Denuncios_web/FeatureServer/0";
		
		public static var URL_REPARTOS:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/CECOM/Reparto_view/MapServer/0";
		public static var URL_REPARTOS_VIEW:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/CECOM/Reparto_view/MapServer/1";
		public static var URL_REPARTOS_NIS:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Mobile/Reparto/FeatureServer/1";
		
		public static var ndo:String; 
		
		public static var URL_BUSQUEDA_CLIENTES:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/Chilquinta_006/ClientesV2/MapServer/0";
		public static var URL_LECTURAS_VERIFY:String = "https://gisredint.chilquinta.cl/arcgis/rest/services/CECOM/Lectura_xy/MapServer/0";
			
		public function urls()
		{
				
		}
		
		public static function setndo_(s:String):void{
			ndo = s;
		}
		
		
	}
}