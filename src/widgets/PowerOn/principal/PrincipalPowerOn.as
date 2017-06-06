package widgets.PowerOn.principal
{
	import mx.collections.ArrayCollection;
	import mx.controls.DataGrid;
	import mx.controls.Label;
	import mx.events.FlexEvent;
		
	import spark.components.DropDownList;
	import spark.components.supportClasses.SkinnableComponent;
		
	import comun.principal.IPrincipal;
	import widgets.PowerOn.busqueda.BusquedaCliente;
	import widgets.PowerOn.principal.PrincipalPowerOnSkin;
	
	public class PrincipalPowerOn
	{	/*
		[Bindable]
		private var listaSeleccionado:ArrayCollection;
		
		[Bindable]
		private var dropTipoOrden:ArrayCollection;
		
		[Bindable]
		private var dropEstadoOrden:ArrayCollection;
		
		[Bindable]
		private var dropAfectado:ArrayCollection;
		
		[Bindable]
		private var listaOrdenes:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		private var arr:ArrayCollection = new ArrayCollection();
		
		private var fechaformateada:Date;
		private var clientes_transformador:Number;
		
		[SkinPart(required="true")]
		public var listaOrdenes:ArrayCollection;
		
		[SkinPart(required="true")]
		public var selIndex:Label;
		
		[SkinPart(required="true")]
		public var ddlOrden:DropDownList; 
		
		[SkinPart(required="true")]
		public var ddlEstado:DropDownList;
		
		[SkinPart(required="true")]
		public var ddlAfectado:DropDownList;
		
		public function PrincipalPowerOn()
		{
			setStyle("skinClass", PrincipalPowerOnSkin);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,creationComplete);
		}
		
		public function creationComplete(e:FlexEvent):void{
			init();
		}
		
		private function init():void
		{
			
			dropTipoOrden = new ArrayCollection([
				{label:"Todas...", data: 0},
				{label:"Investigation", data:"investigation"},
				{label:"Restoration", data:"restoration"}, 
				{label:"Switching", data:"switching"}
			]);
			
			dropEstadoOrden = new ArrayCollection([
				{label:"Todas...", data: 0},
				{label:"Arrived", data:"arrived"},
				{label:"Dispatched", data:"dispatched"},
				{label:"En Ruta", data:"en_route"}, 
				{label:"En Progreso", data:"in_progress"},
				{label:"Nueva", data:"new"},
				{label:"Ready", data:"ready"},
				{label:"Suspended", data:"suspended"}
			]);
			
			dropAfectado = new ArrayCollection([
				{label:"Todos...", data: 0},
				{label:"Cliente", data:"Cliente"}, 
				{label:"Transformador", data:"Transformador"},
				{label:"Origen Falla", data:"Origen Falla"}
			]);
	
			Cliente.listarClientes();
			listarTransformadores();				
			
		}*/
	}
}