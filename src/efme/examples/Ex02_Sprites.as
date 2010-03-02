package efme.examples
{
	import efme.GameEngine;
	import efme.examples.ex02.SpriteDemo;
	
	[SWF(width=640, height=480)]
	/**
	 * @private
	 * 
	 * A showcase of the most common features used when drawing sprites. This
	 * includes loading an image, drawing it, and animating it.
	 * 
	 * The classes you'll use in this demo.
	 * 
	 * - EfnSprite
	 * - Image
	 * - GameEngine (introduced in Ex. 01)
	 * - GameState
	 */
	public class Ex02_Sprites extends GameEngine
	{
		public function Ex02_Sprites()
		{
			super(640, 480);
			start();
		}
		
		override protected function onInit():void 
		{
			enterState(new SpriteDemo(this));
		}
	}
}