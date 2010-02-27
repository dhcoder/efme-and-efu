package efme.core.graphics2d 
{
	import flash.geom.Rectangle;

	/**
	 * Used to specify advanced rendering options for the Image class.
	 * 
	 * @see Image.draw
	 * @see Image.drawSub
	 * @see Image.drawTile
	 */
	public class DrawOptions
	{
		/**
		 * A scale factor, to stretch your image in the X direction.
		 */
		public var scaleX:Number;
		
		/**
		 * A scale factor, to stretch your image in the Y direction.
		 */
		public var scaleY:Number;
		
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
		 * An alpha value to draw this image with. Clamped 0.0 to 1.0 (Default = 1.0)
		 */
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void
		{
			if (value < 0.0) { value = 0.0; }
			else if (value > 1.0) { value = 1.0; }
			_alpha = value;
		}

		/**
		 * Number (in degrees) that you want to rotate your image.
		 * (Default = 0.0)
		 */
		public var rotate:Number;
		
		/**
		 * Anchor-point to rotate around.
		 */
		public var rotateAnchor:uint;

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
			scaleX = 1.0;
			scaleY = 1.0;
			
			flipX = false;
			flipY = false;
			
			blendColor = 0xFFFFFF;
			alpha = 1.0;
			
			rotate = 0.0;
			rotateAnchor = Anchor.MIDDLE;
			
			applySmoothing = false;
			
			// Add anything else here? Update clone()!
		}
		
		/**
		 * Test to see if these draw options, when applied, don't
		 * actually do anything.
		 * 
		 * @return <code>true</code> if user never set any draw options up.
		 */
		public function hasNoEffect():Boolean
		{
			return (
				scaleX == 1.0 &&
				scaleY == 1.0 &&
				flipX == false &&
				flipY == false &&
				blendColor == 0xFFFFFF &&
				alpha == 1.0 &&
				rotate == 0.0 &&
				rotateAnchor == Anchor.MIDDLE &&
				applySmoothing == false);
		}
		
		/**
		 * Clone the current drawOptions and return it.
		 * 
		 * @return The cloned draw options.
		 */
		public function clone():DrawOptions
		{
			var drawOptionsClone:DrawOptions = new DrawOptions();
			
			drawOptionsClone.scaleX = scaleX;
			drawOptionsClone.scaleY = scaleY;
			
			drawOptionsClone.flipX = flipX;
			drawOptionsClone.flipY = flipY;
			
			drawOptionsClone.blendColor = blendColor;
			drawOptionsClone.alpha = alpha;
			
			drawOptionsClone.rotate = rotate;
			drawOptionsClone.rotateAnchor = rotateAnchor;
			
			drawOptionsClone.applySmoothing = applySmoothing;
			
			return drawOptionsClone;
		}
		
		private var _alpha:Number;
	}

}