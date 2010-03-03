package efme.game.efnodes 
{
	import efme.core.graphics2d.support.Align;
	import efme.core.graphics2d.TextArea;
	import efme.game.EfNode;
	import efme.game.GameState;
	import flash.geom.Point;
	/**
	 * An EfNode for rendering text onto the screen into a bounded area.
	 */
	public class EfnTextArea extends EfNode
	{
		public function EfnTextArea(gameState:GameState, text:String = "", size:uint = 10, width:Number = 0.0, height:Number = 0.0, align:int = Align.LEFT, font:String = "")
		{
			super(gameState);
			_textArea = new TextArea(text, size, width, height, align, font);
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Provide access to this node's text area. This is useful if you want
		 * to change any text settings after construction.
		 */
		public function get targetTextArea():TextArea { return _textArea; }
		
		override protected function onUpdate(offset:Point, elapsedTime:uint):void 
		{
			if (modified)
			{
				_textArea.maxWidth = width;
				_textArea.maxHeight = height;
			}
		}
		
		override protected function onRender():void 
		{
			_textArea.image.draw(engine.screen, new Point(x, y));
		}
		
		private var _textArea:TextArea;
	}

}