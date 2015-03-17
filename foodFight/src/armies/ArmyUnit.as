package armies 
{
	import flash.geom.Point;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import gameWorld.territories.Territory;
	import gameWorld.Tile;
	import interfaces.IDisposable;
	import interfaces.IStorable;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import storedGameData.ISavedData;
	import storedGameData.SavedGameData_ArmyUnit;
	import storedGameData.SavedGameData_Soldier;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class ArmyUnit extends EventDispatcher implements IDisposable,IStorable
	{
		static public const PICK_FOR_DEPLOY_NEW_SOLDIER:String = "pickForDeployNewSoldier";
		static public const DESTROYED:String = "destroyed";
		static public const PICK_FOR_ADD_NEW_ITEM:String = "pickForAddNewItem";
		static public const PICKED_FOR_ACTION:String = "pickedForAction";
		
		private var _enable:Boolean;
		
		private var _waitingForDeploy	:Boolean;
		private var _onTerritory	:Territory;
		private var _myTile			:Tile;
		private var _soldiers		:Vector.<Soldier>
		private var _myArmy			:Army;
		private var _totalSoldiers	:int;
		private var _picked			:Boolean;
		//private var _onInteractionWith:ArmyUnit;

		private var _active:Boolean;
		private var _view:ArmyUnitView;
		private var _clickable:Boolean;
		
		private var _movesLeftInRound:int;
		private var _onInteractionWithArr:Vector.<ArmyUnit>;
		
		private var _coinsInStorage:int = 0;
		private var _status:String;
		
		
		public function ArmyUnit(army:Army) 
		{
			_view = new ArmyUnitView(army.armyData);
			
			_myArmy = army;
			_soldiers = new Vector.<Soldier>;
			
			status = UnitStatusEnum.WAITING_FOR_ACTION;
			view.butn.addEventListener(Event.TRIGGERED, clicked);
		}
		
		public function buildMe():void 
		{
			_view.showBuildAnimation();
		}
	
		private function clicked(e:Event):void 
		{
			/*if (_waitingForDeploy)
			{
				view.downAnimation();
				view.setClickable(true);
				dispatchEvent(new Event(PICK_FOR_DEPLOY_NEW_SOLDIER));
			} else
			{
				if (_onInteractionWith)
				{
					if (this.myArmy == _onInteractionWith.myArmy) 
					{
						if (_onInteractionWith.myArmy.myPlayer.movesLeft)
						{
							_onInteractionWith.myArmy.moveForcesToTerritory(_onInteractionWith, this);
						}
						
					} else
					{
						_onInteractionWith.myArmy.attackTerritory(_onInteractionWith, this);
						//this._myArmy.attackTerritory(_onInteractionWith, this);
					}
					//_picked = false;
				} else
				{
					view.setClickable(false);

					dispatchEvent(new Event(PICKED_FOR_ACTION));
					this.setNeighborsForInteraction();
					view.downAnimation();
				}
			}*/


			switch (status) 
			{
				case UnitStatusEnum.WAITING_FOR_DEPLOY:
					view.downAnimation();
					//view.setClickable(true);
					dispatchEvent(new Event(PICK_FOR_DEPLOY_NEW_SOLDIER));
					break;
				case UnitStatusEnum.WAITING_FOR_ACTION:
					
					status = UnitStatusEnum.PICKED_FOR_ACTION;
					view.downAnimation();
					//view.setClickable(false);
					GameApp.game.unitsController.setPickedUnit(this);
					dispatchEvent(new Event(PICKED_FOR_ACTION));
					this.setNeighborsForInteraction();
					
					
					break;
				case UnitStatusEnum.WAITING_FOR_INTERACTION:
					status = UnitStatusEnum.PICKED_FOR_INTERACTION;
					/*if (this.myArmy == _onInteractionWith.myArmy) 
					{
						if (_onInteractionWith.myArmy.myPlayer.movesLeft)
						{
							_onInteractionWith.myArmy.moveForcesToTerritory(_onInteractionWith, this);
						}
						
					} else
					{
						_onInteractionWith.myArmy.attackTerritory(_onInteractionWith, this);
					}*/
					
					GameApp.game.unitsController.setInteractionUnit(this)
					
					break;
			}
		}
		
		public function clearNeighborsInteraction():void 
		{
			//_picked = false;
			for each (var item:ArmyUnit in _onInteractionWithArr) 
			{
				item.status = UnitStatusEnum.WAITING_FOR_ACTION;
				/*if (item.view)
				{
					item.clearInteraction();
				}*/
			}
		}
		
		public function setNeighborsForInteraction():void 
		{
			clearNeighborsInteraction();
			
			_onInteractionWithArr = new Vector.<ArmyUnit>();
			for each (var item:Territory in this.onTerritory.neighborsArr) 
			{
				if (canSetTerritoryForInteraction(item))
				{
					item.armyUnit.setForInteraction(this);
					_onInteractionWithArr.push(item.armyUnit);
				}
			}
		}
		
		private function canSetTerritoryForInteraction(territory:Territory):Boolean
		{
			if (!territory.owner) return false;
			//if (this._myArmy.myPlayer.diplomacy.isAlly(territory.owner.myPlayer)) return false;
			if (this._myArmy.myPlayer.isMyAlly(territory.owner.myPlayer)) return false;
			if (this._myArmy != territory.owner && this._myArmy.myPlayer.attacksLeft <= 0) return false;
			if (this._myArmy == territory.owner && this._myArmy.myPlayer.movesLeft <= 0) return false;
			
			return true;
		}
		
		public function setForInteraction(armyUnit:ArmyUnit):void 
		{
			//this._onInteractionWith = armyUnit;

			this.status = UnitStatusEnum.WAITING_FOR_INTERACTION;
			//clickable = true;
			//view.setClickable(true, true, this._onInteractionWith._myArmy == this._myArmy?0:0);
		}	
	
		public function addSoldier(newSoldier:Soldier):void
		{
			//Tracer.alert("ADD NEW SOLDIER == " + _soldiers.length);
			newSoldier.myArmyUnit = this;
			_soldiers.push(newSoldier);
			
			this.totalSoldiers = _soldiers.length;
		}
		
		public function getSoldier(visualDisplay:Boolean = false):Soldier
		{
			if (!_soldiers.length) return null;
			var soldier:Soldier = _soldiers.pop();
			
			this.totalSoldiers = _soldiers.length;
			return soldier;
		}
		
		public function clearInteraction():void
		{
			//_onInteractionWith = null;

			/*if (!this._myArmy.myPlayer.isHuman)
			{
				clickable = false;
				//view.setClickable(false);
			}*/
		}
		
		public function killSoldiers(soldierArr:Vector.<Soldier>) :void
		{
			for each (var item:Soldier in soldierArr) 
			{
				item.kill();
			}
		}
		
		public function get myArmy():Army 
		{
			return _myArmy;
		}
		
		public function get totalSoldiers():int 
		{
			return _totalSoldiers;
		}
		
		public function set totalSoldiers(value:int):void 
		{
			if (!view) { Tracer.alert("NO ARMY UNIT VIEW!!!!")
				return;
			}
			_totalSoldiers = value;
			
			if (_totalSoldiers < 2)
			{
				status = UnitStatusEnum.ACTIONLESS;
			} else if (status == UnitStatusEnum.ACTIONLESS)
			{
				status = UnitStatusEnum.WAITING_FOR_ACTION;
			}
			view.setSoldiersNum(value);
		}
		
		public function set myArmy(value:Army):void 
		{
			_myArmy = value;
			this.totalSoldiers = this.totalSoldiers;
		}
		
		public function get myTile():Tile 
		{
			return _myTile;
		}
		
		public function set myTile(value:Tile):void 
		{
			_myTile = value;
			this.onTerritory = _myTile.territory;
		}
		
		public function get onTerritory():Territory 
		{
			return _onTerritory;
		}
		
		public function set onTerritory(value:Territory):void 
		{
			_onTerritory = value;
		}
		
		public function get soldiers():Vector.<Soldier> 
		{
			return _soldiers;
		}

		public function set waitingForDeploy(value:Boolean):void 
		{
			_waitingForDeploy = value;
			if (value)
			{
				status = UnitStatusEnum.WAITING_FOR_DEPLOY;
				//clearInteraction();
				//clickable = true;
			} else
			{
				status = UnitStatusEnum.WAITING_FOR_ACTION;
			}
			
		}
		
		public function set isPicked(value:Boolean):void 
		{
			_picked = value;
			
			if (!value)
			{
				//clearNeighborsInteraction();
				status = UnitStatusEnum.WAITING_FOR_ACTION;
			}

			//view.setPicked(value);
		}
		
		public function get view():ArmyUnitView 
		{
			return _view;
		}
		
		public function get active():Boolean 
		{
			return _active;
		}
		
		public function set active(value:Boolean):void 
		{
			_active = value;
			this.view.touchable = value;
		}
		
		public function set clickable(value:Boolean):void 
		{
			if (!view) return;
			_clickable = value;

			view.setClickable(value);
		}
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;

			view.showClickArea = value;
		}
		
		public function get movesLeftInRound():int 
		{
			return _movesLeftInRound;
		}
		
		public function set movesLeftInRound(value:int):void 
		{
			_movesLeftInRound = value;
		}
		
		public function get coinsInStorage():int 
		{
			return _coinsInStorage;
		}
		
		public function set coinsInStorage(value:int):void 
		{
			_coinsInStorage = value;
		}
		
		public function get status():String 
		{
			return _status;
		}
		
		public function set status(value:String):void 
		{
			_status = value;
			
			switch (_status) 
			{
				case UnitStatusEnum.WAITING_FOR_DEPLOY:
				case UnitStatusEnum.WAITING_FOR_ACTION:
					//clearNeighborsInteraction();
					clickable = this.myArmy.myPlayer.isHuman?true:false;
					break;
				case UnitStatusEnum.WAITING_FOR_INTERACTION:
					clickable = true;
					break;
				case UnitStatusEnum.PICKED_FOR_ACTION:
					clickable = false;
					break;
				case UnitStatusEnum.ATTACK:
				case UnitStatusEnum.MOVE:
				case UnitStatusEnum.ACTIONLESS:
					clickable = false;
					break;
			}
			
		}

		public function getNeighborsAndMe():Vector.<Territory> 
		{
			var arr:Vector.<Territory> = new Vector.<Territory>;
			arr.push(this.onTerritory);
			
			for each (var t:Territory in this.onTerritory.neighborsArr) 
			{
				arr.push(t);
			}
			
			return arr;
		}
		
		public function destroy():void 
		{
			//_onTerritory.citizen.talk(SentencesLibrary.getRandomLoseSentence());
			
			view.addEventListener(ArmyUnitView.DESTROY_COMPLETE, destroyComplete);
			view.destroyAnimation();
		}
		
		private function destroyComplete(e:Event):void 
		{
			_view.removeEventListener(ArmyUnitView.DESTROY_COMPLETE, destroyComplete);
			//_view.dispose();
			_view = null;
			
			_onTerritory.removeCitizen();
			dispatchEvent(new Event(DESTROYED));
		}
		
		public function getLocationPoint():Point 
		{
			//return new Point(this._myTile.view.x - this._myTile.view.parent.x, this._myTile.view.y - this._myTile.view.parent.y);;
			return new Point(this._myTile.view.x , this._myTile.view.y);
			//return new Point(this.view.x , this.view.y);
		}
		
		/* INTERFACE interfaces.IDisposable */
		
		public function dispose():void 
		{
			if (_view)
			{
				//_view.removeFromParent(true);
				//GameApp.game.world.actionLayer.removeObject(_view);
				_view.dispose();
				_view = null;
			}
		}
		
		/* INTERFACE interfaces.IStorable */
		
		public function getDataTranslateObject():XMLNode 
		{
			var armyUnitNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "armyUnit");
			
			var armyUnitAtt:Object = new Object();
			armyUnitAtt.onTile = this._myTile.id;
			armyUnitAtt.teritoryID = this._onTerritory.id;
			armyUnitAtt.active = this._active;
			
			armyUnitNode.attributes = armyUnitAtt;
				
			for each (var soldier:Soldier in this.soldiers) 
			{
				var soldierNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "soldier");
				var soldierAtt:Object = new Object();
				soldierAtt.exp = soldier.exp;
				soldierNode.attributes = soldierAtt;
				armyUnitNode.appendChild(soldierNode);
			}
			
			return armyUnitNode;
		}
		
		/* INTERFACE interfaces.IStorable */
		
		public function translateBackFromData(data:ISavedData):void 
		{
			var translateData:SavedGameData_ArmyUnit = data as SavedGameData_ArmyUnit;
			this.myTile =  this._onTerritory.mainTile;
			
			for each (var soldierData:SavedGameData_Soldier in translateData.soldiers) 
			{
				//this.addSoldier(new Soldier(this.myArmy.armyData));
				this.addSoldier(this.myArmy.getNewSoldier());
			}
		}
		
	}

}