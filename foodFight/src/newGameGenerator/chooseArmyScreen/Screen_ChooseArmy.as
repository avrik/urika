package newGameGenerator.chooseArmyScreen 
{
	import assets.AssetsEnum;
	import globals.MainGlobals;
	import starling.display.Button;
	import starling.display.MovieClip;
	import starling.events.Event;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class Screen_ChooseArmy extends ViewComponent 
	{
		private var _pickButns:Vector.<Button>
		private var _lastPicked:Button;
		
		private var infoBar:PickArmyInfoBar
		private var assetsMC:MovieClip;
		
		public function Screen_ChooseArmy() 
		{
			_pickButns = new Vector.<Button>;
		}
		
		override protected function init():void 
		{
			super.init();
			
			assetsMC = new MovieClip(MainGlobals.assetsManger.getTextureAtlas(AssetsEnum.SCREEN_ARMY_PICK_ASSETS).getTextures());
			infoBar = new PickArmyInfoBar(assetsMC);
			
			addChild(infoBar)

			var pickBarSprite:PickArmyBar = new PickArmyBar(assetsMC)
			pickBarSprite.addEventListener(Event.SELECT, pickClick);
			this.addChild(pickBarSprite);
			
			pickBarSprite.x = 20;
			pickBarSprite.y = 130;
			
			infoBar.x = 20;// (stage.stageWidth - info.width) / 2;
			infoBar.y = pickBarSprite.y + pickBarSprite.height + 10;
			
			var okButn:Button = new Button(MainGlobals.assetsManger.getTexture(AssetsEnum.SCREEN_PICK_OK_BUTN));
			okButn.x = infoBar.x + infoBar.width - (okButn.width + 70);
			okButn.y = infoBar.y + (infoBar.height - okButn.height) / 2;
			okButn.addEventListener(Event.TRIGGERED, okClick);
			this.addChild(okButn);
		}

		private function pickClick(e:Event):void 
		{
			var pickBarSprite:PickArmyBar = e.currentTarget as PickArmyBar;
			infoBar.setArmyNum(pickBarSprite.lastPicked.id);
		}
		
		private function okClick(e:Event):void 
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}

}