package  
{
	import armies.Army;
	import armies.data.ArmyData;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import interfaces.IStorable;
	import players.Player;
	import players.Player_Human;
	import players.Player_Virtual;
	import players.PlayerData;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.events.Event;
	import storedGameData.ISavedData;
	import storedGameData.SavedGameData_Player;
	import storedGameData.SavedGameData_Players;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class PlayersManager implements IStorable
	{
		//private var _disable:Boolean;
		private var _playersArr		:Vector.<Player> = new Vector.<Player>;
		private var _activePlayers	:Vector.<Player> = new Vector.<Player>;
		private var _assignPlayers	:Vector.<Player>;
		private var _userPlayer		:Player_Human;
		
		private var assignCount:int = 0;
		
		public function PlayersManager() 
		{
			//GlobalEventManger.addEvent(GlobalEventsEnum.ROUND_COMPLETE, setRoundComplete);
		}
		
		public function assignArmiesAndPlayers():void 
		{
			if (!GamePlayManager.armiesPickedForPlaying)
			{
				GamePlayManager.armiesPickedForPlaying = new Vector.<ArmyData>;
				for (var j:int = 0; j < (GamePlayManager.totalPlayersPlaying - 1); ++j)
				{
					GamePlayManager.armiesPickedForPlaying.push(ConfigurationData.armiesData.armies[j + 1]);
				}
			}
			
			addPlayer(new PlayerData( { name:"Human player" } ), GameApp.game.armiesManager.getAvailableArmy(GamePlayManager.userArmyNum, true) , true);
			
			var total:int = GamePlayManager.armiesPickedForPlaying.length;
			
			for (var i:int = 0; i < total; i++) 
			{
				addPlayer(new PlayerData( { name:"computer_player_#" + i } ), GameApp.game.armiesManager.getAvailableArmy() );
			}
			
			if (GamePlayManager.shuffleAllPlayer)
			{
				_playersArr.sort(shufflePlayers);
			}
			
			activatePlayers();
			
			assignTerritories();
		}
		
		public function activatePlayers():void
		{
			for (var i:int = 0; i < _playersArr.length; ++i) 
			{
				
				if (ConfigurationData.debugData.cheatData.strongest)
				{
					_playersArr[i].army.setStartingUnits(_playersArr[i].isHuman?50:10);
				} else
				{
					_playersArr[i].army.setStartingUnits();
				}
				_playersArr[i].id = i;
				if (_playersArr[i].alive)
				{
					_activePlayers.push(_playersArr[i]);
				}
			}
		}
		
		private static function shufflePlayers(a:Player, b:Player):int
		{
			return Math.floor( Math.random() * 3 - 1 );
		}
		
		private function addPlayer(playerData:PlayerData, army:Army, isHuman:Boolean = false, alive:Boolean = true):Player
		{
			var newPlayer:Player = isHuman?new Player_Human(_playersArr.length, playerData,army):new Player_Virtual(_playersArr.length, playerData,army);
			_playersArr.push(newPlayer);
			
			/*if (alive)
			{
				_activePlayers.push(newPlayer);
			}*/
			newPlayer.alive = alive;
			
			if (newPlayer.isHuman)
			{
				this._userPlayer = newPlayer as Player_Human;
			}

			Tracer.alert("NEW PLAYER ADDED : " + newPlayer.playerData.name);
			
			return newPlayer as Player;
		}
		
		private function assignTerritories():void 
		{
			GameApp.game.uiLayer.addTitle("Preparing a New World")
			_assignPlayers = new Vector.<Player>;
			
			for each (var item:Player in _activePlayers) 
			{
				_assignPlayers.push(item);
			}
		
			//Starling.juggler.add(new DelayedCall(assignNextPlayersTerritory, .5));
			Starling.juggler.add(new DelayedCall(assignNextTerritory, .1));

		}
		
		private function assignNextTerritory():void 
		{
			var player:Player = _assignPlayers[assignCount];
			var assigned:Boolean = player.assignNewTerritory();
			GameApp.game.uiLayer.playersInfoBar.update(player.id);
			
			if (assigned)
			{
				assignCount = assignCount >= _assignPlayers.length-1?0:assignCount + 1;
				Starling.juggler.add(new DelayedCall(assignNextTerritory, .05));
			} else
			{
				//Tracer.alert("COMPLETEE!!!!!!!!!!!!!!");
				GameApp.game.uiLayer.removeTitle();
				playersAreReady();
			}
		}
		
		public function playersAreReady(deployNewStartingUnits:Boolean=true):void
		{
			var player:Player;
			var length:int = _activePlayers.length;
			
			for (var i:int = 0; i <length; ++i) 
			{
				player = _activePlayers[i];
				if (i == length - 1)
				{
					player.addEventListener(Player.ASSIGN_TERRITORIES_COMPLETE, armyAssignComplete);
				}
				
				player.setPlayersArmy(deployNewStartingUnits);
				
			}
			
			//_userPlayer.readyForNewGame();
		}

		private function armyAssignComplete(e:Event):void 
		{
			GlobalEventManger.dispatchEvent(GlobalEventsEnum.PLAYER_READY_FOR_PLAY);
		}
		
		public function get playersArr():Vector.<Player> 
		{
			return _playersArr;
		}
		
		public function get userPlayer():Player_Human 
		{
			return _userPlayer;
		}
		
		public function get activePlayers():Vector.<Player> 
		{
			return _activePlayers;
		}
		
		public function getTotalPlayers():int
		{
			return _activePlayers.length;
		}
		
		public function removePlayer(player:Player):void
		{
			this._activePlayers.splice(this._activePlayers.indexOf(player), 1);
		}
		
		public function getPlayerByID(num:int):Player 
		{
			for each (var item:Player in _activePlayers) 
			{
				if (num == item.id)
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function removeAll():void
		{
			this._playersArr = new Vector.<Player>;
			this._activePlayers = new Vector.<Player>;
			_userPlayer = null;
		}
		
		/* INTERFACE interfaces.IStorable */
		
		public function getDataTranslateObject():XMLNode 
		{
			var playersNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "players");

			for each (var item:Player in this.playersArr) 
			{
				playersNode.appendChild(item.getDataTranslateObject());
			}
			
			return playersNode;
		}
		
		public function translateBackFromData(data:ISavedData):void 
		{
			var translateData:SavedGameData_Players = data as SavedGameData_Players;
			
			for each (var item:SavedGameData_Player in translateData.players) 
			{
				var army:Army = GameApp.game.armiesManager.getArmyByID(item.armyID - 1,item.isHuman);
				var player:Player = addPlayer(new PlayerData( { name:item.name } ),army , item.isHuman, item.alive );
				player.translateBackFromData(item)
			}
		}
		
	}

}