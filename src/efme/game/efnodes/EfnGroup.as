package efme.game.efnodes 
{
	import efme.game.EfNode;
	import efme.game.EfNodeList;
	
	/**
	 * An EfNode parent that contains a list of EfNode children.
	 */
	public class EfnGroup extends EfNode
	{
		public function EfnGroup(initialSize:uint = 0) 
		{
			_children = new EfNodeList(initialSize);
		}
		
		public function get children():EfNodeList { return _children; }
		
		private var _children:EfNodeList;
	}

}