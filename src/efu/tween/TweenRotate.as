package efu.tween 
{
	import efme.game.EfNode;
	
	/**
	 * Tween a node to some destination rotation
	 */
	public class TweenRotate extends Tween
	{
		public function TweenRotate(targetNode:EfNode, rotation:Number, tweenLength:uint, nextTween:Tween = null) 
		{
			super(tweenLength, nextTween);
			
			_targetNode = targetNode;
			_rotationTo = rotation;
		}
		
		override protected function onStartTween():void 
		{
			_rotationFrom = _targetNode.rotation;
		}
		
		override protected function onTween(percentComplete:Number):void 
		{
			_targetNode.rotation = _rotationFrom + (percentComplete * (_rotationTo - _rotationFrom));
		}
		
		private var _targetNode:EfNode;
		
		private var _rotationFrom:Number;
		private var _rotationTo:Number;
	}

}