package widgets.PowerOn.conversion
{
	public class ConversionXY
	{
		public function ConversionXY()
		{
		}
		
		public static function CONVERT_XY(ValorX:Number, ValorY:Number):void  //(ByVal ValorX, ByVal ValorY)
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
			var Huso:Number; //INTEGER
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
			Exentricidad = (Math.sqrt(Math.pow(aMayor, 2) - Math.pow(bMenor, 2)) / aMayor);
			Exentricidad2 = Math.sqrt(Math.pow(aMayor, 2) - Math.pow(bMenor, 2)) / bMenor;
			e2 = Math.pow(Exentricidad2, 2);
			C = Math.pow(aMayor, 2) / bMenor;
			MeridianoCentral = 6 * Huso - 183;
			YSurEcuador = YExtern - 10000000;
			Fi = YSurEcuador / (6366197.724 * 0.9996);
			Ni = C / (Math.pow((1 + e2 * Math.pow(Math.cos(Fi), 2)), (1 / 2))) * 0.9996;
			a = (XExtern - 500000) / Ni;
			A1 = Math.sin(2 * Fi);
			A2 = A1 * (Math.pow(Math.cos(Fi), 2)); //revisar
			J2 = Fi + A1 / 2;
			J4 = (3 * J2 + A2) / 4;
			J6 = (5 * J4 + A2 * Math.pow((Math.cos(Fi)), 2)) / 3;
			Alfa = (3 / 4) * e2;
			Beta = (5 / 3) * Math.pow(Alfa, 2);
			Gamma = (35 / 27) * Math.pow(Alfa, 3);
			BFi = 0.9996 * C * (Fi - (Alfa * J2) + (Beta * J4) - (Gamma * J6));
			b = (YSurEcuador - BFi) / Ni;
			Zeta = ((e2 * (Math.pow(a, 2))) / 2) * Math.pow(Math.cos(Fi), 2);
			xi = a * (1 - (Zeta / 3));
			Eta = b * (1 - Zeta) + Fi;
			
			SenHXi = (Math.exp(xi) - Math.exp(-xi)) / 2;
			
			DeltaLamda = Math.atan(SenHXi / Math.cos(Eta));
			Tau = Math.atan(Math.cos(DeltaLamda) * Math.tan(Eta));
			fiRadian = Fi + (1 + e2 * Math.pow(Math.cos(Fi), 2) - (3 / 2) * e2 * Math.sin(Fi) * Math.cos(Fi) * (Tau - Fi)) * (Tau - Fi);
			
			XG0Conv = DeltaLamda / Math.PI * 180 + MeridianoCentral;
			YG0Conv = fiRadian / Math.PI * 180;			
		}	
	}
}