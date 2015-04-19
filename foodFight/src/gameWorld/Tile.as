package gameWorld 
{
	import armies.Army;
	import armies.ArmyUnit;
	import armies.Soldier;
	import ascb.util.NumberUtilities;
	import flash.geom.Point;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import gameWorld.territories.Territory;
	import interfaces.IDisposable;
	import interfaces.IStorable;
	import starling.events.EventDispatcher;
	import storedGameData.ISavedData;
	import storedGameData.SavedGameData_Tile;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class Tile extends EventDispatcher implements IDisposable,IStorable
	{
		private var _owner:Army;
		private var _territory		:Territory;
		private var _xpos			:int;
		private var _ypos			:int;
		private var _neighborsArr	:Vector.<Tile> = new Vector.<Tile>;
		private var _id				:int;
		public var isMainTile:Boolean;
		private var _coastTile:Boolean;
		private var _view:TileView;
		private var bordered:Boolean;
		private var _coins:int;
		
		
		
		private var _soldier:Soldier
		
		
		
		public function Tile(id:int)
		{
			this._id = id;
			_view = new TileView();
			
			
		}
		
		public function setXYPos(xpos:int, ypos:int):void 
		{
			this._xpos = xpos;
			this._ypos = ypos;
			
			var margin:int = -4;
			var tilt:int = xpos % 2?0:(_view.height + margin) / 2;
			var x:int = xpos * ((_view.width + margin) / 1.3);
			var y:int = ypos * (_view.height + margin) + (tilt);
			
			_view.x = x + view.tileWidth;
			_view.y = y + view.tileHeight / 2;
				
			_view.bringToFront();
		}
		
		public function getNameByPos():String
		{
			return this._xpos.toString() + "_" + this._ypos.toString();
		}
		
		public function setMyNeighbors(neighborsArr:Vector.<Tile>):void 
		{
			this._neighborsArr = neighborsArr;
		}
		
		public function addNeighbor(tile:Tile):void 
		{
			if (!this._neighborsArr) this._neighborsArr = new Vector.<Tile>;
			this._neighborsArr.push(tile);
		}
		
		public function setEmpty():void 
		{
			_view.setEmpty();
		}
		
		
		
		/* INTERFACE interfaces.IDisposable */
		
		public function dispose():void 
		{
			
		}
		
		/* INTERFACE interfaces.IStorable */
		
		public function getDataTranslateObject():XMLNode 
		{
			var tileNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "tile");
			var tileAtt:Object = new Object();
			tileAtt.id = this.id;
			tileAtt.xpos = this.xpos;
			tileAtt.ypos = this.ypos;
			tileNode.attributes = tileAtt;
				
			return tileNode
		}
		
		public function translateBackFromData(data:ISavedData):void 
		{
			var translateData:SavedGameData_Tile = data as SavedGameData_Tile;
		}
		
		public function addArmyUnit(value:ArmyUnit):void 
		{
			//view.addChild(value.view);
			
			//GameApp.getInstance.game.world.map.view.armyUnitsPH.addChild(value.view);
			
			//value.view.x = this.view.x;
			//value.view.y = this.view.y;
			//GameApp.getInstance.game.world.actionLayer.addObject(value.view,this.view.x,this.view.y)
			//view.bringToFront();
		}
		
		public function getRandomNeighbor(sameTerritory:Boolean = true, excludeMain:Boolean = false):Tile
		{
			var tile:Tile;
			
			if (_neighborsArr.length)
			{
				if (this._owner && sameTerritory)
				{
					var count:int = 100;
					do
					{
						tile = _neighborsArr[NumberUtilities.random(0, (_neighborsArr.length - 1))];
						count--;
					}
					while (this.territory != tile.territory && count && (excludeMain && tile.isMainTile))
				} else
				{
					tile = _neighborsArr[NumberUtilities.random(0, (_neighborsArr.length - 1))];
				}
			} 
					
			return tile
		}
		
		public function setBorders():void 
		{
			var arr:Vector.<int> = new Vector.<int>;
			var arr2:Vector.<int> = new Vector.<int>;
			
			if (this.xpos == 0) 
			{
				arr.push(0);
				arr.push(5);
			}
			if (this.ypos == 0) {
				
				arr.push(1);
				
				if (this.xpos % 2)
				{
					arr.push(0);
					arr.push(2);
				}
			}
			
			if (this.xpos == Map.MAX_XPOS) {
				arr.push(2);
				arr.push(3);
			}
			
			if (this.ypos == Map.MAX_YPOS) {
				arr.push(4);
				if (this.xpos % 2==0)
				{
					arr.push(3);
					arr.push(5);
				}
			}

			//for each (var item:Tile in this.neighborsArr) 
			var length:int = this.neighborsArr.length;
			var item:Tile;
			for (var i:int = 0; i <length ; ++i) 
			{
				item = this.neighborsArr[i];
				
				if (item.territory != this.territory)
				{
					if (!this.owner)
					{
						arr = populateBorderArr(item, arr);
					} else
					{
						if (item.owner == this.owner)
						{
							arr2 = populateBorderArr(item, arr2);
						} else
						{
							arr = populateBorderArr(item, arr);
						}
					}
				}
			}
			
			_view.setBorders(arr,arr2);
			bordered = true;
		}
		
		public function unTerritory():void 
		{
			_neighborsArr = new Vector.<Tile>;
			_owner = null;
			territory = null;
			isMainTile = false;
			//view.showBorders = false;
			//setBorders();
		}
		
		public function addCoin():void 
		{
			this._coins++;
			this.territory.totalCoins += this._coins;
			view.addCoinImage();
		}
		
		private function populateBorderArr(item:Tile,addToArr:Vector.<int>):Vector.<int>
		{
			if (this.xpos % 2)
			{
				if (item.xpos < this.xpos && item.ypos < this.ypos) addToArr.push(0);
				if (item.xpos == this.xpos && item.ypos < this.ypos) addToArr.push(1);
				if (item.xpos > this.xpos && item.ypos < this.ypos) addToArr.push(2);
				
				if (item.xpos > this.xpos && item.ypos == this.ypos) addToArr.push(3);
				if (item.xpos == this.xpos && item.ypos > this.ypos) addToArr.push(4);
				if (item.xpos < this.xpos && item.ypos == this.ypos) addToArr.push(5);
			} else
			{
				if (item.xpos < this.xpos && item.ypos == this.ypos) addToArr.push(0);
				if (item.xpos == this.xpos && item.ypos < this.ypos) addToArr.push(1);
				if (item.xpos > this.xpos && item.ypos == this.ypos) addToArr.push(2);
				
				if (item.xpos > this.xpos && item.ypos > this.ypos) addToArr.push(3);
				if (item.xpos == this.xpos && item.ypos > this.ypos) addToArr.push(4);
				if (item.xpos < this.xpos && item.ypos > this.ypos) addToArr.push(5);
			}
			
			var newArr:Vector.<int> = new Vector.<int>;
			for (var i:int = 0; i < 6; i++) 
			{
				if (addToArr.indexOf(i) != -1)
				{
					newArr.push(i);
				}
			}
			return newArr;
		}
		
		public function get xpos():int 
		{
			return _xpos;
		}
		
		public function get ypos():int 
		{
			return _ypos;
		}
		
		public function get neighborsArr():Vector.<Tile> 
		{
			return _neighborsArr;
		}
		
		public function set territory(value:Territory):void 
		{
			_territory = value;
		}
		
		public function get territory():Territory 
		{
			return _territory;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get view():TileView 
		{
			return _view;
		}
		
		public function set owner(value:Army):void 
		{
			_owner = value;
			_view.setOwner(value.armyData.id, _coins?true:false);
			
			var rand:int = Math.random() * 3;
			
			/*if (!rand)
			{
				addSoldier()
			}*/
		}
		
		public function addSoldier(newSoldier:Soldier):void
		{
			if (_soldier)
			{
				_soldier.removeVisualDisplay();
			}
			_soldier = newSoldier
			//_view.addChild(_soldier.view);
			//var point:Point = MainGameApp.getInstance.game.world.actionLayer.getObjectGlobalCord(_view);
			MainGameApp.getInstance.game.world.actionLayer.addObject(_soldier.view, _view.x, _view.y);
		}
		
		public function get owner():Army 
		{
			return _owner;
		}
		
		public function get coins():int 
		{
			return _coins;
		}
		
		public function get coastTile():Boolean 
		{
			return _coastTile;
			
		}
		
		public function set coastTile(value:Boolean):void 
		{
			_coastTile = value;
			//this.view.alpha = 0.2;
		}
		
		public function get soldier():Soldier 
		{
			return _soldier;
		}
		
	}

}