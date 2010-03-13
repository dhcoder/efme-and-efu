package efme.game.efnodes 
{
	import efme.core.graphics2d.Image;
	import efme.core.graphics2d.support.Align;
	import efme.core.graphics2d.TextArea;
	import efme.game.EfNode;
	import efme.game.GameState;
	import flash.geom.Point;
	import flash.utils.getTimer;
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
			
			updateDefaultSize();
		}
		
		public function get text():String { return _textArea.text; }
		public function set text(value:String):void
		{
			if (_textArea.text != value)
			{
				_textArea.text = value;
				updateDefaultSize();
			}
		}
		
		public function get fontSize():uint { return _textArea.fontSize; }
		public function set fontSize(value:uint):void
		{
			if (_textArea.fontSize != value)
			{
				_textArea.fontSize = value;
				updateDefaultSize();
			}
		}

		public function get textColor():uint { return _textArea.textColor; }
		public function set textColor(value:uint):void
		{
			if (_textArea.textColor != value)
			{
				_textArea.textColor = value;
			}
		}

		public function get alignment():int { return _textArea.alignment; }
		public function set alignment(value:int):void
		{
			if (_textArea.alignment != value)
			{
				_textArea.alignment = value;
			}
		}

		public function get lineSpacing():uint { return _textArea.alignment; }
		public function set lineSpacing(value:uint):void
		{
			if (_textArea.lineSpacing != value)
			{
				_textArea.lineSpacing = value;
				updateDefaultSize();
			}
		}

		// TODO: Embedded font
		
		public function get font():String { return _textArea.font; }
		public function set font(value:String):void
		{
			if (_textArea.font != value)
			{
				_textArea.font = value;
				updateDefaultSize();
			}
		}

		public function get textWidth():Number { return _textArea.textWidth; }
		public function get textHeight():Number { return _textArea.textHeight; }
		
		public function beginUpdate():void { _textArea.beginUpdate(); }
		public function endUpdate():void { _textArea.endUpdate(); updateDefaultSize();  }
		
		override protected function onUpdate(offset:Point, elapsedTime:uint):void 
		{
			if (modified)
			{
				var DEBUG_TIMER:int;
				DEBUG_TIMER = getTimer();
				
				_textArea.beginUpdate();
				_textArea.width = width;
				_textArea.height = height;
				_textArea.endUpdate();
				
				DEBUG_TIMER = getTimer() - DEBUG_TIMER;
				
				if (DEBUG_TIMER > 3)
				{
					trace("LONG TEXT AREA UPDATE:", DEBUG_TIMER, this.text);
				}
			}
		}
		
		override protected function onRender():void 
		{
			_textArea.image.draw(engine.screen, new Point(x, y), drawOptions);
		}
		
		/**
		 * Update this node's default size, depending on the current
		 * target textArea settings.
		 */
		private function updateDefaultSize():void
		{
			defaultWidth = _textArea.textWidth;
			defaultHeight = _textArea.textHeight;
		}
		
		private var _textArea:TextArea;
	}

}