package efme.core.audio 
{
	import efme.game.Callback;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
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

			_musicTransform = new SoundTransform(0.5);
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

		public function playMusic(music:Music, fadeCurrentMusic:Number = 0.0, repeat:Boolean = true, callbackMusicComplete:Callback = null):void
		{
			// TODO: Remove hack
			// TODO: Implement fade
			_music = music;
			_repeat = repeat;
			_callbackMusicComplete = callbackMusicComplete;

			_musicChannel = _music.soundData.play(0, 0, _musicTransform);
			_musicChannel.addEventListener(Event.SOUND_COMPLETE, handleMusicComplete, false, 0, true);
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
		
		private function handleMusicComplete(event:Event):void
		{
			if (_repeat)
			{
				_musicChannel = _music.soundData.play(0, 0, _musicTransform);
				_musicChannel.addEventListener(Event.SOUND_COMPLETE, handleMusicComplete, false, 0, true);
			}
			else
			{
				if (_callbackMusicComplete != null)
				{
					_callbackMusicComplete.call();
				}
			}
		}
		
		private var _dictSounds:Dictionary;
		private var _dictSoundChannels:Dictionary;
		private var _soundChannels:Vector.<SoundChannel>;
		
		private var _music:Music;
		private var _musicChannel:SoundChannel;
		private var _musicTransform:SoundTransform;
		private var _musicNext:Music;
		private var _repeat:Boolean;
		private var _callbackMusicComplete:Callback;
		
	}

}