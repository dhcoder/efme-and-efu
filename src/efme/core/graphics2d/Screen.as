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
	public class Screen extends Surface
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
			super(new BitmapData(width, height, false, clearColor), clearColor);
			
			_bitmap = new Bitmap(bitmapData);
			_bitmap.scaleX = _bitmap.scaleY = scale;
			
			gameEngine.addChild(_bitmap);
		}
		
		/**
		 * The scale of this screen.
		 */
		public function get scale():Number { return _bitmap.scaleX; }
		
		private var _bitmap:Bitmap; // Bitmap that fills the screen; draw on it!
	}
}