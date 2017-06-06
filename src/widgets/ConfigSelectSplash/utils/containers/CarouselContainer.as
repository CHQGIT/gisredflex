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
package widgets.EMSplash.utils.containers
{
	import caurina.transitions.Tweener;

	import flash.display.DisplayObject;
	import flash.events.Event;

	import mx.core.EdgeMetrics;

	import org.papervision3d.objects.DisplayObject3D;

	public class CarouselContainer extends BasePV3DContainer
	{
		override public function addChild(child:DisplayObject):DisplayObject {
			var child:DisplayObject = super.addChild(child);

			var plane:DisplayObject3D = lookupPlane(child);
			plane.material.doubleSided = true;

			var reflection:DisplayObject3D = lookupReflection(child);
			reflection.material.doubleSided = true;

			return child;
		}


		private var _angle:Number;

		public function set angle(value:Number):void {
			_angle = value;

			moveCamera();
			scene.renderCamera(camera);
		}

		public function get angle():Number {
			return _angle;
		}

		private function moveCamera():void {
			camera.x =  Math.cos(_angle) *(width);
   			camera.z =  Math.sin(_angle) *(width);
		}

		override protected function layoutChildren(unscaledWidth:Number, unscaledHeight:Number):void {
			super.layoutChildren(unscaledWidth, unscaledHeight);

			var numOfItems:int = this.numChildren;

			if(numOfItems == 0) return;

			var radius:Number = unscaledWidth-10;
			var anglePer:Number = (Math.PI*2) / numOfItems;

			for(var i:uint=0; i<numOfItems; i++)
			{
				//var childIndex:int = (selectedIndex + i) % numOfItems;
				var child:DisplayObject = getChildAt(i);

				var p:DisplayObject3D = lookupPlane(child);
				p.container.visible = true;

				var zPosition:Number = Math.sin(i*anglePer) * radius;
				var xPosition:Number = Math.cos(i*anglePer) * radius;
				var yRotation:Number = (-i*anglePer) * (180/Math.PI) + 270;

				p.x = xPosition;
				p.z = zPosition;
				p.rotationY = yRotation;

				if(reflectionEnabled) {
					var reflection:DisplayObject3D = lookupReflection(child);
					reflection.x = xPosition;
					reflection.z = zPosition;
					reflection.y = -child.height - 2;
					reflection.rotationY = yRotation;
				}
			}


			if(selectedChild) {
				var bm:EdgeMetrics = borderMetrics;

				selectedChild.x = unscaledWidth/2 - selectedChild.width/2 - bm.top;
				selectedChild.y = unscaledHeight/2 - selectedChild.height/2 - bm.left;

				selectedChild.visible = false;
			}

			var cameraAngle:Number = anglePer*selectedIndex;

			if(cameraAngle - _angle > Math.PI) {
				_angle += Math.PI*2;
				moveCamera();
			}
			else if(_angle - cameraAngle > Math.PI) {
				_angle -= Math.PI*2;
				moveCamera();
			}

			camera.zoom = 1 + 20/unscaledWidth;
			camera.focus = unscaledWidth/2;

			Tweener.addTween(this, {angle:cameraAngle, time:tweenDuration});

		}

		override protected function enterFrameHandler(event:Event):void {
			try {
				if(Tweener.isTweening(camera)){
					scene.renderCamera(camera);
				}
			}
			catch(e:Error) { }
		}
	}
}