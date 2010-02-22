package efme
{
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.display.Sprite;
	import flash.events.Event;

	import efme.core.graphics2d.Screen;
	
	/**
	 * The main class which drives EFME, responsible for initializing all of
	 * its various components and acting as the pulse which updates / renders
	 * your game.
	 * 
	 * <p>To get started using EFME, create your own class which extends
	 * <code>Engine</code>, and call <code>super(...)</code> with your
	 * desired setup. Then, call <code>start()</code>.</p>
	 * 
	 * <p>To see this in action, please review
	 * efme.examples.Ex01_GettingStarted.</p>
	 * 
	 * @example The following code sets up a basic 640x480 Engine.
	 * <listing version="3.0">
	 * public class MyGame extends Engine
	 * {
	 *   public function MyGame()
	 *   {
	 *     super(640, 480);
	 *     start();
	 *   }
	 * }
	 * </listing>
	 */
	public class Engine extends Sprite
	{
		/**
		 * Construct an EFME engine with your desired appearance settings.
		 * 
		 * @param width The desired width of your display screen.
		 * @param height The desired height of your display screen.
		 * @param clearColor The background color (hex code) of your display screen (default = Black)
		 */
		public function Engine(width:uint, height:uint, clearColor:uint = 0x000000, scale:Number = 1.0):void
		{
			_screen = new Screen(this, width, height, clearColor);
		}

		/**
		 *  Provide access to the target screen.
		 */
		public function get screen():Screen	{ return _screen; }
		
		
		/**
		 * Call this function to start executing your game.
		 * 
		 * <p>This doesn't happen automatically in the constructor, because
		 * sometimes you want to do some additional setup before you begin.</p>
		 */
		public function start():void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.displayState = StageDisplayState.NORMAL;
			
			stage.frameRate = 60;
		}

		
		private var _screen:Screen;

	}
}