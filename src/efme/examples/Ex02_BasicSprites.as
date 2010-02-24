package efme.examples
{
	import efme.core.graphics2d.AnchorStyle;
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
			
			_timer = new Timer(40);
			_timer.addEventListener(TimerEvent.TIMER, handleTimer);
			_timer.start();
		}
		
		private function handleTimer(event:TimerEvent):void
		{
			if (_image1.bitmapData == null || _image2.bitmapData == null)
			{
				return;
			}

			screen.beginDraw();
			screen.clear();
			
			var drawOptions:DrawOptions = new DrawOptions();
			drawOptions.rotate = (_timer.currentCount % 180) * 2;
			//drawOptions.flipX = (_timer.currentCount % 360) > 180;

			var rate:uint = 3;
			var tileX:uint = (_timer.currentCount % (_image2.numTilesX * rate)) / rate;

			//_image2.drawTile(screen, tileX, 0, new Point(80, 80), drawOptions);

			//drawOptions.alpha = (_timer.currentCount % 70) / 100.0 + .3;
			_image2.drawTile(screen, tileX, 0, new Point(128, 128), drawOptions);

			/*
			
			drawOptions.rotateAnchor = AnchorStyle.TOP_LEFT;
			_image2.drawTile(screen, tileX, 0, new Point(128, 128), drawOptions);

			drawOptions.rotateAnchor = AnchorStyle.TOP_MIDDLE;
			_image2.drawTile(screen, tileX, 0, new Point(384, 128), drawOptions);

			drawOptions.rotateAnchor = AnchorStyle.TOP_RIGHT;
			_image2.drawTile(screen, tileX, 0, new Point(640, 128), drawOptions);

			drawOptions.rotateAnchor = AnchorStyle.LEFT;
			_image2.drawTile(screen, tileX, 0, new Point(128, 384), drawOptions);

			drawOptions.rotateAnchor = AnchorStyle.MIDDLE;
			_image2.drawTile(screen, tileX, 0, new Point(384, 384), drawOptions);

			drawOptions.rotateAnchor = AnchorStyle.RIGHT;
			_image2.drawTile(screen, tileX, 0, new Point(640, 384), drawOptions);

			drawOptions.rotateAnchor = AnchorStyle.BOTTOM_LEFT;
			_image2.drawTile(screen, tileX, 0, new Point(128, 640), drawOptions);

			drawOptions.rotateAnchor = AnchorStyle.BOTTOM_MIDDLE;
			_image2.drawTile(screen, tileX, 0, new Point(384, 640), drawOptions);

			drawOptions.rotateAnchor = AnchorStyle.BOTTOM_RIGHT;
			_image2.drawTile(screen, tileX, 0, new Point(640, 640), drawOptions);
			*/
			
			screen.endDraw();
		}
	}
}