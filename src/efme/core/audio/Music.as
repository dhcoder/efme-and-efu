package efme.core.audio 
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	
	/**
	 * A class which encapsulates the data of a sound effect.
	 * 
	 * <p> Use <code>engine.audioPlayer.playSound(...)</code> to play this
	 * sound effect.
	 * 
	 * @see AudioPlayer#playSound
	 */
	public class Music
	{
		public function Music(soundData:Sound = null) 
		{
			_soundData = soundData;
			_soundTransform = new SoundTransform();
		}

		public function get soundData():Sound { return _soundData; }
		public function set soundData(value:Sound):void { _soundData = value; }
		
		private var _soundData:Sound;
		private var _soundTransform:SoundTransform;
	}

}