package armies 
{
	import flash.geom.Point;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import gameWorld.territories.Territory;
	import gameWorld.Tile;
	import interfaces.IDisposable;
	import interfaces.IStorable;
	import starling.display.Graphics;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import storedGameData.ISavedData;
	import storedGameData.SavedGameData_ArmyUnit;
	import storedGameData.SavedGameData_Soldier;
	import urikatils.LoggerHandler;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class ArmyUnit extends EventDispatcher implements IDisposable,IStorable
	{
		static public const PICK_FOR_DEPLOY_NEW_SOLDIER:String = "pickForDeployNewSoldier";
		static public const DESTROYED:String = "destroyed";
		//static public const PICK_FOR_ADD_NEW_ITEM:String = "pickForAddNewItem";
		//static public const PICKED_FOR_ACTION:String = "pickedForAction";

		
		private var _enable:Boolean;
		
		private var _waitingForDeploy	:Boolean;
		private var _onTerritory	:Territory;
		private var _myTile			:Tile;
		private var _soldiers		:Vector.<Soldier>
		private var _myArmy			:Army;
		private var _totalSoldiers	:int;
		//private var _picked			:Boolean;
		//private var _onInteractionWith:ArmyUnit;

		private var _active:Boolean;
		private var _view:ArmyUnitView;
		//private var _movesLeftInRound:int;
		
		private var _coinsInStorage:int = 0;
		private var _status:String;
		
		private var _healthPoints:int
		private var _alive:Boolean;
		
		public function ArmyUnit(army:Army) 
		{
			_view = new ArmyUnitView(this,army.armyData);
			
			_myArmy = army;
			_soldiers = new Vector.<Soldier>;
			
			//status = UnitStatusEnum.WAITING_FOR_ACTION;
			
			healthPoints = Math.random() * 10 + 1;
			
		}

		public function ready():void 
		{
			_alive = true;
			if (_myArmy.myPlayer.isHuman)
			{
				_view.addClickableIndecator();
			}
		}
		
		public function buildMe():void 
		{
			_view.showBuildAnimation();
			
			
		}
		
		public function addSoldier(newSoldier:Soldier):void
		{
			newSoldier.myArmyUnit = this;
			_soldiers.push(newSoldier);
			
			//var tile:Tile = _onTerritory.getRandomTile();
			//tile.addSoldier(newSoldier);
			
			this.totalSoldiers = _soldiers.length;
		}
		
		public function getSoldier(visualDisplay:Boolean = false):Soldier
		{
			if (!_soldiers.length) return null;
			var soldier:Soldier = _soldiers.pop();
			
			this.totalSoldiers = _soldiers.length;
			return soldier;
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
			if (!view) { LoggerHandler.getInstance.info(this,"NO ARMY UNIT VIEW!!!!")
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
			status = UnitStatusEnum.IDLE;
			
			var tile:Tile
			for each (var item:Soldier in _soldiers) 
			{
				tile = _onTerritory.getRandomTile();
				tile.addSoldier(item);
			}
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
			//this.view.touchable = value;
		}
		
		/*public function set clickable(value:Boolean):void 
		{
			if (!view) return;
			//_clickable = value;

			view.setClickable(value);
		}*/
		
		public function set enable(value:Boolean):void 
		{
			_enable = value;

			view.showClickArea = value;
		}
		
		/*public function get movesLeftInRound():int 
		{
			return _movesLeftInRound;
		}
		
		public function set movesLeftInRound(value:int):void 
		{
			_movesLeftInRound = value;
		}*/
		
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
			if (_status != value)
			{
				_status = value;
				
				switch (_status) 
				{
					case UnitStatusEnum.IDLE:
						clearMarks();
						_view.continueAnimation();
						_view.onFocus = false;
						break;
					case UnitStatusEnum.HIDE_FROM_ACTION:
						_view.alpha = 0;
						_onTerritory.view.alpha = .2;
						_view.stopAnimation();
						_view.onFocus = false;
						break;
					case UnitStatusEnum.SELECTED_FOR_ACTION:
						_onTerritory.view.alpha = 1;
						_view.stopAnimation();
						_view.alpha = 1;
						_view.onFocus = true;
						break;
					case UnitStatusEnum.READY_TO_BE_SELECTED:
						_view.alpha = .8;
						_view.stopAnimation();
						_view.onFocus = true;
						_onTerritory.view.alpha = .4;
						break;

				}
			}
		}
		
		public function getMySoldiers():Vector.<Soldier>
		{
			var arr:Vector.<Soldier> = new Vector.<Soldier>;
			for each (var item:Tile in _onTerritory.tiles) 
			{
				if (item.soldier)
				{
					arr.push(item.soldier);
				}
			}
			
			return arr;
		}
		
		public function get healthPoints():int 
		{
			return _healthPoints;
		}
		
		public function set healthPoints(value:int):void 
		{
			_healthPoints = value;
			
			if (_view) _view.showHealthBar(value)
		}
		
		public function get alive():Boolean 
		{
			return _alive;
		}
		
		
		
		public function clearMarks():void 
		{
			this._onTerritory.view.alpha = 1
			this._view.alpha = 1;
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
			_alive = false;
			
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
				//GameApp.getInstance.game.world.actionLayer.removeObject(_view);
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