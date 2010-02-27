package efme.examples 
{
	import efme.GameEngine;
	
	[SWF(width=640, height=480)]
	/**
	 * @private
	 * 
	 * A demo of various, miscellaneous support features availabe in the
	 * EFME/EFU engine set.
	 * 
	 * - Controlling the ContextMenu
	 * - Utilizing GameEngine.services
	 * - Using efme.core without creating EfNodes.
	 */
	public class Ex99_MiscFeatures extends GameEngine
	{
		public function Ex99_MiscFeatures() 
		{
			super(640, 480);
			start();
			
			// TODO: An actual demo
		}
	}

}