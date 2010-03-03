package efme.core.graphics2d.support
{
	/**
	 * @private
	 * 
	 * A simple class used to store tileX and tileY values. This can be
	 * especially useful when working with tiled images.
	 * 
	 * <p> This class isn't used directly by <code>Image</code> , but if your
	 * own class wants to maintain tile coordinates, this class is provided for
	 * convenience.
	 * 
	 * <p> The <code>AnimationState</code> class in the efme.game package
	 * demonstrates how you can it.
	 * 
	 * @see AnimationState#currentTile
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