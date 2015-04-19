package newGameGenerator 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import globals.MainGlobals;
	import newGameGenerator.chooseArmyScreen.Screen_ChooseArmy;
	import newGameGenerator.chooseMapScreen.Screen_ChooseMap;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Color;
	import ui.ViewComponent;
	/**
	 * ...
	 * @author ...
	 */
	public class NewGameGenerator extends ViewComponent
	{
		private var chooseMap	:Sprite;
		private var chooseArmy	:Sprite;
		private var _titleImg	:Image;
		private var assetsMC	:MovieClip;
		private var backButn	:Button;
		private var _header		:Sprite;
		
		public function NewGameGenerator() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			addChild(new Image(MainGlobals.assetsManger.getTexture(AssetsEnum.SCREEN_PICK_ARMY_BG))) as Image;
			
			assetsMC = new MovieClip(MainGlobals.assetsManger.getTextureAtlas(AssetsEnum.SCREEN_ARMY_PICK_ASSETS).getTextures());
			_titleImg = new Image(assetsMC.getFrameTexture(21))
			_header = new Sprite();
			
			_titleImg.touchable = false
			
			backButn = new Button(Texture.empty(100,64));
			backButn.text = "Back";
			backButn.fontSize = -1;
			backButn.fontName = FontManager.Badaboom;
			backButn.fontColor = Color.GRAY;
			
			backButn.text = "Back";
			backButn.x = this.stage.stageWidth - (backButn.width + 10);
			backButn.y = 20;
			backButn.addEventListener(Event.TRIGGERED, backClick);
			backButn.alphaWhenDisabled = .8;
			
			this.gotToArmyPickScreen();
			
			_header.addChild(_titleImg);
			addChild(_header);
			_header.x = -10;
			_header.y = -10;
			_header.addChild(backButn);
		}
		
		private function backClick(e:Event):void 
		{
			gotBackToArmyPickScreen()
		}
		
		private function gotBackToArmyPickScreen():void 
		{
			gotToArmyPickScreen();
			animateScreenOut(chooseMap, backToArmyScreenComplete, true);
			chooseArmy.x = -stage.stageWidth;
			
			var tween:Tween = new Tween(chooseArmy, .5, Transitions.EASE_IN_OUT);
			tween.moveTo(0, 0);
			tween.onComplete = function():void
			{
				Starling.juggler.remove(tween);
			}
			Starling.juggler.add(tween);
		}
		
		private function backToArmyScreenComplete():void 
		{
			chooseMap.removeEventListeners();
			chooseMap.removeFromParent(true);
		}
		
		private function gotToArmyPickScreen():void 
		{
			backButn.visible = false;

			chooseArmy = addChild(new Screen_ChooseArmy()) as Sprite;
			chooseArmy.addEventListener(Event.COMPLETE, armyPicked);
			_titleImg.texture = assetsMC.getFrameTexture(21);
		}
		
		private function mapPicked(e:Event):void 
		{
			//animateScreenOut(chooseMap, mapPickComplete);
			mapPickComplete();
		}
		
		private function armyPicked(e:Event):void 
		{
			chooseMap = addChild(new Screen_ChooseMap()) as Sprite;
			chooseMap.addEventListener(Event.COMPLETE, mapPicked);
			chooseMap.x = stage.stageWidth;
			
			animateScreenOut(chooseArmy, armyPickComplete);
			_titleImg.texture = assetsMC.getFrameTexture(22);
			
			var tween:Tween = new Tween(chooseMap, .5, Transitions.EASE_IN_OUT);
			tween.moveTo(0, 0);
			tween.onComplete = function():void
			{
				Starling.juggler.remove(tween);
				Screen_ChooseMap(chooseMap).showMap();
				backButn.visible = true;
				
			}
			Screen_ChooseMap(chooseMap).activate();
			Starling.juggler.add(tween);
		}
		
		private function animateScreenOut(screen:Sprite,onCompleteFunc:Function,back:Boolean=false):void
		{
			var tween:Tween = new Tween(screen, .5, Transitions.EASE_IN_OUT);
			tween.moveTo(back?stage.stageWidth: -stage.stageWidth, 0);
			tween.onComplete = function():void
			{
				Starling.juggler.remove(tween);
				onCompleteFunc();
			}
			Starling.juggler.add(tween);
		}
		
		private function armyPickComplete():void 
		{
			chooseArmy.removeEventListeners();
			chooseArmy.removeFromParent(true);
		}
		
		private function mapPickComplete():void 
		{
			chooseMap.removeEventListeners();
			chooseMap.removeFromParent(true);
			
			dispatchEvent(new Event(Event.COMPLETE));
			this.removeFromParent(true);
		}
		
	}

}