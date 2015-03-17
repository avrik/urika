package gameWorld.maps 
{
	import ascb.util.NumberUtilities;
	import assets.AssetsEnum;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import gameWorld.territories.Territory;
	import gameWorld.Tile;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.VAlign;
	import ui.ViewComponent;


	
	/**
	 * ...
	 * @author Avrik
	 */
	public class MapEditor extends ViewComponent 
	{
		private var _tilesArrByPos:Array = new Array();
		private var _tiles:Vector.<MapEditorTile> = new Vector.<MapEditorTile>;
		private var _gridPH:Sprite;
		private var _saveButn:Button;
		private var _backButn:Button;
		private var _randomButn:Button;
		private var _activeTiles:Vector.<MapEditorTile>= new Vector.<MapEditorTile>;
		private var _territories:Vector.<Territory> = new Vector.<Territory>;
		private var _freeTiles:Vector.<MapEditorTile>;
		
		public function MapEditor() 
		{
			//_worldData = worldData;
		}
		
		override protected function init():void 
		{
			super.init();
			
			addChild(new Image(TopLevel.assets.getTexture(AssetsEnum.MAP_BG))) as Image;
			_gridPH = new Sprite();
			addChild(_gridPH);
			createTilesGrid();
			
			this._gridPH.x = (stage.stageWidth - this._gridPH.width) / 2 - 40;
			this._gridPH.y = 100;
			
			var butnImg:Image = new Image(TopLevel.assets.getTexture(AssetsEnum.SCREEN_PICK_OK_BUTN));
			
			_backButn = addButton(TopLevel.assets.getTexture(AssetsEnum.SETTINGS_WINDOW_CLOSE_BUTN),10, "", backClicked,1);
			_randomButn = addButton(butnImg.texture, stage.stageWidth - (butnImg.width + 20), "SET TERRITORIES", randomClicked);
			_saveButn = addButton(butnImg.texture, stage.stageWidth - (butnImg.width * .5 + 10), "SAVE", saveClicked);
			
			_randomButn.enabled = false;
			_saveButn.enabled = false;
		}
		
		
		private function addButton(texture:Texture, x:Number, text:String, func:Function, scale:Number = .5):Button
		{
			var butn:Button = new Button(texture);
			butn.scaleX = butn.scaleY = scale;
			butn.x = x;
			butn.text = text;
			butn.fontSize = 15 / scale;
			butn.textVAlign = VAlign.BOTTOM;
			
			butn.y = stage.stageHeight - (butn.height + 10);
			butn.addEventListener(Event.TRIGGERED, func);
			
			addChild(butn);
			return butn;
		}
		
		private function randomClicked(e:Event):void 
		{
			createTerritories();
			
			_saveButn.enabled = _territories.length?true:false;
		}
		
		private function saveClicked(e:Event):void 
		{
			saveMap();
		}
		
		private function saveMap():void 
		{
			var xmlDoc:XMLDocument = new XMLDocument();
			xmlDoc.appendChild(getDataTranslateObject());
			
			
			/*var result:XMLDocument = new XMLDocument();
            result.ignoreWhite = true;
            result.parseXML(xmlDoc);*/

			var xml:XML = new XML(xmlDoc.firstChild);
			
			Tracer.alert("XML TO SAVE :\n" + xml);
		}
		
		private function createTilesGrid():void
		{
			var xCount:int = 0;
			var yCount:int = 0
			
			var total:int = ConfigurationData.worldData.totalTiles;
			var newTile:MapEditorTile;
			
			for (var i:int = 0; i < total; ++i)
			{
				newTile = new MapEditorTile(i)
				_gridPH.addChild(newTile.view);
				newTile.setXYPos(xCount, yCount);
				newTile.setEmpty();
				newTile.addEventListener(Event.SELECT,tileViewClicked)
				_tilesArrByPos[newTile.getNameByPos()] = newTile;
				xCount++;

				_tiles.push(newTile);
				
				if (xCount == ConfigurationData.worldData.tilesInRow)
				{
					yCount++;
					xCount = 0;
				}
				
				newTile.activate();
			}
			
			
		}
		
		private function tileViewClicked(e:Event):void 
		{
			var tile:MapEditorTile = e.currentTarget as MapEditorTile;
			if (!tile.view.empty)
			{
				if (_activeTiles.indexOf(tile) == -1)
				{
					_activeTiles.push(tile);
				}
				
			} else
			{
				if (_activeTiles.indexOf(tile) != -1)
				{
					_activeTiles.splice(_activeTiles.indexOf(tile), 1);
				}
				
			}
			
			_randomButn.enabled = _activeTiles.length > 5?true:false;
		}
		
		private function setTilesNeighbors():void
		{
			var length:int = _tiles.length;
			var item:Tile;
			
			for (var i:int = 0; i < length; ++i) 
			{
				item = _tiles[i];
				if (item.territory)
				{
					item.unTerritory();
				}
				
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
		
		private function addNighborToTileByPos(addToTile:Tile, x:int, y:int):void
		{
			var nighborTile:Tile = _tilesArrByPos[x.toString() + "_" + y.toString()];
			if (nighborTile && (nighborTile !== addToTile) && nighborTile is Tile && (_activeTiles.indexOf(nighborTile)!=-1))
			{
				addToTile.addNeighbor(nighborTile);
			}
		}
		
		
		private function createTerritories():void
		{
			this.setTilesNeighbors();
			
			/*if (_territories.length)
			{
				var l:int = _territories.length;
				for (var j:int = 0; j <l ; j++) 
				{
					_territories[j].dispose();
					_territories[j] = null;
				}
			}*/
			_territories = new Vector.<Territory>;
			_freeTiles = new Vector.<MapEditorTile>;
			
			for each (var item:Tile in _activeTiles) 
			{
				_freeTiles.push(item);
				//item.view.setUnEmpty();
			}
			
			setTerritoryStartingTiles();
			
			var length:int = this._territories.length;
			for (var i:int = 0; i < length; ++i) 
			{
				this._territories[i].setReady();
				//this._territories[i].setMyBorders();
			}
		}
		
		
		private function setTerritoryStartingTiles():void
		{
			//var startingTerritoryTiles:Vector.<Tile> = new Vector.<Tile>;
			//_freeTerritories = new Vector.<Territory>
			
			var startingTile:MapEditorTile;
			var count:int;
			var tileNum:int;
			var gotOccupiedNeighbor:Boolean = false;
			
			var totalTerritories:int = Math.floor(_freeTiles.length / 5);
			
			if (totalTerritories)
			{
				for (var i:int = 0; i < totalTerritories; ++i) 
				{
					count = 0;
					
					do
					{
						count++;
						tileNum = NumberUtilities.random(0, _freeTiles.length - 1);
						//saveStartingTiles.push(tileNum)
						startingTile = _freeTiles[tileNum];
						gotOccupiedNeighbor = false;
						
						for each (var tileNeighbor:MapEditorTile in startingTile.neighborsArr) 
						{
							if (tileNeighbor.territory)
							{
								gotOccupiedNeighbor = true;
								break;
							}
						}
					} while (gotOccupiedNeighbor && _freeTiles.indexOf(startingTile)!=-1 && count<500)
					
					
					_freeTiles.splice(_freeTiles.indexOf(startingTile), 1);
					//startingTerritoryTiles.push(startingTile);
					
					this.initNewTerritory(i, startingTile);
					
					//Tracer.alert("setTerritoryStartingTiles");
				}
			} else
			{
				Tracer.alert("NOT ENUGH TILES");
			}
			
			expandTerritories();
			//Tracer.alert("saveStartingTiles = " + saveStartingTiles);
		}
		
		private function initNewTerritory(id:int, startingTile:MapEditorTile):void
		{
			//Tracer.alert("111111111111 === " + _freeTiles.length);
			var newTerritory:Territory = new Territory(id);
			newTerritory.addTile(startingTile);
				
			_territories.push(newTerritory);
			this._gridPH.addChild(newTerritory.view);
		}
		
		private function expandTerritories():void 
		{
			//Tracer.alert("22222222222222 === " + _freeTiles.length);
			var tile:Tile;
			var count:int = 500;
			do
			{
				//if (!_freeTiles.length) break;
				count--;
				for each (var territory:Territory in _territories) 
				{
					tile = territory.getRandomTile();
					
					for each (var neighborTile:MapEditorTile in tile.neighborsArr) 
					{
						if (!neighborTile.territory)
						{
							territory.addTile(neighborTile);
							_freeTiles.splice(_freeTiles.indexOf(neighborTile), 1);
							
							if (!_freeTiles.length) return;
						}
						
						//Tracer.alert("3333333333333 === " + _freeTiles.length);
					}
				}
			}
			while (_freeTiles.length && count)
			
			//Tracer.alert("BBBBBBBBBB === " + _activeTiles.length);
		}
		
		
		
		public function getDataTranslateObject():XMLNode 
		{
			var mapNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "map");
			var territoriesNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "territories");
			
			var mapDataAtt:Object = new Object();
			mapDataAtt.tilesInRow = ConfigurationData.worldData.tilesInRow;
			mapDataAtt.totalTiles = ConfigurationData.worldData.totalTiles;
			mapNode.attributes = mapDataAtt;
			
			mapNode.appendChild(territoriesNode);
			
			for each (var item:Territory in this._territories) 
			{
				territoriesNode.appendChild(item.getDataTranslateObject());
			}
			
			return mapNode;
		}
		
		
		private function backClicked(e:Event):void 
		{
			goBack();
		}
		
		private function goBack():void 
		{
			this.removeFromParent(true);
		}
		
		
		
	}

}