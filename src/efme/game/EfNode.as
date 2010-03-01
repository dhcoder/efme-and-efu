package efme.game
{
	import efme.core.graphics2d.support.Anchor;
	import efme.core.graphics2d.support.DrawOptions;
	import efme.game.efnodes.EfnGroup;
	import efme.GameEngine;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * EfNodes are the building blocks of the EFME engine. You can think of
	 * them essentially as game objects. For everything in a game that
	 * has positional information (such as a player, enemy, text blurb, button,
	 * sound emitter, particle emitter, etc.), then it is almost certainly
	 * derived from an EfNode.
	 * 
	 * <p> The EFME engine uses a hierarchical, tree orgnaization system for its
	 * game objects, where the <code>GameState</code> class acts as the root.
	 * Access a <code>GameState</code>'s children nodes through its 
	 * <code>GameState.efNodes</code> property. 
	 * 
	 * <p> All EfNodes have an X/Y position and an 'active' value. They also
	 * have the ability to own children nodes (you must specify this in the
	 * constructor).
	 * 
	 * <p> Additionally, to support various visual options nodes may have,
	 * they also have a W/H area, color, alpha, and rotation values, although
	 * its up to each derived node class to decide if / how they'll use
	 * those values. (Example: A group will pass those values onto its children,
	 * while a sound emitter will just ignore them. A particle emitter might
	 * use all values but W/H).
	 * 
	 * <p> The work of each <code>EfNode</code> takes place in their update
	 * and render functions. If you create your own <code>EfNode</code>, be
	 * sure to override <code>onUpdate(...)</code> and <code>onRender()</code>
	 * functions.
	 * 
	 * <p> An advantage of the hierarchy system is that you can group elements
	 * together, and then adjust just the parent, which will pass the effects
	 * downward. For example, if you have all of your elements in a group, you
	 * can move the parent to (100,100) and the children will move as well.
	 * You can also set a parent group to <code>active = false;</code>, which
	 * immediately turns it and its descednent <code>EfNode</code>s off. (This
	 * can be really useful to show/hide a menu system, for example).
	 * 
	 * <p> An EfNode tree's update/render order is an important concept to 
	 * understand. In a nutshell, it updates/renders from the bottom to the
	 * top. See efme.examples.Ex05_GameTree for a deeper discussion on this
	 * point.
	 * 
	 * <p> <strong>Note:</strong> As a naming convention, any EfNode-derived
	 * class begins with the letters <code>Efn</code>, for example 
	 * <code>EfnGroup</code>, <code>EfnSprite</code>, <code>EfnParticles</code>,
	 * etc.
	 * 
	 * @see efme.GameState#efNodes
	 */
	public class EfNode
	{
		/**
		 * Construct an EfNode.
		 * 
		 * <p> Note that all EfNodes have the potential to own child nodes,
		 * but you have to specify that in the constructor.
		 *
		 * @param parentState The game state this node is part of
		 * @param hasChildren Whether or not this node can have children (Default = false)
		 */
		public function EfNode(parentState:GameState, hasChildren:Boolean = false) 
		{
			_parentState = parentState;
			if (hasChildren)
			{
				_childNodes = new EfNodeList();
			}

			_active = true;
			_rectArea = new Rectangle();
			_drawOptions = new DrawOptions();
		}
		
		public function get parentState():GameState { return _parentState; }
		
		public function get engine():GameEngine { return _parentState.engine; }
		
		/**
		 * Whether or not this node is active. If <code>false</code>, this
		 * node (and any children nodes it may have) will not get calls to
		 * <code>update</code> and <code>render</code>.
		 */
		public function get active():Boolean { return _active; }
		public function set active(value:Boolean):void { _active = value; }

		/**
		 * The x-coordinate of this node (relative to its parent)
		 */
		public function get x():Number { return _rectArea.x; }
		public function set x(value:Number):void { _rectArea.x = value; _modified = true; }
		
		/**
		 * The y-coordinate of this node (relative to its parent)
		 */
		public function get y():Number { return _rectArea.y; }
		public function set y(value:Number):void { _rectArea.y = value; _modified = true; }

		/**
		 * The width of this node
		 */
		public function get width():Number { return _rectArea.width; }
		public function set width(value:Number):void { _rectArea.width = value; _modified = true; }
		
		/**
		 * The height of this node
		 */
		public function get height():Number { return _rectArea.height; }
		public function set height(value:Number):void { _rectArea.height = value; _modified = true; }

		/**
		 * The tint color of this node. (Default = 0xFFFFFF, i.e. white)
		 */
		public function get color():uint { return _drawOptions.blendColor; }
		public function set color(value:uint):void { _drawOptions.blendColor = value; _modified = true; }

		/**
		 * The alpha of this node. Clamped 0.0 to 1.0 (Default = 1.0)
		 */
		public function get alpha():Number { return _drawOptions.alpha; }
		public function set alpha(value:Number):void { _drawOptions.alpha = value; _modified = true; }

		/**
		 * Number (in degrees) that you want to rotate your image.
		 * (Default = 0.0)
		 */
		public function get rotation():Number { return _drawOptions.rotation; }
		public function set rotation(value:Number):void { _drawOptions.rotation = value; _modified = true; }
		
		/**
		 * Anchor-point to rotate around.
		 */
		public function get rotationAnchor():uint { return _drawOptions.rotationAnchor; }
		public function set rotationAnchor(value:uint):void { _drawOptions.rotationAnchor = value; _modified = true; }
		
		/**
		 * Update this EfNode. This call will be ignored if the node is not
		 * active.
		 * 
		 * @param offset The offset of this class's parent from 0x0. To get the this EfNode's absolute position, use offset.x + x, offset.y + y
		 */
		final public function update(offset:Point, elapsedTime:uint):void
		{
			if (_active)
			{
				onUpdate(offset, elapsedTime);
				_modified = false;
			}
		}
		
		/**
		 * Render this EfNode. This call will be ignored if the node is not
		 * active.
		 */
		final public function render():void
		{
			if (_active)
			{
				onRender();
			}
		}
		
		/**
		 * Override this function in your derived class to handle
		 * updating this node.
		 */
		protected function onUpdate(offset:Point, elapsedTime:uint):void 
		{
		}

		/**
		 * Override this function in your derived class to handle
		 * rendering this node.
		 */
		protected function onRender():void 
		{
		}
		
		/**
		 * Whether or not this node has been modified this frame. You can
		 * choose to check this value if your node's update loop is expensive,
		 * and you only want to do so when something has changed (like
		 * re-parse some text).
		 * 
		 * <p> You may choose to set it yourself; this variable is really
		 * provided for your convenience, as the base class doesn't use it at
		 * all.
		 */
		protected function get modified():Boolean { return _modified; }
		protected function set modified(value:Boolean):void { _modified = value; }

		/**
		 * The internal drawOptions that is updated when . This class is updated when a user makes
		 * edits to this EfNode. If you call <code>Image.drawXXX(...)</code>,
		 * be sure to pass this in!
		 */
		protected function get drawOptions():DrawOptions { return _drawOptions; }

		private var _parentState:GameState;
		
		private var _active:Boolean;
		private var _rectArea:Rectangle;
		private var _drawOptions:DrawOptions;
		private var _childNodes:EfNodeList;
		private var _modified:Boolean;
	}

}