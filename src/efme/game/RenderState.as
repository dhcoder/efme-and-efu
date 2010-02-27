package efme.game 
{
	/**
	 * Because EFME uses a hierarchical system to manage its game objects,
	 * it needs a way for to let parent game objects pass their current
	 * drawing state down to the children.
	 * 
	 * <p> <code>RenderState</code> contains the collective render state from
	 * all ancestors rendered so far this frame. This includes the current
	 * color, rotation, and translated X/Y values.
	 */
	public class RenderState
	{
		public function RenderState() 
		{
		}
		
	}

}