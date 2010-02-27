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
	 * you can add callbacks to that action by using the
	 * <code>addActionFiredHandler(action, callback)</code> and 
	 * <code>addActionStateHandler(action, callback)</code> calls.
	 * 
	 * <p> You can also test the keyboard state using 
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
	 *     keyboard.addActionFiredHandler(ACTION_SHOOT, handleShoot);
	 *     keyboard.addActionStateHandler(ACTION_DUCK, handleDuck);
	 *   }
	 * 
	 *   private function handleShoot(action:int):void
	 *   {
	 *     trace("BANG!");
	 *   }
	 * 
	 *   private function handleDuck(action:int, keyDown:Boolean):void
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
			
			_dictActionFiredHandlers = new Dictionary();
			_dictActionStateHandlers = new Dictionary();
			
			// TODO: Adjust these values
			_repeatDelay = 500.0;
			_repeatRate = 150.0;
		}
		
		/**
		 * The keyboard class can handle key repeating when a user holds
		 * down a key. This functionality is only available to callbacks
		 * registered by calling <code>addActionHander(...)</code>.
		 * 
		 * <p> Repeat Delay is the time (in milliseconds) to wait between
		 * a key first being pressed to the time it starts repeating.
		 * 
		 * <p> <strong>Note:</strong> If this or <code>repeatRate</code> set to
		 * 0, key repeating is disabled.
		 * 
		 * @see repeatRate
		 */
		public function get repeatDelay():uint { return _repeatDelay; }
		public function set repeatDelay(value:uint):void { _repeatDelay = value; }

		/**
		 * The keyboard class can handle key repeating when a user holds
		 * down a key. This functionality is only available to callbacks
		 * registered by calling <code>addActionHander(...)</code>.
		 * 
		 * <p> Repeat Rate is the time to wait (in milliseconds) to
		 * send out a new "actionFired" event once a key is in repeat mode.
		 * 
		 * <p> <strong>Note:</strong> If this or <code>repeatDelay</code> set to
		 * 0, key repeating is disabled.
		 *
		 * @see repeatDelay
		 */
		public function get repeatRate():uint { return _repeatRate; }
		public function set repeatRate(value:uint):void { _repeatRate = value; }

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
		 * Register an action callback for every time the specified action
		 * fires.
		 * 
		 * The signature of the callback needs to take a single <code>int</code>
		 * argument and return <code>void</code>. For example:
		 * 
		 * <p> <code>function handleActionFired(action:int):void</code>
		 * 
		 * <p> The <code>int</code> argument will be the value of the action 
		 * that caused the callback. This is useful, for example, if you have 
		 * one callback registered for multiple actions.
		 * 
		 * @param action The action we wish to register for
		 * @param callback A function that takes an <code>int</code> and returns <code>void</code>
		 * 
 		 * @see removeActionFiredHandler
		 */
		public function addActionFiredHandler(action:int, callback:Function):void
		{
			var actionFiredHandlers:Vector.<Function> = _dictActionFiredHandlers[action] as Vector.<Function>;
			
			if (actionFiredHandlers == null)
			{
				actionFiredHandlers = new Vector.<Function>();
				_dictActionFiredHandlers[action] = actionFiredHandlers;
			}
			
			if (actionFiredHandlers.indexOf(callback) < 0)
			{
				actionFiredHandlers.push(callback);
			}
		}

		/**
		 * Register an action callback for every time the keypress state for
		 * the specified action changes.
		 * 
		 * The signature of the callback needs to take an <code>int</code>
		 * argument and a <code>Boolean</code> argument, and it must return 
		 * <code>void</code>. For example:
		 * 
		 * <p> <code>function handleActionState(action:int, keyDown:Boolean):void</code>
		 * 
		 * <p> The <code>int</code> argument will be the value of the action 
		 * that caused the callback. This is useful, for example, if you have
		 * one callback registered for multiple actions.
		 * 
		 * <p> The <code>Boolean</code> argument will tell if the action key is
		 * currently pressed (</code>true</code>) or not.
		 * 
		 * @param action The action we wish to register for
		 * @param callback A function that takes an <code>int</code> and returns <code>void</code>
		 * 
		 * @see removeActionStateHandler
		 */
		public function addActionStateHandler(action:int, callback:Function):void
		{
			var actionStateHandlers:Vector.<Function> = _dictActionStateHandlers[action] as Vector.<Function>;
			
			if (actionStateHandlers == null)
			{
				actionStateHandlers = new Vector.<Function>();
				_dictActionStateHandlers[action] = actionStateHandlers;
			}
			
			if (actionStateHandlers.indexOf(callback) < 0)
			{
				actionStateHandlers.push(callback);
			}
		}

		/**
		 * Unregister an action callback that was registered with
		 * <code>addActionFiredHandler(...)</code>
		 * 
		 * @return <code>true</code> if the remove was successful
		 * 
		 * @see addActionFiredHandler
		 */
		public function removeActionFiredHandler(action:int, callback:Function):Boolean
		{
			var actionFiredHandlers:Vector.<Function> = _dictActionFiredHandlers[action] as Vector.<Function>;
			
			if (actionFiredHandlers != null)
			{
				var index:int = actionFiredHandlers.indexOf(callback);
				if (index >= 0)
				{
					actionFiredHandlers.splice(index, 1);
					return true;
				}
			}
			
			return false;
		}

		/**
		 * Unregister an action callback that was registered with
		 * <code>addActionStateHandler(...)</code>
		 * 
		 * @see addActionStateHandler
		 */
		public function removeActionStateHandler(action:int, callback:Function):Boolean
		{
			var actionStateHandlers:Vector.<Function> = _dictActionStateHandlers[action] as Vector.<Function>;
			
			if (actionStateHandlers != null)
			{
				var index:int = actionStateHandlers.indexOf(callback);
				if (index >= 0)
				{
					actionStateHandlers.splice(index, 1);
					return true;
				}
			}
			
			return false;
		}

		/**
		 * Remove ALL registered action handlers (of both the "action fired" and
		 * "state changed" variety)
		 */
		public function removeAllHandlers():void
		{
			_dictActionFiredHandlers = new Dictionary();
			_dictActionStateHandlers = new Dictionary();
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
		public function update(elapsedTime:int):void
		{
			var key:Object;
			
			// Update held time for all keys.
			for (key in _dictKeyToHeldTime)
			{
				var heldTime:int = _dictKeyToHeldTime[key] as int;
				_dictKeyToHeldTime[key] = heldTime + elapsedTime;
			}

			// If we have repeat delays set up, check to fire callbacks
			if (_repeatDelay > 0.0 && _repeatRate > 0.0)
			{
				for (key in _dictKeyToFireTime)
				{
					// Update fire time
					var fireTime:int = _dictKeyToFireTime[key] as int;
					fireTime -= elapsedTime;
					
					// See if it's time to fire!
					if (fireTime <= 0.0)
					{
						if (_dictKeyToAction[key] != null)
						{
							dispatchActionFired(_dictKeyToAction[key] as int);
						}
					
						while (fireTime <= 0.0)
						{
							fireTime += _repeatRate;
						}
					}
					
					// Update dictionary
					_dictKeyToFireTime[key] = fireTime;
				}
			}
			
			// Clean all "Just Released" keys
			for (key in _dictKeyJustReleased)
			{
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
				_dictKeyToHeldTime[e.keyCode] = 0.0;
				_dictKeyToFireTime[e.keyCode] = _repeatDelay;
				
				if (_dictKeyToAction[e.keyCode] != null)
				{
					var action:int = _dictKeyToAction[e.keyCode] as int;
					dispatchActionFired(action);
					dispatchActionStateChanged(action, true);
				}
			}
		}
		
		/**
		 * Internal handler for the KeyboardEvent.KEY_UP event.
		 */
		private function handleKeyUp(e:KeyboardEvent):void
		{
			if (_dictKeyToHeldTime[e.keyCode] != null)
			{
				delete _dictKeyToHeldTime[e.keyCode];
				delete _dictKeyToFireTime[e.keyCode];
				_dictKeyJustReleased[e.keyCode] = true;
				
				if (_dictKeyToAction[e.keyCode] != null)
				{
					var action:int = _dictKeyToAction[e.keyCode] as int;
					dispatchActionStateChanged(action, false);
				}
			}
		}

		/**
		 * Internal handler which calls any appropriate "Action Fired"
		 * callbacks.
		 */
		private function dispatchActionFired(action:int):void
		{
			var actionFiredCallbacks:Vector.<Function> = _dictActionFiredHandlers[action];
							
			if (actionFiredCallbacks != null)
			{
				for each (var callback:Function in actionFiredCallbacks)
				{
					callback(action);
				}
			}
		}

		/**
		 * Internal handler which calls any appropriate "Action State"
		 * callbacks.
		 */
		private function dispatchActionStateChanged(action:int, keyDown:Boolean):void
		{
			var actionStateCallbacks:Vector.<Function> = _dictActionStateHandlers[action];
							
			if (actionStateCallbacks != null)
			{
				for each (var callback:Function in actionStateCallbacks)
				{
					callback(action, keyDown);
				}
			}
		}
			
		// Key <-> Action relationships
		private var _dictActionToKey:Dictionary;
		private var _dictKeyToAction:Dictionary;
		
		// Key pressed / released state
		private var _dictKeyToHeldTime:Dictionary; // action -> int (time in ms key held down)
		private var _dictKeyToFireTime:Dictionary; // action -> int (time in ms until next fire event)
		private var _dictKeyJustReleased:Dictionary; // action -> Boolean, true when just released
		
		// Registered action callbacks (action -> Vector.<Function>)
		private var _dictActionFiredHandlers:Dictionary;
		private var _dictActionStateHandlers:Dictionary;
		
		private var _repeatDelay:int;
		private var _repeatRate:int;
	}

}