package efme.game.efnodes.support 
{
	import efme.core.graphics2d.Image;
	/**
	 * A class to handle the data and timing of an animation.
	 * 
	 * @example Create a new animation.
	 * <listing version="3.0">
	 * var image:Image = ...; // Initialize image
	 * 
	 * // Specify an animation with 4 frames. The first 3 frames take 300 ms
	 * // (the default rate), while the last frame takes 1000 ms.
	 * 
	 * var anim:Animation = new Animation(image, [[0,0], [0,1], [0,2], [1,0,1000]], Animation.LOOP);
	 * </listing>
	 */
	public class Animation
	{
		/**
		 * Return the default frame length (in milleseconds)
		 */
		public static function get defaultFrameLength():uint { return _defaultFrameLength; }
		public static function set defaultFrameLength(value:uint):void { _defaultFrameLength = value; }
		
		public function Animation(sourceImage:Image, frames:Array, repeat:Boolean)
		{
			// Validate incoming data
			for (var frameInfo:Array in frames)
			{
				if (frameInfo.length != 2 && frameInfo.length != 3)
				{
					throw new Error("Animation frames data can only contain 2 (tileX, tileY) or 3 (tileX, tileY, frame length) values.");
				}
			}

			_sourceImage = sourceImage;
			_frames = frames;
			_repeat = animType;
			
			_currentTile = new TilePosition(0, 0);
			
			_timeCounter = 0;
			_currentFrame = 0;
			_timeFrameStarted = 0;
		}
		
		public function get sourceImage():Image { return _sourceImage; }
		public function get currentTile():TilePosition { return _currentTile; }
		
		public function update(elapsedTime:uint):void
		{
			// Always update if we're repeating, but if this is a play-once
			// animation, don't bother repeating if we get to the last frame.
			if (_repeat || _currentFrame < _frames.length - 1)
			{
				_timeCounter += elapsedTime;
				
				var frameInfo:Array = _frames[_currentFrame];
				var frameLen:uint = (frameInfo.length == 3 ? frameInfo[2] : _defaultFrameLength); // Use frame length if stores in 
				var nextFrameTime:uint = _timeFrameStarted + frameLen;
				
				if (_timeCounter > nextFrameTime)
				{
					_currentFrame = (_currentFrame + 1) % _frames.length;
					_timeFrameStarted = nextFrameTime;
					
					_currentTile.tileX = frameInfo[0];
					_currentTile.tileY = frameInfo[1];
				}
			}
		}
		
		private static var _defaultFrameLength:uint = 300;

		private var _sourceImage:Image;
		private var _frames:Array;
		private var _repeat:Boolean;
		
		private var _currentTile:TilePosition;

		private var _timeCounter:uint;
		private var _currentFrame:uint;
		private var _timeFrameStarted:uint;
	}

}