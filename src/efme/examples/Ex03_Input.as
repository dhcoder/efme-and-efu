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
		}
		
		override protected function onInit():void 
		{
			super.onInit();
			
			keyboard.associateAction(UserActions.MOVE_LEFT, Key.LEFT);
			keyboard.associateAction(UserActions.MOVE_RIGHT, Key.RIGHT);
			keyboard.associateAction(UserActions.SHOOT, Key.SPACE);
		}
		
		override protected function onUpdate(elapsedTime:Number):void 
		{
			super.onUpdate(elapsedTime);
			
			
		}
	}

}