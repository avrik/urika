package  
{
	import game.GameController;
	import game.GameView;
	import starling.display.Sprite;
	import urikatils.LoggerHandler;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class Application extends Sprite 
	{
		private var _gameController:GameController;
		
		public function Application() 
		{
			super();
			LoggerHandler.getInstance.info(this, "APPLICATION READY");
			var gameView:GameView = new GameView();
			
			_gameController = new GameController(gameView);
			
			addChild(gameView);
		}
		
	}

}