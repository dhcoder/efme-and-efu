package efme.examples
{
	import efme.core.graphics2d.DrawOptions;
	import efme.core.graphics2d.Image;
	import efme.core.support.Assets;
	import efme.GameEngine;

	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;


	[SWF(width=640, height=480)]
	/**
	 * @private
	 * 
	 * A showcase of the most common features used when drawing sprites. This
	 * includes loading an image, drawing it, and animating it.
	 */
	public class Ex02_Sprites extends GameEngine
	{
		private var _imageCatAnim:Image;
		
		private var _animRate:int;
		private var _tileX:uint;

		public function Ex02_Sprites()
		{
			super(640, 480);
			start();
		}
		
		override protected function onInit():void 
		{
			super.onInit();
			
			_imageCatAnim = new Image(128, 128);
			_animRate = 0;
			_tileX = 0;
			
			assets.requestImage("data/images/image_tiled.png", _imageCatAnim);
		}
		
		override protected function onUpdate(elapsedTime:int):void 
		{
			_animRate += elapsedTime;
			
			if (_animRate > 100)
			{
				_animRate = 0;
				_tileX = (_tileX + 1) % _imageCatAnim.numTilesX;
			}
		}
		
		override protected function onRenderBackground():void 
		{
			super.onRenderBackground();

			var drawOptions:DrawOptions = new DrawOptions();
//			drawOptions.rotate = (_timer.currentCount % 180) * 2;
			//drawOptions.flipX = (_timer.currentCount % 360) > 180;

//			var tileX:uint = (_timer.currentCount % (_image2.numTilesX * rate)) / rate;

			//_image2.drawTile(screen, tileX, 0, new Point(80, 80), drawOptions);

			//drawOptions.alpha = (_timer.currentCount % 70) / 100.0 + .3;
			_imageCatAnim.drawTile(screen, _tileX, 0, new Point(128, 128), drawOptions);
			drawOptions.alpha = .5;
			_imageCatAnim.drawTile(screen, (_tileX + 1) % _imageCatAnim.numTilesX, 0, new Point(128, 128), drawOptions);

			/*
			
			drawOptions.rotateAnchor = Anchor.TOP_LEFT;
			_image2.drawTile(screen, tileX, 0, new Point(128, 128), drawOptions);

			drawOptions.rotateAnchor = Anchor.TOP_MIDDLE;
			_image2.drawTile(screen, tileX, 0, new Point(384, 128), drawOptions);

			drawOptions.rotateAnchor = Anchor.TOP_RIGHT;
			_image2.drawTile(screen, tileX, 0, new Point(640, 128), drawOptions);

			drawOptions.rotateAnchor = Anchor.LEFT;
			_image2.drawTile(screen, tileX, 0, new Point(128, 384), drawOptions);

			drawOptions.rotateAnchor = Anchor.MIDDLE;
			_image2.drawTile(screen, tileX, 0, new Point(384, 384), drawOptions);

			drawOptions.rotateAnchor = Anchor.RIGHT;
			_image2.drawTile(screen, tileX, 0, new Point(640, 384), drawOptions);

			drawOptions.rotateAnchor = Anchor.BOTTOM_LEFT;
			_image2.drawTile(screen, tileX, 0, new Point(128, 640), drawOptions);

			drawOptions.rotateAnchor = Anchor.BOTTOM_MIDDLE;
			_image2.drawTile(screen, tileX, 0, new Point(384, 640), drawOptions);

			drawOptions.rotateAnchor = Anchor.BOTTOM_RIGHT;
			_image2.drawTile(screen, tileX, 0, new Point(640, 640), drawOptions);
			*/
		}
	}
}