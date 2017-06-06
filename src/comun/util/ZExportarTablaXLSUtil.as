package comun.util
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	
	import comun.util.zalerta.ZAlerta;
	
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	
	import widgets.Interrupciones.global.Global;

	public class ZExportarTablaXLSUtil
	{
		public var cabeceras:ArrayCollection;
		public var datos:ArrayCollection;
		public var nombreArchivo:String;
		public var grilla:DataGrid;
		
		public function ZExportarTablaXLSUtil( grilla:DataGrid,datos:ArrayCollection,nombreArchivo:String)
		{						
			this.grilla = grilla;
			this.datos = datos;
			this.nombreArchivo = nombreArchivo;
		}
		
		public function obtenerCabeceras():void
		{
			cabeceras = new ArrayCollection;
			for each(var columna:DataGridColumn in grilla.columns)
			{
				cabeceras.addItem(columna.headerText);
			}	
		}

		
		public function generarExcel():void		
		{			
			try
			{
				obtenerCabeceras();				
				
				var sheet: Sheet = new Sheet();				
				sheet.resize(datos.length + 1, cabeceras.length );
				for(var i:int = 0 ; i < cabeceras.length ; i++)
				{
					var cabecera:String = ZStringUtil.reemplazarAcentos(cabeceras[i].toString());					
					sheet.setCell(0, i, cabecera);	
				}							
				
				for(var pos: Number = 1; pos < (datos.length + 1); pos++)
				{
					var fila: ArrayCollection = datos.getItemAt(pos - 1) as ArrayCollection;					
					for(var x:int = 0 ; x < fila.length ; x++)
					{
						var elemento:String = fila[x] != null ? fila[x] .toString() : "";
						sheet.setCell(pos, x , ZStringUtil.reemplazarAcentos(elemento));						
					}					
				}
				
				var xls: ExcelFile = new ExcelFile();
				xls.sheets.addItem(sheet);
				
				var bytes: ByteArray = xls.saveToByteArray();
				var archivoReferencia: FileReference = new FileReference();
				
				archivoReferencia.save(bytes, nombreArchivo + ".xls");				
			}
			catch(e:Error)
			{
				ZAlerta.show(e.message);
				ZAlerta.show(e.getStackTrace());
			}
		}
				
	}
}