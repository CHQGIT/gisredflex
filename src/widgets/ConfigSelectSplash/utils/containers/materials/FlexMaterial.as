/*
Copyright (c) 2008 Doug McCune

Permission is hereby granted, free of charge, to any person obtaining a copy of this software
and associated documentation files (the “Software”), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT
OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
package widgets.ConfigSelectSplash.utils.containers.materials
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;

	import org.papervision3d.materials.MovieMaterial;

	public class FlexMaterial extends MovieMaterial
	{
		public function FlexMaterial(movieAsset:DisplayObject=null, transparent:Boolean=true)
		{
			if(movieAsset is UIComponent) {
				addUpdateListeners(UIComponent(movieAsset));
			}

			super(movieAsset, transparent, false);
		}

		private function addUpdateListeners(component:UIComponent):void {
			component.addEventListener(FlexEvent.UPDATE_COMPLETE, handleUpdateComplete, false, 10, true);

			if(component is Container) {
				var n:int = Container(component).numChildren;

				for(var i:int=0; i<n; i++) {
					var child:DisplayObject = component.getChildAt(i);

					if(child is UIComponent) {
						addUpdateListeners(UIComponent(child));
					}
				}
			}
		}

		private function handleUpdateComplete(event:Event):void {
			updateBitmap();
		}
	}
}