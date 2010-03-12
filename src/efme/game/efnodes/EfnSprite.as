package efme.game.efnodes 
{
	import efme.core.graphics2d.Image;
	import efme.core.graphics2d.support.Anchor;
	import efme.core.graphics2d.support.DrawOptions;
	import efme.core.graphics2d.support.TilePosition;
	import efme.game.Animation;
	import efme.game.AnimationState;
	import efme.game.Callback;
	import efme.game.EfNode;
	import efme.game.GameState;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * An EfNode which can display static and animated images.
	 */
	public class EfnSprite extends EfNode
	{
		/**
		 * Create a new, empty sprite. If you want to set it to a single, static
		 * image, or at least set up an initial image, you can do so here.
		 * 
		 * <p> If a sprite's W/H values are set to 0, the target image's W/H
		 * is used when rendering.
		 * 
		 * <p> Change the image a sprite is pointing to using the
		 * <cod>targetImage</code> property.
		 * 
		 * <p> Use the <code>addAnimation(...)</code> and
		 * <code>playAnimation(...)</code> functions to use animations
		 * with this sprite.
		 * 
		 * @see #addAnimation
		 * 
		 * @param parentState The game state this node is part of
		 * @param image An image to set as this sprite's target.
		 * @param width The width of this node. Leave as 0 to use the target image's width.
		 * @param height The height of this node. Leave as 0 to use the target image's height.
		 */
		public function EfnSprite(parentState:GameState, image:Image = null, width:Number = 0.0, height:Number = 0.0)
		{
			super(parentState);
			
			_targetImage = image;
			_targetTile = null;
			_targetSubrect = null;
			
			_renderAnchor = Anchor.TOP_LEFT;
			
			_dictAnims = null;
			_currentAnim = -1;
			
			updateDefaultSize();
		}
		
		/**
		 * Get or set the active image this sprite displays.
		 */
		public function get targetImage():Image { return _targetImage; }
		public function set targetImage(value:Image):void
		{
			if (_targetImage != value)
			{
				_targetImage = value;
				setToWholeImage();
			}
		}
		
		/**
		 * Whether or not this sprite is flipped horizontally.
		 */
		public function get flipX():Boolean { return drawOptions.flipX; }
		public function set flipX(value:Boolean):void
		{
			if (drawOptions.flipX != value)
			{
				drawOptions.flipX = value;
				modified = true;
			}
		}
		
		/**
		 * Whether or not this sprite is flipped vertically.
		 */
		public function get flipY():Boolean { return drawOptions.flipY; }
		public function set flipY(value:Boolean):void
		{
			if (drawOptions.flipY != value)
			{
				drawOptions.flipY = value;
				modified = true;
			}
		}

		/**
		 * Specify this sprite's render anchor (i.e. the part of the sprite to
		 * draw at X,Y). Common values for this are TOP_LEFT (default behavior)
		 * and CENTER (drawn centered at X,Y).
		 */
		public function get renderAnchor():int { return _renderAnchor; }
		public function set renderAnchor(value:int):void { _renderAnchor = value; }
		
		/**
		 * Whether or not this sprite uses smoothing when rendering. Looks better but
		 * more expensive.
		 */
		public function get applySmoothing():Boolean { return drawOptions.applySmoothing; }
		public function set applySmoothing(value:Boolean):void { drawOptions.applySmoothing = value; }
		
		/**
		 * The current animation that is set. Check <code>isAnimPlaying</code>
		 * to see if it's currently playing.
		 */
		public function get currentAnimation():int { return _currentAnim; }
		
		/**
		 * By default, sprites use the whole image. If this sprite's target
		 * image is tiled, though, and you want to set this sprite to a
		 * particular tile, then call this function.
		 * 
		 * <p> Once a sprite is set to tiled mode, it will remain so until
		 * the <code>targetImage</code> property is changed, or until a call
		 * to either the <code>setToSubrect(...)</code> or 
		 * <code>setToWholeImage</code> functions.
		 * 
		 * @param tileX The X-index of the tile to set to
		 * @param tileY The Y-index of the tile to set to
		 */
		public function setToTile(tileX:uint, tileY:uint):void
		{
			_targetSubrect = null;
			
			if (_targetTile == null)
			{
				_targetTile = new TilePosition(tileX, tileY);
			}
			else
			{
				_targetTile.X = tileX;
				_targetTile.Y = tileY;
			}

			updateDefaultSize();
		}
		
		/**
		 * By default, sprites use the whole image. If you want to set this
		 * sprite to a portion of the tiled image, though, then call this
		 * function.
		 * 
		 * <p> Once a sprite is set to subrect mode, it will remain so until
		 * the <code>targetImage</code> property is changed, or until a call
		 * to either the <code>setToSubrect(...)</code> or 
		 * <code>setToWholeImage</code> functions.
		 * 
		 * @param subrect The portion of the image to set to
		 */
		public function setToSubrect(subrect:Rectangle):void
		{
			_targetTile = null;
			
			if (_targetSubrect == null)
			{
				_targetSubrect = subrect.clone();
			}
			else
			{
				_targetSubrect.x = subrect.x;
				_targetSubrect.y = subrect.y;
				_targetSubrect.width = subrect.width;
				_targetSubrect.height = subrect.height;
			}
			
			updateDefaultSize();
		}
		
		/**
		 * Use this function to reset the effect of calling either
		 * <code>setToTile</code> or <code>setToSubrect</code> functions.
		 * 
		 * <p> <strong>Note:</strong> You do not need to call this when
		 * you set a sprite to a new target image.
		 * 
		 * @param subrect The portion of the image to set to
		 */
		public function setToWholeImage():void
		{
			if (_targetTile != null || _targetSubrect != null)
			{
				_targetTile = null;
				_targetSubrect = null;
			}

			updateDefaultSize();
		}

		public function addAnimation(animIndex:uint, sourceImage:Image, frames:Array, repeat:Boolean = false):void
		{
			if (sourceImage == null) { throw new Error("Attempting to add animation with no source image."); }
			var animData:Animation = new Animation(sourceImage, frames);
			addAnimationData(animIndex, animData, repeat);
		}
		
		public function addAnimationData(animIndex:uint, animData:Animation, repeat:Boolean = false):void
		{
			if (_dictAnims == null) { _dictAnims = new Dictionary(); }
			
			_dictAnims[animIndex] = new AnimationState(animData, repeat);
		}
		
		public function startAnimation(animIndex:uint, callbackAnimComplete:Callback = null):Boolean
		{
			if (_dictAnims[animIndex] != null)
			{
				if (_currentAnim >= 0)
				{
					// Clear any current animation that's already playing
					(_dictAnims[_currentAnim] as AnimationState).reset();
				}

				_currentAnim = animIndex;
				var animState:AnimationState = _dictAnims[animIndex];
				animState.start(callbackAnimComplete);
				
				setToAnimFrame();
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function stopAnimation():Boolean
		{
			if (_currentAnim >= 0)
			{
				(_dictAnims[_currentAnim] as AnimationState).stop();
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function resumeAnimation():Boolean
		{
			if (_currentAnim >= 0)
			{
				(_dictAnims[_currentAnim] as AnimationState).resume();
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function isAnimSet():Boolean
		{
			return (_currentAnim >= 0);
		}
		
		public function isAnimPlaying():Boolean
		{
			if (_currentAnim >= 0)
			{
				return (_dictAnims[_currentAnim] as AnimationState).isPlaying;
			}
			else
			{
				return false;
			}
		}
		
		public function getAnimPlayTime():uint
		{
			if (_currentAnim >= 0)
			{
				return (_dictAnims[_currentAnim] as AnimationState).playTime;
			}
			else
			{
				return 0;
			}
		}
		
		
		public function isAnimComplete():Boolean
		{
			if (_currentAnim >= 0)
			{
				return (_dictAnims[_currentAnim] as AnimationState).isComplete;
			}
			else
			{
				return false;
			}
		}

		/**
		 * Update this sprite.
		 */
		override protected function onUpdate(offset:Point, elapsedTime:uint):void 
		{
			if (_currentAnim >= 0)
			{
				var animState:AnimationState = _dictAnims[_currentAnim];
				animState.update(elapsedTime);
				setToAnimFrame();
			}
			
			if (modified)
			{
				if (_targetImage != null)
				{
					if (_targetTile != null)
					{
						drawOptions.scaleX = (width > 0.0 ? width / _targetImage.tileWidth : 1.0);
						drawOptions.scaleY = (height > 0.0 ? height / _targetImage.tileHeight : 1.0);
					}
					else if (_targetSubrect != null)
					{
						drawOptions.scaleX = (width > 0.0 ? width / _targetSubrect.width : 1.0);
						drawOptions.scaleY = (height > 0.0 ? height / _targetSubrect.height : 1.0);
					}
					else
					{
						drawOptions.scaleX = (width > 0.0 ? width / _targetImage.width : 1.0);
						drawOptions.scaleY = (height > 0.0 ? height / _targetImage.height : 1.0);
					}
				}
			}
		}
		
		/**
		 * Render this sprite.
		 */
		override protected function onRender():void 
		{
			if (_targetImage != null)
			{
				var renderPoint:Point = new Point(x, y);
				
				if (_renderAnchor != Anchor.TOP_LEFT)
				{
					var anchorPoint:Point = Anchor.getAnchorPoint(bounds, _renderAnchor);
					renderPoint.x -= (anchorPoint.x - x);
					renderPoint.y -= (anchorPoint.y - y);
				}
				
				if (_targetTile != null)
				{
					_targetImage.drawTile(engine.screen, _targetTile.X, _targetTile.Y, renderPoint, drawOptions);
				}
				else if (_targetSubrect != null)
				{
					_targetImage.drawSub(engine.screen, _targetSubrect, renderPoint, drawOptions);
				}
				else
				{
					_targetImage.draw(engine.screen, renderPoint, drawOptions);
				}
			}
		}

		/**
		 * Update this node's default size, depending on the current
		 * target image settings.
		 */
		private function updateDefaultSize():void
		{
			if (_targetImage != null)
			{
				if (_targetTile != null)
				{
					defaultWidth = _targetImage.tileWidth;
					defaultHeight = _targetImage.tileHeight;
				}
				else if (_targetSubrect != null)
				{
					defaultWidth = _targetSubrect.width;
					defaultHeight = _targetSubrect.height;
				}
				else
				{
					defaultWidth = _targetImage.width;
					defaultHeight = _targetImage.height;
				}
			}
			else
			{
				defaultWidth = 0;
				defaultHeight = 0;
			}
		}

		/**
		 * If an animation is currently running, update this sprite to the
		 * current frame in the animation.
		 */
		private function setToAnimFrame():void
		{
			if (_currentAnim >= 0)
			{
				var animState:AnimationState = _dictAnims[_currentAnim]; 
				
				modified = (_targetImage != animState.targetAnim.sourceImage);
				_targetImage = animState.targetAnim.sourceImage;
				
				setToTile(animState.currentTile.X, animState.currentTile.Y);
			}
		}

		private var _targetImage:Image;
		private var _targetTile:TilePosition;
		private var _targetSubrect:Rectangle;

		private var _renderAnchor:int;
	
		private var _dictAnims:Dictionary;
		private var _currentAnim:int;
		
	}

}