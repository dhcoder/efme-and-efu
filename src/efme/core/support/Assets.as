package efme.core.support
{
	import efme.core.audio.SoundEffect;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
    import flash.net.URLRequest;
	import flash.utils.Dictionary;

	import efme.core.graphics2d.Image;
	
	/**
	 * The <code>Assets</code> class acts both as a central cache as well as a
	 * loading manager for all game assets.
	 * 
	 * <p> EFME encourages on-the-fly asset loading, as opposed to using the
	 * <code>[Embed]</code> tag, as that allows for more cooperative
	 * development between programmers and artists. (When you use 
	 * the <code>[Embed]</code> tag, artists  need to recompile the application 
	 * if they want to see and test their changes).
	 * 
	 * <p> Of course, EFME recognizes the huge advantage <code>[Embed]</code>
	 * provides, especially in the online deployment of your Flash application
	 * (just one .swf, instead of many separated files out on the network),
	 * so <code>Assets</code> provides an interface to handle both methods.
	 * 
	 * @example The following code demonstrates the on-the-fly loading method:
	 * <listing version="3.0">
	 * import efme.core.graphics2d.Image;
	 * import efme.Engine;
	 * 
	 * class SomeClass
	 * {
	 *   private var _engine:Engine;
	 *   private var _image1:Image;
	 *   private var _image2:Image;
	 *   
	 *   public function SomeClass(engine:Engine)
	 *   {
	 *     _engine = engine;
	 *     _image1 = new Image();
	 *     _image2 = new Image();
	 *     _engine.assets.requestImage('data/image1.png', _image1);
	 *     _engine.assets.requestImage('data/image2.png', _image2);
	 *   }
	 * 
	 *   public function render():void
	 *   {
	 *     if (_engine.assets.isLoadingImage(_image1))
	 *     {
	 *       // Optionally test if assets are still loading
	 *     }
	 * 
	 *     _image1.draw(_engine.screen); // If still loading, it will
	 *     _image2.draw(_engine.screen); // draw nothing
	 *   }
	 * }
	 * </listing>
	 * @example The following code demonstrates embedded asset loading:
	 * <listing version = "3.0">
	 * import efme.core.graphics2d.Image;
	 * import efme.Engine;
	 * 
	 * class SomeClass
	 * {
	 *   private var _engine:Engine;
	 * 
	 *   [Embed(source = 'data/image1.png')]private const Img1:Class;
	 *   [Embed(source = 'data/image2.png')]private const Img2:Class;
	 *   private var _image1:Image;
	 *   private var _image2:Image;

	 *   public function SomeClass(engine:Engine)
	 *   {
	 *     _engine = engine;
	 *     _image1 = _engine.assets.getImage(Img1); // Loads instantly
	 *     _image2 = _engine.assets.getImage(Img2);
	 *   }
	 
	 *   public function render():void
	 *   {
	 *     _image1.draw(_engine.screen);
	 *     _image2.draw(_engine.screen);
	 *   }
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

			_dictSoundToSoundEffect = new Dictionary();
			_dictSoundEffectToSound = new Dictionary();
			
			_numItemsLoading = 0;
		}
		
		/**
		 * Function to check if anything is in the process of loading.
		 */
		public function isLoading():Boolean
		{
			return _numItemsLoading > 0;
		}
		
		/**
		 * Request loading an image file, putting the final result into the specified
		 * <code>Image</code>, when complete.
		 * 
		 * @param strFile The file to load (.bmp, .tga, .png, .jpg)
		 * @param image An instance of an <code>Image</code> to hold the loaded file.
		 * @param useCache Set to true to cache this image / use an existing image if already loaded.
		 */
		public function requestImage(strFile:String, image:Image, useCache:Boolean = true):void
		{
			if (image == null)
			{
				throw new Error("Passed null image into Asset.requestImage");
			}
			else if (_dictImageToLoader[image] != null)
			{
				throw new Error("Requesting multiple loads into the same image");
			}

			var strFileLower:String = strFile.toLowerCase();
			
			if (_dictCachedBitmaps[strFileLower] != null)
			{
				image.bitmapData = _dictCachedBitmaps[strFileLower] as BitmapData;
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
				++_numItemsLoading;
			}
		}

		/**
		 * Request a sound file, putting the final result into the specified
		 * <code>SoundEffect</code>, when complete.
		 * 
		 * @param strFile The file to load (.mp3)
		 * @param soundEffect An instance of a <code>SoundEffect</code> to hold the loaded file.
		 */
		public function requestSound(strFile:String, soundEffect:SoundEffect):void
		{
			if (soundEffect == null)
			{
				throw new Error("Passed null soundEffect into Asset.requestSound");
			}
			else if (_dictSoundEffectToSound[soundEffect] != null)
			{
				throw new Error("Requesting multiple loads into the same soundEffect");
			}

			var soundData:Sound = new Sound();
			soundData.addEventListener(Event.COMPLETE, handleLoadSoundEffectComplete);
			soundData.addEventListener(IOErrorEvent.IO_ERROR, handleLoadSoundEffectFailed);
			
			_dictSoundToSoundEffect[soundData] = soundEffect;
			_dictSoundEffectToSound[soundEffect] = soundData;
			
			var request:URLRequest = new URLRequest(strFile);
			soundData.load(request);
			++_numItemsLoading;
		}

		/**
		 * Function called when an image load succeeds.
		 */
		private function handleLoadImageComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			var image:Image = _dictLoaderToImage[loaderInfo] as Image;
			var strFile:String = _dictImageToFilename[image];
			
			var bitmapData:BitmapData = (loaderInfo.content as Bitmap).bitmapData;
			
			image.bitmapData = bitmapData;
			_dictCachedBitmaps[strFile] = image.bitmapData;
			
			handleLoadImageFinished(event.target as LoaderInfo);
		}

		/**
		 * Function called when an image load fails.
		 */
		private function handleLoadImageFailed(event:IOErrorEvent):void
		{
			handleLoadImageFinished(event.target as LoaderInfo);
		}
		
		/**
		 * Function called to clean up after a load image request either
		 * succeeded or failed.
		 */
		private function handleLoadImageFinished(loaderInfo:LoaderInfo):void
		{
			var image:Image = _dictLoaderToImage[loaderInfo] as Image;
			delete _dictLoaderToImage[loaderInfo];
			delete _dictImageToLoader[image];
			delete _dictImageToFilename[image];
			
			--_numItemsLoading;
		}

		/**
		 * Function called when an sound effect load succeeds.
		 */
		private function handleLoadSoundEffectComplete(event:Event):void
		{
			var soundData:Sound = event.target as Sound;
			var soundEffect:SoundEffect = _dictSoundToSoundEffect[soundData] as SoundEffect;
			
			soundEffect.soundData = soundData;
			handleLoadSoundEffectFinished(soundData);
		}

		/**
		 * Function called when an sound effect load fails.
		 */
		private function handleLoadSoundEffectFailed(event:IOErrorEvent):void
		{
			handleLoadSoundEffectFinished(event.target as Sound);
		}
		
		/**
		 * Function called to clean up after a load sound effect request either
		 * succeeded or failed.
		 */
		private function handleLoadSoundEffectFinished(soundData:Sound):void
		{
			var soundEffect:SoundEffect = _dictSoundToSoundEffect[soundData] as SoundEffect;
			delete _dictSoundToSoundEffect[soundData];
			delete _dictSoundEffectToSound[soundEffect];
			
			--_numItemsLoading;
		}
		
		
		private var _numItemsLoading:uint;
		
		private var _dictLoaderToImage:Dictionary;
		private var _dictImageToLoader:Dictionary;
		private var _dictImageToFilename:Dictionary;
		private var _dictCachedBitmaps:Dictionary;
		
		private var _dictSoundToSoundEffect:Dictionary;
		private var _dictSoundEffectToSound:Dictionary;
		
	}
}