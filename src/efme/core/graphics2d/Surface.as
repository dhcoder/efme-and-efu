package efme.core.graphics2d 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * A base class for anything that has an internal <code>BitmapData</code>
	 * which you can draw on.
	 * 
	 * <p> You can access the interal <code>BitmapData</code> through the
	 * <code>bitmapData</code> property, but you must be sure to do so only
	 * between <code>beginDraw()/endDraw()</code> calls.
	 */
	public class Surface
	{
		/**
		 * Construct a surface. You can set it to its target bitmapData now  with your desired appearance settings.
		 * 
		 * @param bitmapData The internal bitmapData for this surface.
		 * @param clearColor The background color (hex code) for this surface's clear color (default = Black)
		 */
		public function Surface(bitmapData:BitmapData, clearColor:uint = 0x000000):void
		{
			_bitmapData = bitmapData;
			_clearColor = clearColor;
		}
		
		/**
		 * The width of this surface.
		 */
		public function get width():uint { return bitmapData != null ? bitmapData.width : 0; }

		/**
		 * The height of this surface.
		 */
		public function get height():uint { return bitmapData != null ? bitmapData.height : 0; }
		
		/**
		 * The internal BitmapData of this surface. Don't access this unless you
		 * know what you're doing!!
		 */
		public function get bitmapData():BitmapData	{ return _bitmapData; }
		public function set bitmapData(value:BitmapData):void { _bitmapData = value; }
		
		/**
		 * The background color of this surface.
		 */
		public function get clearColor():uint { return _clearColor; }
		public function set clearColor(value:uint):void { _clearColor = value; }

		/**
		 * If you know you are going to do many render calls to this surface,
		 * you will improve performace by wrapping those calls in a 
		 * <code>beginUpdate()/endUpdate()</code> pair.
		 */
		public function beginUpdate():void
		{
			if (!_isLocked)
			{
				_isLocked = true;
				bitmapData.lock();
			}
		}
		
		/**
		 * Call when you are finished with your rendering to the surface.
		 * After this function is called, the screen will apply all the
		 * rendering updates it received so far.
		 */
		public function endUpdate():void 
		{
			if (_isLocked)
			{
				bitmapData.unlock();
				_isLocked = false;
			}
		}
		
		/**
		 * Clear this screen, filling it with the color specified by the
		 * <code>clearColor</code> property.
		 * 
		 * @see #clearColor
		 */
		public function clear():void
		{
			bitmapData.fillRect(bitmapData.rect, _clearColor);
		}
		
		private var _bitmapData:BitmapData; // Internal bitmap data
		private var _isLocked:Boolean; // True when we are in beginDraw/endDraw
		private var _clearColor:uint; // The background color
	}
}