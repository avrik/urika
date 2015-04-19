package gamePlay 
{
	import players.Player;
	import starling.events.Event;
	import starling.utils.Color;
	/**
	 * ...
	 * @author Avrik
	 */
	public class DiplomacyManager 
	{
		private var _alliances:Vector.<Alliance> = new Vector.<Alliance>;
		
		
		public function DiplomacyManager() 
		{
			
		}
		
		public function addNewAlliance(player1:Player,player2:Player):void
		{
			var allinace:Alliance = new Alliance(_alliances.length, player1, player2);
			allinace.addEventListener(Event.REMOVED, removeAlliance);
			_alliances.push(allinace);
			
			MainGameApp.getInstance.game.uiLayer.eventMessagesManager.addEventMessage(player1.army.armyData.name + " and " + player2.army.armyData.name + " sign a  non attack Agreement", Color.YELLOW);
		}
		
		private function removeAlliance(e:Event):void 
		{
			var allinace:Alliance = e.currentTarget as Alliance;
			cancelAlliance(allinace);
		}
		
		public function cancelAlliance(allinace:Alliance):void 
		{
			allinace.removeEventListeners();
			_alliances.splice(_alliances.indexOf(allinace), 1);
		}
		
		public function cancelAllianceByPlayer(player:Player):void 
		{
			for each (var item:Alliance in _alliances) 
			{
				if (item.gotPlayer(player))
				{
					//cancelAlliance(item)
					item.cancelAlliance();
					break;
				}
			}
		}
		
		public function areAllies(player1:Player,player2:Player):Boolean
		{
			for each (var item:Alliance in _alliances) 
			{
				if (item.gotPlayer(player1) && item.gotPlayer(player2))
				{
					return true;
					
				}
			}
			
			return false;
		}
		
		public function isPartOfAlliance(player:Player):int 
		{
			var num:int = 0;
			
			for each (var item:Alliance in _alliances) 
			{
				if (item.gotPlayer(player))
				{
					num++;
					
				}
			}
			
			return num;
		}
		
		public function getMyAllies(player:Player):Vector.<Player> 
		{
			var arr:Vector.<Player> = new Vector.<Player>;
			for each (var item:Alliance in _alliances) 
			{
				if (item.gotPlayer(player))
				{
					for each (var item2:Player in item.playersArr) 
					{
						if (item2 != player)
						{
							arr.push(item2);
						}
					}
				}
			}
			
			return arr;
		}
		
		
		
	}

}