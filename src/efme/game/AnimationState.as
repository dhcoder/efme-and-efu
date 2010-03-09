package efme.game
{
	import efme.core.graphics2d.support.TilePosition;
	import efme.core.graphics2d.Image;
	/**
	 * A class to handle the current state of an animation.
	 * 
	 * <p> Construct this class with animation data, and then use
	 * <code>update(elapsedTime)</code> which will progress through
	 * the animation.
	 */
	public class AnimationState
	{
		/**
		 * Get or set the default frame length (in milleseconds).
		 */
		public static function get defaultFrameLength():uint { return _defaultFrameLength; }
		public static function set defaultFrameLength(value:uint):void { _defaultFrameLength = value; }

		/**
		 * Construct this animation state with a target animation.
		 * 
		 * @param anim The target animation to track
		 * @param repeat Whether or not to loop this animation (default = false)
		 */
		public function AnimationState(targetAnim:Animation, repeat:Boolean = false)
		{
			_targetAnim = targetAnim;
			
			_repeat = repeat;

			_currentTile = new TilePosition();
			reset();
			
		}
		
		public function get targetAnim():Animation { return _targetAnim; }
		public function get currentTile():TilePosition { return _currentTile; }
		
		public function get isPlaying():Boolean { return !_stopped; }
		public function get isComplete():Boolean { return _animComplete; }
		
		public function get playTime():uint { return _timeCounter; }

		/**
		 * Start this animation from the beginning.
		 * 
		 * <p> To resume an animation from its current point, call
		 * <code>resume()</code>.
		 * 
		 * <p> To pause an animation, call <code>stop()</code>.
		 * 
		 * @param callbackAnimComplete For non-looping animations, you can specify a callback to be called when the animation is complete (default = null)
		 */
		public function start(callbackAnimComplete:Callback = null):void
		{
			reset();
			_callbackAnimComplete = callbackAnimComplete;
			_stopped = false;
		}

		/**
		 * Pause this animation.
		 */
		public function stop():void
		{
			_stopped = true;
		}
		
		/**
		 * Resume this animation from where it left off.
		 */
		public function resume():void
		{
			if (!_animComplete)
			{
				_stopped = false;
			}
		}
		
		/**
		 * Restart this animation back to the beginning.
		 */
		public function reset():void 
		{
			var firstFrameInfo:Array = targetAnim.frames[0];
			_currentTile.X = firstFrameInfo[0];
			_currentTile.Y = firstFrameInfo[1];
			
			_stopped = true;
			_animComplete = false;
			_callbackAnimComplete = null;
			
			_timeCounter = 0;
			_currentFrame = 0;
			_timeFrameStarted = 0;
		}
		
		public function update(elapsedTime:uint):void
		{
			if (!_stopped && !_animComplete)
			{
				_timeCounter += elapsedTime;

				var numFrames:uint = targetAnim.frames.length;
				var frameInfo:Array = targetAnim.frames[_currentFrame];
				var frameLen:uint = (frameInfo.length == 3 ? frameInfo[2] : _defaultFrameLength); // Use frame length if stores in 
				var nextFrameTime:uint = _timeFrameStarted + frameLen;
				
				if (_timeCounter > nextFrameTime)
				{
					if (_repeat || _currentFrame < numFrames - 1)
					{
						_currentFrame = (_currentFrame + 1) % numFrames;
						frameInfo = targetAnim.frames[_currentFrame];
						
						_timeFrameStarted = nextFrameTime;
						
						_currentTile.X = frameInfo[0];
						_currentTile.Y = frameInfo[1];
					}
					else
					{
						// Non-looping animation which just went past its last frame...
						_animComplete = true;
						_stopped = true;
						
						if (_callbackAnimComplete != null)
						{
							_callbackAnimComplete.call();
						}
					}
				}
			}
		}

		private static var _defaultFrameLength:uint = 100;

		private var _targetAnim:Animation;

		private var _currentTile:TilePosition;

		private var _repeat:Boolean;
	
		private var _timeCounter:uint;
		private var _currentFrame:uint;
		private var _timeFrameStarted:uint;

		private var _stopped:Boolean;
		private var _animComplete:Boolean;
		
		private var _callbackAnimComplete:Callback;
	}

}