package efme.examples
{
	import efme.GameEngine;

	[SWF(width=640, height=480)]
	/**
	 * @private
	 * 
	 * This example demonstrates how to organize your EfNodes hierarchically.
	 * In other words, we are going to use EfnGroups, which will act as
	 * parents over other nodes.
	 * 
	 * We will use this to:
	 * 
	 * - Create a "Player" node, which is a collection of 4 sprites, grouped
	 * together.
	 * - Create a menu which can be easily turned on and off when the user
	 * hits 'ENTER'
	 * - Apply some color affects to the player and his world.
	 */
	public class Ex05_GameTree extends GameEngine
	{
		public function Ex05_GameTree()
		{
			super(640, 480);
			start();
		}
	}
}