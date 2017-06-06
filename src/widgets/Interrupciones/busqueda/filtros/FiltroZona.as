package widgets.Interrupciones.busqueda.filtros
{
	import mx.collections.ArrayCollection;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.componentesComunes.ComponenteDosListas;
	import widgets.Interrupciones.componentesComunes.DtoObjetoLista;
	import widgets.Interrupciones.servicios.UtilWhere;
	
	public class FiltroZona extends SkinnableComponent
	{
		[SkinPart]
		public var componenteDosListas:ComponenteDosListas;
		
		public function FiltroZona()
		{
			setStyle("skinClass", FiltroZonaSkin);
		}
		
		override protected function partAdded(partName:String, instance:Object): void{
		}
		
		public function cargarTipos(): void
		{
			var elementos: ArrayCollection = new ArrayCollection;
			var nombreElementos: Array = new Array("San Antonio", "Los Andes", "Marga Marga", "Costa", "Valparaiso", "Quillota");
			
			for(var pos: Number = 0; pos < nombreElementos.length; pos++)
			{
				var dtoObjetoLista: DtoObjetoLista = new DtoObjetoLista;
				dtoObjetoLista.idTipo = (pos + 1);
				dtoObjetoLista.valor = nombreElementos[pos];
				
				elementos.addItem(dtoObjetoLista);
			}
			
			this.componenteDosListas.elementoSeleccionar.dataProvider = elementos;
		}
		
		public function guardarDatoZona(): ArrayCollection
		{
			var elementosSeleccionados: ArrayCollection = this.componenteDosListas.mostrarElementosSeleccionados();
			var datoZona: ArrayCollection = new ArrayCollection;
			
			for(var pos: Number = 0; pos < elementosSeleccionados.length; pos++)
			{
				datoZona.addItem(elementosSeleccionados[pos].valor);
			}
			
			return datoZona;
		}
			
		public function generarWhere_2():String{
			var arregloZona:ArrayCollection=guardarDatoZona();
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
		
		public function generarWhere(zona: ArrayCollection, whereObject: Object): void
		{
			if(zona.length != 0)
			{
				whereObject.stringWhere = UtilWhere.comprobarDatoVacioWhere(whereObject.stringWhere);
				whereObject.stringWhere += UtilWhere.concatenarArrayCollectionEnWhere(zona, "zona");
			}
		}
	}
}