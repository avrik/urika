package gameWorld.territories 
{
	import armies.Army;
	import armies.ArmyUnit;
	import ascb.util.NumberUtilities;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import gameWorld.Continent;
	import gameWorld.territories.Citizen;
	import gameWorld.Tile;
	import interfaces.IDisposable;
	import interfaces.IStorable;
	import starling.events.TouchEvent;
	import storedGameData.ISavedData;
	import storedGameData.SavedGameData_Territory;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class Territory implements IDisposable, IStorable
	{
		public var worth:Number = 100;
		private var _totalCoins:int;
		private var _id:int;
		
		private var _darken			:Boolean;
		private var _owner			:Army;
		private var _mainTile		:Tile;
		private var _tiles			:Vector.<Tile> = new Vector.<Tile>;
		private var _neighborsArr	:Vector.<Territory> ;
		
		private var _armyUnit			:ArmyUnit;
		private var _enemyTerritories	:Vector.<Territory>;
		private var _myTerritories		:Vector.<Territory>;
		private var _disable			:Boolean;
		private var _view				:TerritoryView
		private var _citizen:Citizen;
		
		private var _capital:Boolean;
		private var _linkedToCapital:Boolean;
		private var _onContinent:Continent;
		private var _coastTiles:Vector.<Tile> = new Vector.<Tile>;
		
		public function Territory(id:int) 
		{
			this._id = id;
			_view = new TerritoryView(this);
			
		}
		
		public function addTile(tile:Tile):void
		{
			if (tile)
			{
				tile.territory = this;
				if (_tiles.length == 0)
				{
					this.mainTile = tile;
					
				}
				
				_tiles.push(tile)
				this.view.addChild(tile.view);
				//_totalCoins += tile.coins;
				//this._extraDefence += tile.extraDefence;
			}
		}
		
		public function setReady():void
		{
			setNeighbors();
			setMyBorders();
		}
		
		public function setMyBorders():void
		{
			/*for each (var item:Tile in _tiles) 
			{
				item.setBorders();
			}*/
		}
		
		
		private function setNeighbors():void
		{
			_neighborsArr = new Vector.<Territory>;
			
			for each (var item:Tile in _tiles) 
			{
				for each (var neighborTile:Tile in item.neighborsArr) 
				{
					if (neighborTile.territory && neighborTile.territory != this && _neighborsArr.indexOf(neighborTile.territory) == -1)
					{
						_neighborsArr.push(neighborTile.territory);
					}
					
					if (!neighborTile.territory)
					{
						item.coastTile = true;
						_coastTiles.push(item)
					}
				}
				
				item.view.setAsInTerritory();
			}
		}
		
		public function setNeighborsType():void
		{
			_enemyTerritories = new Vector.<Territory>;
			_myTerritories = new Vector.<Territory>;
			
			for each (var item:Territory in _neighborsArr) 
			{
				if (item.owner == this.owner)
				{
					_myTerritories.push(item);
				} else
				{
					_enemyTerritories.push(item);
				}
			}
		}
		
		public function getRandomTile():Tile 
		{
			return _tiles[NumberUtilities.random(0, (_tiles.length - 1))];
		}
		
		public function get armyUnit():ArmyUnit 
		{
			return _armyUnit;
		}
		
		public function set armyUnit(value:ArmyUnit):void 
		{
			if (_armyUnit)
			{
				_armyUnit.dispose();
			}
			
			_armyUnit = value;
			_armyUnit.myTile = this._mainTile;

			//this._mainTile.view.addChild(value.view);
			//this._mainTile.addArmyUnit(value);
			//MainGameApp.getInstance.game.world.actionLayer.addObject(value.view, this._mainTile.view.x, this._mainTile.view.y);
			MainGameApp.getInstance.game.world.actionLayer.addArmyUnit(value.view, this._mainTile.view.x, this._mainTile.view.y);
			_armyUnit.buildMe();
			//_mainTile.view.bringToFront();
			this.owner = this._armyUnit.myArmy;
		}
		
		/*public function set disable(value:Boolean):void 
		{
			_disable = value;

			this.view.touchable = !value;
			trace("ter disable == " + _disable);
		}*/
		
		public function get owner():Army 
		{
			return _owner;
		}
		
		public function set owner(value:Army):void 
		{
			if (_owner == value && this._armyUnit) return;
			_owner = value;
			
			//LoggerHandler.getInstance.info(this,"OWNER == " + value);
			if (value)
			{
				for each (var item:Tile in _tiles)
				{
					item.owner = value;
				}
				setMyBorders();
				
				var len:int = this.neighborsArr.length;
				for (var i:int = 0; i <len ; ++i) 
				{
					if (this.neighborsArr[i].owner)
					{
						this.neighborsArr[i].setMyBorders();
					}
				}
				
				/*if (this.capital)
				{
					this.view.removeCapitalFlag();
				}*/
			}
			
			if (this._armyUnit)
			{
				this._armyUnit.myArmy = value;
				this.setNeighborsType();
				
				for each (var neighborItem:Territory in _neighborsArr) 
				{
					neighborItem.setNeighborsType();
				}
				
				/*if (this._citizen)
				{
					this._citizen.dispose();
				}
				
				this._citizen = new Citizen(this);
				MainGameApp.getInstance.game.world.actionLayer.addObject(this._citizen.view, this._armyUnit.view.x, this._armyUnit.view.y-30);*/
			}
		}
		
		public function getPatrolTiles():Vector.<Tile>
		{
			var arr:Vector.<Tile> = new Vector.<Tile>;
			var length:int = tiles.length;
			for (var i:int = 0; i <length ; ++i) 
			{
				if (!tiles[i].isMainTile)
				{
					arr.push(tiles[i]);
				}
			}
			return arr;
		}
		
		public function get enemyTerritories():Vector.<Territory> 
		{
			return _enemyTerritories;
		}
		
		public function get neighborsArr():Vector.<Territory> 
		{
			return _neighborsArr;
		}
		
		public function set selectForAction(value:Boolean):void 
		{
			if (value)
			{
				darken = false;
				armyUnit.view.scaleX = armyUnit.view.scaleY = 1.2;
				
				for each (var item:Territory in _neighborsArr) 
				{
					item.darken = false;
					//item.view.alpha = .5
				}
			} else
			{
				armyUnit.view.scaleX = armyUnit.view.scaleY = 1;
			}
		}
		
		public function set darken(value:Boolean):void 
		{
			_darken = value;
			
			var length:int = _tiles.length;
			for (var i:int = 0; i <length ; ++i) 
			{
				//item.blendMode = value?BlendMode.MULTIPLY:BlendMode.NORMAL;
				_tiles[i].view.alpha = value?.5:1;
				if (this.armyUnit)
				{
					//this.armyUnit.view.butn.visible = !value;
					this.armyUnit.view.mySprite.visible = !value;
				}
				/*if (_citizen)
				{
					_citizen.disable = value;
					
				}*/
				_tiles[i].view.showBorders = !value;
			}
			
			/*if (view.flag)
			{
				//view.flag.alpha = value?.2:1;
				view.flag.visible = !value;
			}*/
			
		}
		
		public function removeCitizen():void 
		{
			if (_citizen)
			{
				_citizen.dispose();
				_citizen = null;
			}
		}
		
		public function get tiles():Vector.<Tile> 
		{
			return _tiles;
		}
		
		/* INTERFACE interfaces.IStorable */
		
		public function getDataTranslateObject():XMLNode
		{
			var territoryNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "territory");
			var territoryAtt:Object = new Object();
			territoryAtt.id = this.id.toString();
			
			territoryAtt.owner = this._owner?this._owner.armyData.id:"";
			territoryAtt.mainTileID = this._mainTile.id;
			territoryNode.attributes = territoryAtt;

			for each (var item:Tile in _tiles) 
			{
				territoryNode.appendChild(item.getDataTranslateObject());
			}
			
			return territoryNode;
		}
		
		
		
		public function translateBackFromData(data:ISavedData):void 
		{
			var translateData:SavedGameData_Territory = data as SavedGameData_Territory;
		}
		
		public function get view():TerritoryView 
		{
			return _view;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get mainTile():Tile 
		{
			return _mainTile;
		}
		
		public function set mainTile(value:Tile):void 
		{
			_mainTile = value;
			value.isMainTile = true;
		}
		
		public function get citizen():Citizen 
		{
			return _citizen;
		}
		
		public function get capital():Boolean 
		{
			return _capital;
		}
		
		public function set capital(value:Boolean):void 
		{
			_capital = value;
			
			/*if (view)
			{
				_view.setType(value?"C":"");
			}*/
			//view.alpha = value?.2:1;
			
			for each (var item:Territory in _myTerritories) 
			{
				item.linkedToCapital = true;
			}
			
			//view.addCapitalFlag();
		}
		
		public function get linkedToCapital():Boolean 
		{
			return _linkedToCapital;
		}
		
		public function set linkedToCapital(value:Boolean):void 
		{
			if (_linkedToCapital == value) return;
			_linkedToCapital = value;
			
			if (!this._capital)
			{
				/*if (view)
				{
					view.setType(value?"L":"");
				}*/
				//view.alpha = value?.5:1;
				for each (var item:Territory in _myTerritories) 
				{
					item.linkedToCapital = value;
				}
			}
			
		}
		
		public function get onContinent():Continent 
		{
			return _onContinent;
		}
		
		public function set onContinent(value:Continent):void 
		{
			_onContinent = value;
		}
		
		public function get totalCoins():int 
		{
			return _totalCoins;
		}
		
		public function set totalCoins(value:int):void 
		{
			_totalCoins = value;
		}
		
		public function get myTerritories():Vector.<Territory> 
		{
			return _myTerritories;
		}
		
		
		
		/* INTERFACE interfaces.IDisposable */
		
		public function dispose():void 
		{
			removeCitizen();
			for each (var item:Tile in _tiles) 
			{
				item.dispose();
			}
			
			if (view)
			{
				_view.removeFromParent(true);
				_view = null;
			}
		}
		
		public function isCoastTerriroty():Boolean 
		{
			return _coastTiles.length?true:false;
		}
		
		public function getRandomCoastTile():Tile 
		{
			return _coastTiles[NumberUtilities.random(0, _coastTiles.length - 1)];
		}
		
		public function getTerritorySize():int 
		{
			return this.tiles.length
		}
		
		public function isNeighborOf(territory:Territory):Boolean 
		{
			return _neighborsArr.indexOf(territory) != -1?true:false;
		}
		
		
		
		
	}

}