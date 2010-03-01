package efme.core.graphics2d.support
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * An class to handle anchoring positions. Given a rectangle and an
	 * anchoring style, you can get the corresponding point on the rectangle.
	 * 
	 * <pre>
	 * TL------T------TR
	 * |               |
	 * L       M       R
	 * |               |
	 * BL------B------BR
	 * </pre>
	 */
	public class Anchor
	{
		public static const TOP_LEFT: int = 0;
		public static const TOP_MIDDLE: int = 1;
		public static const TOP_RIGHT: int = 2;
		public static const LEFT: int = 3;
		public static const MIDDLE: int = 4;
		public static const RIGHT: int = 5;
		public static const BOTTOM_LEFT: int = 6;
		public static const BOTTOM_MIDDLE: int = 7;
		public static const BOTTOM_RIGHT: int = 8;
		
		public static function getAnchorPoint(rect:Rectangle, anchorStyle:int):Point
		{
			var anchorPoint:Point = null;
			switch (anchorStyle) 
			{
				case TOP_LEFT:
					anchorPoint = rect.topLeft;
					break;
				case TOP_MIDDLE:
					anchorPoint = new Point(rect.left + rect.width / 2, rect.top);
					break;
				case TOP_RIGHT:
					anchorPoint = new Point(rect.right, rect.top);
					break;
				case LEFT:
					anchorPoint = new Point(rect.left, rect.top + rect.height / 2);
					break;
				case MIDDLE:
					anchorPoint = new Point(rect.left + rect.width / 2, rect.top + rect.height / 2);
					break;
				case RIGHT:
					anchorPoint = new Point(rect.right, rect.top + rect.height / 2);
					break;
				case BOTTOM_LEFT:
					anchorPoint = new Point(rect.left, rect.bottom);
					break;
				case BOTTOM_MIDDLE:
					anchorPoint = new Point(rect.left + rect.width / 2, rect.bottom);
					break;
				case BOTTOM_RIGHT:
					anchorPoint = rect.bottomRight;
					break;
				default:
					throw new Error("Requested anchor point with bad anchorStyle argument");
					break;
			}
			
			return anchorPoint;
		}
	}
}