package efme
{
	import efme.core.input.Keyboard;
	import efme.core.input.Mouse;
	import efme.core.support.Assets;
	import efme.core.support.Services;
	import efme.game.GameState;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.ui.ContextMenu;
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
			
			// Members to be initialized after the stage is created.
			_keyboard = null;
			_mouse = null;
			
			// TODO: Move this to a better place and expose ability to add
			// new items to the list. Probably efme.support.ContextMenu?
			var cleanContextMenu:ContextMenu = new ContextMenu();
			cleanContextMenu.hideBuiltInItems();
			contextMenu = cleanContextMenu;
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
		 * Set the next game state we're going to enter into.
		 */
		public function enterState(gameState:GameState):void
		{
			_gameStateNext = gameState;
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
		protected function onUpdate(elapsedTime:uint):void
		{
		}
		
		/**
		 * Override in a derived class. This function gives you a chance to
		 * render to the screen before anything else.
		 * 
		 * <p><strong>Note:</strong> Usually, most/all rendering should take
		 * place in your <code>GameState</code>'s <code>EfNode</code>s, but this
		 * hook-point is still provided if you want to render something that
		 * is globally behind every screen in your game.
		 * 
		 * @see efme.game.EfNode
		 * @see efme.game.EfNode#onRender
		 */
		protected function onRenderBackground():void
		{
		}

		/**
		 * Override in a derived class. This function gives you a chance to
		 * render to the screen after everything else.
		 * 
		 * <p><strong>Note:</strong> Usually, most/all rendering should take
		 * place in your <code>GameState</code>'s <code>EfNode</code>s, but this
		 * hook-point is still provided if you want to render something that
		 * is globally in front of every screen in your game. (Say, like an
		 * FPS overlay)
		 * 
		 * @see efme.game.EfNode
		 * @see efme.game.EfNode#onRender
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
			
			_gameState = null;

			_prevFrameTime = flash.utils.getTimer();

			onInit();

			// We're initialized. Kick-off the game timer!
			_gameTimer = new Timer(1000 / _desiredFps);
			_gameTimer.addEventListener(TimerEvent.TIMER, handleGameTick);

			_gameTimer.start();
		}

		/**
		 * The heartbeat of EFME. This tick handler is set up to be
		 * called "_desiredFps" times every second.
		 * 
		 * <p> If the game starts to fall behind the desired FPS, we
		 * pause rendering until we catch up.
		 */
		private function handleGameTick(e:TimerEvent):void
		{
			//
			// Handle update
			//
 			
			var currFrameTime:int = flash.utils.getTimer();
			var elapsedTime:uint = currFrameTime - _prevFrameTime;
			_prevFrameTime = currFrameTime;
			
			if (!assets.isLoading()) // Pause the game while assets are loading. 
			// TODO Some way to let the users handle this? Show a progress bar or something?
			{
				onUpdate(elapsedTime);
				
				if (_gameState != null)
				{
					_gameState.update(elapsedTime);
				}
				
				keyboard.update(elapsedTime);
				mouse.update(elapsedTime);

				//
				// Handle render
				//
				
				_screen.beginDraw();
				_screen.clear();
				
				onRenderBackground();
				
				if (_gameState != null)
				{
					_gameState.render();
				}
				
				onRenderForeground();
				_screen.endDraw();

				//
				// Check if we should move to the next game state
				//
				
				if (_gameStateNext != null)
				{
					if (_gameState != null)
					{
						_gameState.alarms.clear();
						_gameState.efNodes.clear();
					}
					// TODO: Remove all from game state. This clears all nodes and alarms?
					_gameState = _gameStateNext;
					_gameState.handleEntered();
					
					_gameStateNext = null;
					
					System.gc();
					System.gc();
				}
			}
		}
		
		private static const MAX_FPS:uint = 200;
		
		private var _screen:Screen;
		
		private var _desiredFps:uint;
		private var _actualFps:uint;
		private var _gameTimer:Timer;
		
		private var _prevFrameTime:int; // milliseconds since this SWF started
		
		private var _keyboard:Keyboard;
		private var _mouse:Mouse;
		
		private var _assets:Assets;
		private var _services:Services;
		
		private var _gameState:GameState;
		private var _gameStateNext:GameState;
	}
}