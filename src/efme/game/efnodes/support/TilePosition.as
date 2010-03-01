package efme.game.efnodes.support 
{
	/**
	 * @private
	 * 
	 * A simple class used to store tileX and tileY values. Used by
	 * the <code>Animation</code> class.
	 * 
	 * @see Animation
	 */
	public class TilePosition
	{
		public var tileX:uint;
		public var tileY:uint;
		
		public function TilePosition(tileX:uint = 0, tileY:uint = 0)
		{
			this.tileX = tileX;
			this.tileY = tileY;
		}
	}
}