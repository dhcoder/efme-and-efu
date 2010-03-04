package efme.game 
{
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * A collection of <code>Alarm</code>s.
	 */
	public class AlarmList
	{
		/**
		 * Create an empty list of alarms.
		 */
		public function AlarmList() 
		{
			_items = new Vector.<Alarm>();
			_keepAlarmResident = new Dictionary(true);
		}
		
		/**
		 * The number of alarms in this list.
		 */
		public function get numAlarms():uint { return _items.length; }
		
		/**
		 * Return the alarm at the specified index.
		 * 
		 * @param index Index of the alarm we want to retrieve.
		 * @return The alarm at the specified index.
		 */
		public function getAlarm(index:uint):Alarm
		{
			return _items[index];
		}
		
		/**
		 * Return the index of the specified alarm.
		 * 
		 * @param alarm The alarm we want to get the index for.
		 * @return The index of the alarm, or -1 if not found.
		 */
		public function indexOf(alarm:Alarm):int
		{
			return _items.indexOf(alarm);
		}

		/**
		 * Add a single <code>Alarm</code> to the end of this list.
		 */
		public function add(alarm:Alarm, startAlarm:Boolean=true, removeWhenDone:Boolean=true):void
		{
			_items.push(alarm);
			
			if (startAlarm)
			{
				alarm.start();
			}
			
			if (!removeWhenDone)
			{
				_keepAlarmResident[alarm] = true; // Value doesn't matter, just add it to the dictionary
				// TODO test this!
			}
		}
		
		/**
		 * Remove the specified <code>Alarm</code> from this list.
		 * 
		 * <p> You may choose to use <code>removeAt(index)</code> instead if
		 * you already know the index of this alarm. It's a little more
		 * efficient.
		 * 
		 * @return <code>true</code> if the Alarm was part of this list, false
		 * otherwise.
		 */
		public function remove(alarm:Alarm):Boolean
		{
			var removeAlarmIndex:int = indexOf(alarm);
			
			if (removeAlarmIndex >= 0)
			{
				_items.splice(removeAlarmIndex, 1);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Remove the <code>Alarm</code> at the specified index from this list.
		 */
		public function removeAt(index:uint):void
		{
			_items.splice(index, 1);
		}
		
		/**
		 * Clear the contents of this list.
		 */
		public function clear():void
		{
			_items.splice(0, _items.length);
			
			for (var key:Object in _keepAlarmResident)
			{
				delete _keepAlarmResident[key];
			}
		}
		
		/**
		 * Call <code>update(...)</code> on all items in the list.
		 */
		public function update(elapsedTime:uint):void
		{
			for (var nAlarm:uint = 0; nAlarm < _items.length; ++nAlarm)
			{
				var alarm:Alarm = _items[nAlarm];
				alarm.update(elapsedTime);
				
				if (alarm.isFinished && _keepAlarmResident[alarm] == null)
				{
					removeAt(nAlarm);
					--nAlarm; // Adjust for removed alarm
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function toString():String 
		{
			return _items.toString();
		}
		
		private var _items:Vector.<Alarm>;
		private var _keepAlarmResident:Dictionary;
	}
}