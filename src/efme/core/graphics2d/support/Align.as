package efme.core.graphics2d.support 
{
	import flash.text.TextFormatAlign;
	/**
	 * Simple alignment enumeration type.
	 */
	public class Align
	{
		public static const LEFT:int = 0;
		public static const CENTER:int = 1;
		public static const RIGHT:int = 2;
		public static const JUSTIFY:int = 3;
		
		public static function toString(alignment:int):String
		{
			switch (alignment) 
			{
				case LEFT: return TextFormatAlign.LEFT;
				case CENTER: return TextFormatAlign.CENTER;
				case RIGHT: return TextFormatAlign.RIGHT;
				case JUSTIFY: return TextFormatAlign.JUSTIFY;
				default: throw new Error("Called Align.toString() with bad alignment value.");
			}
			
		}
	}

}