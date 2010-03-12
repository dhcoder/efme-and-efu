package efu.tween 
{
	import efme.game.EfNode;
	
	/**
	 * Tween a node to some destination width
	 */
	public class TweenWidth extends Tween
	{
		public function TweenWidth(targetNode:EfNode, width:Number, tweenLength:uint, nextTween:Tween = null) 
		{
			super(tweenLength, nextTween);
			
			_targetNode = targetNode;
			_widthTo = width;
		}
		
		override protected function onStartTween():void 
		{
			_widthFrom = _targetNode.width;
		}
		
		override protected function onTween(percentComplete:Number):void 
		{
			_targetNode.width = _widthFrom + (percentComplete * (_widthTo - _widthFrom));
		}
		
		private var _targetNode:EfNode;
		
		private var _widthFrom:Number;
		private var _widthTo:Number;
	}

}