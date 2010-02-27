package efme.game 
{
	/**
	 * The root of all EfNode game objects.
	 */
	public class GameState
	{
		public function GameState() 
		{
			_efnRootNodes = new EfNodeList();
		}
		
		public function init():void
		{
			onInit();
		}
		
		public function shutdown():void
		{
			_efnRootNodes.shutdown();
			onShutdown();
		}
	
		public function update(elapsedTime:int):void
		{
			_efnRootNodes.update(elapsedTime);
		}
		
		public function render():void
		{
			var renderState:RenderState = new RenderState();
			_efnRootNodes.render(renderState);
		}
		
		protected function onInit():void 
		{
		}
		
		protected function onShutdown():void
		{
		}
		
		private var _efnRootNodes:EfNodeList;
	}

}