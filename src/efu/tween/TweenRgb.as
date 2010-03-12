package efu.tween 
{
	import efme.core.graphics2d.support.Color;
	import efme.game.EfNode;
	
	/**
	 * Tween a node to some destination color
	 */
	public class TweenRGB extends Tween
	{
		public function TweenAlpha(targetNode:EfNode, color:uint, tweenLength:uint, nextTween:Tween = null) 
		{
			super(tweenLength, nextTween);
			
			_targetNode = targetNode;

			var colorTo:Color = new Color(color);
			
			_rTo = colorTo.r;
			_gTo = colorTo.g;
			_bTo = colorTo.b;
		}
		
		override protected function onStartTween():void 
		{
			var colorFrom:Color = new Color(_targetNode.color);
			
			_rFrom = colorFrom.r;
			_gFrom = colorFrom.g;
			_bFrom = colorFrom.b;
		}
		
		override protected function onTween(percentComplete:Number):void 
		{
			var _rTween:uint = _rFrom + (percentComplete * (_rTo - _rFrom));
			var _gTween:uint = _gFrom + (percentComplete * (_gTo - _gFrom));
			var _bTween:uint = _bFrom + (percentComplete * (_bTo - _bFrom));
			
			_targetNode.color = Color.hexFromRgb(_rTween, _gTween, _bTween);
		}
		
		private var _targetNode:EfNode;
		
		private var _rFrom:uint;
		private var _gFrom:uint;
		private var _bFrom:uint;
		private var _rTo:uint;
		private var _gTo:uint;
		private var _bTo:uint;
	}

}