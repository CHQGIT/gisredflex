package widgets.Interrupciones.wizard.pasos
{
	import spark.components.Label;
	import spark.components.supportClasses.SkinnableComponent;
	
	import widgets.Interrupciones.busqueda.resultado.porClienteSED.InterrupcionesPorClienteSED;
	import widgets.Interrupciones.principal.Principal;
	import widgets.Interrupciones.servicios.interrupciones.DtoInterrupcion;

	public class PasoResultadoInterrupciones extends SkinnableComponent
	{
		[SkinPart (required="true")]
		public var interrupciones:InterrupcionesPorClienteSED;
		
		public var principal:Principal;
		
		[SkinPart (required="true")]
		public var labelInterrupcion:Label;
		
		[SkinPart (required="true")]
		public var labelBloque:Label;
		
		[SkinPart (required="true")]
		public var labelClientesAfectados:Label;
		
		[SkinPart (required="true")]
		public var labelDuracion:Label;
		
		[SkinPart (required="true")]
		public var labelAlimentador:Label;
		
		[SkinPart (required="true")]
		public var labelSSEE:Label;
		
		[SkinPart (required="true")]
		public var labelClasificacion1:Label;
		
		[SkinPart (required="true")]
		public var labelClasificacion2:Label;
		
		[SkinPart (required="true")]
		public var labelClasificacion3:Label;
		
		[SkinPart (required="true")]
		public var labelTransformador:Label;
		
		public function PasoResultadoInterrupciones()
		{
			setStyle("skinClass",SkinPasoResultadoInterrupciones);
		}
		
		override protected function partAdded(partName:String,instance:Object):void{
			if(instance == interrupciones)
			{
				interrupciones.comboZona.visible=false;
				
				interrupciones.botonVerDuracion.label="Ver";
				interrupciones.botonVerDuracionAgrupado.label="Ver Agrupado";
				
				interrupciones.botonVerFrecuencia.visible=false;
				interrupciones.botonVerFrecuencia.height=0;
				interrupciones.botonVerFrecuenciaAgrupado.visible=false;
				interrupciones.botonVerFrecuenciaAgrupado.height=0;
				
				interrupciones.botonVerInterrupcion.visible=false;
				
				interrupciones.columnaFrecuencia.visible=false;
				interrupciones.columnaDuracion.visible=false;
				
				interrupciones.width=interrupciones.width*0.8;
			}
		}
		
		public function mostrarInterrupcionSeleccionada(dtoInterrupcion:DtoInterrupcion):void{
			labelInterrupcion.text=""+dtoInterrupcion.idInterrupcion;
			labelBloque.text=dtoInterrupcion.bloque;
			labelClientesAfectados.text=""+dtoInterrupcion.afectados;
			labelDuracion.text=""+dtoInterrupcion.duracion;
			labelAlimentador.text=dtoInterrupcion.alimentador;
			labelSSEE.text=dtoInterrupcion.ssee;
			labelClasificacion1.text=dtoInterrupcion.causa1;
			labelClasificacion2.text=dtoInterrupcion.causa2;
			labelClasificacion3.text=dtoInterrupcion.causa3;
			labelTransformador.text=""+dtoInterrupcion.transformadoresInterrumpidos;
		}
		
		public function limpiarResultados():void
		{
			labelInterrupcion.text="";
			labelBloque.text="";
			labelClientesAfectados.text="";
			labelDuracion.text="";
			labelAlimentador.text="";
			labelSSEE.text="";
			labelClasificacion1.text="";
			labelClasificacion2.text="";
			labelClasificacion3.text="";
			labelTransformador.text="";
			interrupciones.limpiarResultados();
		}
	}
}