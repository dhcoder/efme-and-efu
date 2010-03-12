package efu.tween 
{
	import efme.game.EfNode;
	
	/**
	 * Tween a node to some destination height
	 */
	public class TweenHeight extends Tween
	{
		public function TweenHeight(targetNode:EfNode, height:Number, tweenLength:uint, nextTween:Tween = null) 
		{
			super(tweenLength, nextTween);
			
			_targetNode = targetNode;
			_heightTo = height;
		}
		
		override protected function onStartTween():void 
		{
			_heightFrom = _targetNode.height;
		}
		
		override protected function onTween(percentComplete:Number):void 
		{
			_targetNode.height = _heightFrom + (percentComplete * (_heightTo - _heightFrom));
		}
		
		private var _targetNode:EfNode;
		
		private var _heightFrom:Number;
		private var _heightTo:Number;
	}

}