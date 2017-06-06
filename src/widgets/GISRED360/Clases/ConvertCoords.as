package widgets.GISRED360.Clases
{
	import flash.sampler.NewObjectSample;
	
	import flashx.textLayout.formats.Float;

	
	
	
	public class ConvertCoords
	{
		
		
			public var X_lon:Number;       // X coordinate of the collision
			public var Y_lat:Number;       // Y coordinate of the collision
			
		
			public function ToGeographic(mercatorX_lon:Number, mercatorY_lat:Number):void{
			
				if ( (Math.abs(mercatorX_lon) < 180) && (Math.abs(mercatorY_lat) < 90) ) {
				 return;
				}
				
				if ((Math.abs(mercatorX_lon) > 20037508.3427892 && (Math.abs(mercatorY_lat) > 20037508.3427892))) {
					return;
				}
				
				var x:Number = mercatorX_lon;
				var y:Number = mercatorY_lat;
				var num3:Number = x / 6378137.0;
				var num4:Number = num3 * 57.295779513082323;
				var num5:Number = Math.floor(((num4 + 180.0) / 360.0));
				var num6:Number = num4 - (num5 * 360.0);
				var num7:Number = 1.5707963267948966 - (2.0 * Math.atan(Math.exp((-1.0 * y) / 6378137.0)));
				mercatorX_lon = num6;
				mercatorY_lat = num7 * 57.295779513082323;
				
				X_lon = mercatorX_lon;
				Y_lat = mercatorY_lat;

				
			}
			

	}
}