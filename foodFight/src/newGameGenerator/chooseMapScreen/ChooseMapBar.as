package newGameGenerator.chooseMapScreen 
{
	import assets.AssetsEnum;
	import feathers.controls.ScrollContainer;
	import feathers.layout.HorizontalLayout;
	import gameWorld.Map;
	import gameWorld.maps.data.MapData;
	import gameWorld.maps.data.MapsData;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Graphics;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import storedGameData.SavedGameData_Map;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class ChooseMapBar extends ViewComponent 
	{
		static public const MAP_READY:String = "mapReady";
		static public const GENERATING_MAP:String = "generatingMap";

		
		private var _map:Map;
		private var _mapContainer:ScrollContainer;
		private var waitTF:TextField;
		private var blockMC:Sprite;
		
		private var _mapsContainer:SavedMapsContainer;
		
		public function ChooseMapBar() 
		{
			
		}
					
		override protected function init():void 
		{
			super.init();

			this.addChild(new Image(TopLevel.assets.getTexture(AssetsEnum.SCREEN_PICK_MAP_PH))) as Image;

			_mapContainer = new ScrollContainer();
			this.addChild(_mapContainer)
			
			_mapContainer.x = 14;
			_mapContainer.width = 502;
			_mapContainer.height = 500;
			
			var layout:HorizontalLayout = new HorizontalLayout();
			//layout.useVirtualLayout = true;
			layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			layout.paddingTop = 74;
			layout.paddingLeft = -70;

			_mapContainer.layout = layout;
			
			blockMC = new Sprite();
			blockMC.touchable = false;
			var g:Graphics = new Graphics(blockMC)
			g.beginFill(0, .5);
			g.drawRect(14, 74, 504, 360);
			g.endFill();
			this.addChild(blockMC);
			
			waitTF = new TextField(510, 50, "GENERATING NEW MAP", "Verdana", 14, 0xffffff);
			waitTF.autoScale = true;
			waitTF.y = 220;
			blockMC.addChild(waitTF);
			
			
			_mapsContainer = new SavedMapsContainer();
			_mapsContainer.y = 400;
			_mapsContainer.addEventListener(Event.SELECT, thumbSelected);
			addChild(_mapsContainer);
			//setNewMap();
		}
		
		
		
		private function thumbSelected(e:Event):void 
		{
			var mapsContainer:SavedMapsContainer = e.currentTarget as SavedMapsContainer;
			Tracer.alert("THUMB SELECTED " + mapsContainer.selected.id);
			
			setNewMap(MapsData.mapsDataArr[mapsContainer.selected.id])
		}
		
		public function setNewMap(mapData:SavedGameData_Map = null):void
		{
			dispatchEvent(new Event(GENERATING_MAP))
			blockMC.visible = true;
			
			if (map)
			{
				map.dispose();
				map.removeEventListeners();
			}
			
			_map = new Map();
			map.view.scaleX = map.view.scaleY = .5;
			//map.view.touchable = false;
			//map.view.flatten();
			
			_mapContainer.addChild(map.view);
			
			Starling.juggler.add(new DelayedCall(showNewMap, .5,[mapData]));
		}
		
		private function showNewMap(mapData:SavedGameData_Map):void 
		{
			//_mapContainer.addChild(map.view) as Map;
			if (mapData)
			{
				_map.translateBackFromData(mapData);
			} else
			{
				_map.generateRandomNewMap();
			}
			map.view.flatten();
			blockMC.visible = false;
			
			dispatchEvent(new Event(MAP_READY))
		}
		
		public function get map():Map 
		{
			return _map;
		}
		
	}

}