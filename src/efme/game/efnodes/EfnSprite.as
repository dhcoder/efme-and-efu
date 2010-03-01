package efme.game.efnodes 
{
	import efme.core.graphics2d.Image;
	import efme.core.graphics2d.support.DrawOptions;
	import efme.game.EfNode;
	import efme.game.GameState;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * An EfNode which can display static and animated images.
	 */
	public class EfnSprite extends EfNode
	{
		/**
		 * Create a new, empty sprite. If you want to set it to a single, static
		 * image, or at least set up an initial image, you can do so here.
		 * 
		 * <p> If a sprite's W/H values are set to 0, the target image's W/H
		 * is used when rendering.
		 * 
		 * <p> Change the image a sprite is pointing to using the
		 * <cod>targetImage</code> property.
		 * 
		 * <p> Use the <code>addAnimation(...)</code> and
		 * <code>playAnimation(...)</code> functions to use animations
		 * with this sprite.
		 * 
		 * @see #addAnimation
		 * 
		 * @param parentState The game state this node is part of
		 * @param image An image to set as this sprite's target.
		 * @param width The width of this node. Leave as 0 to use the target image's width.
		 * @param height The height of this node. Leave as 0 to use the target image's height.
		 */
		public function EfnSprite(parentState:GameState, image:Image = null, width:Number = 0.0, height:Number = 0.0)
		{
			super(parentState);
			_targetImage = image;
		}
		
		override protected function onRender():void 
		{
			if (_targetImage != null)
			{
				_targetImage.draw(engine.screen, new Point(50, 50), drawOptions);
			}
		}
		
		private var _dictAnims:Dictionary;
		private var _targetImage:Image;
		
	}

}