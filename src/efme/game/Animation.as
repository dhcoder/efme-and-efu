package efme.game
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
		 * A helper function which, assuming most animations in a tiled image go
		 * from left-to-right, top-to-bottom, lets you specify just the starting
		 * and ending tiles, and generates all frames in-between.
		 * 
		 * @param frameLength Specify the frame length if you want this animation to have a frame rate different from the default.
		 * 
		 * @example The result of calling makeFrames with various arguments.
		 * <listing version="3.0">
		 * makeFrames(0,0, 3,0);     // => [[0, 0], [1, 0], [2, 0], [3, 0]]
		 * makeFrames(0,0, 2,1);     // => [[0, 0], [1, 0], [2, 0], [0, 1], [1, 1], [2, 1]]
		 * </listing>
		 * 
		 * @see #makeFramesRow
		 * @see #makeFramesX
		 */
		public static function makeFrames(fromTileX:uint, fromTileY:uint, toTileX:uint, toTileY:uint, frameLength:uint = 0):Array
		{
			return makeFramesX(toTileX - fromTileX, fromTileX, fromTileY, toTileX, toTileY);
		}

		/**
		 * A helper function to create animation frames for animations contained
		 * in a single row, from left-to-right, in a tiled animation.
		 * 
		 * @param frameLength Specify the frame length if you want this animation to have a frame rate different from the default.
		 * 
		 * @example The result of calling makeFramesRow with various arguments.
		 * <listing version="3.0">
		 * makeFramesRow(0, 0,3);           // => [[0,0], [1,0], [2,0], [3,0]]
		 * makeFramesRow(1, 2,4);           // => [[2,1], [3,1], [4,1]]
		 * makeFramesRow(1, 2,4).reverse(); // => [[4,1], [3,1], [2,1]]
		 * </listing>
		 * 
		 * @see #makeFrames
		 * @see #makeFramesX
		 */
		public static function makeFramesRow(tileY:uint, fromTileX:uint, toTileX:uint, frameLength:uint = 0):Array
		{
			return makeFramesX(toTileX - fromTileX, fromTileX, tileY, toTileX, tileY, frameLength);
		}
		
		/**
		 * A helper function which, assuming most animations in a tiled image go
		 * from left-to-right, top-to-bottom, lets you specify just the starting
		 * and ending tiles, and generates all frames in-between.
		 * 
		 * <p> <code>makeFrames(...)</code> assumes that the number of x-tiles
		 * in your animation can be inferred from the <code>fromX</code> and 
		 * <code>toX</code> parameters. Call <code>makeFramesX(...)</code> when
		 * this assumption doesn't hold true.
		 * 
		 * @param numTilesX The number of x-tiles per row of this animation. This value is not used in the last row.
		 * @param frameLength Specify the frame length if you want this animation to have a frame rate different from the default.
		 * 
		 * @example The result of calling makeFramesX with various arguments.
		 * <listing version="3.0">
		 * makeFrames(0,0, 2,1);     // => [[0, 0], [1, 0], [2, 0], [0, 1], [1, 1], [2, 1]]
		 * makeFramesX(5, 0,0, 2,1); // => [[0,0], [1, 0], [2, 0], [3, 0], [4, 0], [0, 1], [1, 1], [2, 1]]
		 * </listing>
		 * 
		 * @see #makeFrames
		 * @see #makeFramesRow
		 */
		public static function makeFramesX(numTilesX:uint, fromTileX:uint, fromTileY:uint, toTileX:uint, toTileY:uint, frameLength:uint = 0):Array
		{
			if (toTileX >= fromTileX && toTileY >= fromTileY)
			{
				var frames:Array = new Array();
				var thisRowToTileX:uint = numTilesX - 1;
				
				for (var currTileY:uint = fromTileY; currTileY <= toTileY; ++currTileY)
				{
					if (currTileY == toTileY)
					{
						thisRowToTileX = toTileX;
					}
					
					for (var currTileX:uint = fromTileX; currTileX <= thisRowToTileX; ++currTileX)
					{
						var frame:Array;
						
						if (frameLength == 0)
						{
							frame = new Array(currTileX, currTileY);
						}
						else
						{
							frame = new Array(currTileX, currTileY, frameLength);
						}
						frames.push(frame);
					}
				}
				
				return frames;
			}
			else
			{
				throw new Error("Trying to make animation frames with a bad range.");
			}
			
		}
		
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