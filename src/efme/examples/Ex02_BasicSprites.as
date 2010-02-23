package efme.examples
{
	import efme.Engine;
	import efme.core.graphics2d.Image;
	import efme.core.support.Assets;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/*
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	
	
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLRequest;
	*/

	[SWF(width=640, height=480)]
	/**
	 * @private
	 * 
	 * A showcase of the most common features used when drawing sprites. This
	 * includes loading an image, drawing it, and animating it.
	 */
	public class Ex02_BasicSprites extends Engine
	{
//		[Embed(source = '../../../bin/example_data/image1.png')]private static const Img1:Class;
//		[Embed(source = '../../../bin/example_data/image1.png')]private static const Img2:Class;
		
		private var _timer:Timer;

		private var _image1:Image;
		private var _image2:Image;

		public function Ex02_BasicSprites()
		{
			super(640, 480);
			start();

			var assets:Assets = new Assets();
			
			_image1 = new Image();
			_image2 = new Image(128, 128);
			
			assets.requestImage("example_data/image_normal.png", _image1);
			assets.requestImage("example_data/image_tiled.png", _image2);
			
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
			_timer.start();
		}
		
		private function handleTimer(event:TimerEvent):void
		{
			screen.beginDraw();
			screen.clear();
			_image1.draw(screen, 50, 50);
			_image2.drawTile(screen, _timer.currentCount % 6, 0, 100, 100);
			screen.endDraw();
		}
	}
}