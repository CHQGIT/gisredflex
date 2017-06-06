package comun.util
{
	public class ZStringUtil
	{
		public function ZStringUtil()
		{
		}
		
		public static function reemplazarAcentos(s:String):String{
			s=s.replace("á","a");
			s=s.replace("é","e");
			s=s.replace("í","i");
			s=s.replace("ó","o");
			s=s.replace("ú","u");
			
			s=s.replace("Á","A");
			s=s.replace("É","E");
			s=s.replace("Í","I");
			s=s.replace("Ó","O");
			s=s.replace("Ú","U");
			
			s=s.replace("Ñ","N");
			s=s.replace("ñ","n");
			
			return s;
		}
	}
}