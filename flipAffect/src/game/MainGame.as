package game 
{
	import game.board.BoardEvent;
	import game.board.BoardView;
	import game.players.PlayerModel;
	import game.players.PlayersManager;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class MainGame extends Sprite 
	{
		private var _board:BoardView;
		private var _playersManager:PlayersManager
		
		public function MainGame() 
		{
			super();
			trace("NEW GAME");
			init();
		}
		
		private function init():void
		{
			_playersManager = new PlayersManager;
			_playersManager.addNewPlayer(new PlayerModel(PlayerModel.RED))
			_playersManager.addNewPlayer(new PlayerModel(PlayerModel.BLUE))
			_board = new BoardView();
			_board.addEventListener(BoardEvent.NODE_CLICK,onNodeClick)
			addChild(_board);
			
			startNewGame();
		}
		
		private function onNodeClick(e:BoardEvent):void 
		{
			trace("CLICK");
		}
		
		private function startNewGame():void 
		{
			nextRound();
		}
		
		private function nextRound():void 
		{
			_playersManager.getCurrentPlayer()
		}
		
	}

}