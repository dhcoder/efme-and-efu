package efme.game
{
	import efme.core.graphics2d.Anchor;
	import efme.core.graphics2d.DrawOptions;
	import flash.geom.Point;
	/**
	 * EfNodes are the building blocks of the EFME engine. You can think of
	 * them essentially as game objects. For everything in a game that
	 * has positional information (such as a player, enemy, text blurb, button,
	 * sound emitter, particle emitter, etc.), then it is almost certainly
	 * derived from an EfNode.
	 * 
	 * <p> The EFME engine uses a hierarchical, tree orgnaization system for its
	 * game objects, where <code>GameEngine.gameRoot</code> is the exposed
	 * starting point. Each part of that tree is an EfNode.
	 * 
	 * <p> EfNodes have an X/Y position, color, alpha, rotation, and 
	 * active values. (Careful, EfNodes are points and don't have W/H in most
	 * cases). They also have <code>onInit()</code>, <code>onShutdown()</code>,
	 * <code>onUpdate(elapsedTime:int)</code>, and 
	 * <code>onRender(renderState:RenderState)</code> functions you can
	 * overload.
	 * 
	 * <p> An advantage of the hierarchy system is that you can group elements
	 * together, and then adjust just the parent, which will pass the effects
	 * downward. For example, if you have all of your elements in a group, you
	 * can move the parent to (100,100) and the children will move as well.
	 * You can also set a parent group to <code>active = false;</code>, which
	 * immediately turns it and its descednent EfNodes off. (This can be really
	 * useful to show/hide a menu system, for example).
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
	 * @see efme.GameEngine#gameRoot
	 */
	public class EfNode
	{
		public function EfNode() 
		{
		}
		
		/**
		 * The x-coordinate of this node (relative to its parent)
		 */
		public function get x():Number { return _pos.x; }
		public function set x(value:Number):void { _pos.x = value; }
		
		/**
		 * The y-coordinate of this node (relative to its parent)
		 */
		public function get y():Number { return _pos.y; }
		public function set y(value:Number):void { _pos.y = value; }

		/**
		 * The tint color of this node. (Default = 0xFFFFFF, i.e. white)
		 */
		public function get color():uint { return _drawOptions.blendColor; }
		public function set color(value:uint):void { _drawOptions.blendColor = value; }

		/**
		 * The alpha of this node. Clamped 0.0 to 1.0 (Default = 1.0)
		 */
		public function get alpha():Number { return _drawOptions.alpha; }
		public function set alpha(value:Number):void { _drawOptions.alpha = value; }

		/**
		 * Number (in degrees) that you want to rotate your image.
		 * (Default = 0.0)
		 */
		public function get rotation():Number { return _drawOptions.rotation; }
		public function set rotation(value:Number):void { _drawOptions.rotation = value; }
		
		/**
		 * Anchor-point to rotate around.
		 */
		public function get rotationAnchor():uint { return _drawOptions.rotationAnchor; }
		public function set rotationAnchor(value:uint):void { _drawOptions.rotationAnchor = value; }
		
		/**
		 * Whether or not this node is active. If <code>false</code>, this
		 * node (and any children nodes it may have) will not get calls to
		 * <code>update</code> and <code>render</code>.
		 */
		public function get active():Boolean { return _active; }
		public function set active(value:Boolean):void { _active = value; }
		
		/**
		 * Initialize this EfNode. This gets called when a node is added into
		 * the EFME system.
		 */
		final public function init():void
		{
			_pos = new Point();
			_drawOptions = new DrawOptions();
			_active = true;

			onInit();
		}
		
		/**
		 * Initialize this EfNode. This gets called when a node is removed out
		 * of the EFME system.
		 */
		final public function shutdown():void
		{
			onShutdown();
			
			_pos = null;
			_drawOptions = null;
			_active = false;
		}

		/**
		 * Update this EfNode. This call will be ignored if the node is not
		 * active.
		 */
		final public function update(elapsedTime:int):void
		{
			if (_active)
			{
				onUpdate(elapsedTime);
			}
		}
		
		/**
		 * Render this EfNode. This call will be ignored if the node is not
		 * active.
		 */
		final public function render(renderState:RenderState):void
		{
			if (_active)
			{
				onRender(renderState);
			}
		}
		
		/**
		 * Override this function in your derived class to handle
		 * initializing this node.
		 */
		protected function onInit():void
		{
		}
		
		/**
		 * Override this function in your derived class to handle
		 * cleaning up any resources used by this node.
		 */
		protected function onShutdown():void
		{
		}

		/**
		 * Override this function in your derived class to handle
		 * updating this node.
		 */
		protected function onUpdate(elapsedTime:int):void 
		{
		}

		/**
		 * Override this function in your derived class to handle
		 * rendering this node.
		 */
		protected function onRender(renderState:RenderState):void 
		{
		}
		
		/**
		 * The internal drawOptions. This class is updated when a user makes
		 * edits to this EfNode. If you call <code>Image.drawXXX(...)</code>,
		 * be sure to pass this in!
		 */
		protected function get drawOptions():DrawOptions { return _drawOptions; }
		
		private var _pos:Point;
		private var _drawOptions:DrawOptions;
		private var _active:Boolean;
	}

}