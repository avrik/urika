package game 
{
	import game.board.BoardController;
	import game.board.BoardView;
	/**
	 * ...
	 * @author Avrik
	 */
	public class GameController 
	{
		private var _gameView:GameView;
		private var _boardController:BoardController;
		
		public function GameController(gameView:GameView) 
		{
			this._gameView = gameView;
			
			newGame();
		}
		
		public function newGame():void
		{
			setNewBoard();
		}
		
		private function setNewBoard():void 
		{
			var boardView:BoardView = new BoardView();
			this._boardController = new BoardController(boardView);
			this._boardController.init();
			
			this._gameView.addChild(boardView);
		}
		
	}

}