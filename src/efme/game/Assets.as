package efme.game
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
	import flash.utils.Dictionary;

	import efme.core.graphics2d.Image;
	
	/**
	 * The <code>Assets</code> class acts both as a central cache as well as a
	 * loading manager for all game assets.
	 * 
	 * <p> EFME encourages on-the-fly asset loading (as opposed to using the
	 * <code>[Embed]</code> tag, as that allows for more cooperative
	 * development between programmers and artists (with <code>[Embed]</code>,
	 * artists need access to a Flash compiler if they want to see their
	 * changes).
	 * 
	 * <p> Of course, EFME recognizes the huge advantage <code>[Embed]</code>
	 * provides, especially in the online deployment of your Flash application
	 * (just one .swf, instead of many separated files out on the network),
	 * so <code>Assets</code> provides an interface to handle both methods.
	 * 
	 * <p> After using either loading method, you are simply given your
	 * game asset. It's possible the asset isn't totally loaded yet but
	 * This handle allows you to pass around the asset and not
	 * worry about whether it is still in the process of loading or not.
	 * 
	 * <p> While the assets are loading, you can check the overall state
	 * by querying the <code>percentComplete</code> property. You can also
	 * add a callback to be called when loading is complete.
	 * 
	 * @example
	 * <listing version="3.0">
	 * import efme.core.graphics2d.Image;
	 * 
	 * //
	 * // On-the-fly method
	 * //
	 * 
	 * private var _image1:Image;
	 * private var _image2:Image;
	 * public function init():void
	 * {
	 *   _image1 = new Image();
	 *   _image2 = new Image();
	 *   engine.assets.requestImage('data/image1.png', _image1);
	 *   engine.assets.requestImage('data/image2.png', _image2);
	 * }
	 * public function render():void
	 * {
	 *   engine.screen.drawImage(_image1); // If still loading, it will
	 *   engine.screen.drawImage(_image2); // draw nothing
	 * 
	 *   if (engine.assets.isLoadingImage(_image1))
	 *   {
	 *     // Optionally handle assets that are loading
	 *   }
	 * }
	 * 
	 * //
	 * // Embedded asset method
	 * //
	 * 
	 * [Embed(source = 'data/image1.png')]private const Img1:Class;
	 * [Embed(source = 'data/image2.png')]private const Img2:Class;
	 * private var _image1:Image;
	 * private var _image2:Image;
	 * public function init():void
	 * {
	 *   _image1 = engine.assets.getImage(Img1); // Loads instantly
	 *   _image2 = engine.assets.getImage(Img2);
	 * }
	 * public function render():void
	 * {
	 *   engine.screen.drawImage(_image1);
	 *   engine.screen.drawImage(_image2);
	 * }
	 * </listing>
	 */
	public class Assets
	{
		public function Assets() 
		{
			_dictLoaderToImage = new Dictionary();
			_dictImageToLoader = new Dictionary();
			_dictImageToFilename = new Dictionary();
			
			_dictCachedBitmaps = new Dictionary(true);
		}
		
		public function requestImage(strFile:String, image:Image, cache:Boolean = true):void
		{
			// TODO: Handle errors if null image or duplicate image?

			var strFileLower:String = strFile.toLowerCase();
			
			if (_dictCachedBitmaps[strFileLower] != null)
			{
				// TODO: bitmapData
				// image.bitmapData = _dictCachedBitmaps[strFileLower] as BitmapData;
			}
			else
			{
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadImageComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoadImageFailed);
				
				_dictLoaderToImage[loader.contentLoaderInfo] = image;
				_dictImageToLoader[image] = loader.contentLoaderInfo;
				_dictImageToFilename[image] = strFileLower;
				
				var request:URLRequest = new URLRequest(strFileLower);
				loader.load(request);
			}
		}

		public function isLoadingImage(image:Image):Boolean
		{
			return (_dictImageToLoader[image] != null);
		}
		
		private function handleLoadImageComplete(event:Event):void
		{
			trace("handleLoadImageComplete");
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var image:Image = _dictLoaderToImage[loaderInfo] as Image;
			var strFile:String = _dictImageToFilename[image];
			
			trace(loaderInfo.content);
			trace("Loaded", strFile);
			var bitmapData:BitmapData = (loaderInfo.content as Bitmap).bitmapData;
			
			// TODO: bitmapData
			//image.bitmapData = bitmapData;
			_dictCachedBitmaps[strFile] = bitmapData;
			
			cleanImageDictionaries(event.target as LoaderInfo);
		}

		private function handleLoadImageFailed(event:IOErrorEvent):void
		{
			trace("handleLoadImageFailed");
			cleanImageDictionaries(event.target as LoaderInfo);
		}
		
		private function cleanImageDictionaries(loaderInfo:LoaderInfo):void
		{
			var image:Image = _dictLoaderToImage[loaderInfo] as Image;
			delete _dictLoaderToImage[loaderInfo];
			delete _dictImageToLoader[image];
			delete _dictImageToFilename[image];
		}

		private var _dictLoaderToImage:Dictionary;
		private var _dictImageToLoader:Dictionary;
		private var _dictImageToFilename:Dictionary;
		
		private var _dictCachedBitmaps:Dictionary;
	}
}