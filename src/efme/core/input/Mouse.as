package efme.core.input 
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	/**
	 * A class that represents the current mouse state.
	 * 
	 * <p> You can use <code>isPressed(button)</code>, 
	 * <code>isReleased(button)</code>, <code>isJustPressed(button)</code>, and
	 * <code>isJustReleased(button)</code> to check the state of any button on
	 * the mouse.
	 */
	public class Mouse
	{
		/**
		 * Mouse constructor. Takes a Flash stage and listens to the mouse
		 * input it receives.
		 */
		public function Mouse(stage:Stage) 
		{
			stage.addEventListener(MouseEvent.CLICK, handleMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}
		
		private function handleMouseDown(e:MouseEvent):void
		{
			trace("MOUSE DOWN");
		}
		
		private function handleMouseUp(e:MouseEvent):void 
		{
			
		}
	}

}