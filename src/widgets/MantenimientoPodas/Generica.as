package widgets.MantenimientoPodas
{
	import mx.collections.ArrayList;

	public class Generica
	{
		public static var IdPoligonoPodoas:Number;
		public static var numeroSolicitud:Number;
		public static var maxActividad:int;
		
		
		public static var id_arranque:Number;
		[Bindable]public static var Nom_arranque:String;
		public static var segmento_id:Number;
		[Bindable]public static var Nomcalle:String;
		[Bindable]public static var Nomcomuna:String;
		
		[Bindable] public static var NombreUsuario:String;
		
		public static var EstadoAbierto:int = 0;
		
		public static var Insert:Boolean;
		public static var Modify:Boolean;
		public static var Delete:Boolean;
		
		[Bindable]public static var AreaMtto:String;
		[Bindable]public static var grupoCompra:String;
		
		
		public static var valorUF:Number;
		public static var fechaPago:String;
		public static var num_contrato:String;
		public static var vig_contrato_desde:String;
		public static var vig_contrato_hasta:String;
		public static var fechaHoy:String;
		public static var nom_area:String;
		public static var nombre_grupo_compra:String;
		
		public static var totalNoEmergencia:int;
		public static var totalEmergencia:int;
		public static var totalMontoAPagar:int;
		
		
		[Bindable]public static var numerosLibroObra:String;
		[Bindable]public static var permisosPreventivos:String;
		[Bindable]public static var ArrayNumerosLibroObra:Array=  new Array;
		[Bindable]public static var ArrayPermisosPreventivos:ArrayList =  new ArrayList;
		
		public function Generica()
		{
			
		}
	}
}

