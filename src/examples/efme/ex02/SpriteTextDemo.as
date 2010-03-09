package efme.examples.ex02 
{
	import efme.core.graphics2d.Image;
	import efme.core.graphics2d.support.Align;
	import efme.game.Alarm;
	import efme.game.Callback;
	import efme.game.efnodes.EfnSprite;
	import efme.game.efnodes.EfnTextArea;
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
		private var _textArea:EfnTextArea;

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
			_catSprite.addAnimation(ANIM_WALK_LEFT, catImage, [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0], [5, 0]]);
			// Note, same as addAnimation(ANIM_WALK_LEFT, catImage, Animation.makeFramesRow(0, 0, 5));
			
			_textArea = new EfnTextArea(this, "HELLO, WORLD", 20, 200, 0.0, Align.RIGHT);
		}

		/**
		 * Called when this game state is entered by the Game Engine.
		 */
		override protected function onEntered():void 
		{
			_catSprite.x = _catSprite.y = 100;
			_catSprite.startAnimation(ANIM_WALK_LEFT);
			
			_catSprite.alarms.add(new Alarm(1000, new Callback(meow)));
			_catSprite.alarms.add(new Alarm(1500, new Callback(meow, "Unya??"), false), true, false);
			
			_textArea.x = _textArea.y = 100;
			
			efNodes.add(_catSprite);
			efNodes.add(_textArea);
		}
		
		private var _total:uint = 0;
		override protected function onUpdate(elapsedTime:uint):void 
		{
			_total += elapsedTime;
			
			if (_total > 20)
			{
				_total = 0;
				_textArea.width--;
				
				if (_textArea.width == 20)
				{
					_textArea.width = 200;
				}
			}
		}
		
		private function meow(cry:String = "UNYAAAA!"):void
		{
			trace(cry);
		}
	}

}