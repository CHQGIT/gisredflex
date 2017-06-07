package widgets.Interrupciones.busqueda.resultado.exportarExcel
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import comun.util.ZStringUtil;
	import comun.util.zalerta.ZAlerta;
	
	import widgets.Interrupciones.global.Global;
	import widgets.Interrupciones.servicios.InterrupcionBaseDto;
	import widgets.Interrupciones.servicios.interrupciones.DtoInterrupcion;
	
	public class ExportarExcel
	{
		public function ExportarExcel()
		{
		}
		
		public static function exportar(datos:ArrayCollection, nombreFichero: String):void{
			try
			{
				var resultado:ArrayCollection = datos;
				
				var sheet: Sheet = new Sheet();
				sheet.resize(resultado.length + 1, 3);
				
				
				if (Global.tipoBusquedaCliente()){
					sheet.setCell(0, 0, "Nis");
				}
				else{
					sheet.setCell(0, 0, "SED");
				}
				
				sheet.setCell(0, 1, "Duracion");
				sheet.setCell(0, 2, "Frecuencia");
				
				Global.log("numero de filas en reporte "+datos.length);
				
				for(var pos: Number = 1; pos < (resultado.length + 1); pos++)
				{
					var interrupcionDTO: InterrupcionBaseDto = resultado.getItemAt(pos - 1) as InterrupcionBaseDto;
				
					sheet.setCell(pos, 0, interrupcionDTO.id.toString());
					sheet.setCell(pos, 1, interrupcionDTO.duracionNis.toString());
					sheet.setCell(pos, 2, interrupcionDTO.frecuenciaNis.toString());
				}
				
				var xls: ExcelFile = new ExcelFile();
				xls.sheets.addItem(sheet);
				
				var bytes: ByteArray = xls.saveToByteArray();
				var archivoReferencia: FileReference = new FileReference();
				archivoReferencia.save(bytes, nombreFichero + ".xls");
			}
			catch(e:Error){
				ZAlerta.show(e.message);
				ZAlerta.show(e.getStackTrace());
			}
		}
		
		public static function exportarInterrupcion(datos:ArrayCollection, nombreFichero: String):void{
			try
			{
				var resultado:ArrayCollection = datos;
				
				var sheet: Sheet = new Sheet();
				sheet.resize(resultado.length + 1, 10);
				//04.04.2017 : Agregando dos campos para separar id por tamaño. (Eve)
				sheet.setCell(0, 0, "Interrupcion ID");
				
				sheet.setCell(0, 1, "Interrupcion ID");
				sheet.setCell(0, 2, "Bloque");
				sheet.setCell(0, 3, "Clientes Afectados");
				sheet.setCell(0, 4, "Duracion");
				sheet.setCell(0, 5, "Alimentador");
				sheet.setCell(0, 6, "SSEE");
				sheet.setCell(0, 7, "Clasificacion 1");
				sheet.setCell(0, 8, "Clasificacion 2");
				sheet.setCell(0, 9, "Clasificacion 3");
				sheet.setCell(0, 10, "Transformador");
				var s = new Array();
				s.push("","Interrupcion,Bloque,Clientes Afectados,Duracion,Alimentador,SSEE,Clasificacion 1,Clasificacion 2,Clasificacion 3,Transformador\n");
				Global.log("numero de filas en reporte "+datos.length);
				for(var pos: Number = 1; pos < (resultado.length + 1); pos++)
				{
					//04.04.2017 : Separando campo ID por tamaño. (Eve)
					var dtoInterrupcion: DtoInterrupcion = resultado.getItemAt(pos - 1) as DtoInterrupcion;
					var myString:String = new String(dtoInterrupcion.idInterrupcion);
					var halfLeft:String;
					var halfRight:String;
					var myStringLength:int;
					var theRestLength:int;
					myStringLength = dtoInterrupcion.idInterrupcion.length;
					halfLeft = dtoInterrupcion.idInterrupcion.substring(0,Math.round(myStringLength/2));
					theRestLength= myStringLength - Math.round(myStringLength/2);
					halfRight = dtoInterrupcion.idInterrupcion.substring(theRestLength,myStringLength);
					//04.04.2017 : Agregando dos filas debido al tamaño del campo ID. (Eve)
					/*sheet.setCell(pos, 0, halfLeft);
					sheet.setCell(pos, 1, halfRight);
					sheet.setCell(pos, 2, dtoInterrupcion.bloque);
					sheet.setCell(pos, 3, dtoInterrupcion.afectados);
					sheet.setCell(pos, 4, ""+dtoInterrupcion.duracion);
					sheet.setCell(pos, 5, ZStringUtil.reemplazarAcentos(dtoInterrupcion.alimentador));
					sheet.setCell(pos, 6, ZStringUtil.reemplazarAcentos(dtoInterrupcion.ssee));
					sheet.setCell(pos, 7, ZStringUtil.reemplazarAcentos(dtoInterrupcion.causa1));
					sheet.setCell(pos, 8, ZStringUtil.reemplazarAcentos(dtoInterrupcion.causa2));
					sheet.setCell(pos, 9, ZStringUtil.reemplazarAcentos(dtoInterrupcion.causa3));
					sheet.setCell(pos, 10, dtoInterrupcion.transformadoresInterrumpidos);
					*/
					
					//10.04.2017: exportar a txt
					s.push(halfLeft+halfRight+","+dtoInterrupcion.bloque+","
						+dtoInterrupcion.afectados+","+
						dtoInterrupcion.duracion+","+
						ZStringUtil.reemplazarAcentos(dtoInterrupcion.alimentador)+","+
						ZStringUtil.reemplazarAcentos(dtoInterrupcion.ssee)+","+
						ZStringUtil.reemplazarAcentos(dtoInterrupcion.causa1)+","+
						ZStringUtil.reemplazarAcentos(dtoInterrupcion.causa2)+","+
						ZStringUtil.reemplazarAcentos(dtoInterrupcion.causa3)+","+
						dtoInterrupcion.transformadoresInterrumpidos+"\n");
					
					
				}
				//10.04.2017: exportar a txt
				var fr = new FileReference();
				fr.save(s,"interrupciones.csv");
				
				
				
			}
			catch(e:Error){
				ZAlerta.show(e.message);
				ZAlerta.show(e.getStackTrace());
			}
		}
	}
}