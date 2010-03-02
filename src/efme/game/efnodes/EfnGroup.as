package efme.game.efnodes 
{
	import efme.game.EfNode;
	import efme.game.EfNodeList;
	import efme.game.GameState;
	import flash.geom.Point;
	
	/**
	 * An EfNode parent that contains a list of EfNode children.
	 */
	public class EfnGroup extends EfNode
	{
		public function EfnGroup(gameState:GameState) 
		{
			super(gameState, true);
		}
		
		/**
		 * Provide access to this group's children.
		 */
		public function get children():EfNodeList { return childNodes; }
	}

}