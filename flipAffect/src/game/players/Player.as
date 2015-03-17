package game.players 
{
	import game.pions.Pion;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Player 
	{
		private var _playerModel:PlayerModel;
		private var _pions:Vector.<Pion> = new Vector.<Pion>;
		
		public function Player(playerModel:PlayerModel) 
		{
			this._playerModel = playerModel;
			for (var i:int = 0; i < 10; i++) 
			{
				addPion();
			}
		}
		
		private function addPion():void 
		{
			var newPion:Pion = new Pion(playerModel.color);
			_pions.push(newPion);
		}
		
		public function get playerModel():PlayerModel 
		{
			return _playerModel;
		}
		
	}

}