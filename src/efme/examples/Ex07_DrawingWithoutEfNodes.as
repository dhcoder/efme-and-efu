package efme.examples 
{
	import efme.GameEngine;
	
	[SWF(width=640, height=480)]
	/**
	 * @private
	 * 
	 * All demos so far have introduced you to the <code>EfNode</code> concept.
	 * But did you know you can use the EFME system without ever creating a 
	 * single <code>EfNode</code>?
	 * 
	 * <p> To accomplish this, simple override any of the functions
	 * <code>GameEngine.onUpdate(...)</code>, 
	 * <code>GameEngine.onRenderBackground()</code>, 
	 * <code>GameEngine.onRenderForeground()</code>, 
	 * <code>GameState.onUpdate(...)</code>,
	 * <code>GameState.onRenderBackground()</code>, and 
	 * <code>GameState.onRenderForeground()</code>. 
	 * 
	 * <p> Within those functions, you can work directly with the EFME core
	 * classes, such as <code>Image</code>, <code>Font</code>, and 
	 * <code>Sound</code>.
	 * 
	 * <p> While in this demo we don't create a single <code>EfNode</code>,
	 * you can use a combination of these techniques and <code>EfNode</code>s
	 * if you'd like.
	 */
	public class Ex07_DrawingWithoutEfNodes extends GameEngine
	{
		public function Ex07_DrawingWithoutEfNodes() 
		{
			super(640, 480);
			start();
			
			// TODO: An actual demo
		}
	}

}