package efme
{
	import efme.core.input.Keyboard;
	import efme.core.input.Mouse;
	import efme.core.support.Assets;
	import efme.core.support.Services;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import efme.core.graphics2d.Screen;
	
	/**
	 * The main class which drives EFME, responsible for initializing all of
	 * its various components and acting as the pulse which updates / renders
	 * your game.
	 * 
	 * <p>To get started using EFME, create your own class which extends
	 * <code>GameEngine</code>, and call <code>super(...)</code> with your
	 * desired setup. Then, call <code>start()</code>.</p>
	 * 
	 * @example The following code sets up a basic 640x480 Engine.
	 * <listing version="3.0">
	 * public class MyGame extends GameEngine
	 * {
	 *   public function MyGame()
	 *   {
	 *     super(640, 480);
	 *     start();
	 *   }
	 * }
	 * </listing>
	 */
	public class GameEngine extends Sprite
	{
		/**
		 * Construct an EFME engine with your desired appearance settings.
		 * 
		 * @param width The desired width of your display screen.
		 * @param height The desired height of your display screen.
		 * @param clearColor The background color (hex code) of your display screen (default = Black)
		 */
		public function GameEngine(width:uint, height:uint, clearColor:uint = 0x000000, scale:Number = 1.0):void
		{
			// TODO: Use scale!
			_screen = new Screen(this, width, height, clearColor);
			
			_assets = new Assets();
			_services = new Services();
			
			_keyboard = null; // Initialized after the stage is created
			_mouse = null;    // ..
		}

		/**
		 *  Provide access to the target screen.
		 */
		public function get screen():Screen	{ return _screen; }

		/**
		 * Provide access to this game's asset manager.
		 */
		public function get assets():Assets { return _assets; }
		
		/**
		 * Provide access to this game's global services.
		 */
		public function get services():Services { return _services; }
		
		
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
			
			_keyboard = new Keyboard(stage);
			_mouse = new Mouse(stage);
			
			_frameTimer = new Timer(4);
			_frameTimer.addEventListener(TimerEvent.TIMER, handleFrameTick);
			_frameTimer.start();
		}
		
		private function handleFrameTick(e:TimerEvent):void
		{
			// TODO: Remove this return; this happens once game objects are put into place
			return;

			_screen.beginDraw();
			_screen.clear();
			_screen.endDraw();
		}

		private var _screen:Screen;
		private var _frameTimer:Timer;
		
		private var _keyboard:Keyboard;
		private var _mouse:Mouse;
		
		private var _assets:Assets;
		private var _services:Services;
	}
}