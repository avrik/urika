package gamePlay 
{
	import players.Player;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.utils.Color;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Alliance extends EventDispatcher
	{
		public static var validForTurns:int = 5;
		
		private var _id:int;
		private var _players:Vector.<Player>
		private var _validForMoreRounds:int;
		private var _player1:Player;
		private var _player2:Player;
		
		
		//public function Alliance(id:int, newAlley:Player)
		public function Alliance(id:int, player1:Player, player2:Player)
		{
			this._player2 = player2;
			this._player1 = player1;
			this._id = id;
			
			_player1.addAlly(_player2);
			_player2.addAlly(_player1);
			this._players = new Vector.<Player>;
			this._players.push(player1);
			this._players.push(player2);
			
			this.validForMoreRounds = validForTurns;
			GlobalEventManger.addEvent(GlobalEventsEnum.ROUND_COMPLETE, onRoundComplete);
		}
		
		private function onRoundComplete():void 
		{
			this.validForMoreRounds--
			
			if (!_player1.alive || !_player2.alive)
			{
				cancelAlliance(false);
			}
			
			if (this.validForMoreRounds <= 0)
			{
				cancelAlliance();
			}
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get validForMoreRounds():int 
		{
			return _validForMoreRounds;
		}
		
		public function set validForMoreRounds(value:int):void 
		{
			_validForMoreRounds = value;
		}
		
		public function get playersArr():Vector.<Player> 
		{
			return _players;
		}
		
		public function cancelAlliance(announce:Boolean=true):void
		{
			_player1.removeAlly(_player2);
			_player2.removeAlly(_player1);
			if (announce)
			{
				//GameApp.getInstance.game.uiLayer.addTitle("Alliance between " + this._players[0].army.armyData.name + " & " + this._players[1].army.armyData.name + " ended", 1);
				MainGameApp.getInstance.game.uiLayer.eventMessagesManager.addEventMessage("Alliance between " + this._players[0].army.armyData.name + " & " + this._players[1].army.armyData.name + " ended", Color.YELLOW);
			}
			
			dispatchEvent(new Event(Event.REMOVED));
		}
		
		public function gotPlayer(player:Player):Boolean 
		{
			return this._players.indexOf(player) != -1?true:false;
		}
		
	}

}