package efme.examples
{
	import efme.core.graphics2d.DrawOptions;
	import efme.Engine;
	import efme.core.graphics2d.Image;
	import efme.core.support.Assets;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
			
			assets.requestImage("data/images/image_normal.png", _image1);
			assets.requestImage("data/images/image_tiled.png", _image2);
			
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
			_timer.start();
		}
		
		private function handleTimer(event:TimerEvent):void
		{
			screen.beginDraw();
			screen.clear();
//			_image1.draw(screen, new Point(50, 50));
//			_image2.draw(screen, new Point(0, 0));
	//		_image2.drawTile(screen, _timer.currentCount % 6, 0, new Point(100, _image2.height + 10));
		//	_image2.drawSub(screen, new Rectangle(20, 20, 80, 20), new Point(150, _image2.height * 2 + 20));
			
			var drawOptions:DrawOptions = new DrawOptions();
			drawOptions.flipX = true;
			drawOptions.flipY = true;

//			_image2.drawTile(screen, _timer.currentCount % 6, 0, new Point(0, 0));
			_image2.drawTile(screen, _timer.currentCount % 6, 0, new Point(0, 0), drawOptions);
			
			_image2.draw(screen, new Point(10, 200));
			//_image2.drawTile(screen, _timer.currentCount % 6, 0, new Point(100 + _image2.tileWidth + 10, _image2.height + 10), drawOptions);
			//_image2.drawTile(screen, _timer.currentCount % 6, 0, new Point(100 + _image2.tileWidth + 10, _image2.height + 10), drawOptions);

			
			screen.endDraw();
		}
	}
}