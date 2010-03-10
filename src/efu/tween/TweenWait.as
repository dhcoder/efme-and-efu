package efu.tween 
{
	/**
	 * A tween spacer, one that does nothing but wait. Useful to interject
	 * between tweens.
	 */
	public class TweenWait extends Tween
	{
		public function TweenWait(tweenLength:uint, nextTween:Tween) 
		{
			super(tweenLength, nextTween);
		}
	}

}