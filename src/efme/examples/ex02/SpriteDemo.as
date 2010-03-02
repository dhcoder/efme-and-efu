package efme.examples.ex02 
{
	import efme.core.graphics2d.Image;
	import efme.game.efnodes.EfnSprite;
	import efme.game.GameState;
	import efme.GameEngine;
	
	/**
	 * A basic game state for showing off sprites.
	 */
	public class SpriteDemo extends GameState
	{
		private static const ANIM_WALK_LEFT:uint = 0;
		
		private var _catSprite:EfnSprite;
		
		/**
		 * Construct a new SpriteDemo GameState. Initialize all the assets
		 * we will need.
		 */
		public function SpriteDemo(engine:GameEngine)
		{
			super(engine);
			
			var catImage:Image = new Image(128, 128);
			engine.assets.requestImage("data/images/image_tiled.png", catImage);
			
			_catSprite = new EfnSprite(this);
			_catSprite.width = 200;
			_catSprite.height = 250;
			_catSprite.addAnimation(ANIM_WALK_LEFT, catImage, [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0]]);
		}

		/**
		 * 
		 */
		override protected function onEntered():void 
		{
			_catSprite.x = _catSprite.y = 100;
			_catSprite.startAnimation(ANIM_WALK_LEFT);
			
			efNodes.add(_catSprite);
		}
	}

}