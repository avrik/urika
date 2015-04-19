package armies 
{
	import armies.data.ArmyData;
	import ascb.util.NumberUtilities;
	import flash.geom.Point;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import gameConfig.ConfigurationData;
	import gamePlay.GamePlayManager;
	import gameWorld.territories.SentencesLibrary;
	import gameWorld.territories.Territory;
	import interfaces.IDisposable;
	import interfaces.IStorable;
	import players.Player;
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import storedGameData.ISavedData;
	import storedGameData.SavedGameData_Army;
	import storedGameData.SavedGameData_ArmyUnit;
	import urikatils.LoggerHandler;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class Army extends EventDispatcher implements IStorable,IDisposable
	{
		static public const ATTACK_COMPLETE:String = "attackComplete";
		static public const ACCUPAY_COMPLETE:String = "accupayComplete";
		
		static public const DEPLOY_BY_ENEMYS:String = "deployByEnemys";
		static public const DEPLOY_COMPLETED:String = "deployCompleted";
		static public const MOVE_FORCES_COMPLETE:String = "moveForcesComplete";
		
		private var _disableUnits:Boolean;
		
		private var _armyUnits:Vector.<ArmyUnit>;
		private var _myPlayer:Player;

		protected var _soldiersToDeployArr:Vector.<Soldier>;
		private var deployDelay:DelayedCall;
		private var _armyData:ArmyData;
		
		private var _soldiers:Vector.<Soldier> = new Vector.<Soldier>;
		
		
		public function Army(armyData:ArmyData, startingSoldiersAmount:int=10)
		{
			this._armyData = armyData;
			
			LoggerHandler.getInstance.info(this,"NEW ARMY = " + this._armyData);

			this._armyUnits = new Vector.<ArmyUnit>;
			
			/*var newSoldier:Soldier
			for (var i:int = 0; i < startingSoldiersAmount; i++) 
			{
				newSoldier = new Soldier(armyData);
				_soldiers.push(newSoldier);
			}*/
		}
			
		public function deactivate():void
		{
			
		}
		
		public function activateForNewRound():void
		{
			
		}
		
		public function setStartingUnits(totalUnits:int = 0):void
		{
			this._soldiersToDeployArr = new Vector.<Soldier>;
			
			var totalSoldierToDeploy:int = totalUnits?totalUnits:(gameConfig.ConfigurationData.worldData.totalTerritories / GamePlayManager.totalPlayersPlaying) * 4;

			for (var i:int = 0; i < totalSoldierToDeploy; i++) 
			{
				this._soldiersToDeployArr.push(getNewSoldier());
			}
		}
		
		public function getNewSoldier():Soldier
		{
			return new Soldier(_armyData);
		}
		
		
		public function assignToPlayer(player:Player):void
		{
			_myPlayer = player;
		}
		
		public function addAndDeployRoundUnits():void
		{
			this._soldiersToDeployArr = new Vector.<Soldier>;
			
			for (var i:int = 0; i < this._myPlayer.getSoldiersDeployAmount(); i++) 
			{
				this._soldiersToDeployArr.push(getNewSoldier());
			}
		}
		
		public function addNewArmyUnit(soldier:Soldier = null, coins:int = 0):ArmyUnit
		{
			//LoggerHandler.getInstance.info(this,"ADD NEW ARMY UNIT!!");
			var newArmyUnit:ArmyUnit = new ArmyUnit(this);
			newArmyUnit.coinsInStorage = coins;
			_armyUnits.push(newArmyUnit);
			newArmyUnit.addEventListener(ArmyUnit.DESTROYED, armyUnitDestroed);
			if (soldier)
			{
				newArmyUnit.addSoldier(soldier);
			} else
			if (this._soldiersToDeployArr && this._soldiersToDeployArr.length)
			{
				newArmyUnit.addSoldier(this._soldiersToDeployArr.pop());
			}
			
			return newArmyUnit;
		}
		
		private function armyUnitDestroed(e:Event):void 
		{
			
			removeArmyUnit(e.currentTarget as ArmyUnit);
		}
		
		public function getRandomUnit(getBy:String=""):ArmyUnit 
		{
			//var armyUnit:ArmyUnit;
			//armyUnit = _armyUnits[NumberUtilities.random(0, (_armyUnits.length - 1))];
			
			if (getBy == Army.DEPLOY_BY_ENEMYS)
			{
				var armyUnitsWithEnemies:Vector.<ArmyUnit> = new Vector.<ArmyUnit>;
				for each (var item:ArmyUnit in _armyUnits) 
				{
					if (item.onTerritory.enemyTerritories.length)
					{
						armyUnitsWithEnemies.push(item);
					}
				}
				
				if (armyUnitsWithEnemies.length)
				{
					return armyUnitsWithEnemies[NumberUtilities.random(0, (armyUnitsWithEnemies.length - 1))];
				}
				
			}
			
			return _armyUnits[NumberUtilities.random(0, (_armyUnits.length - 1))];
		}
		
		public function deployStartingUnits():void
		{
			deployUnits();
		}
		
		public function deployUnits(by:String = "", armyUnit:ArmyUnit = null):void
		{
			deployDelay = new DelayedCall(deployUnitToRandomArmyUnit, .02, [by]);
			deployDelay.repeatCount = this._soldiersToDeployArr.length;

			Starling.juggler.add(deployDelay);
		}
		
		private function deployUnitToRandomArmyUnit(by:String):void 
		{
			this.getRandomUnit(by).addSoldier(this._soldiersToDeployArr.pop());
			
			MainGameApp.getInstance.game.uiLayer.playersInfoBar.update(this._myPlayer.id);
			
			if (deployDelay.isComplete)
			{
				dispatchEvent(new Event(DEPLOY_COMPLETED));
				Starling.juggler.remove(deployDelay);
			}
		}

		public function removeArmyUnit(armyUnit:ArmyUnit):void 
		{
			armyUnit.removeEventListeners();
			this._armyUnits.splice(this._armyUnits.indexOf(armyUnit), 1);
			
			LoggerHandler.getInstance.info(this," - REMOVE ARMY UNIT == " + this._armyUnits.length);
		}
		
		public function attackTerritory(myArmyUnit:ArmyUnit, targetArmyUnit:ArmyUnit):void
		{
			myArmyUnit.onTerritory.citizen.talk(SentencesLibrary.getRandomAttackSentence());
			MainGameApp.getInstance.game.warManager.setBattle(myArmyUnit, targetArmyUnit);
			
			myArmyUnit.myArmy.myPlayer.reportAttack();
		}
		
		protected function attackComplete():void 
		{
			MainGameApp.getInstance.game.warManager.removeEventListeners();
			myPlayer.reportAttackComplete();
			
			dispatchEvent(new Event(ATTACK_COMPLETE))
		}
		
		public function moveForcesToTerritory(myArmyUnit:ArmyUnit, targetArmyUnit:ArmyUnit):void
		{
			myArmyUnit.status = UnitStatusEnum.MOVE;
			var territoriesToFocus:Vector.<Territory> = new Vector.<Territory>;
			territoriesToFocus.push(myArmyUnit.onTerritory, targetArmyUnit.onTerritory)
			MainGameApp.getInstance.game.world.map.setTerritoriesFocus(territoriesToFocus);
			
			if (myArmyUnit.totalSoldiers <= 1) return;

			//myArmyUnit.myArmy.myPlayer.movesLeft--;
			myPlayer.reportMove();
			
			var s:Soldier = myArmyUnit.getSoldier();
			var soldierDisplay:Sprite = s.getVisual();
			
			var targetPoint:Point = new Point(targetArmyUnit.getLocationPoint().x, targetArmyUnit.getLocationPoint().y+10);
			
			var tween:Tween = new Tween(soldierDisplay, .4, Transitions.EASE_OUT);
			tween.moveTo(targetPoint.x, targetPoint.y);
			tween.scaleTo(targetArmyUnit.view.mySprite.scaleX);
			tween.onComplete = moveForceComplete
			tween.onCompleteArgs = [myArmyUnit,targetArmyUnit, s];

			Starling.juggler.add(tween);
		}
		
		protected function moveForceComplete(myArmyUnit:ArmyUnit,targetArmyUnit:ArmyUnit,soldier:Soldier):void 
		{
			myArmyUnit.status = UnitStatusEnum.WAITING_FOR_ACTION;
			soldier.removeVisualDisplay();

			targetArmyUnit.addSoldier(soldier);		
			myPlayer.reportMoveComplete();
			
			dispatchEvent(new Event(MOVE_FORCES_COMPLETE));
		}
		
		

		public function accupayTerritory(armyUnit:ArmyUnit, territory:Territory):void 
		{
			territory.owner = armyUnit.myArmy;
			territory.armyUnit = armyUnit.myArmy.addNewArmyUnit(armyUnit.getSoldier());
			this.myPlayer.assignTerritory(territory);
			
			dispatchEvent(new Event(ACCUPAY_COMPLETE));
		}
		
		public function getSoldiersNumber():int 
		{
			var num:int = 0;
			for each (var item:ArmyUnit in this._armyUnits) 
			{
				num += item.totalSoldiers;
			}
			
			return num;
		}
		
		/* INTERFACE interfaces.IStorable */
		
		public function getDataTranslateObject():XMLNode 
		{
			var armyNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "army");

			var armyAtt:Object = new Object();
			armyAtt.armyID = this.armyData.id;
			armyNode.attributes = armyAtt;
			
			for each (var armyUnit:ArmyUnit in this.armyUnits) 
			{
				armyNode.appendChild(armyUnit.getDataTranslateObject());
			}
			
			return armyNode;
		}
		
		public function setReady():void
		{
			for each (var item:ArmyUnit in _armyUnits) 
			{
				item.ready()
			}
		}
		
		public function translateBackFromData(data:ISavedData):void 
		{
			var translateData:SavedGameData_Army = data as SavedGameData_Army;
			var territory:Territory
			
			for each (var item:SavedGameData_ArmyUnit in translateData.armyUnits) 
			{
				territory = MainGameApp.getInstance.game.world.map.getTerritoryByID(item.teritoryID);
				this.myPlayer.assignTerritory(territory);
				
				territory.armyUnit = this.addNewArmyUnit();
				
				
				/*armyUnit.myTile =  territory.mainTile;
				//armyUnit.active = item.active;
			
				for each (var soldierData:SavedGameData_Soldier in item.soldiers) 
				{
					armyUnit.addSoldier(new Soldier(this.armyData.units[0]));
				}*/
				territory.armyUnit.translateBackFromData(item)
			}
		}
		
		/* INTERFACE interfaces.IDisposable */
		
		public function dispose():void 
		{
			if (_armyUnits)
			{
				var len:int = _armyUnits.length;
				for (var i:int = 0; i <len ; i++) 
				{
					_armyUnits[i].dispose();
				}
			}
			
			_armyUnits = null;
		}
		
		public function getTotalStrenght():int 
		{
			return this.getSoldiersNumber();
		}
		
		public function getSoldierAttackBonus():int 
		{
			return this._armyData.bonus == ArmyBonusEnum.ATTACK_BONUS?1:0;
		}
		
		public function getSoldierDefenceBonus():int 
		{
			return this._armyData.bonus == ArmyBonusEnum.DEFENCE_BONUS?1:0;
		}
		
		public function getActionMoveBonus():int 
		{
			return this._armyData.bonus == ArmyBonusEnum.MOVE_ACTION_BONUS?1:0;
		}
		
		public function getActionAttackBonus():int 
		{
			return this._armyData.bonus == ArmyBonusEnum.ATTACK_ACTION_BONUS?1:0;
		}
		
		public function getActionDiplomacyBonus():int 
		{
			return this._armyData.bonus == ArmyBonusEnum.DIPLOMACY_ACTION_BONUS?1:0;
			
		}
		
		public function getLuckBonus():int 
		{
			return this._armyData.bonus == ArmyBonusEnum.LUCK_BONUS?1:0;
			
		}

		public function get armyUnits():Vector.<ArmyUnit> 
		{
			return _armyUnits;
		}
		
		public function get myPlayer():Player 
		{
			return _myPlayer;
		}

		public function get armyData():ArmyData 
		{
			return _armyData;
		}

		public function set disableUnits(value:Boolean):void 
		{
			_disableUnits = value;
			
			for each (var item:ArmyUnit in armyUnits) 
			{
				item.enable = !value;
			}
		}

	}

}