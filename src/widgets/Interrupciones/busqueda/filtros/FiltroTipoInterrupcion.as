package widgets.Interrupciones.busqueda.filtros
{
	import mx.collections.ArrayCollection;
	
	import spark.components.CheckBox;
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.servicios.UtilWhere;

	public class FiltroTipoInterrupcion extends SkinnableComponent
	{
		[SkinPart]
		public var interrupcion1: CheckBox;
		[SkinPart]
		public var interrupcion2: CheckBox;
		
		public function FiltroTipoInterrupcion()
		{
			setStyle("skinClass", FiltroTipoInterrupcionSkin);
		}
		
		public function guardarDatoTipoInterrupcion(): ArrayCollection
		{
			var datoTipoInterrupcion: ArrayCollection = new ArrayCollection;
			
			if(this.interrupcion1.selected)
			{
				datoTipoInterrupcion.addItem(interrupcion1.label.toUpperCase());
			}
			
			if(this.interrupcion2.selected)
			{
				datoTipoInterrupcion.addItem(interrupcion2.label.toUpperCase());
			}
			
			return datoTipoInterrupcion;
		}
		
		public function generarWhere(tipoInterrupcion: ArrayCollection, whereObject: Object): void
		{
			if(tipoInterrupcion.length != 0)
			{
				whereObject.stringWhere = UtilWhere.comprobarDatoVacioWhere(whereObject.stringWhere);
				whereObject.stringWhere += UtilWhere.concatenarArrayCollectionEnWhere(tipoInterrupcion, "tipo_interrupcion");
			}
		}
	}
}