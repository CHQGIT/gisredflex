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
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class ReflectionFlexMaterial extends FlexMaterial
	{
		public function ReflectionFlexMaterial(movieAsset:DisplayObject=null, transparent:Boolean=true)
		{
			super(movieAsset, transparent);
		}

		override public function drawBitmap():void {

			var mtx:Matrix = new Matrix();
			mtx.scale( movie.scaleX, -movie.scaleY );
			mtx.translate(0, movie.height);

			bitmap.draw( movie, mtx, movie.transform.colorTransform, BlendMode.LAYER );

			var sprite:Sprite = new Sprite();

			var alphas:Array = [0, .2];
			var ratios:Array = [150, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(bitmap.width, bitmap.height, Math.PI/2, 0, 0);

			sprite.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], alphas, ratios, matr);
			sprite.graphics.drawRect(0,0,bitmap.width,bitmap.height);

			bitmap.draw(sprite, mtx, null, BlendMode.ALPHA);
		}

	}
}