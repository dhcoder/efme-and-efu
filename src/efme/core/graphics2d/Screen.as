package efme.core.graphics2d
{
	import efme.Engine;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * A class which represents the window that your game is drawn on. It
	 * contains information about the resolution, background color, and
	 * scale of your game.
	 * 
	 * <p>Furthermore, anything you render into the Screen shows up in your
	 * Flash window.</p>
	 * 
	 * <p><strong>NOTE:</strong>Don't initialize this class yourself - it is
	 * created by efme.Engine, and accessed through efme.Engine's 
	 * <code>screen</code> property.</p>
	 */
	public class Screen
	{
		/**
		 * Construct a screen with your desired appearance settings.
		 * 
		 * @param engine The parent engine which is running the application.
		 * @param width The desired width of this display screen.
		 * @param height The desired height of this display screen.
		 * @param clearColor The background color (hex code) of your display screen (default = Black)
		 */
		public function Screen(engine:Engine, width:uint, height:uint, clearColor:uint):void
		{
			_bitmap = new Bitmap(new BitmapData(width, height, false, clearColor));
			_clearColor = clearColor;
			
			engine.addChild(_bitmap);
		}
		
		/**
		 * The width of this display screen.
		 */
		public function get width():uint { return _bitmap.bitmapData.width; }

		/**
		 * The height of this display screen.
		 */
		public function get height():uint { return _bitmap.bitmapData.height; }
		
		/**
		 * The internal BitmapData of this screen's render buffer. Don't
		 * access this unless you know what you're doing!!
		 * 
		 * <p> Furthermore, you can only access this property between
		 * <code>beginDraw()</code> and <code>endDraw()</code> calls.
		 */
		public function get bitmapData():BitmapData { return (_isLocked ? _bitmap.bitmapData : null); }
		
		/**
		 * The background color of this display screen.
		 */
		public function get clearColor():uint { return _clearColor; }
		public function set clearColor(value:uint):void
		{
			_clearColor = value;
		}

		/**
		 * Call before you do any rendering to the screen. Calling any
		 * draw functions or accessing the <code>bitmapData</code> property
		 * will fail if you don't call this first.
		 */
		public function beginDraw():void
		{
			if (!_isLocked)
			{
				_isLocked = true;
				_bitmap.bitmapData.lock();
			}
		}
		
		/**
		 * Call when you are finished with your rendering to the screen.
		 * After this function is called, the screen will apply all the
		 * rendering updates it received so far.
		 */
		public function endDraw():void 
		{
			if (_isLocked)
			{
				_bitmap.bitmapData.unlock();
				_isLocked = false;
			}
		}
		
		/**
		 * Clear this screen, filling it with the color specified by the
		 * <code>clearColor</code> property.
		 * 
		 * @see clearColor
		 */
		public function clear():void
		{
			// TODO: Error if no beginDraw
			if (_isLocked)
			{
				_bitmap.bitmapData.fillRect(_bitmap.bitmapData.rect, _clearColor);
			}
		}

		private var _bitmap:Bitmap; // Bitmap that fills the screen; draw on it!
		private var _isLocked:Boolean; // True when we are in beginDraw/endDraw
		private var _clearColor:uint; // The background color
	}
}