﻿package efme.game
{
	import efme.core.graphics2d.Image;
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
		 */
		public function EfNode(parentState:GameState) 
		{
			_parentState = parentState;
			_childNodes = null;

			_active = true;
			
			_rectArea = new Rectangle(0, 0, -1, -1);
			_drawOptions = new DrawOptions();
			_alarms = new AlarmList();
			
			_defaultWidth = 0.0;
			_defaultHeight = 0.0;

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

		// TODO: Check if value chaned before setting modified to true
		
		/**
		 * The x-coordinate of this node (relative to its parent)
		 */
		public function get x():Number { return _rectArea.x; }
		public function set x(value:Number):void
		{
			if (_rectArea.x != value)
			{
				_rectArea.x = value; 
				_modified = true;
			}
		}
		
		/**
		 * The y-coordinate of this node (relative to its parent)
		 */
		public function get y():Number { return _rectArea.y; }
		public function set y(value:Number):void
		{
			if (_rectArea.y != value)
			{
				_rectArea.y = value;
				_modified = true;
			}
		}

		/**
		 * The width of this node
		 */
		public function get width():Number { return (_rectArea.width >= 0.0 ? _rectArea.width : _defaultWidth); }
		public function set width(value:Number):void
		{
			if (_rectArea.width != value)
			{
				_rectArea.width = value;
				_modified = true;
			}
		}
		
		/**
		 * The height of this node
		 */
		public function get height():Number { return (_rectArea.height >= 0.0 ? _rectArea.height : _defaultHeight); }
		public function set height(value:Number):void
		{
			if (_rectArea.height != value)
			{
				_rectArea.height = value;
				_modified = true;
			}
		}


		/**
		 * Return the rectangular bounds of this node (relative to its parent).
		 */
		public function get bounds():Rectangle { return new Rectangle(_rectArea.x, _rectArea.y, width, height); }

		/**
		 * The tint color of this node. (Default = 0xFFFFFF, i.e. white)
		 */
		public function get color():uint { return _drawOptions.blendColor; }
		public function set color(value:uint):void
		{
			if (_drawOptions.blendColor != value)
			{
				_drawOptions.blendColor = value;
				_modified = true;
			}
		}

		/**
		 * The alpha of this node. Clamped 0.0 to 1.0 (Default = 1.0)
		 */
		public function get alpha():Number { return _drawOptions.alpha; }
		public function set alpha(value:Number):void
		{
			if (_drawOptions.alpha != value)
			{
				_drawOptions.alpha = value;
				_modified = true;
			}
		}

		/**
		 * Number (in degrees) that you want to rotate your image.
		 * (Default = 0.0)
		 */
		public function get rotation():Number { return _drawOptions.rotation; }
		public function set rotation(value:Number):void
		{
			if (_drawOptions.rotation != value)
			{
				_drawOptions.rotation = value;
				_modified = true;
			}
		}
		
		/**
		 * Anchor-point to rotate around.
		 */
		public function get rotationAnchor():uint { return _drawOptions.rotationAnchor; }
		public function set rotationAnchor(value:uint):void
		{
			if (_drawOptions.rotationAnchor != value)
			{
				_drawOptions.rotationAnchor = value;
				_modified = true;
			}
		}
		
		/**
		 * Get this node's list of alarms. You can directly add new alarms to
		 * this property, by calling <code>alarms.add(new Alarm(...))</code>.
		 */
		public function get alarms():AlarmList { return _alarms; }
		
		public function fitToChildren(recursive:Boolean = false):void
		{
			if (_childNodes != null)
			{
				var nNode:uint;
				var efNode:EfNode;
				
				if (recursive)
				{
					for (nNode = 0; nNode < _childNodes.length; ++nNode)
					{
						_childNodes.getNode(nNode).fitToChildren(true);
					}
				}
				
				var minX:Number = Number.MAX_VALUE;
				var minY:Number = Number.MAX_VALUE;
				var maxX:Number = Number.MIN_VALUE;
				var maxY:Number = Number.MIN_VALUE;
				
				for (nNode = 0; nNode < _childNodes.length; ++nNode)
				{
					efNode = _childNodes.getNode(nNode);
					
					minX = Math.min(minX, efNode.x);
					minY = Math.min(minY, efNode.y);
					maxX = Math.max(maxX, efNode.x + efNode.width);
					maxY = Math.max(maxY, efNode.y + efNode.height);
				}
				
				x += minX
				y += minY
				width = maxX - minX;
				height = maxY - minY;

				if (minX != 0 || minY != 0)
				{
					for (nNode = 0; nNode < _childNodes.length; ++nNode)
					{
						efNode = _childNodes.getNode(nNode);
						
						efNode.x -= minX;
						efNode.y -= minY;
					}
				}
			}
		}
		
		/**
		 * Update this EfNode. This call will be ignored if the node is not
		 * active.
		 * 
 		 * <p> This function calls <code>onUpdate(...)</code> to give any
		 * derived classes a chance to handle this call.
		 * 
		 * @param offset The offset of this class's parent from 0x0. To get the this EfNode's absolute position, use offset.x + x, offset.y + y
		 */
		final public function update(offset:Point, elapsedTime:uint):void
		{
			if (_active)
			{
				_alarms.update(elapsedTime);

				onUpdate(offset, elapsedTime);
				
				if (_childNodes != null)
				{
					offset.x += _rectArea.x;
					offset.y += _rectArea.y;

					_childNodes.update(offset, elapsedTime);

					offset.x -= _rectArea.x;
					offset.y -= _rectArea.y;
				}
				
				onUpdateComplete();
				
				_modified = false;
			}
		}
		
		/**
		 * Render this EfNode. This call will be ignored if the node is not
		 * active or if it is totally transparent.
		 * 
		 * <p> This function calls <code>onRender()</code> to give any
		 * derived classes a chance to handle this call.
		 * 
		 * @see onRender
		 */
		final public function render():void
		{
			if (_active && alpha > 0.0)
			{
				onRender();
				
				if (_childNodes != null)
				{
					Image.drawState.pushDrawOptions(bounds, drawOptions);
					
					_childNodes.render();

					Image.drawState.popDrawOptions();
				}
				
				onRenderComplete();
			}
		}
		
		/**
		 * Do cleanup work on this node and any children it might have.
		 * For example, it releases all internal alarms.
		 * 
		 * <p> This function will get called on all nodes in a game state when 
		 * that game state is exited. However, if you manually remove an
		 * <code>EfNode</code> from a game state before it is exited, you are
		 * recommended to call this function yourself. (For example, if you
		 * kill an enemy node and pull it out of the game state, it is safe
		 * to call <code>enemyNode.cleanup()</code>.
		 * 
		 * <p> This function calls <code>onCleanup()</code> to give any
		 * derived classes a chance to handle this call.
		 * 
		 * @see onCleanup
		 */
		final public function cleanup():void
		{
			_alarms.clear();
			onCleanup();
			
			if (_childNodes != null)
			{
				_childNodes.cleanup();
				_childNodes = null;
			}
		}
		
		// TODO: MORE FINALS EVERYWHERE! MAKES INTERFACE INTENTIONS CLEARER
		
		/**
		 * Override this function in your derived class to handle
		 * updating this node.
		 */
		protected function onUpdate(offset:Point, elapsedTime:uint):void 
		{
		}
	
		/**
		 * Override this function in your derived class to handle rendering this
		 * node.
		 */
		protected function onRender():void 
		{
		}
		
		/**
		 * Override this function in your derived class if you need to do
		 * anything once the node is done updating. This might be useful if you
		 * had to prepare some temporary resources for the node's children
		 * while they updated.
		 */
		protected function onUpdateComplete():void
		{
		}
		
		/**
		 * Override this function in your derived class if you need to do
		 * anything once the node is done rendering. This might be useful if you
		 * had to prepare some temporary resources for the node's children
		 * while they rendered.
		 */
		protected function onRenderComplete():void
		{
		}
		
		/**
		 * Override this function in your derived class to handle cleaning up
		 * any internal resources it may have held onto while its parent game
		 * state was running.
		 */
		protected function onCleanup():void
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
		 * (Internal access only) Get or set the default width of this node.
		 * This is the width that is used if the user never explicitly sets the
		 * size.
		 */
		protected function get defaultWidth():Number { return _defaultWidth; }
		protected function set defaultWidth(value:Number):void
		{
			if (_defaultWidth != value)
			{
				_defaultWidth = value;
				_modified = true;
			}
		}
			

		/**
		 * (Internal access only) Get or set the default height of this node.
		 * This is the width that is used if the user never explicitly sets the
		 * size.
		 */
		protected function get defaultHeight():Number { return _defaultHeight; }
		protected function set defaultHeight(value:Number):void
		{
			if (_defaultHeight != value)
			{
				_defaultHeight = value;
				_modified = true;
			}
		}

		/**
		 * The internal drawOptions that is updated when the user change's
		 * any of this node's visual settings (width, height, rotation, color,
		 * etc.).
		 * 
		 * <p> Calls to <code>Image.drawXXX(...)</code> expect a
		 * <code>DrawOptions</code> argument. Instead of creating your own copy
		 * at render time, just pass this one in!
		 */
		protected function get drawOptions():DrawOptions { return _drawOptions; }
		
		/**
		 * Provide protected access to this node's children.
		 */
		protected function get childNodes():EfNodeList
		{
			if (_childNodes == null)
			{
				_childNodes = new EfNodeList(); // Lazy instantiation - create memory for children when requested first time
			}

			return _childNodes;
		}

		private var _parentState:GameState;
		
		private var _active:Boolean;
		
		private var _rectArea:Rectangle;
		private var _drawOptions:DrawOptions;
		private var _defaultWidth:Number;
		private var _defaultHeight:Number;
		private var _modified:Boolean;

		private var _childNodes:EfNodeList;
		private var _alarms:AlarmList;
	}
}