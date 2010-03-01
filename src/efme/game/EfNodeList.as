﻿package efme.game 
{
	import flash.geom.Point;
	import flash.utils.Proxy;

	/**
	 * A collection of <code>EfNode</code>s. If you create your own 
	 * <code>EfNode</code> which needs to have children nodes, you will want to
	 * add an <code>EfNodeList</code> variable to that class.
	 */
	public class EfNodeList
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
			_initialSize = initialSize;
			clear();
		}
		
		/**
		 * The number of EfNodes in this list.
		 */
		public function get numItems():uint { return _numItems; }
		
		/**
		 * Return the node at the specified index.
		 * 
		 * @param index Index of the node we want to retrieve.
		 * @return The node at the specified index.
		 */
		public function getNode(index:uint):EfNode
		{
			return _items[index];
		}
		
		/**
		 * Return the index of the specified node.
		 * 
		 * @param efNode The node we want to get the index for.
		 * @return The index of the node, or -1 if not found.
		 */
		public function indexOf(efNode:EfNode):int
		{
			return _items.indexOf(efNode);
		}

		/**
		 * Add a single <code>EfNode</code> to the end of this list.
		 */
		public function add(efNode:EfNode):void
		{
			_items.push(efNode);
			++_numItems;
		}
		
		/**
		 * Add a vector of <code>EfNode</code>s to the end of this list.
		 */
		public function addMany(efNodes:Vector.<EfNode>):void
		{
			for (var nNodeAdd:int = 0; nNodeAdd < efNodes.length; ++nNodeAdd)
			{
				_items.push(efNodes[nNodeAdd]);
				++_numItems;
			}
		}
		
		/**
		 * Add the contents of another <code>EfNodeList</code> to the end of
		 * this list.
		 */
		public function addList(efNodeList:EfNodeList):void
		{
			for (var nNodeAdd:int = 0; nNodeAdd < efNodeList._numItems; ++nNodeAdd)
			{
				_items.push(efNodeList._items[nNodeAdd]);
				++_numItems;
			}
		}
		
		/**
		 * Remove the specified <code>EfNode</code> from this list.
		 * 
		 * <p> You may choose to use <code>removeAt(index)</code> instead if
		 * you already know the index of this node. It's a little more
		 * efficient.
		 * 
		 * @return <code>true</code> if the EfNode was part of this list, false
		 * otherwise.
		 */
		public function remove(efNode:EfNode):Boolean
		{
			var nNodeRemove:int = indexOf(efNode);
			
			if (nNodeRemove >= 0)
			{
				_items.splice(nNodeRemove, 1);
				--_numItems;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Remove the <code>EfNode</code> at the specified index from this list.
		 */
		public function removeAt(index:uint):void
		{
			_items.splice(index, 1);
			--_numItems;
		}
		
		/**
		 * Clear the contents of this list.
		 */
		public function clear():void
		{
			_items = new Vector.<EfNode>(_initialSize);
			_numItems = 0;
		}
		
		/**
		 * Call <code>update(...)</code> on all items in the list.
		 */
		public function update(offset:Point, elapsedTime:uint):void
		{
			for (var nNode:int = _numItems - 1; nNode >= 0; --nNode)
			{
				_items[nNode].update(offset, elapsedTime);
			}
		}
		
		/**
		 * Call <code>render()</code> on all items in the list.
		 */
		public function render():void
		{
			for (var nNode:int = _numItems - 1; nNode >= 0; --nNode)
			{
				_items[nNode].render();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function toString():String 
		{
			return _items.toString();
		}
		
		private var _items:Vector.<EfNode>;
		private var _numItems:uint;

		private var _initialSize:uint;
	}

}