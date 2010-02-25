package efme.examples 
{
	import efme.core.input.Key;
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
		public function Ex03_Input() 
		{
			super(640, 480);
			start();
		}
		
		override protected function onInit():void 
		{
			super.onInit();
			
			keyboard.associateAction(UserActions.MOVE_LEFT, Key.LEFT);
			keyboard.associateAction(UserActions.MOVE_RIGHT, Key.RIGHT);
			keyboard.associateAction(UserActions.SHOOT, Key.SPACE);
			
			keyboard.addActionFiredHandler(UserActions.SHOOT, handleShoot);
			
			keyboard.addActionStateHandler(UserActions.MOVE_LEFT, handleMove);
			keyboard.addActionStateHandler(UserActions.MOVE_RIGHT, handleMove);
		}
		
		private function handleShoot(action:int):void
		{
			trace("BANG!", keyboard.getActionKeyHeldTime(action));
		}
		
		private function handleMove(action:int, actionEngaged:Boolean):void
		{
			if (actionEngaged)
			{
				if (action == UserActions.MOVE_LEFT)
				{
					trace("Moving left...");
				}
				else
				{
					trace("Moving right...");
				}
			}
			else
			{
				trace("Stopped");
			}
		}
	}

}