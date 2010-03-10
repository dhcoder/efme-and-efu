package efme.core.graphics2d.support 
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * A "draw state" is a representation of the current rendering environement.
	 * 
	 * <p> Say you want to render an image at x=100, y=100, rotated 45 degrees.
	 * If your draw state is set to x=300,y=-50, rotated 10 degrees, then your
	 * final image will be drawn at 400, 50, rotated at 55 degrees.
	 * 
	 * <p> To update a draw state, call one of the <code>pushXXX(...)</code>
	 * functions. Be sure to call a matching <code>popXXX()</code> call when
	 * done drawing!
	 */
	public class DrawState
	{
		public function DrawState() 
		{
			_offsetStack = new Vector.<Point>();
			_colorStack = new Vector.<uint>();
			_alphaStack = new Vector.<Number>();
			_matrixStack = new Vector.<Matrix>();
			
			_offsetStack.push(new Point(0, 0));
			_colorStack.push(0xFFFFFF);
			_alphaStack.push(1.0);
			_matrixStack.push(new Matrix());
		}
		
		public function get offset():Point { return _offsetStack[_offsetStack.length - 1]; }
		public function get color():uint { return _colorStack[_colorStack.length - 1]; }
		public function get alpha():Number { return _alphaStack[_alphaStack.length - 1]; }
		public function get matrix():Matrix { return _matrixStack[_matrixStack.length - 1]; }
		
		public function get inMatrixMode():Boolean { return _matrixStack.length > 1; }
		
		public function pushOffset(offset:Point):void
		{
			var offsetPrev:Point = this.offset;
			offset.x += offsetPrev.x;
			offset.y += offsetPrev.y;

			_offsetStack.push(offset);
		}
		
		public function pushColor(color:uint, alpha:Number):void
		{
			var colorPrev:uint = this.color;
			var alphaPrev:Number = this.alpha;
			
			color = Color.blendColors(color, colorPrev);
			alpha *= alphaPrev;
			
			_colorStack.push(color);
			_alphaStack.push(alpha);
		}
		
		public function pushTSR(translate:Point, scaleX:Number = 1.0, scaleY:Number = 1.0, rotation:Number = 0.0, rotationAnchor:int = Anchor.MIDDLE, rotationWidth:Number = 0.0, rotationHeight:Number = 0.0):void
		{
			rotation = DrawOptions.normalizeRotation(rotation);
			if (inMatrixMode || scaleX != 1.0 || scaleY != 1.0 || rotation != 0.0)
			{
				var matrix:Matrix = new Matrix();
				
				if (rotation != 0.0)
				{
					var rotationPoint:Point = Anchor.getAnchorPoint(new Rectangle(0,0,rotationWidth,rotationHeight), rotationAnchor);
					matrix.translate(-rotationPoint.x, -rotationPoint.y);
					matrix.rotate(rotation * DEG_TO_RAD)
					matrix.translate(rotationPoint.x, rotationPoint.y);
				}

				//
				// Handle scale and translation
				//
				
				matrix.scale(scaleX, scaleY);
				matrix.translate(translate.x, translate.y);

				if (!inMatrixMode)
				{
					// We're just about to switch over from offset mode to
					// matrix mode. Convert over to the new system.
					matrix.translate(offset.x, offset.y);
				}

				
				matrix.concat(this.matrix);

				
				
				_matrixStack.push(matrix);
			}
			else
			{
				pushOffset(translate);
			}
		}
		
		public function pushDrawOptions(drawArea:Rectangle, drawOptions:DrawOptions):void
		{
			pushColor(drawOptions.blendColor, drawOptions.alpha);
			pushTSR(drawArea.topLeft, drawOptions.scaleX, drawOptions.scaleY, drawOptions.rotation, drawOptions.rotationAnchor, drawArea.width, drawArea.height);
		}
		
		public function popOffset():void
		{
			if (_offsetStack.length > 1)
			{
				_offsetStack.pop();
			}
			else
			{
				throw _popMismatchError;
			}
		}
		
		public function popColor():void
		{
			if (_colorStack.length > 1)
			{
				_colorStack.pop();
				_alphaStack.pop();
			}
			else
			{
				throw _popMismatchError;
			}
		}
		
		public function popTSR():void
		{
			if (inMatrixMode)
			{
				if (_matrixStack.length > 1)
				{
					_matrixStack.pop();
				}
				else
				{
					throw _popMismatchError;
				}
			}
			else
			{
				if (_offsetStack.length > 1)
				{
					_offsetStack.pop();
				}
				else
				{
					throw _popMismatchError;
				}
			}
		}

		public function popDrawOptions():void
		{
			popColor();
			popTSR();
		}

		/**
		 * Constant to convert from degrees (our unit of preference) to radians
		 * (Flash's unit of preference);
		 */
		private static const DEG_TO_RAD:Number = Math.PI / 180.0;

		
		private static var _popMismatchError:Error = new Error("Extra, unmatched pop() called.");
		
		private var _offsetStack:Vector.<Point>;
		private var _colorStack:Vector.<uint>;
		private var _alphaStack:Vector.<Number>;

		private var _matrixStack:Vector.<Matrix>;
		
	}

}