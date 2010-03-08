﻿package efme.core.graphics2d 
{
	import efme.core.graphics2d.Screen;
	import efme.core.graphics2d.support.Anchor;
	import efme.core.graphics2d.support.Color;
	import efme.core.graphics2d.support.DrawOptions;
	import efme.core.graphics2d.support.DrawState;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.AsyncErrorEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	/**
	 * A class which references image data and can render it.
	 * 
	 * <p> The class handles both regular and tiled images. By specifying a
	 * size in the constructor, you are setting an explicit tile size.
	 * 
	 * <p> A call to <code>draw(screen, ...)</code> will draw the whole image,
	 * regardless if it's tiled or not. Meanwhile, a call to 
	 * <code>drawTile(screen, tileX, tileY, ...)</code> will draw a particular
	 * tile (or nothing if not tiled).
	 * 
	 * <p> Additionally, if you need more advanced rendering features, like
	 * scaling, rotation, and color-blending, you can pass in an optional
	 * <code>DrawOptions</code> argument, which contains your additional 
	 * rendering requirements. Be aware that making these calls with the extra
	 * draw options are more expensive.
	 * 
	 * @see DrawOptions
	 */
	public class Image
	{
		/**
		 * The rendering anchor used when drawing images.
		 * 
		 * <p> When you make a call to draw an image at some (X, Y), the
		 * image is drawn so that the anchor is at that point.
		 * 
		 * <p> Common values for this are <code>Anchor.TOP_LEFT</code>
		 * (this is the common behavior of most 2D rendering libraries) and 
		 * <code>Anchor.MIDDLE</code> (image centered around X/Y).
		 * 
		 * @default Anchor.TOP_LEFT
		 */
		public static function get renderAnchor():int { return _renderAnchor; }
		public static function set renderAnchor(value:int):void { _renderAnchor = value; }

		public static function get drawState():DrawState { return _drawState; }
		
		/**
		 * Update the draw state for all Images.
		 * 
		 * <p> If a draw state is set, it affects all subsequent 
		 * <code>drawXXX(...)</code> calls. For example, if a draw state is set
		 * to X=100, y=300, rotate=45, then a call to 
		 * <code>draw(...)</code> at X=10, Y=10, rotate=100 will *actually*
		 * draw the image at X=110, y=310, rotate=145.
		 * 
		 * <p> This functionality is used so you can group images in a
		 * hierarchy, where the parent specifies some global 
		 * position/color/rotation settings, and the child images are
		 * influenced by it.
		 * 
		 * @param offset
		 * @param drawOptions
		 * 
		 * @see popDrawState
		public static function pushDrawState(area:Rectangle, color:uint, alpha:Number, rotate:Number, rotateAnchor:uint):void
		{
			var matrixAppend:Matrix = new Matrix();
			
			var rotateAnchorPoint:Point = Anchor.getAnchorPoint(Rectangle, rotateAnchor);
			matrixAppend.translate( -rotateAnchorPoint.x, -rotateAnchorPoint.y );
			matrixAppend.rotate(rotate * DEG_TO_RAD);
			matrixAppend.translate( -rotateAnchorPoint.x, -rotateAnchorPoint.y );

			matrixAppend.translate(offset.x, offset.y);
			
			var colorAppend:uint = color;
			var alphaAppend:Number = alpha;
			
			if (_stackSize == 0)
			{
				_matrixStack = new Vector.<Matrix>(0);
				_colorStack = new Vector.<uint>(0);
				_alphaStack = new Vector.<Number>(0);
			}
			else
			{
				matrixAppend.concat(_matrixStack[_stackSize - 1]);
				colorAppend = 0xFFFFFF;
				alphaAppend *= _alphaStack[_stackSize - 1];
			}

			_matrixStack.push(matrixAppend);
			_colorStack.push(colorAppend);
			_alphaStack.push(alphaAppend);

			++_stackSize;
			
		}
		
		public static function popDrawState():void
		{
			if (_stackSize == 0)
			{
				throw new Error("Calling Image.popDrawState() when there's no draw state set.");
			}
			
			_matrixStack.pop();
			_colorStack.pop();
			_alphaStack.pop();
			
			--_stackSize;
			
			if (_stackSize == 0)
			{
				_matrixStack = null;
				_colorStack = null;
				_alphaStack = null;
			}
		}
		*/
		
		/**
		 * Initialize your image. Specify a tile width and height if the image
		 * is divided into a grid.
		 * 
		 * @param bitmapData
		 * @param tileWidth
		 * @param tileHeight
		 */
		public function Image(tileWidth:uint = 0, tileHeight:uint = 0, bitmapData:BitmapData = null)
		{
			_tileWidth = tileWidth;
			_tileHeight = tileHeight;
			_bitmapData = bitmapData;
		}

		/**
		 * The height of the image.
		 */
		public function get height():uint { return (_bitmapData != null ? _bitmapData.height : 0); }

		/**
		 * The width of the image.
		 */
		public function get width():uint { return (_bitmapData != null ? _bitmapData.width : 0); }

		/**
		 * If this image is tiled, this is the width of each cell. Will be
		 * 0 if not tiled.
		 */
		public function get tileWidth():uint { return _tileWidth; }
		public function set tileWidth(value:uint):void { _tileWidth = value; }

		/**
		 * If this image is tiled, this is the height of each cell. Will be
		 * 0 if not tiled.
		 */
		public function get tileHeight():uint { return _tileHeight; }
		public function set tileHeight(value:uint):void { _tileHeight = value; }

		/**
		 * This property is provided for convenience, and it gets the number
		 * of tiles in this image's X direction.
		 * 
		 * <p> If you call this on an untiled Image, it will return 0.
		 */
		public function get numTilesX():uint { return (_bitmapData != null ? _bitmapData.width / _tileWidth : 0); }

		/**
		 * This property is provided for convenience, and it gets the number
		 * of tiles in this image's Y direction.
		 * 
		 * <p> If you call this on an untiled Image, it will return 0.
		 */
		public function get numTilesY():uint { return (_bitmapData != null ? _bitmapData.height / _tileHeight : 0); }

		/**
		 * The inner bitmap data for this image. Don't access this unless you
		 * know what you're doing!!
		 */
		public function get bitmapData():BitmapData { return _bitmapData; }
		public function set bitmapData(value:BitmapData):void { _bitmapData = value; }

		/**
		 * Draw this image onto the screen in its entirety.
		 * 
		 * @param screen Target screen to render to
		 * @param destPoint Target point to render at
		 * @param drawOptions Additional render options, if needed (default = null)
		 */
		public function draw(screen:Screen, destPoint:Point, drawOptions:DrawOptions = null):void
		{
			if (_bitmapData != null)
			{
				drawInternal(screen, new Rectangle(0, 0, _bitmapData.width, _bitmapData.height), destPoint, drawOptions);
			}
		}
		
		/**
		 * Draw a subportion of this image onto the screen.
		 * 
		 * @param screen Target screen to render to
		 * @param sourceRect Rectangular subportion of this image to draw
		 * @param destPoint Target point to render at
		 * @param drawOptions Additional render options, if needed (default = null)
		 */
		public function drawSub(screen:Screen, sourceRect:Rectangle, destPoint:Point, drawOptions:DrawOptions = null):void
		{
			drawInternal(screen, sourceRect, destPoint, drawOptions);
		}
		
		/**
		 * Draw a tile from within this tiled image. If this is not a tiled
		 * image, then calling this function generates an error.
		 * 
		 * @param screen Target screen to render to
		 * @param tileX The X-index of the tile to render
		 * @param tileY The Y-index of the tile to render
		 * @param destPoint Target point to render at
		 * @param drawOptions Additional render options, if needed (default = null)
		 */
		public function drawTile(screen:Screen, tileX:uint, tileY:uint, destPoint:Point, drawOptions:DrawOptions = null):void
		{
			if (_tileWidth > 0 && _tileHeight > 0)
			{
				drawInternal(screen, new Rectangle(tileX * _tileWidth, tileY * _tileHeight, _tileWidth, _tileHeight), destPoint, drawOptions);
			}
			else
			{
				throw new Error("Calling drawTile on untiled image.");
			}
		}

		/**
		 * Create a copy of this image. 
		 * 
		 * <p> <strong>Technical note:</strong> Every time you make a call to
		 * drawTile or drawSub with <code>DrawOptions</code> passed in, this
		 * class internally needs to set aside a buffer for intermediate
		 * rendering. For speed, it caches this buffer for subsequent calls to
		 * drawTile/drawSub.
		 * 
		 * <p> Therefore, if you have an <code>Image</code> from which you 
		 * intend to render lots of subportions or tiles of it to the screen 
		 * (using <code>DrawOptions</code>), you should consider cloning it, so
		 * each clone can get its own, more stable internall cache.
		 * 
		 * @return A cloned image.
		 */
		public function clone():Image
		{
			return new Image(_tileWidth, _tileHeight, _bitmapData);
		}
		
		/**
		 * Internal helper function for all drawXXX function calls.
		 */
		private function drawInternal(screen:Screen, sourceRect:Rectangle, destPoint:Point, drawOptions:DrawOptions):void
		{
			if (_bitmapData != null)
			{
				//
				// Prepare destination point - this can be adjusted by the
				// render anchor and also the global draw-state offset
				//
				
				if (_renderAnchor != Anchor.TOP_LEFT)
				{
					var imageRect:Rectangle = new Rectangle(0, 0, sourceRect.width, sourceRect.height);
					var renderAnchorPoint:Point = Anchor.getAnchorPoint(imageRect, _renderAnchor);
					
					destPoint.x -= renderAnchorPoint.x;
					destPoint.y -= renderAnchorPoint.y;
				}
				
				if (!_drawState.inMatrixMode)
				{
					destPoint.x += _drawState.offset.x;
					destPoint.y += _drawState.offset.y;
				}
				
				if ((drawOptions == null || drawOptions.hasNoEffect()) &&
					(_drawState.color == 0xFFFFFF && _drawState.alpha == 1.0) &&
					!_drawState.inMatrixMode)
				{
					// Basic rendering. It's super fast!
					screen.bitmapData.copyPixels(_bitmapData, sourceRect, destPoint);
				}
				else
				{
					// Advanced rendering.
					
					if (drawOptions == null) { drawOptions = _blankDrawOptions; }

					var matrix:Matrix = new Matrix();
					var colorTransform:ColorTransform = null;
					var bitmapDataFinal:BitmapData;
					
					//
					// Creating working internal buffer if we need it
					// (necessary if user wants to render a subportion of the
					// full image)
					//

					if (sourceRect.x != 0 || sourceRect.y != 0 || 
						sourceRect.width != _bitmapData.width || sourceRect.height != _bitmapData.height)
					{
						// If user is trying to render a subportion of this image using
						// advanced rendering techniques, we need to copy it over to
						// our internal bitmapData first
						if (_bitmapDataX == null || !sourceRect.equals(_sourceRectX))
						{
							_bitmapDataX = new BitmapData(sourceRect.width, sourceRect.height);
							_sourceRectX = sourceRect;
							
							_bitmapDataX.copyPixels(_bitmapData, sourceRect, new Point(0, 0));
						}
						bitmapDataFinal = _bitmapDataX;
					}
					else
					{
						bitmapDataFinal = _bitmapData;
					}
					
					//
					// Handle flip
					//
					
					if (drawOptions.flipX)
					{
						matrix.scale( -1, 1);
						matrix.translate(bitmapDataFinal.width, 0);
					}
					if (drawOptions.flipY)
					{
						matrix.scale(1, -1);
						matrix.translate(0, bitmapDataFinal.height);
					}

					//
					// Handle rotating
					//
					
					if (drawOptions.rotation != 0.0)
					{
						var rotateAnchorPoint:Point = Anchor.getAnchorPoint(bitmapDataFinal.rect, drawOptions.rotationAnchor);
						matrix.translate(-rotateAnchorPoint.x, -rotateAnchorPoint.y);
						matrix.rotate(drawOptions.rotation * DEG_TO_RAD)
						matrix.translate(rotateAnchorPoint.x, rotateAnchorPoint.y);
					}

					//
					// Handle scale and translation
					//
					
					matrix.scale(drawOptions.scaleX, drawOptions.scaleY);
					matrix.translate(destPoint.x, destPoint.y);
					
					if (_drawState.inMatrixMode)
					{
						matrix.concat(_drawState.matrix);
					}
					
					//
					// Handle blending colors and setting alpha
					//
					
					var blendColorFinal:uint = drawOptions.blendColor;
					var alphaFinal:Number = drawOptions.alpha;
					
					if (_drawState.color != 0xFFFFFF)
					{
						blendColorFinal = Color.blendColors(blendColorFinal, _drawState.color);
					}
					
					if (_drawState.alpha < 1.0)
					{
						alphaFinal *= _drawState.alpha
					}
					
					if (blendColorFinal != 0xFFFFFF || alphaFinal < 1.0)
					{
						colorTransform = new ColorTransform();
						
						if (blendColorFinal != 0xFFFFFF)
						{
							var color:Color = new Color(blendColorFinal);
							colorTransform.redMultiplier = color.r / 255.0;
							colorTransform.greenMultiplier = color.g / 255.0;
							colorTransform.blueMultiplier = color.b / 255.0;
						}
						colorTransform.alphaMultiplier = alphaFinal;
					}

					//
					// Everything is set up, so... draw!
					//
					screen.bitmapData.draw(bitmapDataFinal, matrix, colorTransform, BlendMode.NORMAL, null, drawOptions.applySmoothing);
				}
			}
		}

		/**
		 * Constant to convert from degrees (our unit of preference) to radians
		 * (Flash's unit of preference);
		 */
		private static const DEG_TO_RAD:Number = Math.PI / 180.0;

		/**
		 * Render anchor, option global for all images. As far as I understand
		 * it, this is a render preference, rather than an option people would
		 * set per draw call.
		 */
		private static var _renderAnchor:int = Anchor.TOP_LEFT;

		/**
		 * The global draw state. Drawing any images will be affected by the
		 * current draw state.
		 */
		private static var _drawState:DrawState = new DrawState();
		
		/**
		 * A clean set of draw options to use in drawInternal(...) in case
		 * the user doesn't set anything themselves.
		 */
		private static var _blankDrawOptions:DrawOptions = new DrawOptions();

		/**
		 * The bitmap data that our image will render
		 */
		private var _bitmapData:BitmapData;

		private var _tileWidth:uint;
		private var _tileHeight:uint;
		
		/**
		 * Flash can't directly handle doing advanced rendering techniques
		 * (like rotating or scaling) on a subportion of an image. So, if we
		 * get such a request, we need to first copy the subportion out
		 * to a new bitmapData.
		 * 
		 * TODO: The extra data, if unused after a certain amount of time,
		 * is let go to be garbage collected.
		 */
		private var _bitmapDataX:BitmapData
		private var _sourceRectX:Rectangle;

		
	}

}