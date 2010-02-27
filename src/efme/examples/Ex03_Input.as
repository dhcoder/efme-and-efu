package efme.examples 
{
	import efme.core.input.Key;
	import efme.core.input.Mouse;
	import efme.examples.ex03.UserActions;
	import efme.GameEngine;

	[SWF(width=640, height=480)]
	/**
	 * @private
	 * 
	 * A demo of the keyboard and mouse features offered by EFME.
	 */
	public class Ex03_Input extends GameEngine
	{
		private static const SHOOT_RATE:int = 200; // Fire one shot every 200 ms
		private var _shootTimer:int;
		
		public function Ex03_Input() 
		{
			super(640, 480);
			start();
		}
		
		override protected function onInit():void 
		{
			super.onInit();
			
			// Associate keyboard actions
			keyboard.associateAction(UserActions.DUCK, Key.DOWN);
			keyboard.associateAction(UserActions.SHOOT, Key.SPACE);
		}
		
		override protected function onUpdate(elapsedTime:int):void 
		{
			super.onUpdate(elapsedTime);

			//
			// Testing the mouse state
			//
			
			if (mouse.isButtonJustPressed())
			{
				trace("Click at " + mouse.x + ", " + mouse.y);
			}
			else if (mouse.isButtonJustReleased())
			{
				trace("Mouse button released at " + mouse.x + ", " + mouse.y + ". You held the button down for " + mouse.getButtonHeldTime() / 1000.0 + " seconds!");
			}
			// if (mouse.isButtonPressed()) trace("SPAM: Holding mouse down!");
			
			//
			// Pattern to handle a repeating key. In this case, while
			// holding spacebar, shoot once every 200 ms.
			//
			
			if (keyboard.isActionKeyJustPressed(UserActions.SHOOT))
	 		{
				_shootTimer = 0;
	 		}
	 		if (keyboard.isActionKeyDown(UserActions.SHOOT))
	 		{
				if (_shootTimer <= 0)
				{
					handleShoot();
					_shootTimer += SHOOT_RATE;
				}

				_shootTimer -= elapsedTime;
	 		}

	 		//
			// Pattern to handle a held key. In this case, while
			// holding down... duck!!
			//

			if (keyboard.isActionKeyJustPressed(UserActions.DUCK))
	 		{
				handleDuck(true);
	 		}
	 		else if (keyboard.isActionKeyJustReleased(UserActions.DUCK))
	 		{
				handleDuck(false);
	 		}
		}
		
		private function handleShoot():void
		{
			trace("BANG!");
		}
		
		private function handleDuck(duck:Boolean):void
		{
			if (duck)
			{
				trace("Ducking...");
			}
			else
			{
				trace("Standing! You were ducking for " + keyboard.getActionKeyHeldTime(UserActions.DUCK) / 1000.0 + " seconds!");
			}
		}
	}

}