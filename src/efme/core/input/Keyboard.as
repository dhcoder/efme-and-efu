package efme.core.input 
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	/**
	 * A class that represents the current keyboard state.
	 * 
	 * <p> You can use <code>isKeyDown(key)</code>, 
	 * <code>isKeyUp(key)</code>, <code>isKeyJustPressed(key)</code>, and
	 * <code>isKeyJustReleased(key)</code> to check the state of any key on
	 * the keyboard.
	 * 
	 * <p> You can also optionally bind actions to keys, using the 
	 * <code>associateAction(action, key)</code> call. Once an action is bound,
	 * you can also test the keyboard state using 
	 * <code>isActionKeyDown(action)</code>, <code>isActionKeyUp(action)</code>,
	 * <code>isActionKeyJustPressed(action)</code>, and 
	 * <code>isActionKeyJustReleased(action)</code>.
	 * 
	 * <p> <strong>Recommendation:</strong> if you start to think of your input
	 * in terms of actions, rather than handling specific keys, it takes a
	 * degree of hardcoding out of your code, making it easy to reassign
	 * keypresses later. It's also clearer to say, "I want to handle jumping
	 * here" rather than "I want to handle the 'q' key here".
	 * 
	 * <p> <strong>Note:</strong> Whoever is responsible for this class must 
	 * regularly call <code>update(elapsedTime)</code> so it can update its
	 * internal state.
	 * 
	 * @example The initialization and use of the Keyboard class in your game.
	 * <listing version="3.0">
	 * class MyGame extends GameEngine
	 * {
	 *   private static const ACTION_JUMP:int = 0; // Best to put these in a separate
	 *   private static const ACTION_DUCK:int = 1; // class in a real application
	 *
	 *   private static const SHOOT_RATE:int = 200; // One shot / 200 ms
	 * 
	 *   private var _shootTimer:int;
	 * 
	 *   public function MyGame()
	 *   {
	 *     super(640, 480);
	 *     start();
	 *   }
	 * 
	 *   protected override function onInit():void
	 *   {
	 *     keyboard.associateAction(ACTION_SHOOT, Key.SPACE);
	 *     keyboard.associateAction(ACTION_DUCK, Key.DOWN);
	 * 
	 *     _shootTimer = 0;
	 *   }
	 * 
	 *   protected override function onUpdate(elapsedTime:uint)
	 *   {
	 *      if (keyboard.isActionKeyJustPressed(ACTION_SHOOT)
	 *      {
	 *        _shootTimer = 0;
	 *      }
	 *      if (keyboard.isActionKeyPressed(ACTION_SHOOT)
	 *      {
	 *        if (_shootTimer <= 0)
	 *        {
	 *          handleShoot();
	 *          _shootTimer = SHOOT_RATE;
	 *        }
	 *        else
	 *        {
	 *          _shootTimer -= elapsedTime;
	 *        }
	 *      }
	 *      if (keyboard.isActionKeyJustPressed(ACTION_DUCK))
	 *      {
	 *         handleDuck(true);
	 *      }
	 *      else if (keyboard.isActionKeyJustReleased(ACTION_DUCK))
	 *      {
	 *         handleDuck(false);
	 *      }
	 *   }
	 * 
	 *   private function handleShoot():void
	 *   {
	 *     trace("BANG!");
	 *   }
	 * 
	 *   private function handleDuck(keyDown:Booelean):void
	 *   {
	 *     if (keyDown)
	 *     {
	 *       trace("Ducking...");
	 *     }
	 *     else
	 *     {
	 *       trace("Stand up!");
	 *     }
	 *   }
	 * }
	 * </listing>
	 */
	public class Keyboard
	{
		/**
		 * Keyboard constructor. Takes a Flash stage and listens to the keyboard
		 * input it receives.
		 */
		public function Keyboard(stage:Stage) 
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyUp);
			
			_dictActionToKey = new Dictionary();
			_dictKeyToAction = new Dictionary();

			_dictKeyToHeldTime = new Dictionary();
			_dictKeyToFireTime = new Dictionary();
			_dictKeyJustReleased = new Dictionary();
		}
	
		/**
		 * Associate an action to a particular key. Subsequent calls to this
		 * function with the same action will reassociate it to a new key,
		 * releasing the previous binding.
		 * 
		 * <p> <strong>Note:</strong> <code>action</code> is just an
		 * <code>int</code>. While you could just choose a number like
		 * "42" and use it all over your code, that's prone to error. It's
		 * recommended you create a list of constants somewhere in your project,
		 * like
		 * 
		 * <pre>
		 * public static const SOME_ACTION:int = 0;
		 * public static const ANOTHER_ACTION:int = 1;
		 * </pre>
		 * 
		 * @param action The action you want to register
		 * @param keyCode The keycode you want to register.
		 */
		public function associateAction(action:int, keyCode:int):void
		{
			_dictActionToKey[action] = keyCode;
			_dictKeyToAction[keyCode] = action;
		}

		/**
		 * Update the keyboard's internal state.
		 * 
		 * <p> This must be done regularly, or else the repeat rate and
		 * the "just pressed/released" key tests won't work.
		 * 
		 * <p> Also, because of the implementation specifics, you have to
		 * call this function AFTER you call update on all of your own
		 * objects.
		 * 
		 * @param elapsedTime How much time has elapsed (in ms) since the last call to update.
		 */
		public function update(elapsedTime:uint):void
		{
			var key:Object;
			
			// Update held time for all keys.
			for (key in _dictKeyToHeldTime)
			{
				var heldTime:int = _dictKeyToHeldTime[key] as int;
				_dictKeyToHeldTime[key] = heldTime + elapsedTime;
			}

			// Clean all keys that were released previous the previous frame
			for (key in _dictKeyJustReleased)
			{
				delete _dictKeyToHeldTime[key];
				delete _dictKeyJustReleased[key];
			}
		}

		/**
		 * Test if the specified keyCode is currently held down.
		 * 
		 * @see Key
		 */
		public function isKeyDown(keyCode:int):Boolean
		{
			return _dictKeyToHeldTime[keyCode] != null;
		}

		/**
		 * Test if the specified keyCode is currently released.
		 * 
		 * @see Key
		 */
		public function isKeyUp(keyCode:int):Boolean
		{
			return _dictKeyToHeldTime[keyCode] == null;
		}
		
		/**
		 * Test if the specified keyCode was just pressed last frame.
		 * 
		 * @see Key
		 */
		public function isKeyJustPressed(keyCode:int):Boolean
		{
			return ((_dictKeyToHeldTime[keyCode] as int) == 0);
		}
		
		/**
		 * Test if the specified keyCode was just released last frame.
		 * 
		 * @see Key
		 */
		public function isKeyJustReleased(keyCode:int):Boolean
		{
			return _dictKeyJustReleased[keyCode] != null;
		}
		
		/**
		 * Get the number of milliseconds this key has been held down.
		 */
		public function getKeyHeldTime(keyCode:int):int
		{
			return (_dictKeyToHeldTime[keyCode] as int);
		}

		/**
		 * Test if the key associated with the specified action is currently
		 * held down.
		 */
		public function isActionKeyDown(action:int):Boolean
		{
			return isKeyDown(_dictActionToKey[action] as int);
		}

		/**
		 * Test if the key associated with the specified action is currently
		 * released.
		 */
		public function isActionKeyUp(action:int):Boolean
		{
			return isKeyUp(_dictActionToKey[action] as int);
		}
		
		/**
		 * Test if the key associated with the specified action was just
		 * pressed last frame.
		 */
		public function isActionKeyJustPressed(action:int):Boolean
		{
			return isKeyJustPressed(_dictActionToKey[action] as int);
		}
		
		/**
		 * Test if the key associated with the specified action was just
		 * released last frame.
		 */
		public function isActionKeyJustReleased(action:int):Boolean
		{
			return isKeyJustReleased(_dictActionToKey[action] as int);
		}
		
		/**
		 * Get the number of milliseconds the key associated with the specified
		 * action has been held down.
		 */
		public function getActionKeyHeldTime(action:int):int
		{
			return getKeyHeldTime(_dictActionToKey[action] as int);

		}

		
		/**
		 * Internal handler for the KeyboardEvent.KEY_DOWN event.
		 */
		private function handleKeyDown(e:KeyboardEvent):void
		{
			if (_dictKeyToHeldTime[e.keyCode] == null)
			{
				_dictKeyToHeldTime[e.keyCode] = 0;
			}
		}
		
		/**
		 * Internal handler for the KeyboardEvent.KEY_UP event.
		 */
		private function handleKeyUp(e:KeyboardEvent):void
		{
			_dictKeyJustReleased[e.keyCode] = true;
		}

		// Key <-> Action relationships
		private var _dictActionToKey:Dictionary;
		private var _dictKeyToAction:Dictionary;
		
		// Key pressed / released state
		private var _dictKeyToHeldTime:Dictionary; // action -> int (time in ms key held down)
		private var _dictKeyToFireTime:Dictionary; // action -> int (time in ms until next fire event)
		private var _dictKeyJustReleased:Dictionary; // action -> Boolean, true when just released
	}

}