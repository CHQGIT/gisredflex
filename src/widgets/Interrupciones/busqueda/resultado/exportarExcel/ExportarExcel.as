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
				
				var s: Sheet = new Sheet();
				s.resize(resultado.length + 1, 10);
				
				s.setCell(0, 0, "Interrupcion");
				s.setCell(0, 1, "Bloque");
				s.setCell(0, 2, "Clientes Afectados");
				s.setCell(0, 3, "Duracion");
				s.setCell(0, 4, "Alimentador");
				s.setCell(0, 5, "SSEE");
				s.setCell(0, 6, "Clasificacion 1");
				s.setCell(0, 7, "Clasificacion 2");
				s.setCell(0, 8, "Clasificacion 3");
				s.setCell(0, 9, "Transformador");
				
				Global.log("numero de filas en reporte "+datos.length);
				
				for(var pos: Number = 1; pos < (resultado.length + 1); pos++)
				{
					var dtoInterrupcion: DtoInterrupcion = resultado.getItemAt(pos - 1) as DtoInterrupcion;
					
					ZAlerta.show(dtoInterrupcion.idInterrupcion);
					
					s.setCell(pos, 0, dtoInterrupcion.idInterrupcion);
					s.setCell(pos, 1, dtoInterrupcion.bloque);
					s.setCell(pos, 2, dtoInterrupcion.afectados);
					s.setCell(pos, 3, ""+dtoInterrupcion.duracion);
					s.setCell(pos, 4, ZStringUtil.reemplazarAcentos(dtoInterrupcion.alimentador));
					s.setCell(pos, 5, ZStringUtil.reemplazarAcentos(dtoInterrupcion.ssee));
					s.setCell(pos, 6, ZStringUtil.reemplazarAcentos(dtoInterrupcion.causa1));
					s.setCell(pos, 7, ZStringUtil.reemplazarAcentos(dtoInterrupcion.causa2));
					s.setCell(pos, 8, ZStringUtil.reemplazarAcentos(dtoInterrupcion.causa3));
					s.setCell(pos, 9, dtoInterrupcion.transformadoresInterrumpidos);
				}
				
				var xls: ExcelFile = new ExcelFile();
				xls.sheets.addItem(s);
				
				var bytes: ByteArray = xls.saveToByteArray();
				var archivoReferencia: FileReference = new FileReference();
				
				archivoReferencia.save(bytes, nombreFichero + ".xls");
				
			}
			catch(e:Error){
				ZAlerta.show(e.message);
				ZAlerta.show(e.getStackTrace());
			}
		}
	}
}