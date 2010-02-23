package efme.core.graphics2d 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
		 * @param targetX Target x to render at
		 * @param targetY Target y to render at
		 */
		public function draw(screen:Screen, targetX:Number = 0, targetY:Number = 0):void
		{
			if (_bitmapData != null)
			{
				var rectSrc:Rectangle = new Rectangle(0, 0, _bitmapData.width, _bitmapData.height);
				var ptDst:Point = new Point(targetX, targetY);
				
				screen.bitmapData.copyPixels(_bitmapData, rectSrc, ptDst);
			}
		}

		/**
		 * Draw a tile from within this tiled image. If the image has no
		 * tiles, then this is the same as drawing the whole screen.
		 * 
		 * @param screen Target screen to render to
		 * @param tileX The X-index of the tile to render
		 * @param tileY The Y-index of the tile to render
		 * @param targetX Target x to render at
		 * @param targetY Target y to render at
		 */
		public function drawTile(screen:Screen, tileX:uint = 0, tileY:uint = 0, targetX:Number = 0, targetY:Number = 0):void
		{
			if (_bitmapData != null && _tileWidth > 0 && _tileHeight > 0)
			{
				var rectSrc:Rectangle = new Rectangle(tileX * _tileWidth, tileY * _tileHeight, _tileWidth, _tileHeight);
				var ptDst:Point = new Point(targetX, targetY);
				
				screen.bitmapData.copyPixels(_bitmapData, rectSrc, ptDst);
			}
		}

		
		private var _bitmapData:BitmapData;
		private var _tileWidth:uint;
		private var _tileHeight:uint;
	}

}