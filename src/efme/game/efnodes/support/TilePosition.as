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
		public var X:uint;
		public var Y:uint;
		
		public function TilePosition(X:uint = 0, Y:uint = 0)
		{
			this.X = X;
			this.Y = Y;
		}
	}
}