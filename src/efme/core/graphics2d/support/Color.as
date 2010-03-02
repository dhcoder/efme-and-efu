package efme.core.graphics2d.support 
{
	/**
	 * A convenience class to help convert colors between uint and r, g, b
	 * values.
	 */
	public class Color
	{
		public static function colorFromRgb(r:uint, g:uint, b:uint):Color
		{
			return new Color(hexFromRgb(r, g, b));
		}
		
		public static function hexFromRgb(r:uint, g:uint, b:uint):uint
		{
			r &= 0xFF;
			g &= 0xFF;
			b &= 0xFF;
			
			return (r << 16) | (g << 8) | b;
		}
		
		public static function blendColors(hexValueLhs:uint, hexValueRhs:uint):uint
		{
			var colorLhs:Color = new Color(hexValueLhs);
			var colorRhs:Color = new Color(hexValueRhs);
			
			colorLhs.blendWith(colorRhs);
			
			return colorLhs.hexValue;
		}
		
		public function Color(hexValue:uint = 0xFFFFFF) 
		{
			_r = (hexValue & 0xFF0000) >> 16;
			_g = (hexValue & 0x00FF00) >> 8;
			_b = (hexValue & 0x0000FF);
		}

		/**
		 * The hex value of this color.
		 */
		public function get hexValue():uint
		{
			return hexFromRgb(_r, _g, _b);
		}
		
		/**
		 * The red component of this color.
		 */
		public function get r():uint { return _r; }
		public function set r(value:uint):void { _r = (value & 0xFF); }

		/**
		 * The green component of this color.
		 */
		public function get g():uint { return _g; }
		public function set g(value:uint):void { _g = (value & 0xFF); }

		/**
		 * The blue component of this color.
		 */
		public function get b():uint { return _b; }
		public function set b(value:uint):void { _b = (value & 0xFF); }
		

		/**
		 * Blend this color with specified color.
		 */
		public function blendWith(colorRhs:Color):void
		{
			_r = ((_r * colorRhs._r) / 255);
			_g = ((_g * colorRhs._g) / 255);
			_b = ((_b * colorRhs._b) / 255);
		}
		
		private var _r:uint;
		private var _g:uint;
		private var _b:uint;
	}

}