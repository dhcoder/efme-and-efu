package efme.core.graphics2d 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	/**
	 * A base class for anything that can be drawn onto.
	 */
	public class Artist
	{
		public function Artist(graphics:Graphics) 
		{
			graphics = _graphics;
		}

		
		
		private var _graphics:Graphics;
		
	}

}