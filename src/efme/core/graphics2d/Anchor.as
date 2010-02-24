package efme.core.graphics2d 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * An class to handle anchoring positions. Given a rectangle and an
	 * anchoring style, you can get the corresponding point on the rectangle.
	 * 
	 * TL------T------TR
	 * |               |
	 * L       M       R
	 * |               |
	 * BL------B------BR
	 */
	public class Anchor
	{
		public static const TOP_LEFT: uint = 0;
		public static const TOP_MIDDLE: uint = 1;
		public static const TOP_RIGHT: uint = 2;
		public static const LEFT: uint = 3;
		public static const MIDDLE: uint = 4;
		public static const RIGHT: uint = 5;
		public static const BOTTOM_LEFT: uint = 6;
		public static const BOTTOM_MIDDLE: uint = 7;
		public static const BOTTOM_RIGHT: uint = 8;
		
		public static function getAnchorPoint(rect:Rectangle, anchorStyle:uint):Point
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