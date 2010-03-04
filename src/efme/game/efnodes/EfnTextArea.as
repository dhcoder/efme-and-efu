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
		public function EfnTextArea(gameState:GameState, text:String = "", size:uint = 10, width:Number = 0.0, height:Number = 0.0, textColor:uint = 0xFFFFFF, align:int = Align.LEFT, font:String = "")
		{
			super(gameState);
			_textArea = new TextArea(text, size, width, height, textColor, align, font);
			this.width = width;
			this.height = height;
		}
		
		public function get text():String { return _textArea.text; }
		public function set text(value:String):void { _textArea.text = value; }
		
		public function get size():uint { return _textArea.size; }
		public function set size(value:uint):void { _textArea.size = value; }

		public function get textColor():uint { return _textArea.textColor; }
		public function set textColor(value:uint):void { _textArea.textColor = value; }

		public function get alignment():int { return _textArea.alignment; }
		public function set alignment(value:int):void { _textArea.alignment = value; }

		public function get lineSpacing():uint { return _textArea.alignment; }
		public function set lineSpacing(value:uint):void { _textArea.alignment = value; }

		public function get font():String { return _textArea.font; }
		public function set font(value:String):void { _textArea.font = value; }

		public function get textWidth():Number { return _textArea.textWidth; }
		public function get textHeight():Number { return _textArea.textHeight; }
		
		public function beginUpdate():void { _textArea.beginUpdate(); }
		public function endUpdate():void { _textArea.endUpdate(); }
		
		override protected function onUpdate(offset:Point, elapsedTime:uint):void 
		{
			if (modified)
			{
				_textArea.beginUpdate();
				_textArea.width = width;
				_textArea.height = height;
				_textArea.endUpdate();
			}
		}
		
		override protected function onRender():void 
		{
			_textArea.image.draw(engine.screen, new Point(x, y));
		}
		
		private var _textArea:TextArea;
	}

}