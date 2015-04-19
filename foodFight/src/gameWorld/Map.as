package gameWorld 
{
	import ascb.util.NumberUtilities;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import gameConfig.ConfigurationData;
	import gameWorld.data.WorldData;
	import gameWorld.territories.Territory;
	import interfaces.IDisposable;
	import interfaces.IStorable;
	import starling.events.EventDispatcher;
	import storedGameData.ISavedData;
	import storedGameData.SavedGameData_Map;
	import storedGameData.SavedGameData_Territory;
	import storedGameData.SavedGameData_Tile;
	import urikatils.LoggerHandler;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Map extends EventDispatcher implements IDisposable,IStorable
	{
		static public var MAX_XPOS:int = 0;
		static public var MAX_YPOS:int = 0;
		
		private var _disable		:Boolean;
		private var _tiles			:Vector.<Tile> = new Vector.<Tile>;
		private var _freeTiles		:Vector.<Tile> = new Vector.<Tile>;
		private var _tilesArrByPos	:Array = new Array();
		
		private var _territories	:Vector.<Territory> = new Vector.<Territory>;
		private var _freeTerritories:Vector.<Territory> = new Vector.<Territory>;
		
		private var _view			:MapView;
		private var _mapGridData	:WorldData;
		private var continents:Vector.<Continent>;
		
		public function Map()
		{
			LoggerHandler.getInstance.info(this,"NEW MAP CREATED");
			
			_view = new MapView();
			_view.touchable = false;
		}
		
		public function generateRandomNewMap():void
		{
			this._mapGridData = gameConfig.ConfigurationData.worldData;
			this.createTilesGrid();
			this.createNewTerritories();
		}
		
		private function createTilesGrid():void
		{
			var xCount:int = 0; 
			var yCount:int = 0

			var total:int = _mapGridData.totalTiles;
			var newTile:Tile;

			for (var i:int = 0; i < total; ++i)
			{
				newTile = new Tile(i)
				this.view.addTile(newTile.view)
				newTile.setXYPos(xCount, yCount);
				
				
				_tilesArrByPos[newTile.getNameByPos()] = newTile;
				xCount++;

				_tiles.push(newTile);
				_freeTiles.push(newTile);
				
				if (xCount == _mapGridData.tilesInRow)
				{
					yCount++;
					xCount = 0;
				}
			}
			
			MAX_XPOS = _mapGridData.tilesInRow-1;
			MAX_YPOS = yCount-1;
			
			this.setTilesNeighbors();
		}
		
		private function setTilesNeighbors():void
		{
			for each (var item:Tile in _tiles) 
			{
				if (item.xpos % 2)
				{
					addNighborToTileByPos(item, item.xpos - 1, item.ypos-1);
					addNighborToTileByPos(item, item.xpos, item.ypos - 1);
					addNighborToTileByPos(item, item.xpos - 1, item.ypos);
					addNighborToTileByPos(item, item.xpos + 1, item.ypos);
					addNighborToTileByPos(item, item.xpos + 1, item.ypos-1);
					addNighborToTileByPos(item, item.xpos, item.ypos + 1);
				} else
				{
					addNighborToTileByPos(item, item.xpos, item.ypos - 1);
					addNighborToTileByPos(item, item.xpos - 1, item.ypos + 1);
					addNighborToTileByPos(item, item.xpos - 1, item.ypos);
					addNighborToTileByPos(item, item.xpos + 1, item.ypos);
					addNighborToTileByPos(item, item.xpos, item.ypos+1);
					addNighborToTileByPos(item, item.xpos + 1, item.ypos+1);
				}
			}
		}
		
		private function addNighborToTileByPos(addToTile:Tile,x:int, y:int):void
		{
			var nighborTile:Tile = _tilesArrByPos[x.toString() + "_" + y.toString()];
			if (nighborTile && (nighborTile !== addToTile) && nighborTile is Tile)
			{
				addToTile.addNeighbor(nighborTile);
			}
		}
		
		private function createNewTerritories():void
		{
			this.setTerritoryStartingTiles();
			this.expandTerritories();

			territoriesReady()
		}
		
		private function territoriesReady():void
		{
			for each (var finishTerritory:Territory in _territories) 
			{
				finishTerritory.setReady();
			}
			
			_freeTerritories.sort(sortByRandom);

			for each (var item:Tile in _freeTiles) 
			{
				item.setEmpty()
			}
			
			var territoryAlone:Territory;
			var newContinent:Continent;
			
			continents = new Vector.<Continent>;
			
			do
			{
				territoryAlone = this.getTerritoryOnContinent();
				if (territoryAlone)
				{
					newContinent = new Continent();
					newContinent.addTerritory(territoryAlone);
					continents.push(newContinent);
				}
				
			} while (territoryAlone);
			
			
			if (continents.length > 1)
			{
				connectContinents();
			}
		}
		
		private function sortByRandom(a:Territory,b:Territory):int 
		{
			return Math.floor( Math.random() * 3 - 1 );
		}
		
		private function connectContinents():void 
		{
			var connectTo:Continent = continents[0];
			var len:int = continents.length;
			
			
			for (var i:int = 1; i <len; i++) 
			{
				linkBetweenContinents(connectTo, continents[i]);
			}
		}
		
		private function linkBetweenContinents(c1:Continent, c2:Continent):void 
		{
			var t1:Territory;
			var tile:Tile;
			var t2:Territory;
			
			//var g:Graphics = new Graphics(this.view);			
			//g.lineTexture(2, Texture.fromColor(200, 200, 0xffffff));
			//var quad:Quad = new Quad(50, 10, 0xffffff);
			//quad.rotation
			//view.addChild(quad);
			var coastArr:Vector.<Territory> = c2.getCoastTerritories();
			
			var item2:Tile;
			do
			{
				t1 = coastArr.pop();
				tile = t1.getRandomCoastTile();

				var length1:int=tile.neighborsArr.length
				for (var i:int = 0; i <length1 ; ++i) 
				{
					var length2:int = tile.neighborsArr[i].neighborsArr.length
					
					for (var j:int = 0; j <length2 ; ++j) 
					{
						item2 = tile.neighborsArr[i].neighborsArr[j];
						if (item2.territory && item2.territory.onContinent != t1.onContinent)
						{
							t2 = item2.territory;
							
							
							
							break;
							//d.x = t1.mainTile.view.x;
							//quad.y = t1.mainTile.view.y;
							
							
							
						}
					}
				}
			} while (!t2 && coastArr.length)
			
			
		
			//	= c2.territories[0];
			
			
			if (t2)
			{
				t1.neighborsArr.push(t2);
				t2.neighborsArr.push(t1);
			} else
			{
				LoggerHandler.getInstance.info(this,"CANT CONNECT Continents!!!!");
			}
			
			
			
			/*LoggerHandler.getInstance.info(this,"111111");
			LoggerHandler.getInstance.info(this,"111111");
			var g:Graphics = new Graphics(view);
			
			g.lineStyle(2, 0xffffff);
			
			LoggerHandler.getInstance.info(this,"22222");
			//g.moveTo(t1.mainTile.view.x, t1.mainTile.view.y);
			//g.lineTo(t2.mainTile.view.x, t2.mainTile.view.y);
			LoggerHandler.getInstance.info(this,"33333");*/
			
		}
		
		
		private function getTerritoryOnContinent():Territory 
		{
			for each (var item:Territory in _territories) 
			{
				if (!item.onContinent) return item;
			}
			
			return null;
		}
		
		private function setTerritoryStartingTiles():void
		{
			//var startingTerritoryTiles:Vector.<Tile> = new Vector.<Tile>;
			
			
			_freeTerritories = new Vector.<Territory>
			
			var startingTile:Tile;
			//var count:int;
			var tileNum:int;
			var gotOccupiedNeighbor:Boolean = false;
			
			for (var i:int = 0; i < _mapGridData.totalTerritories; ++i) 
			{
				//count = 0;
				{
					do
					{
						//count++;
						tileNum = NumberUtilities.random(0, _freeTiles.length - 1);
						//saveStartingTiles.push(tileNum)
						startingTile = _freeTiles[tileNum];
						gotOccupiedNeighbor = false;
						
						for each (var tileNeighbor:Tile in startingTile.neighborsArr) 
						{
							if (tileNeighbor.territory)
							{
								gotOccupiedNeighbor = true;
							}
						}
					//} while (gotOccupiedNeighbor && count < 500)
					} while (gotOccupiedNeighbor && _freeTiles.indexOf(startingTile)!=-1)
				}
				
				_freeTiles.splice(_freeTiles.indexOf(startingTile), 1);
				//startingTerritoryTiles.push(startingTile);
				
				this.initNewTerritory(i, startingTile);
				
				//LoggerHandler.getInstance.info(this,"setTerritoryStartingTiles");
			}
			
			//LoggerHandler.getInstance.info(this,"saveStartingTiles = " + saveStartingTiles);
		}
		
		
		
		private function initNewTerritory(id:int, startingTile:Tile):void
		{
			//LoggerHandler.getInstance.info(this,"INIT NEW TERRITORY");
			var newTerritory:Territory = new Territory(id);
			newTerritory.addTile(startingTile);
			//newTerritory.view.addEventListener(TouchEvent.TOUCH, onTerritoryTouch);
				
			_freeTerritories.push(newTerritory);
			_territories.push(newTerritory);
			//this.view.landPH.addChild(newTerritory.view);
			this.view.addTerritory(newTerritory.view);
		}

		
		private function expandTerritories():void 
		{
			var tile:Tile;
			
			var expand_max_size:int = 2;
			for (var i:int = 0; i < expand_max_size; ++i) 
			{
				//if (!_freeTiles.length) return;
				
				for each (var territory:Territory in _territories) 
				{
					tile = territory.getRandomTile();
					
					for each (var neighborTile:Tile in tile.neighborsArr) 
					{
						if (!neighborTile.territory)
						{
							territory.addTile(neighborTile);
							_freeTiles.splice(_freeTiles.indexOf(neighborTile), 1);
						}
						
						if (!_freeTiles.length) return;
					}
				}
				
			}
		}
		
		
		
		public function activate():void 
		{
			var tiles:Vector.<Tile> = new Vector.<Tile>();
			
			for each (var territory:Territory in _territories) 
			{
				for each (var tile:Tile in territory.tiles) 
				{
					tiles.push(tile);
				}
			}
			
			tiles.sort(shuffleTiles);
			
			var totalCoins:int = 30;
			var tilePicked:Tile;
			
			for (var i:int = 0; i < totalCoins; ++i) 
			{
				tilePicked = tiles.pop();
				tilePicked.addCoin();
			}
			
			//_view.landPH.scaleX = _view.landPH.scaleY = .5;
		}
		
		public static function shuffleTiles(a:Tile, b:Tile):int
		{
			return Math.floor( Math.random() * 3 - 1 );
		}
		
		
		private function getTileByID(id:int):Tile 
		{
			for each (var item:Tile in _tiles) 
			{
				if (item.id == id) return item;
			}
			
			return null;
		}
		
		public function getRandomTerritory():Territory
		{
			
			return _freeTerritories.pop();
		}
		
		
		
		public function setTerritoriesFocus(territoriesArr:Vector.<Territory>):void
		{
			LoggerHandler.getInstance.info(this,"SET TILE FOCUS" + territoriesArr);
			this.clearTerritoriesFocus();
			
			/*for each (var item:Territory in _territories) 
			{
				if (territoriesArr.indexOf(item) == -1)
				{
					item.darken = true;
				}
			}*/
		}
		
		public function clearTerritoriesFocus():void
		{
			LoggerHandler.getInstance.info(this,"CLEAR TILE FOCUS");

			/*for each (var item:Territory in _territories) 
			{
				item.darken = false;
			}*/
		}
		
		public function getTerritoryByID(num:int):Territory 
		{
			for each (var item:Territory in _territories) 
			{
				if (item.id == num) return item;
			}
			return null;
		}
		
		
		
		public function getDataTranslateObject():XMLNode 
		{
			var mapNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "map");
			//var worldDataNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "worldData");
			var territoriesNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "territories");
			
			var mapAtt:Object = new Object();
			//mapAtt.tilesInRow = ConfigurationData.worldData.tilesInRow;
			//mapAtt.totalTiles = ConfigurationData.worldData.totalTiles;
			
			mapAtt.tilesInRow = _mapGridData.tilesInRow;
			mapAtt.totalTiles = _mapGridData.totalTiles;
			mapAtt.totalTerritories = _mapGridData.totalTerritories;
			mapNode.attributes = mapAtt;
			
			mapNode.appendChild(territoriesNode);
			
			for each (var item:Territory in this.territories) 
			{
				territoriesNode.appendChild(item.getDataTranslateObject());
			}
			
			return mapNode;
		}
		
		public function translateBackFromData(data:ISavedData):void 
		{
			var translateData:SavedGameData_Map = data as SavedGameData_Map;
			
			///LoggerHandler.getInstance.info(this,"INIT NEW MAP FROM DATA" + translateData);
			
			this._mapGridData = new WorldData( new Object() );
			this._mapGridData.totalTerritories = translateData.totalTerritories;
			this._mapGridData.tilesInRow = translateData.tilesInRow;
			this._mapGridData.totalTiles = translateData.totalTiles;
			this.createTilesGrid();
			
			for each (var territoryData:SavedGameData_Territory in translateData.territoriesData.territories) 
			{
				initNewTerritoryByData(territoryData);
			}

			this.territoriesReady();
		}
		
		private function initNewTerritoryByData(savedData:SavedGameData_Territory):void
		{
			var newTerritory:Territory = new Territory(savedData.id);
			
			var tile:Tile;
			for each (var item:SavedGameData_Tile in savedData.tiles) 
			{
				tile = getTileByID(item.id);
				_freeTiles.splice(_freeTiles.indexOf(tile), 1);
				newTerritory.addTile(tile);
				
				newTerritory.translateBackFromData(savedData);
			}
			
			_territories.push(newTerritory);
			_freeTerritories.push(newTerritory);

			this.view.addTerritory(newTerritory.view);
		}
		
		
		public function dispose():void 
		{
			for each (var item:Territory in _territories) 
			{
				item.dispose();
			}
			
			if (view)
			{
				view.removeFromParent(true);
				view.removeEventListeners();
				//_view = null;
			}
		}
		
		
		
		
		
		public function set disable(value:Boolean):void 
		{
			_disable = value;
			//view.touchable = !value;
			
			trace("map disable == " + _disable);
		}
		
		public function get territories():Vector.<Territory> 
		{
			return _territories;
		}
		
		public function get view():MapView 
		{
			return _view;
		}
	}

}