package efme.core.input 
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
	/**
	 * A class that represents the current keyboard state.
	 * 
	 * <p> You can use <code>isPressed(key)</code>, 
	 * <code>isReleased(key)</code>, <code>isJustPressed(key)</code>, and
	 * <code>isJustReleased(key)</code> to check the state of any key on
	 * the keyboard.
	 * 
	 * <p> You can also optionally bind action names to keys, so that every
	 * time that key is pressed, you get a callback. This way, you can think of
	 * your game in terms of actions, rather than specific keys. This makes it
	 * easy for you to allow people to reassign keypresses later.
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
		}
		
		private function handleKeyDown(e:KeyboardEvent):void
		{
		}
		
		private function handleKeyUp(e:KeyboardEvent):void
		{
			
		}
		
		
	}

}