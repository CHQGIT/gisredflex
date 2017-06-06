package widgets.Interrupciones.busqueda
{
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Button;
	import spark.components.DropDownList;
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.global.Global;

	public class MenuPrincipal extends SkinnableComponent
	{
		[SkinPart]
		public var ingresaFormularioBtn: Button;
		[SkinPart]
		public var listaFormularios: DropDownList;
		
		public var elementosFormularios: ArrayCollection;
		
		public function MenuPrincipal()
		{
			setStyle("skinClass", MenuPrincipalSkin);
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if(instance == ingresaFormularioBtn)
			{
				ingresaFormularioBtn.addEventListener(MouseEvent.CLICK, ingresaFormulario_clickHandler);
			}
			
			if(instance == listaFormularios)
			{
				elementosFormularios = new ArrayCollection;
				
				elementosFormularios.addItem("Interrupciones");
				elementosFormularios.addItem("Clientes Sed");
				
				listaFormularios.dataProvider = elementosFormularios;
			}
		}
		
		protected function ingresaFormulario_clickHandler(event: MouseEvent): void
		{			
			var elementoSeleccionado: String = "" + elementosFormularios.getItemAt(listaFormularios.selectedIndex);
			
			if(elementoSeleccionado.toLowerCase() == "interrupciones")
			{
				Global.principal.mostrarFiltros();
			}
			else if(elementoSeleccionado.toLowerCase() == "clientes sed")
			{
				Global.principal.mostrarFormBusquedaClienteSed(); 
			}
		}
	}
}