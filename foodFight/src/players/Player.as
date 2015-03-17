package players 
{
	import armies.Army;
	import armies.ArmyUnit;
	import ascb.util.NumberUtilities;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import gameWorld.territories.Territory;
	import gameWorld.Tile;
	import interfaces.IStorable;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import storedGameData.ISavedData;
	import storedGameData.SavedGameData_Player;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Player extends EventDispatcher implements IStorable
	{
		static public const PLAYER_TURN_COMPLETE:String = "playerTurnComplete";
		static public const ASSIGN_TERRITORIES_COMPLETE:String = "assignTerritoriesComplete";
		static public const PLAYER_READY_FOR_NEW_ROUND:String = "playerReadyForNewRound";
		
		private var _alive		:Boolean;
		private var _playerData	:PlayerData;
		private var _army		:Army;
		private var _score		:Number = 0;
		private var _credits	:Number;
		protected var _isHuman	:Boolean;
		protected var _territories:Vector.<Territory>;
		private var _capitalTerritory:Territory;
		
		private var _id			:int;
		private var _active		:Boolean;
		
		private var _movesPerTurn	:int = 1;
		private var _attacksPerTurn	:int = 3;
		private var _diplomacyPerTurn:int = 1;
		
		private var _movesLeft		:int;
		private var _attacksLeft	:int;
		private var _diplomacyLeft	:int;
		
		private var delayedCall:DelayedCall;
		private var _level:int;
		private var _stars:int;
		private var _linkedToCapitalArr:Vector.<Territory>;
		
		protected var _coinsAmount:int = 0;
		private var _allies:Vector.<Player> = new Vector.<Player>;
		
		public function Player(id:int, playerData:PlayerData, army:Army)
		{
			this._id = id;
			this._playerData = playerData;
			this._army = army;
			this._army.assignToPlayer(this);

			_territories = new Vector.<Territory>;
			Tracer.alert("NEW PLAYER === " + this._army);
			
			_movesPerTurn += this._army.getActionMoveBonus();
			_attacksPerTurn += this._army.getActionAttackBonus();
			_diplomacyLeft += this._army.getActionDiplomacyBonus();
		}
		
		public function getSoldiersDeployAmount():int
		{
			//return this._territories.length >= 5?5:this._territories.length;
			return this.linkedToCapitalArr.length + 3;
			//return 2 + this._stars;
		}
		
		/*public function setStartingTerritories():void
		{
			var totalTerritoriesPerPlayer:int = Math.round(GameApp.game.world.map.territories.length / GamePlayManager.totalPlayersPlaying);
			
			delayedCall = new DelayedCall(assignNewTerritory, .1);
			delayedCall.repeatCount = totalTerritoriesPerPlayer;
			Starling.juggler.add(delayedCall);
		}*/
		
		public function assignNewTerritory():Boolean 
		{
			var newTerritory:Territory = GameApp.game.world.map.getRandomTerritory();
			
			if (newTerritory)
			{
				assignTerritory(newTerritory)
				newTerritory.armyUnit = _army.addNewArmyUnit();
			}
			
			/*if (delayedCall.isComplete)
			{
				
				Starling.juggler.remove(delayedCall);
				assignTerritoriesComplete()
			}*/
			
			return newTerritory?true:false
		}
		
		/*private function assignTerritoriesComplete():void
		{
			setPlayersArmy()
		}*/
		
		
		public function setPlayersArmy(deployNewStartingUnits:Boolean):void
		{
			this.capitalTerritory = getNewCapitalTerritory();
			if (deployNewStartingUnits)
			{
				this._army.addEventListener(Army.DEPLOY_COMPLETED,armyDeployComplete);
				this._army.deployStartingUnits();
			}
			
		}
		
		private function getNewCapitalTerritory():Territory
		{
			var territory:Territory = this.territories[0];
			
			var length:int = this.territories.length;
			for (var i:int = 1; i <length ; ++i) 
			{
				if (this.territories[i].myTerritories.length > territory.myTerritories.length)
				{
					territory = this.territories[i];
				}
			}
			
			return territory;
		}

		
		private function getRandomTerritory():Territory
		{
			if (!territories) return null;
			return this.territories[NumberUtilities.random(0, (this.territories.length - 1))];
		}
		
		private function armyDeployComplete(e:Event):void
		{
			this._army.removeEventListener(Army.DEPLOY_COMPLETED, armyDeployComplete);
			this._army.setReady();
			this._alive = true;
			
			this.setTerritoriesForBattle();
			dispatchEvent(new Event(ASSIGN_TERRITORIES_COMPLETE));
		}
		
		public function assignTerritory(territory:Territory, byWar:Boolean = false):void
		{
			
			//territory.owner = this._army;
			_territories.push(territory);
		}
		
		public function removeTerritory(territory:Territory):Territory
		{
			this.coinsAmount -= territory.armyUnit.coinsInStorage;
			
			this.army.removeArmyUnit(territory.armyUnit);
			
			_territories.splice(_territories.indexOf(territory), 1);
			if (!_territories.length)
			{
				this._alive = false;
				GameApp.game.playersManager.removePlayer(this);
			}
			return territory;
		}
		
		public function handleTurnResouces():void
		{
			/*for each (var item:Tile in _tiles) 
			{
				this.resourcesManager.resetTurnCount();
			}
			
			for each (var item2:Tile in _tiles) 
			{
				for (var i:String in item.resources.resourcesArr) 
				{
					this.resourcesManager.resourcesArr[i].addPerTurn += item2.resources.resourcesArr[i].amount;
					this.resourcesManager.resourcesArr[i].amount += item2.resources.resourcesArr[i].amount;
					//this.resourcesManager.resourcesArr[i].amount += item.resources.resourcesArr[i].amount;
				}
				
			}*/
			
			
		}
		
		/*public function handleRoundComplete():void
		{
			//this._army.addEventListener(Army.DEPLOY_COMPLETED, deployCompleted);
			//this._army.addAndDeployRoundUnits();
			
			//_movesLeft = MOVES_PER_ROUND;
			
		}*/
		
		private function deployCompleted(e:Event):void 
		{
			this._army.removeEventListener(Army.DEPLOY_COMPLETED, deployCompleted);
			//dispatchEvent(new Event(PLAYER_READY_FOR_NEW_ROUND));
			this.readyToStartMyTurn();
		}
		
		protected function readyToStartMyTurn():void 
		{
			//handleMyRoundTreasure()
			army.activateForNewRound();
		}
		
		private function handleMyRoundTreasure():void
		{
			coinsAmount += getTotalTerritoryCoinsNumber();

			Tracer.alert("COINS AMOUNT == " + _coinsAmount);
			
			var countAmount:int = coinsAmount;
			var arr:Vector.<Territory> = new Vector.<Territory>;
			arr = arr.concat(_territories);
			arr.sort(sortBySize);
			
			var territoryItem:Territory;
			var amount:int
			
			do
			{
				if (!arr.length)
				{
					arr = new Vector.<Territory>;
					arr = arr.concat(_territories);
					arr.sort(sortBySize);
				}
				
				territoryItem = arr.pop();
				
				amount = countAmount >= territoryItem.getTerritorySize()?territoryItem.getTerritorySize():countAmount;
				territoryItem.armyUnit.coinsInStorage += amount;
				countAmount -= amount;
			} while (countAmount);
		}
		
		private function sortBySize(a:Territory, b:Territory):int
		{
			if (a.capital)
			{
				return -1;
			} else if (b.capital)
			{
				return 1;
			}
			
			
			if (a.getTerritorySize() > b.getTerritorySize())
			{
				return -1;
			}
			else if (a.getTerritorySize() < b.getTerritorySize())
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		
		/*public function cancelAlliance(player:Player):void 
		{
			this._diplomacy.breakAlliance(player);
			//this._diplomacyLeft --;
			GameApp.game.uiLayer.infoRibbon.updateInfo();
		} 
		
		public function setNewAlliance(player:Player):void 
		{
			//var arr:Vector.<Player> = new Vector.<Player>;
			//arr.push(player);
			this._diplomacy.makeNewAlliance(player);
			//this._diplomacyLeft --;
			GameApp.game.uiLayer.infoRibbon.updateInfo();
		}*/
		
		public function activate():void 
		{
			this._active = true;
			
			movesLeft = _movesPerTurn;
			attacksLeft = _attacksPerTurn;
			diplomacyLeft = _diplomacyPerTurn;
			
			if (GameApp.game.onRoundNum > 1)
			{
				this._army.addEventListener(Army.DEPLOY_COMPLETED, deployCompleted);
				this._army.addAndDeployRoundUnits();
			} else
			{
				readyToStartMyTurn();
			}
		}
		
		public function deactivate():void 
		{
			this._active = false;
			_army.deactivate();
		}
		
		
		public function endMyTurn():void 
		{
			GameApp.game.world.map.clearTerritoriesFocus();
			dispatchEvent(new Event(PLAYER_TURN_COMPLETE));
		}
		
		

		public function get army():Army 
		{
			return _army;
		}
		
		public function set army(value:Army):void 
		{
			_army = value;
		}
		
		public function get playerData():PlayerData 
		{
			return _playerData;
		}
		
		public function get isHuman():Boolean 
		{
			return _isHuman;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get active():Boolean 
		{
			return _active;
		}
		
		/*public function get resourcesManager():PlayerResourcesManager 
		{
			return _resourcesManager;
		}*/
		
		public function get territories():Vector.<Territory> 
		{
			return _territories;
		}
		
		public function get alive():Boolean 
		{
			return _alive;
		}
		
		public function get movesLeft():int 
		{
			return _movesLeft;
		}
		
		public function set movesLeft(value:int):void 
		{
			_movesLeft = value;
		}
		
		public function set alive(value:Boolean):void 
		{
			_alive = value;
			
			if (!value)
			{
				this.army.dispose();
			}
		}
		
		public function get score():Number 
		{
			return _score;
		}
		
		public function set score(value:Number):void 
		{
			_score = value;
		}
		
		public function get level():int 
		{
			return _level;
		}
		
		public function set level(value:int):void 
		{
			_level = value;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function get capitalTerritory():Territory 
		{
			return _capitalTerritory;
		}
		
		public function set capitalTerritory(value:Territory):void 
		{
			_capitalTerritory = value;
			
			for each (var item:Territory in this._territories) 
			{
				item.linkedToCapital = false;
			}
			
			value.capital = true;
			
			_linkedToCapitalArr = new Vector.<Territory>;
			for each (var item2:Territory in this._territories) 
			{
				if (item2.linkedToCapital)
				{
					_linkedToCapitalArr.push(item2);
				}
			}
			
			Tracer.alert("PLAYER #" + this.id + " == " + _linkedToCapitalArr);
			
		}
		
		public function get coinsAmount():int 
		{
			return _coinsAmount;
		}
		
		public function get linkedToCapitalArr():Vector.<Territory> 
		{
			return _linkedToCapitalArr;
		}
		
		/*public function get diplomacy():Diplomacy 
		{
			return _diplomacy;
		}*/
		
		public function get attacksLeft():int 
		{
			return _attacksLeft;
		}
		
		public function get diplomacyLeft():int 
		{
			return _diplomacyLeft;
		}
		
		public function set attacksLeft(value:int):void 
		{
			_attacksLeft = value;
		}
		
		public function set diplomacyLeft(value:int):void 
		{
			_diplomacyLeft = value;
		}
		
		public function set coinsAmount(value:int):void 
		{
			_coinsAmount = value;
			
		}
		
		public function get allies():Vector.<Player> 
		{
			return _allies;
		}

		public function getTotalTerritoryCoinsNumber():int
		{
			var amount:int = 0;
			
			for each (var item:Territory in territories) 
			{
				if (item.linkedToCapital)
				{
					amount += item.totalCoins;
				}
			}
			
			return amount;
		}
		
		
		
		private function setTerritoriesForBattle():void 
		{
			for each (var item:Territory in this._territories) 
			{
				item.setNeighborsType();
				//item.setMyBorders();
			}
		}
		
		/* INTERFACE interfaces.IStorable */
		
		public function getDataTranslateObject():XMLNode 
		{
			var playerNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "player");
			var playerAtt:Object = new Object();
			playerAtt.id = this._id
			playerAtt.armyID = this.army.armyData.id;
			playerAtt.isHuman = this.isHuman;
			playerAtt.score = this._score;
			playerAtt.level = this._level;
			playerAtt.alive = this._alive;
			playerAtt.name = this._playerData.name;
			playerNode.attributes = playerAtt;
			
			playerNode.appendChild(army.getDataTranslateObject());

			return playerNode;
		}
		
		public function translateBackFromData(data:ISavedData):void 
		{
			var translateData:SavedGameData_Player = data as SavedGameData_Player;
			if (translateData)
			{
				this.alive = translateData.alive;
				this.score = translateData.score;
				this.army.translateBackFromData(translateData.armyData);
			}
		}
		
		
		public function reportAttack():void 
		{
			attacksLeft--;
		}
		
		public function reportAttackComplete():void 
		{
			//GameApp.saveGameApp();
			GameApp.game.uiLayer.playersInfoBar.update();
			reportActionComplete();
		}
		
		public function reportMove():void 
		{
			movesLeft--;
			
		}
		
		public function reportMoveComplete():void 
		{
			reportActionComplete();
		}
		
		public function reportActionComplete():void 
		{
			GameApp.saveGameApp();
			GameApp.game.uiLayer.playersInfoBar.update();
		}
		
		public function actionsLeft():Boolean 
		{
			if (_movesLeft || _attacksLeft || _diplomacyLeft) {
				return true;
			} else
			{
				return false;
			}
		}
		
		
		
		
		
		public function addToScore(value:Number):void 
		{
			score += value;
		}
		
		public function addStar():void 
		{
			this._stars++;
		}
		
		public function refreshLinksToCapital():void 
		{
			if (!territories.length) return;
			if (this.capitalTerritory.owner != this._army)
			{
				this.capitalTerritory = getNewCapitalTerritory();
			} else
			{
				this.capitalTerritory = this._capitalTerritory;
			}
			//this.capitalTerritory = this.capitalTerritory?this.capitalTerritory:this.getRandomTerritory();
		}
		
		public function allianceRequest(playerRequest:Player):Boolean 
		{
			var chance:int = 0;
			if (GameApp.game.diplomacyManager.isPartOfAlliance(this) > 1)
			{
				return false;
			}
			
			if (playerRequest.army.getTotalStrenght() >= this.army.getTotalStrenght() || this.army.getActionDiplomacyBonus())
			{
				chance = 2;
			} else
			{
				chance = 5;
			}
			
			return NumberUtilities.random(0, (chance-1)) == 0?true:false;
		}
		
		public function getMyStatus():String
		{
			var myStrength:int = this.army.getTotalStrenght();
			
			if (myStrength <= 2) return PlayerStatusEnum.EXTINCT;
			if (myStrength <= 5) return PlayerStatusEnum.FORGOTTEN;
			if (myStrength <= 10) return PlayerStatusEnum.STRUGGLING;
			if (myStrength <= 20) return PlayerStatusEnum.WEAK;
			if (myStrength <= 30) return PlayerStatusEnum.MEDIOCRE;
			if (myStrength <= 40) return PlayerStatusEnum.STRONG;
			if (myStrength <= 50) return PlayerStatusEnum.POWERFUL;
			return PlayerStatusEnum.UNBEATEN;
		}
		
		public function addAlly(player:Player):void 
		{
			allies.push(player)
		}
		
		public function removeAlly(player:Player):void 
		{
			allies.splice(allies.indexOf(player), 1);
		}
		
		public function isMyAlly(player:Player):Boolean
		{
			for each (var item:Player in allies) 
			{
				if (player == item)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function gotAllies():Boolean 
		{
			return this.allies.length?true:false;
		}
		
		
	}

}