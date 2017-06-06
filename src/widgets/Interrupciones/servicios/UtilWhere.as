package widgets.Interrupciones.servicios
{
	import mx.collections.ArrayCollection;

	public class UtilWhere
	{
		public function UtilWhere()
		{
		}
		
		public static function whereZona(arregloZona:ArrayCollection):String{
			var where:String="";
			
			for (var i:Number=0;i<arregloZona.length;i++){
				var prefijo:String=" or ";
				if (i==0){
					prefijo="";
				}
				
				where+= prefijo+" zona='"+arregloZona[i]+"' ";	
			}
			return where;
		}
		
		public static function comprobarDatoVacioWhere(valorWhere: String): String
		{
			if(valorWhere != "")
			{
				valorWhere += " and ";
			}
			
			return valorWhere;
		}
		
		public static function concatenarArrayCollectionEnWhere(dato: ArrayCollection, nombreColumna: String): String
		{
			var cadenaString: String = "";
			
			for(var pos: Number = 0; pos < dato.length; pos++)
			{
				var prefijo: String = " or ";
				
				if(pos == 0)
				{
					prefijo = "(";
				}
				
				cadenaString += prefijo + nombreColumna + " = '" + dato[pos] + "'"; 
				
				if(pos == (dato.length - 1))
				{
					cadenaString += ")";
				}
			}
			
			return cadenaString;
		}
		
		public static function periodoAWhere(periodoFecha:ArrayCollection):String{
			if (periodoFecha==null){
				return null;
			}
			
			if (periodoFecha.length!=2){
				return null;
			}
			
			return " (fecha_inicio between '" + periodoFecha[0] + "' and '" + periodoFecha[1] + "')";
		}
		
		
		public static function periodoAWhereInterrupcion(periodoFecha:ArrayCollection):String{
			if (periodoFecha==null){
				return null;
			}
			
			if (periodoFecha.length!=2){
				return null;
			}
			
			return " (fh_inicio_interrupcion  between '" + periodoFecha[0] + "' and '" + periodoFecha[1] + "')";
		}

		
		public static function zonaAWhere(listaZona:ArrayCollection):String{
			if (listaZona==null){
				return null;
			}
			
			if (listaZona.length==0){
				return null;
			}
			
			var where:String=" zona in (";
			
			for (var i:Number=0;i<listaZona.length;i++){
				var prefijo:String=",";
				if (i==0){
					prefijo="";
				}
				where+=prefijo+"'"+listaZona[i]+"'";
			}
			
			where+=")";
			
			return where;
		}
		
		public static function sseeAWhere(arraySSEE: ArrayCollection):String
		{	
			if(arraySSEE.length == 0)
			{
				return null;
			}
			
			var where: String = " ssee in (";
			
			for(var pos: Number = 0; pos < arraySSEE.length; pos++)
			{
				var prefijo: String = ",";
				
				if(pos == 0)
				{
					prefijo = "";
				}
				
				where += prefijo + "'" + arraySSEE[pos].valor + "'";
			}
			
			where += ")";
			
			return where;
		}
		
		public static function comunaWhere(arrayComuna: ArrayCollection):String
		{
			if(arrayComuna.length == 0)
			{
				return null;
			}
			
			var where: String = " comuna in (";
			
			for(var pos: Number = 0; pos < arrayComuna.length; pos++)
			{
				var prefijo: String = ",";
				
				if(pos == 0)
				{
					prefijo = "";
				}
				
				where += prefijo + "'" + arrayComuna[pos].valor + "'";
			}
			
			where += ")";
			
			return where;
		}
		
		public static function alimentadorWhere(arrayAlimentador: ArrayCollection):String
		{
			if(arrayAlimentador.length == 0)
			{
				return null;
			}
			
			var where: String = " alimentador in (";
			
			for(var pos: Number = 0; pos < arrayAlimentador.length; pos++)
			{
				var prefijo: String = ",";
				
				if(pos == 0)
				{
					prefijo = "";
				}
				
				where += prefijo + "'" + arrayAlimentador[pos].valor + "'";
			}
			
			where += ")";
			
			return where;
		}
		
		public static function concatenaCondiciones(condiciones:ArrayCollection):String{
			
			var where:String="";
			for (var i:Number=0;i<condiciones.length;i++){
				var prefijo:String=" and ";
				if (i==0){
					prefijo="";
				}
				where+=prefijo+" "+condiciones[i]+" ";
			}
			return where;
		}
		
		public static function idInterrupcionAWhere(idInterrupciones: ArrayCollection):String
		{	
			if(idInterrupciones.length == 0)
			{
				return null;
			}
			
			var where: String = "interrupcion_id in (";
			
			for(var pos: Number = 0; pos < idInterrupciones.length; pos++)
			{
				var prefijo: String = ",";
				
				if(pos == 0)
				{
					prefijo = "";
				}
				
				where += prefijo + "'" + idInterrupciones.getItemAt(pos)+ "'";
			}
			
			where += ")";
			
			return where;
		}
	}
}