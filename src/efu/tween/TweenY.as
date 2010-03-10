package efu.tween 
{
	import efme.game.EfNode;
	
	/**
	 * Tween a node to some destination Y
	 */
	public class TweenY extends Tween
	{
		public function TweenY(targetNode:EfNode, y:Number, tweenLength:uint, nextTween:Tween = null) 
		{
			super(tweenLength, nextTween);
			
			_targetNode = targetNode;
			_yTo = y;
		}
		
		override protected function onStartTween():void 
		{
			_yFrom = _targetNode.y;
		}
		
		override protected function onTween(percentComplete:Number):void 
		{
			_targetNode.y = _yFrom + (percentComplete * (_yTo - _yFrom));
		}
		
		private var _targetNode:EfNode;
		
		private var _yFrom:Number;
		private var _yTo:Number;
	}

}