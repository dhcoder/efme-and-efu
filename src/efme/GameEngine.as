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
	import flash.utils.getTimer;
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
		 * @param scale The amount to scale your game. Use this to give your game a more retro-pixelated look. (default = 1.0)
		 * @param desiredFps The target frames-per-second you want your game to run at. Set to 0 to run as fast as possible. (default=60)
		 */
		public function GameEngine(width:uint, height:uint, clearColor:uint = 0x000000, scale:Number = 1.0, desiredFps:uint=60):void
		{
			_screen = new Screen(this, width, height, clearColor, scale);
			
			_assets = new Assets();
			_services = new Services();
			
			// TODO: Test FPS
			_desiredFps = desiredFps;
			_actualFps = _desiredFps;
			
			_date = new Date();
			
			// Members to be initialized after the stage is created.
			_keyboard = null;
			_mouse = null;
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
		 * Provide access to this game's keyboard state.
		 */
		public function get keyboard():Keyboard { return _keyboard; }

		/**
		 * Provide access to this game's mouse state.
		 */
		public function get mouse():Mouse { return _mouse; }
		
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

		/**
		 * Override in a derived class. This is a good place to initialize
		 * anything that needs to exist over the lifetime of your whole game.
		 */
		protected function onInit():void
		{
		}
		
		/**
		 * Override in a derived class. This is a good place to update some
		 * game-wide system you may have that needs to call update itself.
		 * 
		 * @param elapsedTime Time (in ms) passed since the last update call.
		 */
		protected function onUpdate(elapsedTime:int):void
		{
		}
		
		/**
		 * Override in a derived class. This function gives you a chance to
		 * render to the screen before anything else.
		 * 
		 * <p>Usually, most/all rendering should take place in your 
		 * <code>EfNode</code> or <code>GameState</code> classes, but this
		 * hook-point is still provided if you want to render something that
		 * is globally behind every screen in your game.
		 */
		protected function onRenderBackground():void
		{
		}

		/**
		 * Override in a derived class. This function gives you a chance to
		 * render to the screen after everything else.
		 * 
		 * <p>Usually, most/all rendering should take place in your 
		 * <code>EfNode</code> or <code>GameState</code> classes, but this
		 * hook-point is still provided if you want to render something that
		 * is globally in front of every screen in your game.
		 */
		protected function onRenderForeground():void
		{
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

			_prevFrameTime = flash.utils.getTimer();

			onInit();

			// We're initialized. Kick-off the update timer!
			_frameTimer = new Timer(1000 / MAX_FPS);
			_frameTimer.addEventListener(TimerEvent.TIMER, handleUpdateTick);

			_renderTimer = new Timer(1000 / _desiredFps);
			_renderTimer.addEventListener(TimerEvent.TIMER, handleRenderTick);
			
			_frameTimer.start();
			_renderTimer.start();
		}

		/**
		 * The update heartbeat of EFME. This tick handler is set up to be
		 * called "MAX_FPS" times every second.
		 * 
		 * <p> If the game starts to fall behind the desired FPS, we
		 * pause rendering until we catch up.
		 */
		private function handleUpdateTick(e:TimerEvent):void
		{
			var currFrameTime:int = flash.utils.getTimer();
			var elapsedTime:int = currFrameTime - _prevFrameTime;
			_prevFrameTime = currFrameTime;

			onUpdate(elapsedTime); 
			keyboard.update(elapsedTime);
		}
		
		/**
		 * The render heartbeat of EFME. This tick handler is set up to be
		 * called "_desiredFps" times every second.
		 */
		private function handleRenderTick(e:TimerEvent):void
		{
			_screen.beginDraw();
			_screen.clear();
			onRenderBackground();
			// render world
			onRenderForeground();
			_screen.endDraw();
		}
		
		private static const MAX_FPS:uint = 200;
		
		private var _screen:Screen;
		
		private var _desiredFps:uint;
		private var _actualFps:uint;
		private var _frameTimer:Timer;
		private var _renderTimer:Timer;
		
		private var _date:Date; // Used to maintain our internal clock
		private var _prevFrameTime:int; // milliseconds since this SWF started
		
		private var _keyboard:Keyboard;
		private var _mouse:Mouse;
		
		private var _assets:Assets;
		private var _services:Services;
	}
}