package efme.core.graphics2d 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import efme.core.graphics2d.Screen;
	
	/**
	 * Class which references image data and can render it.
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
				if (drawOptions == null || drawOptions.hasNoEffect())
				{
					// Basic rendering. It's super fast!
					screen.bitmapData.copyPixels(_bitmapData, sourceRect, destPoint);
				}
				else
				{
					// Advanced rendering.

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
					
					if (drawOptions.rotate != 0.0)
					{
						// TODO: Get this point based on anchor information
						var anchorPoint:Point = Anchor.getAnchorPoint(bitmapDataFinal.rect, drawOptions.rotateAnchor);
						matrix.translate(-anchorPoint.x, -anchorPoint.y);
						matrix.rotate(drawOptions.rotate * DEG_TO_RAD)
						matrix.translate(anchorPoint.x, anchorPoint.y);
					}

					//
					// Handle scale and translation
					//
					
					matrix.scale(drawOptions.scaleX, drawOptions.scaleY);
					matrix.translate(destPoint.x, destPoint.y);
					
					//
					// Handle blending colors and setting alpha
					//
					
					if (drawOptions.blendColor != 0xFFFFFF || drawOptions.alpha < 1.0)
					{
						colorTransform = new ColorTransform();
						
						if (drawOptions.blendColor != 0xFFFFFF)
						{
							var r:uint = (drawOptions.blendColor & 0xFF0000) >> 16;
							var g:uint = (drawOptions.blendColor & 0x00FF00) >> 8;
							var b:uint = (drawOptions.blendColor & 0x0000FF);
							colorTransform.redMultiplier = r / 255.0;
							colorTransform.greenMultiplier = g / 255.0;
							colorTransform.blueMultiplier = b / 255.0;
						}
						colorTransform.alphaMultiplier = drawOptions.alpha;
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
		private const DEG_TO_RAD:Number = Math.PI / 180.0;
		
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