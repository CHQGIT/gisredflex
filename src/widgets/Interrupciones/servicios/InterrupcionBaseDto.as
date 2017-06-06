package widgets.Interrupciones.servicios
{
	import com.esri.ags.Graphic;

	public class InterrupcionBaseDto
	{
		public var frecuenciaNis:Number;
		public var duracionNis:Number;
		
		public var id:Number;
		public var causa:String;
		
		public var graphicFrecuencia:Graphic;
		public var graphicDuracion:Graphic;
		
		public var rangoDuracion:Number;
		public var rangoFrecuencia:Number;
		
		public function InterrupcionBaseDto()
		{
		}
	}
}