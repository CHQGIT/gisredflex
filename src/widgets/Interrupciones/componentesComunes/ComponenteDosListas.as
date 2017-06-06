package widgets.Interrupciones.componentesComunes
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.utils.ObjectUtil;
	
	import spark.components.Button;
	import spark.components.Label;
	import spark.components.List;
	import spark.components.supportClasses.SkinnableComponent;
	
	import comun.util.zalerta.ZAlerta;
	
	public class ComponenteDosListas extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var elementoSeleccionar:List;
		
		[SkinPart(required="true")]
		public var elementosSeleccionados:List;
		
		[SkinPart(required="true")]
		public var agregar:Button;
		
		[SkinPart(required="true")]
		public var agregartodo:Button;
		
		[SkinPart(required="true")]
		public var eliminar:Button;
		
		[SkinPart(required="true")]
		public var eliminartodo:Button;
		
		[SkinPart(required="true")]
		public var mensajeValidacion:Label;
		
		public var elementosSeleccionadosALVacia:ArrayList;
		public var funcionEvaluar:Function;
		
		public function ComponenteDosListas()
		{
			super();
			setStyle("skinClass",SkinDosListas);
		}
		
		override protected function partAdded(partName:String, instance:Object):void { 
			
			super.partAdded(partName, instance); 
			
			if(instance == agregar){
				agregar.addEventListener("click",eventoAgregar);
			}
			
			if(instance == agregartodo){
				agregartodo.addEventListener("click" ,funccopiartodo);
			}
			
			if(instance == eliminar){
				eliminar.addEventListener("click",eventoEliminar);
			}
			
			if(instance == eliminartodo){
				eliminartodo.addEventListener("click",funceliminartodotodo);
			}
			
			if (instance==elementoSeleccionar){
				elementoSeleccionar.addEventListener(MouseEvent.DOUBLE_CLICK,eventoAgregar);
			}
			
			if (instance==elementosSeleccionados){
				elementosSeleccionados.addEventListener(MouseEvent.DOUBLE_CLICK,eventoEliminar);
			}
		}
		
		public function dobleClickSeleccionar(e:MouseEvent):void{
			
		}
		
		public function funccopiartodo(event:Event):void{
			var lista:ArrayCollection = new ArrayCollection;
			if(elementosSeleccionados.dataProvider != null){
				lista = elementosSeleccionados.dataProvider as ArrayCollection;
			}
			
			for each(var obj:DtoObjetoLista in elementoSeleccionar.dataProvider as ArrayCollection){
				var noExiste:Boolean = true;
				for each(var o:DtoObjetoLista in lista){
					if(o.idTipo == obj.idTipo){
						noExiste = false;	
					}
				}
				if(noExiste){
					lista.addItem(obj);
				}
			}
			
			elementosSeleccionados.dataProvider = ObjectUtil.copy(lista) as ArrayCollection;
			evaluar(true);
		}
		
		public function mostrarElementosSeleccionados(): ArrayCollection
		{
			var arrayElementosSeleccionados: ArrayCollection = new ArrayCollection;
			var auxElementosSeleccionados: ArrayCollection = this.elementosSeleccionados.dataProvider as ArrayCollection;
			
			if(auxElementosSeleccionados != null)
			{
				arrayElementosSeleccionados = auxElementosSeleccionados;
			}
			
			return arrayElementosSeleccionados;
		}
		
		public function funceliminartodotodo(event:Event):void{
			elementosSeleccionados.dataProvider = ObjectUtil.copy(elementosSeleccionadosALVacia) as ArrayCollection;
			if(funcionEvaluar != null){
				
			}
			evaluar(false);
			
		}	
		
		public function eventoAgregar(e:Event):void{
			if(elementoSeleccionar.selectedIndex == -1){
				ZAlerta.show("Debe seleccionar un elemento de la lista","Información");
				return;
			}
			
			var seleccionado:DtoObjetoLista = elementoSeleccionar.selectedItem as DtoObjetoLista;
			
			if(elementosSeleccionados.dataProvider == null){
				elementosSeleccionados.dataProvider = new ArrayCollection;
			}
			
			if(seleccionado != null && !validar(seleccionado)){
				elementosSeleccionados.dataProvider.addItem(seleccionado);
			}
			evaluar(true);
		}
		
		public function eventoEliminar(e:Event):void{
			if(elementosSeleccionados.selectedIndex == -1){
				ZAlerta.show("Debe seleccionar un elemento de la lista","Información");
				return;
			}
			var seleccionado:DtoObjetoLista = elementosSeleccionados.selectedItem as DtoObjetoLista;
			
			if(elementosSeleccionados.dataProvider != null){
				var index:int = elementosSeleccionados.dataProvider.getItemIndex(seleccionado);
				if(index != -1){
					elementosSeleccionados.dataProvider.removeItemAt(index);				
				}			
			}
			
			evaluar(false);
		}
		
		public function validar(objeto:DtoObjetoLista):Boolean{
			var lista:ArrayCollection = new ArrayCollection;
			lista = elementosSeleccionados.dataProvider as ArrayCollection;
			for each(var o:DtoObjetoLista in lista){
				if(o.idTipo == objeto.idTipo){
					return true;
				}
			}
			return false;
		}
		
		public function validarVacios(textoValidacion:String = ""):Boolean{
			var validadorComunasVacios:Boolean = false;
			var listaSeleccion:ArrayCollection = elementosSeleccionados.dataProvider as ArrayCollection;
			
			if(listaSeleccion== null || listaSeleccion.length <= 0){
				mensajeValidacion.includeInLayout = true;
				mensajeValidacion.visible = true;
				mensajeValidacion.text = textoValidacion == "" ? "Campo Obligatorio" : textoValidacion;
				return true;
			}else{
				mensajeValidacion.includeInLayout = false;
				mensajeValidacion.visible = false;
				return false;
			}
		}
		
		public function limpiar():void{
			mensajeValidacion.visible = false;
			mensajeValidacion.includeInLayout = false;
		}
		
		public function evaluar(v:Boolean):void{
			if(funcionEvaluar != null){
				funcionEvaluar(v);
			}
		}
		
		public function existenElementosPorSeleccionar():Boolean{
			var listaPorSeleccionar:ArrayCollection = this.elementoSeleccionar.dataProvider as ArrayCollection;
			
			if (listaPorSeleccionar==null)
				return false;
			if (listaPorSeleccionar.length==0)
				return false;
			return true;
		}
	}
}