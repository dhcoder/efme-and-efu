package efme.examples
{
	import efme.Engine;
	import efme.core.graphics2d.Image;
	import efme.game.Assets;

	/*
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	
	
    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.*;
    import flash.net.URLRequest;
	*/

	/**
	 * @private
	 * 
	 * A showcase of the most common features used when drawing sprites. This
	 * includes loading an image, drawing it, and animating it.
	 */
	[SWF(width=640, height=480)]
	public class Ex02_BasicSprites extends Engine
	{
		[Embed(source = '../../../bin/example_data/image1.png')]private static const Img1:Class;
		[Embed(source = '../../../bin/example_data/image1.png')]private static const Img2:Class;
		
		public function Ex02_BasicSprites()
		{
			super(640, 480);
			start();

			var assets:Assets = new Assets();
			
			var image1:Image = new Image();
			var image2:Image = new Image();
			var image3:Image = new Image();
			
			assets.requestImage("example_data/image1.png", image1);
			assets.requestImage("example_data/image2.png", image2);
			assets.requestImage("example_data/image3.png", image3);
		}
			
		/*
			for (var i:int = 1; i <= 3; ++i)
			{
				var nImage:int = i; // i % 2 + 1; // 1, 2, 1, 2, etc.
				var url:String = "example_data/image" + nImage + ".png";
				trace("Loading", url);
				
				var loader:Loader = new Loader();
				configureListeners(loader.contentLoaderInfo);
				loader.addEventListener(MouseEvent.CLICK, clickHandler);

				var request:URLRequest = new URLRequest(url);
				loader.load(request);
			}
        }

        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(Event.INIT, initHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            //dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
        }

        private function completeHandler(event:Event):void {
            trace((event.target as LoaderInfo).content);
			trace("completeHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            trace("httpStatusHandler: " + event);
        }

        private function initHandler(event:Event):void {
            trace("initHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            trace("HERE!!!!", event.target);
			trace("ioErrorHandler: " + event);
        }

        private function openHandler(event:Event):void {
            trace("openHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
        }

        private function unLoadHandler(event:Event):void {
            trace("unLoadHandler: " + event);
        }

        private function clickHandler(event:MouseEvent):void {
            trace("clickHandler: " + event);
            var loader:Loader = Loader(event.target);
            loader.unload();
        }
		*/
	}
}