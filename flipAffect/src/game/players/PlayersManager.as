package game.players 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class PlayersManager 
	{
		private var _players:Vector.<Player>=new Vector.<Player>
		private var _currentPlayerIndex:int=0;
		public function PlayersManager() 
		{
			
		}
		
		public function addNewPlayer(playerModel:PlayerModel):void 
		{
			_players.push(new Player(playerModel));
		}
		
		public function getCurrentPlayer():Player 
		{
			var player:Player = _players[_currentPlayerIndex];
			
			return player;
		}
		
	}

}