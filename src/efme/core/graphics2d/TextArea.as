package efme.core.graphics2d 
{
	import efme.core.graphics2d.support.Align;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * A class which represents a rectangular area within which text is
	 * bounded and drawn.
	 * 
	 * <p> To use a <code>TextArea</code>, first create one with the specified
	 * text and text settings. Then, to render it to the screen, you access
	 * its <code>Image</code> property <code>textImage</code> and call
	 * <code>textImage.draw(...)</code>.
	 * 
	 * <p> Finally, each time you change any setting of a <code>TextArea</code>,
	 * this causes a somewhat expensive operation as it updates itself. As a
	 * result, if you know you are going to change a batch of 
	 * <code>TextArea</code> settings, you will want to wrap them with
	 * <code>beginUpdate()/endUpdate()</code> calls.
	 * 
	 * @example Create and draw a TextArea
	 * <listing version = "3.0">
	 * private var _textArea:TextArea;
	 * 
	 * public function Constructor()
	 * {
	 *   TextArea.defaultFont = "Courier";
	 *   _textArea = new TextArea("Hello, world! Goodnight, moon!", 20, 100, 30, Align.CENTER); // 100 pixels wide, 30 pixels high.
	 * }
	 * 
	 * public override function onRender()
	 * {
	 *   _textArea.image.draw(screen, new Point(20, 20)
	 * }
	 * </listing>
	 */
	public class TextArea
	{
		/**
		 * Register an embedded font with this class. Any request to then
		 * use a font with the same name will use the embedded font instead
		 * of a system font.
		 */
		public static function registerEmbeddedFont(font:String):void
		{
			_embeddedFonts.push(font);
		}
		
		/**
		 * The default font (or font family) to use for rendering any
		 * TextArea that doesn't specify its own font.
		 * 
		 * <p> For more information on specifying a valid font, check out the
		 * documentation for the <code>font</code> property.
		 * 
		 * @see TextArea#font
		 */
		public static function get defaultFont():String { return _defaultFont; }
		public static function set defaultFont(value:String):void { _defaultFont = value; }
		
		/**
		 * The default text color to use for all <code>TextArea</code>s. If you
		 * want a particular <code>TextArea</code> to have a different value,
		 * set its <code>textColor</code>property.
		 */
		public static function get defaultTextColor():uint { return _defaultTextColor; }
		public static function set defaultTextColor(value:uint):void { _defaultTextColor = value; }

		public function TextArea(text:String = "", size:uint = 10, width:Number = 0.0, height:Number = 0.0, alignment:int = Align.LEFT, font:String = "") 
		{
			if (font == "") { font = _defaultFont; }
			
			_textField = new TextField();
			_textField.text = text;
			_textField.textColor = _defaultTextColor;
			_textField.multiline = true;
			_textField.wordWrap = true;
			
			_alignment = alignment;
			_width = width;
			_height = height;
			
			_textFormat = new TextFormat();
			_textFormat.size = size;
			_textFormat.font = font;
			_textFormat.leading = 3;
			
			if (_embeddedFonts.indexOf(font) >= 0)
			{
				_textField.embedFonts = true;
			}
			
			_textField.setTextFormat(_textFormat);
			
			_textImage = new Image();
			
			_isUpdating = true; // Start off in "update" mode; this will get turned off when the user accesses the "image" property for the first time
			_modified = true;
			
			
			renderTextToImage();
		}

		/**
		 * The current text this TextArea is set to.
		 * 
		 * <p> Sometimes, when you set a TextArea's text, it can't fit and there
		 * is leftover text. If you care about that leftover text, call
		 * <code>setText(text)</code> instead - it returns the leftover text
		 * that didn't get drawn.
		 * 
		 * @see #setText
		 */
		public function get text():String { return _textField.text; }
		public function set text(value:String):void
		{
			if (_textField.text != value)
			{
				_textField.text = value;
				_modified = true;
				renderTextToImage();
			}
		}

		/**
		 * The font size of this TextArea.
		 */
		public function get fontSize():uint { return _textFormat.size as uint; }
		public function set fontSize(value:uint):void
		{
			if (_textFormat.size as uint != value)
			{
				_textFormat.size = value;
				_modified = true;
				renderTextToImage();
			}
		}
		
		/**
		 * The text color of this TextArea.
		 */
		public function get textColor():uint { return _textField.textColor; }
		public function set textColor(value:uint):void
		{
			if (_textField.textColor != value)
			{
				_textField.textColor = value;
				_modified = true;
				renderTextToImage();
			}
		}
		
		/**
		 * The maximum width of this text area. When text hits this limit,
		 * it wraps.
		 * 
		 * <p> If set to 0.0 (or less), this indicates no maximum width is set.
		 */
		public function get width():Number { return _width; }
		public function set width(value:Number):void
		{
			if (_width != value)
			{
				_width = value;
				_modified = true;
				renderTextToImage()
			}
		}
		
		/**
		 * The maximum height of this text area. When text hits this limit,
		 * it is cut off.
		 * 
		 * <p> If set to 0.0 (or less), this indicates no maximum height is set.
		 */
		public function get height():Number { return _height; }
		public function set height(value:Number):void
		{
			if (_height != value)
			{
				_height = value;
				_modified = true;
				renderTextToImage();
			}
		}

		/**
		 * The alignment of this text area. 
		 */
		public function get alignment():int { return _alignment; }
		public function set alignment(value:int):void
		{
			if (_alignment != value)
			{
				_alignment = value;
				_modified = true;
				renderTextToImage();
			}
		}

		/**
		 * Adjust the spacing between the lines.
		 */
		public function get lineSpacing():uint { return _textFormat.leading as uint; }
		public function set lineSpacing(value:uint):void
		{
			if (_textFormat.leading != value)
			{
				_textFormat.leading = value;
				_modified = true;
				renderTextToImage();
			}
		}
		
		/**
		 * Adjust the font.
		 * 
		 * <p> If set to an empty string, this TextArea uses the value
		 * specified in the <code>defaultFont</code> property.
		 */
		public function get font():String { return _textFormat.font; }
		public function set font(value:String):void
		{
			if (value == "") { value = _defaultFont; }

			if (_textFormat.font != value)
			{
				_textFormat.font = value;
				_textField.embedFonts = _embeddedFonts.indexOf(font) >= 0;
				
				_modified = true;
				renderTextToImage();
			}
		}
		
		/**
		 * Get the current width of the text, in pixels. This should always
		 * be less than or equal to the width of this text area.
		 */
		public function get textWidth():Number { return _textField.textWidth; }

		/**
		 * Get the current height of the text, in pixels. This should always
		 * be less than or equal to the width of this text area.
		 */
		public function get textHeight():Number { return _textField.textHeight; }

		/**
		 * Return the underlying image that has the requested text rendered 
		 * on it. Use <code>textArea.image.draw(screen, ...)</code> to draw
		 * this text area's contents to the screen.
		 */
		// TODO: Delay creating this text area's image until first call to here
		public function get image():Image
		{
			if (_isUpdating)
			{
				endUpdate();
			}
			return _textImage;
		}

		/**
		 * Set this TextArea's text, and if there's any leftover text that
		 * didn't fit, return it.
		 * 
		 * <p> If you don't care about the leftover text, you are encouraged
		 * instead to use the <code>text</code> property.
		 * 
		 * @return Any leftover text that didn't fit in this TextArea.
		 * 
		 * @see #text
		 */
		public function setText(text:String):String
		{
			this.text = text;
			return "";
			// TODO TBI TextArea.setText!
		}

		/**
		 * If you are planning on making a batch set of text changes to this
		 * text area, surround that code with 
		 * <code>beginUpdate()/endUpdte()</code>.
		 */
		public function beginUpdate():void
		{
			_isUpdating = true;
		}
		
		/**
		 * @inheritDoc #beginUpdate
		 */
		public function endUpdate():void
		{
			_isUpdating = false;
			renderTextToImage();
		}
		
		/**
		 * Internally update our image with the latest text rendering at the
		 * current text settings.
		 * 
		 * This call is ignored if called between a beginUpdate()/endUpdate()
		 * pair.
		 */
		private function renderTextToImage():void
		{
			if (_isUpdating || !_modified) { return; }
			
			var bitmapData:BitmapData = _textImage.bitmapData;
			
			// Make sure text field is set up correctly
			if (_textFormat.font == "")
			{
				_textFormat.font = _defaultFont;
			}
			
			_textFormat.align = Align.toString(_alignment);
			
			var fudge:uint = 5; // Fudge factor to give a bit of extra width and height to the text area, because otherwise textField sometimes dumps text
			// TODO: Use TextBlock instead!
			
			_textField.setTextFormat(_textFormat);
			_textField.width = (_width > 0.0 ? _width : _textField.textWidth + fudge);
			_textField.height = (_height > 0.0 ? _height : _textField.textHeight + _textField.getLineMetrics(_textField.numLines - 1).descent + fudge);
			
			if (bitmapData == null || bitmapData.width < _textField.width || bitmapData.height < _textField.height)
			{
				bitmapData = new BitmapData(_textField.width, _textField.height, true, 0x00000000);
				_textImage.bitmapData = bitmapData;
			}
			else
			{
				bitmapData.fillRect(bitmapData.rect, 0x00000000);
			}
			
			bitmapData.draw(_textField);
			_modified = false;
		}

		private static var _defaultFont:String = "";
		private static var _defaultTextColor:uint = 0xFFFFFF;
		private static var _embeddedFonts:Vector.<String> = new Vector.<String>();
		
		private var _textField:TextField;
		private var _textFormat:TextFormat;

		private var _alignment:int;
		private var _width:Number;
		private var _height:Number;
		
		private var _textImage:Image;
		
		private var _isUpdating:Boolean;
		private var _modified:Boolean;
	}

}