package efme.game
{
	/**
	 * A timer class, which calls a callback after a specified interval
	 * has passed.
	 * 
	 * <p> You can set an alarm to either play once or repeat indefinitely.
	 * 
	 * @see AlarmList
	 */
	public class Alarm
	{
		/**
		 * Construct an alarm.
		 */
		public function Alarm(interval:uint, callback:Callback, repeat:Boolean = true)
		{
			_interval = interval;
			_callback = callback;

			_repeat = repeat;
			
			reset();
		}
		
		public function get isRunning():Boolean { return !_stopped; }
		public function get isFinished():Boolean { return _alarmFinished; }

		/**
		 * Start this alarm from the beginning.
		 * 
		 * <p> To resume an alarm from its current point, call
		 * <code>resume()</code>.
		 * 
		 * <p> To pause an alarm, call <code>stop()</code>.
		 */
		public function start():void
		{
			reset();
			_stopped = false;
		}

		/**
		 * Pause this alarm.
		 */
		public function stop():void
		{
			_stopped = true;
		}
		
		/**
		 * Resume this alarm from where it left off.
		 */
		public function resume():void
		{
			if (!_alarmFinished)
			{
				_stopped = false;
			}
		}
		
		/**
		 * Restart this alarm back to the beginning.
		 */
		public function reset():void 
		{
			_stopped = true;
			_alarmFinished = false;
			
			_timeCounter = 0;
		}
		
		/**
		 * Update this alarm with the time passed since the last frame.
		 */
		public function update(elapsedTime:uint):void
		{
			if (!_stopped && !_alarmFinished)
			{
				_timeCounter += elapsedTime;

				if (_timeCounter > _interval)
				{
					if (_repeat)
					{
						_timeCounter -= _interval;
					}
					else
					{
						_alarmFinished = true;
						_stopped = true;
					}
					
					_callback.call();
				}
			}
		}

		private var _repeat:Boolean;

		private var _interval:uint;
		private var _timeCounter:uint;

		private var _stopped:Boolean;
		private var _alarmFinished:Boolean;
		
		private var _callback:Callback;
	}

}