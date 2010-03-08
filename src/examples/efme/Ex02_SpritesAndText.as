package efme.examples
{
	import efme.GameEngine;
	import efme.examples.ex02.SpriteTextDemo;
	
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
	 * - EfnTextArea
	 * - Image
	 * - GameEngine (introduced in Ex. 01)
	 * - GameState
	 */
	public class Ex02_SpritesAndText extends GameEngine
	{
		public function Ex02_SpritesAndText()
		{
			super(640, 480);
			start();
		}
		
		override protected function onInit():void 
		{
			enterState(new SpriteTextDemo(this));
		}
	}
}