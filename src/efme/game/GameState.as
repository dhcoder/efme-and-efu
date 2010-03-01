package efme.game 
{
	import efme.GameEngine;
	import flash.geom.Point;
	/**
	 * The root of all EfNode game objects.
	 */
	public class GameState
	{
		/**
		 * Create a new game state. A game state represents a section of your
		 * game, and each state has its own set of <code>EfNode</code>s which 
		 * you can access via the <code>efNodes</code> property.
		 * 
		 * @param gameEngine The parent game engine this state is attached to.
		 */
		public function GameState(gameEngine:GameEngine) 
		{
			_gameEngine = gameEngine;
			
			_camera = new Point(0, 0);
			_efNodes = new EfNodeList();
		}
		
		/**
		 * Provide access to the engine that this game state is attached to.
		 * Use this property to get access to game services, input state,
		 * the screen we are rendering to, and more.
		 */
		public function get engine():GameEngine { return _gameEngine; }

		/**
		 * The X/Y position of the camera. Move the camera to, in turn,
		 * move the portion of the screen being drawn.
		 */
		public function get camera():Point { return _camera; }
		
		/**
		 * The EfNodes that represent the game objects in this game state.
		 */
		public function get efNodes():EfNodeList { return _efNodes; }
		
		/**
		 * When a <code>GameEngine</code> enters a new game state, this
		 * function is called.
		 * 
		 * <p> Your own derived class should override <code>onEntered()</code>,
		 * which will be called by this function.
		 */
		final public function handleEntered():void
		{
			onEntered();
		}
		
		/**
		 * Update the contents of this game state.
		 */
		final public function update(elapsedTime:uint):void
		{
			onUpdate(elapsedTime); // Give the game-state a chance to handle the update
			
			// Update all EfNodes. Note that if our camera is set to 100x50,
			// we actually want to offset our nodes to -100x-50, shifting
			// the world up and left to give us the illusion that the camera
			// moved down and right.
			var inverseCamera:Point = new Point(-_camera.x, -_camera.y);
			_efNodes.update(inverseCamera, elapsedTime);
		}
		
		/**
		 * Render the contents of this game state to the screen.
		 */
		final public function render():void
		{
			onRenderBackground();
			_efNodes.render();
			onRenderForeground();
		}
		
		/**
		 * Override in a derived class. This is a good place to set up the
		 * initial positions and states of any assets and objects that is
		 * part of this game state.
		 */
		protected function onEntered():void 
		{
		}
		
		/**
		 * Override in a derived class. This is a good place to update some
		 * game-state specific systems, if any.
		 * 
		 * @param elapsedTime Time (in ms) passed since the last update call.
		 */
		protected function onUpdate(elapsedTime:uint):void
		{
		}
		
		/**
		 * Override in a derived class. This function gives your game state
		 * a chance to render before the EfNodes (and therefore below them).
		 * 
		 * <p><strong>Note:</strong> Usually, most/all rendering should take
		 * place in your <code>EfNode</code>s, but this hook-point is still
		 * provided for conveninece, or also if you want to render something that
		 * should be drawn in the background during this game state.
		 * 
		 * @see efme.game.EfNode
		 * @see efme.game.EfNode#onRender
		 */
		protected function onRenderBackground():void
		{
		}
		
		/**
		 * Override in a derived class. This function gives your game state
		 * a chance to render after the EfNodes (and therefore on top of them).
		 * 
		 * <p><strong>Note:</strong> Usually, most/all rendering should take
		 * place in your <code>GameState</code>'s <code>EfNode</code>s, but this
		 * hook-point is still provided if you want to render something that
		 * should be drawn in the background during this game state.
		 * 
		 * @see efme.game.EfNode
		 * @see efme.game.EfNode#onRender
		 */
		protected function onRenderForeground():void
		{
		}

		private var _gameEngine:GameEngine;
		
		private var _camera:Point;
		private var _efNodes:EfNodeList;
	}

}