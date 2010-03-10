package efu.tween 
{
	import efme.game.EfNode;
	/**
	 * Base class for tweening. All <code>Tween</code> subclasses work on a
	 * target <code>EfNode</code>, transitioning it from some original
	 * value to some destination value.
	 * 
	 * <p> Use the <code>Tweener</code> class to concurrently drive a group of
	 * tweens.
	 * 
	 * @see Tweener#add
	 */
	public class Tween
	{
		/**
		 * Create a new Tween.
		 * 
		 * @param tweenLength The length of this tween, in ms. If 0, tween effect is instant.
		 * @param nextTween You can chain tweens. Set this to the next tween to update, after this one is done.
		 */
		public function Tween(tweenLength:uint, nextTween:Tween = null) 
		{
			_tweenLength = tweenLength;
			_nextTween = nextTween;
			
			_timeCounter = 0;
		}

		/**
		 * The length of this tween, in ms.
		 */
		public function get tweenLength():uint { return _tweenLength; }
		
		/**
		 * Update this tween. When it is finishes updating, it passes on the
		 * update call to the next tween, if set.
		 * 
		 * @param elapsedTime Time, in ms, that passed since the last frame
		 
		 * @return The last tween in the chain that was updated. This lets you know the next Tween to call update on next frame.
		 * 
		 * @example How to use <code>tween.update(...)</code> effectively when chaining tweens.
		 * <listing version="3.0">
		 * public function Constructor()
		 * {
		 *   node.X = 0.0;
		 *   _tweenHead = new TweenX(node, 100.0, 200, new TweenX(node, 0.0, 50));
		 * }
		 * 
		 * protected function update(elapsedTime:uint)
		 * {
		 *   if (_tweenHead != null)
		 *   {
		 *     _tweenHead = _tweenHead->update(elapsedTime);
		 *   }
		 * }
		 * </listing>
		 */
		final public function update(elapsedTime:uint):Tween
		{
			if (_timeCounter == 0)
			{
				onStartTween();
			}
			
			onUpdate(elapsedTime);
			
			var leftoverTime:uint = elapsedTime;
			
			if (_timeCounter < _tweenLength)
			{
				_timeCounter += elapsedTime;
				
				if (_timeCounter > _tweenLength)
				{
					leftoverTime = _timeCounter - _tweenLength;
					_timeCounter = _tweenLength;
				}
				else
				{
					leftoverTime = 0;
				}
			}

			var percentComplete:Number = (_timeCounter as Number) / (_tweenLength as Number);
			onTween(percentComplete);
			
			if (_timeCounter < _tweenLength)
			{
				return this;
			}
			else
			{
				if (_nextTween != null)
				{
					return _nextTween.update(leftoverTime);
				}
				else
				{
					return null;
				}
			}
		}
		
		/**
		 * Override this function to handle your tween just beginning.
		 * This is useful, for example, to initialize the starting point of
		 * your tween by checking a node's current value at this point.
		 */
		protected function onStartTween():void
		{
		}
		
		/**
		 * Override this function to perform direct handling of this tween.
		 * Most of the time, however, you can ignore this, and just handle
		 * <code>onTween(percentComplete)</code> instead.
		 */
		protected function onUpdate(elapsedTime:uint):void
		{
		}
		
		/**
		 * Override this function in a derived class to handle the tween.
		 */
		protected function onTween(percentComplete:Number):void
		{
		}
		
		private var _tweenLength:uint;
		private var _timeCounter:uint;
		private var _nextTween:Tween;
		// TODO: Add an acceleration value?
	}

}