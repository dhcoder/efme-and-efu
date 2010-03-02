package efme.game.efnodes.support 
{
	import efme.core.graphics2d.Image;
	/**
	 * A class to handle the data of an animation.
	 * 
	 * <p> Breaking it down, animation data is a list of frames. Each frame
	 * has a tile coordinate and a length (in milliseconds). An animation is
	 * also associated with a source image.
	 * 
	 * <p> While you can specify the length of each frame individually, 
	 * you can also set a single default length to use for frames that don't
	 * have a length specified. Set this through the static
	 * <code>Animation.defaultFrameLength</code> property.
	 * 
	 * <p> Once you have created an animation, it is just static data. You can
	 * use the <code>AnimationState</code> class to actually play it.
	 * 
	 * @example Create a new animation. Note that <code>EfnSprite</code>s do
	 * this internally and you don't 
	 * <listing version="3.0">
	 * public class MyNode extends EfNode
	 * {
	 *   private var _animState:AnimationState;
	 *   public function MyNode()
	 *   {
	 *     var image:Image = ...; // Initialize image
	 * 
	 *     // Specify an animation with 4 frames. The first 3 frames take 100 ms
	 *     // (the default rate), while the last frame takes 1000 ms.
	 * 
	 *     var anim:Animation = new Animation(image, [[0,0], [0,1], [0,2], [1,0,1000]]);
	 *     _animState = new AnimationState(anim); // Loops by default
	 *   }
	 * 
	 *   public override function onUpdate(..., elapsedTime):void
	 *   {
	 *     _animState.update(elapsedTime);
	 *   }
	 * 
	 *   public override function onRender():void
	 *   {
	 *     var tilePos:TilePosition = _animState.getTilePosition();
	 *     image.drawTile(tilePos.X, tilePos.Y
	 *   }
	 * }
	 * </listing>
	 */
	public class Animation
	{
		/**
		 * Get or set the default frame length (in milleseconds).
		 * 
		 * <p> This property is actually part of the <code>AnimationState</code>
		 * class but is provided here for convenience (since some people work
		 * with <code>Animation</code>s but never <code>AnimationState</code>s.
		 */
		public static function get defaultFrameLength():uint { return AnimationState.defaultFrameLength; }
		public static function set defaultFrameLength(value:uint):void { AnimationState.defaultFrameLength = value; }

		/**
		 * Construct animation data.
		 * 
		 * @param sourceImage The image that this animation keys into.
		 * @param frames The frame data. An array of arrays, each child either having two items (tileX, tileY), or three (tileX, tileY, frame length)
		 * 
		 * @example Creating a simple animation with four frames. The fourth
		 * frame lasts for one second, the other three for the value of the
		 * <code>Animation.defaultFrameLength</code> property.
		 * <listing version="3.0">
		 * var image:Image = ...; // Initialize some image.
		 * var anim:Animation = new Animation(image, [[0, 0], [1, 0], [2, 0], [3, 0, 1000]]);
		 * </listing>
		 */
		public function Animation(sourceImage:Image, frames:Array)
		{
			// Validate incoming data
			for each (var frameInfo:Array in frames)
			{
				if (frameInfo.length != 2 && frameInfo.length != 3)
				{
					throw new Error("Animation frames data can only contain 2 (tileX, tileY) or 3 (tileX, tileY, frame length) values.");
				}
			}

			_sourceImage = sourceImage;
			_frames = frames;
		}
		
		public function get sourceImage():Image { return _sourceImage; }
		public function get frames():Array { return _frames; }
		
		private var _sourceImage:Image;
		private var _frames:Array;
	}

}