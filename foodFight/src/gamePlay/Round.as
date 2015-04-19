package gamePlay 
{
	import players.Player;
	import starling.events.Event;
	import urikatils.LoggerHandler;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Round
	{
		private static var _roundNum:int = 0;
		
		private var _onPlayer:Player;
		private var _playersInRound:Vector.<Player>;
		
		public function Round() 
		{
			LoggerHandler.getInstance.info(this,"NEW ROUND == " + _roundNum);
			_roundNum++;
			
			_playersInRound = new Vector.<Player>;
			
			for each (var item:Player in MainGameApp.getInstance.game.playersManager.activePlayers) 
			{
				_playersInRound.push(item)
			}
			
			_playersInRound = _playersInRound.reverse();
			nextPlayerTurn();
		}
		
		private function nextPlayerTurn():void
		{
			MainGameApp.getInstance.saveGameApp();
			if (onPlayer)
			{
				onPlayer.deactivate()
			}

			do
			{
				_onPlayer = _playersInRound.pop();
			} while (!onPlayer.alive)
			
			LoggerHandler.getInstance.info(this,"NEXT PLAYER == " + onPlayer.playerData.name);
			
			onPlayer.addEventListener(Player.PLAYER_TURN_COMPLETE, playerTurnComplete);
			onPlayer.activate();
			
			MainGameApp.getInstance.game.uiLayer.playersInfoBar.markPlayer(onPlayer.id);
		}
		
		private function playerTurnComplete(e:Event):void 
		{
			var player:Player = e.currentTarget as Player;
			player.removeEventListener(Player.PLAYER_TURN_COMPLETE, playerTurnComplete);
			
			if (_playersInRound.length)
			{
				nextPlayerTurn()
			} else
			{
				//dispatchEvent(new Event(Event.COMPLETE));
				GlobalEventManger.dispatchEvent(GlobalEventsEnum.ROUND_COMPLETE);
			}
		}
		
		static public function reset():void 
		{
			_roundNum = 0;
		}
		
		static public function get roundNum():int 
		{
			return _roundNum;
		}
		
		public function get onPlayer():Player 
		{
			return _onPlayer;
		}
		
	}

}