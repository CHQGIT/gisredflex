package widgets.Interrupciones.busqueda.filtros
{
	import mx.collections.ArrayCollection;
	import mx.controls.DateField;
	import mx.events.CalendarLayoutChangeEvent;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import comun.util.zalerta.ZAlerta;
	
	import widgets.Interrupciones.servicios.UtilWhere;

	public class FiltroPeriodo extends SkinnableComponent
	{
		[SkinPart]
		public var fechaInicio: DateField;
		[SkinPart]
		public var fechaFin: DateField;
		
		private static const horaInicio: String = "00:00:00.000";
		private static const horaFinal: String = "23:59:59.999";
		
		public var callBackFecha:Function;
		
		public function FiltroPeriodo()
		{
			setStyle("skinClass", FiltroPeriodoSkin);
		}
		
		override protected function partAdded(partName:String, instance:Object): void
		{
			if(instance == fechaInicio)
			{
				fechaInicio.addEventListener(CalendarLayoutChangeEvent.CHANGE, cambiarFechaInicio);
			}
			
			if(instance == fechaFin)
			{
				fechaFin.addEventListener(CalendarLayoutChangeEvent.CHANGE, cambiarFechaFinal);
			}
		}
		
		protected function cambiarFechaInicio(event: CalendarLayoutChangeEvent): void
		{
			if(this.fechaFin.selectedDate == null)
			{
				this.fechaFin.selectedDate = event.newDate;
			}
			callBackFecha();
		}
		
		protected function cambiarFechaFinal(event: CalendarLayoutChangeEvent): void
		{
			if(this.fechaInicio.selectedDate == null)
			{
				this.fechaInicio.selectedDate = event.newDate;
			}
			callBackFecha();
		}
		
		public function generarWhere(periodoFecha: ArrayCollection, whereObject: Object): void
		{	
			if(periodoFecha.length != 0)
			{
				whereObject.stringWhere = UtilWhere.comprobarDatoVacioWhere(whereObject.stringWhere);
				whereObject.stringWhere += "(fecha_inicio between '" + periodoFecha[0] + "' and '" + periodoFecha[1] + "')";
			}
		}
		
		public function guardarDatoTiempo(): ArrayCollection
		{
			var datoTiempo: ArrayCollection = new ArrayCollection;
			
			if(this.fechaInicio.selectedDate != null && this.fechaFin.selectedDate != null)
			{
				if(this.validarIngresoFecha())
				{
					datoTiempo.addItem(this.convertirDateToString(this.fechaInicio.selectedDate, FiltroPeriodo.horaInicio));
					datoTiempo.addItem(this.convertirDateToString(this.fechaFin.selectedDate, FiltroPeriodo.horaFinal));
				}
				else
				{
					ZAlerta.show("La fecha de inicio no puede ser mayor que la fecha final");
					datoTiempo = null;
				}
			}
			else
			{
				if((this.fechaInicio.selectedDate != null && this.fechaFin.selectedDate == null) || (this.fechaInicio.selectedDate == null && this.fechaFin.selectedDate != null))
				{
					ZAlerta.show("Si una fecha esta ingresada, entonces es obligatorio registrar las 2");
					datoTiempo = null;
				}
			}
			
			return datoTiempo;
		}
		
		public function validarIngresoFecha(): Boolean
		{
			var esValido: Boolean = false;
			
			var fecha1: Number = fechaInicio.selectedDate.getTime();
			var fecha2: Number = fechaFin.selectedDate.getTime();
			
			if(fecha1 == fecha2)
			{
				esValido = true;
			}
			
			if(fecha1 < fecha2)
			{
				esValido = true;
			}
			
			return esValido;
		}
		
		/*** OTROS METODOS ***/
		private function convertirDateToString(fecha: Date, hora: String): String
		{
			var stringFecha: String = fecha.getDate() + "-" + (fecha.getMonth() + 1) + "-" + fecha.getUTCFullYear() + " " + hora;
			
			return stringFecha;
		}
		
		public function valido():Boolean{
			if (fechaInicio.selectedDate==null){
				return false;
			}
			
			if (fechaFin.selectedDate==null){
				return false;
			}
			
			if (!validarIngresoFecha()){
				return false;
			}
			return true;
		}
		
	}
}