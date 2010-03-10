package efu.tween 
{
	import efme.game.EfNode;
	/**
	 * Class to drive a series of tweens.
	 * 
	 * @example How to use the tweener
	 * <listing version="3.0">
	 * var tweener:Tweener = new Tweener();
	 * var sprite:EfnSprite = new EfnSprite(...);
	 * 
	 * // Tween "sprite" from (0,0) to (100,100) over 200 ms, then fade to transparency over a second
	 * tweener.add(new TweenX(sprite, 100.0, 200));
	 * tweener.add(new TweenY(sprite, 100.0, 200));
	 * tweener.add(new TweenWait(200, new TweenAlpha(sprite, 0.0, 1000));
	 * 
	 * // Or, try a shortcut!
	 * tweener.add(Tweener.tweenXY(sprite, 100.0, 100.0, 200), new TweenAlpha(sprite, 0.0, 1000));
	 * </listing>
	 */
	public class Tweener
	{
		public static function tweenXY(targetNode:EfNode, x:Number, y:Number, tweenLength:uint, nextTween:Tween = null):TweenGroup
		{
			var tweenGroup:TweenGroup = new TweenGroup(tweenLength, nextTween);
			tweenGroup.add(new TweenX(targetNode, x, tweenLength));
			tweenGroup.add(new TweenY(targetNode, y, tweenLength));
			return tweenGroup;
		}
		
		public static function tweenXYR(targetNode:EfNode, x:Number, y:Number, rotation:Number, tweenLength:uint, nextTween:Tween = null):TweenGroup
		{
			var tweenGroup:TweenGroup = tweenXY(targetNode, x, y, tweenLength, nextTween);
			tweenGroup.add(new TweenRotate(targetNode, rotation, tweenLength));
			return tweenGroup;
		}
		
		public function Tweener() 
		{
			_tweens = new Vector.<Tween>();
		}
		
		public function add(tween:Tween):void
		{
			_tweens.push(tween);
		}
		
		public function update(elapsedTime:uint):void
		{
			if (_tweens.length > 0)
			{
				trace("IN:", _tweens.length);
			}
			
			for (var nTween:uint = 0; nTween < _tweens.length; ++nTween)
			{
				var tween:Tween = _tweens[nTween];
				tween = tween.update(elapsedTime);
				
				if (tween != null)
				{
					_tweens[nTween] = tween;
				}
				else
				{
					_tweens.splice(nTween, 1);
					--nTween;
				}
			}

			if (_tweens.length > 0)
			{
				trace("OUT:", _tweens.length);
			}

		}
		
		private var _tweens:Vector.<Tween>;
	}

}