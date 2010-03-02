package efme.examples.ex02 
{
	import efme.core.graphics2d.Image;
	import efme.core.graphics2d.Text;
	import efme.game.efnodes.EfnSprite;
	import efme.game.GameState;
	import efme.GameEngine;
	import flash.geom.Point;
	
	/**
	 * A basic game state for showing off sprites.
	 */
	public class SpriteTextDemo extends GameState
	{
		//
		// Animated cat 
		//
		
		private static const ANIM_WALK_LEFT:uint = 0;
		private var _catSprite:EfnSprite;
		
		private var _textTest:Text;

		/**
		 * Construct a new SpriteTextDemo. Initialize all the assets
		 * we will need.
		 */
		public function SpriteTextDemo(engine:GameEngine)
		{
			super(engine);
			
			var catImage:Image = new Image(128, 128);
			engine.assets.requestImage("data/images/image_tiled.png", catImage);
			
			_catSprite = new EfnSprite(this);
			_catSprite.width = 200;
			_catSprite.height = 250;
			_catSprite.addAnimation(ANIM_WALK_LEFT, catImage, [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0]]);
			
			_textTest = new Text("HELLO,\nWORLD");
		}

		/**
		 * Called when this game state is entered by the Game Engine.
		 */
		override protected function onEntered():void 
		{
			_catSprite.x = _catSprite.y = 100;
			_catSprite.startAnimation(ANIM_WALK_LEFT);
			
			efNodes.add(_catSprite);
		}
		
		
		override protected function onRenderForeground():void 
		{
			_textTest.textImage.draw(engine.screen, new Point(50, 50));
		}
	}

}