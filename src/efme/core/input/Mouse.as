package efme.core.input 
{
	import flash.ui.Mouse;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	
	/**
	 * A class that represents the current mouse state.
	 * 
	 * <p> The <code>x</code> and <code>y</code> properties will give you
	 * the screen coordinates where the mouse is located.
	 * 
	 * <p> Furthermore, you can use <code>isButtonPressed()</code>,
	 * <code>isButtonReleased()</code>, <code>isButtonJustPressed()</code>,
	 * <code>isButtonJustReleased()</code> to check the state of the mouse's
	 * left button.
	 * 
	 * <p> <strong>Note:</strong> Flash doesn't expose the pressed state of
	 * middle and right mouse buttons.
	 */
	public class Mouse
	{
		/**
		 * Whether or not the system cursor is shown when the user mouses over
		 * your application. (Default = true)
		 */
		public static function get showSystemCursor():Boolean { return _showSystemCursor }
		public static function set showSystemCursor(value:Boolean):void
		{
			if (value)
			{
				flash.ui.Mouse.show();
				_showSystemCursor = true;
			}
			else
			{
				flash.ui.Mouse.hide();
				_showSystemCursor = false;
			}
		}

		/**
		 * Mouse constructor. Takes a Flash stage and listens to the mouse
		 * input it receives.
		 * 
		 * @param scale Scale factor used to initialize this game, as the
		 * <code>x</code>/<code>y</code> coordinates should be adjusted to
		 * account for it.
		 */
		public function Mouse(stage:Stage, scale:Number = 1.0) 
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			
			_x = _y = 0.0;
			_scale = scale;
		}
		
		/**
		 * The current x-coordinate of the mouse in your game.
		 */
		public function get x():Number { return _x; }

		/**
		 * The current x-coordinate of the mouse in your game.
		 */
		public function get y():Number { return _y; }
		
		/**
		 * Update the mouse's internal state.
		 * 
		 * <p> This must be done regularly, or else the "just pressed/released" 
		 * button tests won't work.
		 * 
		 * <p> Also, because of the implementation specifics, you have to
		 * call this function AFTER you call update on all of your own
		 * objects.
		 * 
		 * @param elapsedTime How much time has elapsed (in ms) since the last call to update.
		 */
		public function update(elapsedTime:uint):void
		{
			_buttonDownPrev = _buttonDownCurr;
			
			if (_buttonDownCurr)
			{
				_buttonHeldTime += elapsedTime;
			}
			else
			{
				_buttonHeldTime = 0;
			}
		}

		/**
		 * Test if the left button is currently held down.
		 */
		public function isButtonPressed():Boolean
		{
			return _buttonDownCurr;
		}
		
		/**
		 * Test if the left button is currently released.
		 */
		public function isButtonReleased():Boolean
		{
			return !_buttonDownCurr;
		}

		/**
		 * Test if the left button was just pressed down this frame.
		 */
		public function isButtonJustPressed():Boolean
		{
			return _buttonDownCurr && !_buttonDownPrev;
		}
		
		/**
		 * Test if the left button was just released this frame.
		 */
		public function isButtonJustReleased():Boolean
		{
			return !_buttonDownCurr && _buttonDownPrev;
		}

		/**
		 * Get the number of milliseconds the left button has been held down.
		 */
		public function getButtonHeldTime():int
		{
			return _buttonHeldTime;
		}

		/**
		 * Internal handler for the MouseEvent.MOUSE_DOWN event.
		 */
		private function handleMouseDown(e:MouseEvent):void
		{
			_buttonDownCurr = true;
			_buttonHeldTime = 0;
		}
		
		/**
		 * Internal handler for the MouseEvent.MOUSE_UP event.
		 */
		private function handleMouseUp(e:MouseEvent):void 
		{
			_buttonDownCurr = false;
		}

		/**
		 * Internal handler for the MouseEvent.MOUSE_MOVE event.
		 */
		private function handleMouseMove(e:MouseEvent):void
		{
			_x = e.stageX / _scale;
			_y = e.stageY / _scale;
		}
		
		private static var _showSystemCursor:Boolean = true;

		private var _x:Number;
		private var _y:Number;
		private var _scale:Number;
		
		private var _buttonDownCurr:Boolean;
		private var _buttonDownPrev:Boolean;
		private var _buttonHeldTime:int;
		
	}

}