package efme.core.graphics2d 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import efme.core.graphics2d.Screen;
	
	/**
	 * Class which represents an image.
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
			// TODO: Error if tileWidth or tileHeight is 0
			if (_tileWidth > 0 && _tileHeight > 0)
			{
				drawInternal(screen, new Rectangle(tileX * _tileWidth, tileY * _tileHeight, _tileWidth, _tileHeight), destPoint, drawOptions);
			}
		}

		/**
		 * Internal helper function for all drawXXX function calls.
		 */
		private function drawInternal(screen:Screen, sourceRect:Rectangle, destPoint:Point, drawOptions:DrawOptions):void
		{
			if (_bitmapData != null && screen.bitmapData != null)
			{
				if (drawOptions == null)
				{
					// Basic rendering. It's super fast!
					screen.bitmapData.copyPixels(_bitmapData, sourceRect, destPoint);
				}
				else
				{
					var matrix:Matrix = new Matrix();
					var colorTransform:ColorTransform = new ColorTransform();

					/*
					if (drawOptions.rotate != 0.0)
					{
						// TODO: Get this point based on anchor information
						var translateX:Number = drawOptions.destRect.width / 2;
						var translateY:Number = drawOptions.destRect.height / 2;
					
						matrix.translate(-translateX, -translateY);
						matrix.rotate(drawOptions.rotate * DEG_TO_RAD)
						matrix.translate(translateX, translateY);
						
						if (drawOptions.destRect.width > 0 && drawOptions.destRect.height > 0)
						{
							matrix.scale(drawOptions.destRect.width / _bitmapData.width, drawOptions.destRect.height / _bitmapData.height);
						}
					}
					
					//colorTransform.color = drawOptions.blendColor;
					//colorTransform.alphaMultiplier = drawOptions.blendAlpha;
					*/

//					matrix.tx = -sourceRect.x;
//					matrix.ty = -sourceRect.y;
					matrix.translate( -sourceRect.x, -sourceRect.y);
					matrix.rotate(30 * DEG_TO_RAD);
					screen.bitmapData.draw(_bitmapData,matrix, null, null, new Rectangle(0, 0, sourceRect.width, sourceRect.height), drawOptions.applySmoothing);
				}
			}
		}
		
		private const DEG_TO_RAD:Number = Math.PI / 180.0;
		
		private var _bitmapData:BitmapData;
		private var _tileWidth:uint;
		private var _tileHeight:uint;
	}

}