﻿package efme.examples
{
	import efme.GameEngine;
	
	[SWF(width=640, height=480)]
	/**
	 * @private
	 * 
	 * A bare-bones, "Hello, world!" example, which sets up an empty
	 * Flash application at 640x480, with a green background color.
	 * 
	 * The classes you'll use in this demo.
	 * 
	 * - GameEngine
	 */
	public class Ex01_GettingStarted extends GameEngine
	{
		public function Ex01_GettingStarted()
		{
			super(640, 480, 0x00FF00);
			start();
			
			trace("Hello, world!");
		}
	}
}