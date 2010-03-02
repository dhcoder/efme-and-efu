package efme.core.graphics2d
{
	import efme.GameEngine;
	
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
		public function Screen(gameEngine:GameEngine, width:uint, height:uint, clearColor:uint, scale:Number):void
		{
			_bitmap = new Bitmap(new BitmapData(width, height, false, clearColor));
			_bitmap.scaleX = _bitmap.scaleY = scale;
			
			_clearColor = clearColor;
			
			gameEngine.addChild(_bitmap);
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
		 * The scale of this screen.
		 */
		public function get scale():Number { return _bitmap.scaleX; }
		
		/**
		 * The internal BitmapData of this screen's render buffer. Don't
		 * access this unless you know what you're doing!!
		 * 
		 * <p> Furthermore, you can only access this property between
		 * <code>beginDraw()</code> and <code>endDraw()</code> calls. Otherwise,
		 * it will throw an error.
		 * 
		 * <p> If you want to test the screen, to see if you can draw to it
		 * or not, check the <code>renderingAllowed</code> property.
		 * 
		 * @throws efme.core.errors.EfSevereError Thrown if this property is accessed outside of a beginDraw()/endDraw() pair.
		 */
		public function get bitmapData():BitmapData
		{ 
			if (_isLocked)
			{
				return _bitmap.bitmapData;
			}
			else
			{
				throw new Error("Trying to render to screen outside of beginDraw()/endDraw() pair.");
			}
		}
		
		/**
		 * Whether the screen can currently be rendered to or not. 
		 * <code>true</code> if a screen is between 
		 * <code>beginDraw()</code>/<code>endDraw()</code> calls.
		 */
		public function get renderingAllowed():Boolean { return _isLocked; }
		
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
			if (_isLocked)
			{
				_bitmap.bitmapData.fillRect(_bitmap.bitmapData.rect, _clearColor);
			}
			else
			{
				throw new Error("Screen.clear() called outside of beginDraw/endDraw pair");
			}
		}

		private var _bitmap:Bitmap; // Bitmap that fills the screen; draw on it!
		private var _isLocked:Boolean; // True when we are in beginDraw/endDraw
		private var _clearColor:uint; // The background color
	}
}