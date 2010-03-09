package efme.core.audio 
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	/**
	 * Class to handle the starting and stopping of sound effects and
	 * music tracks.
	 * 
	 * <p> You can also use this class to stop all sounds, control global volume
	 * levels, and mute all audio.
	 * 
	 * @see Sound
	 * @see Music
	 * @see efme.GameEngine#audioPlayer
	 */
	public class AudioPlayer
	{
		public function AudioPlayer() 
		{
			_dictSounds = new Dictionary();
			_dictSoundChannels = new Dictionary();
			_soundChannels = new Vector.<SoundChannel>();
		}
		
		public function playSound(soundEffect:SoundEffect, allowMultiple:Boolean = true):void
		{
			var soundChannel:SoundChannel;
			
			if (!allowMultiple && _dictSounds[soundEffect] != null)
			{
				soundChannel = _dictSounds[soundEffect];
				soundChannel.stop();
				removeSoundChannel(soundChannel);
			}

			soundChannel = soundEffect.soundData.play();
			soundChannel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
			
			_dictSounds[soundEffect] = soundChannel;
			_dictSoundChannels[soundChannel] = soundEffect;
			
			_soundChannels.push(soundChannel);
		}

		private function handleSoundComplete(event:Event):void
		{
			removeSoundChannel(event.currentTarget as SoundChannel);
		}
		
		private function removeSoundChannel(soundChannel:SoundChannel):void
		{
			_soundChannels.splice(_soundChannels.indexOf(soundChannel), 1);
			delete _dictSounds[_dictSoundChannels[soundChannel]];
			delete _dictSoundChannels[soundChannel];
		}
		
		private var _dictSounds:Dictionary;
		private var _dictSoundChannels:Dictionary;
		private var _soundChannels:Vector.<SoundChannel>;
		
	}

}