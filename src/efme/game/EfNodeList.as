package efme.game 
{
	import flash.utils.Proxy;

	/**
	 * A collection of <code>EfNode</code>s. If you create your own 
	 * <code>EfNode</code> which needs to have children nodes, you will want to
	 * add an <code>EfNodeList</code> variable to that class.
	 */
	public class EfNodeList extends Proxy
	{
		/**
		 * Create a new list of nodes.
		 * 
		 * @param initialSize An initial size to make this list. If you add more
		 * nodes than this size, it will automatically expand. If set to 0,
		 * a reasonable default will be used. (Default = 0)
		 */
		public function EfNodeList(initialSize:uint = 0) 
		{
			_items = new Vector.<EfNode>(initialSize);
			_length = 0;
		}
		
		/**
		 * The number of EfNodes in this list.
		 */
		public function get length():uint { return _length; }
		
		/**
		 * Convenience function. Call 'update' on all items in the list.
		 */
		public function update(elapsedTime:int):void
		{
			for (var nGroup:int = _items.length - 1; --nGroup; nGroup >= 0)
			{
				_items[nGroup].update(elapsedTime);
			}
		}
		
		/**
		 * Convenience function. Call 'render' on all items in the list.
		 */
		public function render(renderState:RenderState):void
		{
			for (var nGroup:int = _items.length - 1; --nGroup; nGroup >= 0)
			{
				_items[nGroup].render(renderState);
			}
		}
		
		/**
		 * Convenience function. Call 'shutdown' on all items in the list.
		 */
		public function shutdown():void
		{
			for (var nGroup:int = _items.length - 1; --nGroup; nGroup >= 0)
			{
				_items[nGroup].shutdown();
			}
		}
		
		private var _items:Vector.<EfNode>;
		private var _length:uint;
	}

}