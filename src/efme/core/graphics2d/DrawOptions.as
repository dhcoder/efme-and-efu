package efme.core.graphics2d 
{
	import flash.geom.Rectangle;

	/**
	 * Use for specifying rendering options for the Image class.
	 * 
	 * @see Image.draw
	 * @see Image.drawSub
	 * @see Image.drawTile
	 */
	public class DrawOptions
	{
		/**
		 * The rectangular area you want to render into. (Default = same size
		 * as source rectange)
		 */
		public var destRect:Rectangle;
		
		/**
		 * Whether or not you want to flip your image horizontally before
		 * rendering. (Default = false)
		 */
		public var flipX:Boolean;
		
		/**
		 * Whether or not you want to flip your image vertically before
		 * rendering. (Default = false)
		 */
		public var flipY:Boolean;
		
		/**
		 * A color to blend with. (Default = 0xFFFFFF, i.e. white)
		 */
		public var blendColor:uint;
		
		/**
		 * An alpha value to blend with, clamped 0.0 to 1.0 (Default = 1.0)
		 */
		public var blendAlpha:Number;

		/**
		 * Number (in degrees) that you want to rotate your image.
		 * (Default = 0.0)
		 */
		public var rotate:Number;
		
		/**
		 * Anchor-point to use for rotations.
		 */
		public var rotateAnchor:String;

		/**
		 * Whether or not you want to apply smoothing to your image. Smoothing
		 * makes a stretched or rotated image look less jagged, but it comes
		 * at a rendering cost, so use it sparingly.
		 */
		public var applySmoothing:Boolean;
		
		/**
		 * Initialize these DrawOptions.
		 * 
		 * <p> <strong>Note:</strong> The defaults are chosen to have no
		 * effect on the final render call. You are expected to change at least
		 * one of them.
		 */
		public function DrawOptions() 
		{
			reset();
		}

		/**
		 * Reset DrawOptions back to the initial state.
		 */
		public function reset():void
		{
			destRect = new Rectangle();
			
			blendColor = 0xFFFFFF;
			blendAlpha = 1.0;
			
			rotate = 0.0;
			rotateAnchor = AnchorStyle.MIDDLE;
			
			applySmoothing = false;
		}
	}

}