package newGameGenerator.chooseMapScreen 
{
	import armies.data.ArmyData;
	import assets.AssetsEnum;
	import assets.FontManager;
	import gameWorld.maps.MapEditor;
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Color;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class Screen_ChooseMap extends ViewComponent 
	{
		private var oppChoser:ChooseOpponentsBar;
		private var _mapChoser:ChooseMapBar;
		private var okButn:Button;
		private var randomButn:Button;
		private var customButn:Button;
		private var backButn:Button;
		
		public function Screen_ChooseMap() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();

			oppChoser = addChild(new ChooseOpponentsBar()) as ChooseOpponentsBar;
			oppChoser.x = 30;
			oppChoser.y = 130;
			
			_mapChoser = addChild(new ChooseMapBar()) as ChooseMapBar;
			mapChoser.x = (stage.stageWidth - mapChoser.width) / 2;
			mapChoser.y = oppChoser.y;
			_mapChoser.addEventListener(ChooseMapBar.MAP_READY, mapReady);
			_mapChoser.addEventListener(ChooseMapBar.GENERATING_MAP, generatingMap);
			
			okButn = new Button(TopLevel.getAssets.getTexture(AssetsEnum.SCREEN_PICK_MAP_OK_BUTN));
			okButn.x = stage.stageWidth - (okButn.width + 30);
			okButn.y = mapChoser.y + mapChoser.height - okButn.height;
			okButn.addEventListener(Event.TRIGGERED, okClick);
			okButn.alphaWhenDisabled = .8;
			
			randomButn = new Button(TopLevel.getAssets.getTexture(AssetsEnum.SCREEN_PICK_MAP_RANDOM_BUTN));
			randomButn.x = okButn.x
			randomButn.y = mapChoser.y;
			randomButn.addEventListener(Event.TRIGGERED, randomClick);
			randomButn.alphaWhenDisabled = .8;
			
			customButn = new Button(TopLevel.getAssets.getTexture(AssetsEnum.SCREEN_PICK_MAP_CUSTEM_BUTN));
			customButn.x = okButn.x
			customButn.y = randomButn.y + randomButn.height + 15;
			customButn.addEventListener(Event.TRIGGERED, custemClick);
			customButn.alphaWhenDisabled = .8;
			
			
			this.addChild(okButn)
			this.addChild(randomButn)
			this.addChild(customButn)
			
			//LocalStorage.saveMap(map);
			this.disable = true;
		}
		
		private function backClick(e:Event):void 
		{
			
		}
		
		private function generatingMap(e:Event):void 
		{
			this.disable = true;
		}
		
		private function mapReady(e:Event):void 
		{
			this.disable = false;
		}
		
		private function set disable(value:Boolean):void
		{
			okButn.enabled = !value;
			randomButn.enabled = !value;
			customButn.enabled = !value;
		}
		
		public function activate():void
		{
			oppChoser.activate();
		}
		
		public function showMap():void 
		{
			mapChoser.setNewMap();
		}
		
		private function custemClick(e:Event):void 
		{
			//mapChoser.setNewMap();

			addChild(new MapEditor());
		}
		
		private function randomClick(e:Event):void 
		{
			mapChoser.setNewMap();
		}
		
		private function okClick(e:Event):void 
		{
			GamePlayManager.totalPlayersPlaying = oppChoser.choosens.length + 1;
			GamePlayManager.armiesPickedForPlaying = new Vector.<ArmyData>;
			
			Tracer.alert("ARMIES PICKDED ARR = " + oppChoser.choosens);
			for (var i:String in oppChoser.choosens) 
			{
				GamePlayManager.armiesPickedForPlaying.push(ConfigurationData.armiesData.armies[oppChoser.choosens[i]]);
			}
			
			//GameApp.game.world.map = mapChoser.map;
			GameApp.game.world.setMap(mapChoser.map);
			//mapChoser.scaleMapUp();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		override public function dispose():void 
		{
			oppChoser.removeFromParent(true);
			mapChoser.removeFromParent(true);
			super.dispose();
		}
		
		public function get mapChoser():ChooseMapBar 
		{
			return _mapChoser;
		}
		
	}

}