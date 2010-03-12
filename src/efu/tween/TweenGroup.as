package efu.tween 
{
	/**
	 * A tween container, allowing you to group a bunch of <code>Tweeen<code>s
	 * into a single, parent tween. You can then add this as part of a tween
	 * chain as a single link in the chain.
	 */
	public class TweenGroup extends Tween
	{
		public function TweenGroup(tweens:Vector.<Tween>, nextTween:Tween = null)
		{
			var tweenLength:uint = 0;
			var tween:Tween = null;
			
			for each (tween in tweens)
			{
				if (tweenLength < tween.tweenLength)
				{
					tweenLength = tween.tweenLength;
				}
			}
			
			super(tweenLength, nextTween);

			_tweens = new Vector.<Tween>();
			
			for each (tween in tweens)
			{
				if (tween.nextTween != null)
				{
					throw new Error("Tweens in tween groups cannot have their nextTween set.");
				}
				_tweens.push(tween);
			}
		}
		
		override protected function onUpdate(elapsedTime:uint):void 
		{
			for each (var tween:Tween in _tweens)
			{
				if (tween != null)
				{
					tween.update(elapsedTime);
				}
			}
		}
		
		private var _tweens:Vector.<Tween>;
	}

}