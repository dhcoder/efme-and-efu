package efu.tween 
{
	import efme.game.EfNode;
	
	/**
	 * Tween a node to some destination X
	 */
	public class TweenX extends Tween
	{
		public function TweenX(targetNode:EfNode, x:Number, tweenLength:uint, nextTween:Tween = null) 
		{
			super(tweenLength, nextTween);
			
			_targetNode = targetNode;
			_xTo = x;
		}
		
		override protected function onStartTween():void 
		{
			_xFrom = _targetNode.x;
		}
		
		override protected function onTween(percentComplete:Number):void 
		{
			_targetNode.x = _xFrom + (percentComplete * (_xTo - _xFrom));
		}
		
		private var _targetNode:EfNode;
		
		private var _xFrom:Number;
		private var _xTo:Number;
	}

}