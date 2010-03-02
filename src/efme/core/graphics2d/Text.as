package efme.core.graphics2d 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * A class which encompases font data and font rendering. 
	 * 
	 * <p> It handles the details of converting an input string to an output
	 * <code>Image</code>, which you are then expected to call its
	 * <code>draw(...)</code> function on.
	 */
	public class Text
	{
		public function Text(text:String) 
		{
			_textField = new TextField();
			_textField.text = text;
			_textField.textColor = 0xFF0000;
			_textField.multiline = false;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.size = 50;
			
			_textField.setTextFormat(textFormat);
			
			_textImage = new Image();
			
			renderTextToImage();
		}
		
		public function get text():String { return _textField.text; }
		public function set text(value:String):void { _textField.text = value; renderTextToImage();  }
		
		public function get textImage():Image { return _textImage; }
		
		private function renderTextToImage():void
		{
			var bitmapData:BitmapData = _textImage.bitmapData;

			// Make sure text field is set up correctly
			_textField.width = _textField.textWidth;
			_textField.height = _textField.textHeight;
			
			if (bitmapData == null || bitmapData.width < _textField.textWidth || bitmapData.height < _textField.textHeight)
			{
				bitmapData = new BitmapData(640, 480, true, 0x00000000);
				_textImage.bitmapData = bitmapData;
				trace(bitmapData.width, bitmapData.height);
			}
			else
			{
				bitmapData.fillRect(bitmapData.rect, 0x00000000);
			}
			
			bitmapData.draw(_textField);
			trace(textImage.width, textImage.height);
		}
		
		private var _textField:TextField;
		private var _textImage:Image;
	}

}