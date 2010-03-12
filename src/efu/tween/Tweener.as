package efu.tween 
{
	import efme.game.Callback;
	import efme.game.EfNode;
	import flash.utils.getTimer;
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
			var tweens:Vector.<Tween> = new Vector.<Tween>();
			tweens.push(new TweenX(targetNode, x, tweenLength));
			tweens.push(new TweenY(targetNode, y, tweenLength));
			
			return new TweenGroup(tweens, nextTween);
		}
		
		public static function tweenXYR(targetNode:EfNode, x:Number, y:Number, rotation:Number, tweenLength:uint, nextTween:Tween = null):TweenGroup
		{
			var tweens:Vector.<Tween> = new Vector.<Tween>();
			tweens.push(new TweenX(targetNode, x, tweenLength));
			tweens.push(new TweenY(targetNode, y, tweenLength));
			tweens.push(new TweenRotate(targetNode, rotation, tweenLength));
			
			return new TweenGroup(tweens, nextTween);
		}
		
		public function Tweener() 
		{
			_tweens = new Vector.<Tween>();
			_callbacks = new Vector.<Callback>();
		}
		
		public function add(tween:Tween, callback:Callback = null):void
		{
			_tweens.push(tween);
			_callbacks.push(callback);
		}
		
		public function clear():void
		{
			_tweens.splice(0, _tweens.length);
		}
		
		public function update(elapsedTime:uint):void
		{
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
					// Tween is finished
					if (_callbacks[nTween] != null)
					{
						_callbacks[nTween].call();
					}
					
					_tweens.splice(nTween, 1);
					_callbacks.splice(nTween, 1);
					
					--nTween;
				}
			}
		}
		
		private var _tweens:Vector.<Tween>;
		private var _callbacks:Vector.<Callback>;
	}

}