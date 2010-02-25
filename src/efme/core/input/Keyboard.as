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
	 * <code>addActionHandler(action, callback)</code> call.
	 * 
	 * <p> You can also test the keyboard state using 
	 * <code>isActionKeyDown(action)</code>, <code>isActionKeyUp(action)</code>,
	 * <code>isActionKeyJustPressed(action)</code>, and 
	 * <code>isActionKeyJustReleased(action)</code>.
	 * 
	 * <p> <strong>Recommendation:</strong> if you start to think of your input
	 * in terms of actions, rather than handling specific keys, it makes your
	 * code flow more readable, as well as makes it easy to allow people to
	 * reassign keypresses later.
	 * 
	 * <p> <strong>Note:</strong> Whoever is responsible for this class must 
	 * regularly call <code>update(elapsedTime)</code> so it can update its
	 * internal state.
	 * 
	 * @example The initialization and use of the Keyboard in your game.
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
	 *     keyboard.associateAction(ACTION_JUMP, Key.SPACE);
	 *     keyboard.associateAction(ACTION_DUCK, Key.DOWN);
	 *   }
	 * 
	 *   protected override function onUpdate(elapsedTime:Number):void
	 *   {
	 *     if (keyboard.isActionKeyJustPressed(ACTION_JUMP)
	 *       trace("Jump!");
	 *     if (keyboard.isActionKeyJustPressed(ACTION_DUCK)
	 *       trace("Duck!");
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
		}
		
		/**
		 * The keyboard class can handle key repeating when a user holds
		 * down a key.
		 * 
		 * <p> Key Delay represents the time (in milliseconds) to wait between
		 * the key first being pressed to the time it starts repeating.
		 * 
		 * <p> If this is set to 0 (or less), key repeating is disabled.
		 * 
		 * @see keyRepeat
		 */
		public function get keyDelay():Number { return _keyDelay; }
		public function set keyDelay(value:Number):void { _keyDelay = value; }

		/**
		 * The keyboard class can handle key repeating when a user holds
		 * down a key.
		 * 
		 * <p> Key Repeat represents the time to wait (in milliseconds) between
		 * each sending out additional between the key first
		 * being pressed to the time it starts repeating.
		 */
		public function get keyRepeat():Number { return _keyRepeat; }
		public function set keyRepeat(value:Number):void { _keyRepeat = value; }

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
		 * Internal handler for the KeyboardEvent.KEY_DOWN event.
		 */
		private function handleKeyDown(e:KeyboardEvent):void
		{
			
		}
		
		/**
		 * Internal handler for the KeyboardEvent.KEY_UP event.
		 */
		private function handleKeyUp(e:KeyboardEvent):void
		{
			
		}
		
		private var _dictActionToKey:Dictionary;
		private var _dictKeyToAction:Dictionary;
		
		private var _keyDelay:Number;
		private var _keyRepeat:Number;
	}

}