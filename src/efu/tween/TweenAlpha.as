package efu.tween 
{
	import efme.game.EfNode;
	
	/**
	 * Tween a node to some destination alpha
	 */
	public class TweenAlpha extends Tween
	{
		public function TweenAlpha(targetNode:EfNode, alpha:Number, tweenLength:uint, nextTween:Tween = null) 
		{
			super(tweenLength, nextTween);
			
			_targetNode = targetNode;
			_alphaTo = alpha;
		}
		
		override protected function onStartTween():void 
		{
			_alphaFrom = _targetNode.alpha;
		}
		
		override protected function onTween(percentComplete:Number):void 
		{
			_targetNode.alpha = _alphaFrom + (percentComplete * (_alphaTo - _alphaFrom));
		}
		
		private var _targetNode:EfNode;
		
		private var _alphaFrom:Number;
		private var _alphaTo:Number;
	}

}