package widgets.PowerOn.busqueda
{
	import com.esri.ags.geometry.Geometry;

	public class UtilXYOrden
	{
		public var geometria:Geometry;
		public var idOrden:String;
		public var nis:String;
		public var sed:String;
		
		public function UtilXYOrden(geometria:Geometry,idOrden:String,nis:String,sed:String)
		{
			this.geometria = geometria;
			this.idOrden= idOrden;
			this.nis = nis;
			this.sed = sed;
		}
	}
}