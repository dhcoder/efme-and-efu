package efu.tween 
{
	/**
	 */
	public class TweenGroup extends Tween
	{
		public function TweenGroup(tweenLength:uint, nextTween:Tween = null)
		{
			super(tweenLength, nextTween);
			
			_tweens = new Vector.<Tween>();
		}
		
		public function add(tween:Tween):void
		{
			_tweens.push(tween);
		}
		
		override protected function onUpdate(elapsedTime:uint):void 
		{
			for each (var tween:Tween in _tweens)
			{
				tween.update(elapsedTime);
			}
		}
		
		private var _tweens:Vector.<Tween>;
	}

}