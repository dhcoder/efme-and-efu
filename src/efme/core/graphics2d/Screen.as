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
	 * <p>Internally, EFME renders its contents into this class, and the
	 * result is displayed on the screen.</p>
	 * 
	 * <p><strong>NOTE:</strong>Don't initialize this class yourself - it is
	 * created by efme.Engine, and accessed through efme.Engine.screen.</p>
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
		 * The background color of this display screen.
		 */
		public function get clearColor():uint { return _clearColor; }
		public function set clearColor(value:uint):void
		{
			_clearColor = value; 
			_bitmap.bitmapData.fillRect(_bitmap.bitmapData.rect, _clearColor);
		}

		
		public function drawSprite():void
		{
			// TODO: Implement drawSprite
		}
		
		private var _bitmap:Bitmap; // Solid-color bitmap that fills the screen
		private var _clearColor:uint;
	}
}