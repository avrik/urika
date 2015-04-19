package ui.uiLayer 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import feathers.core.PopUpManager;
	import globals.MainGlobals;
	import players.Player;
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import ui.ViewComponent;
	import ui.windows.settings.SettingsWindow;
	import ui.windows.store.StoreWindow;
	import urikatils.LoggerHandler;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class UILayer extends ViewComponent
	{
		private var _endTurnButn:Button;
		private var _settingsButn:Button;
		private var _coinButn:Button;
		private var _starsCollector:StarsCollector;
		private var _coinCollector:CoinsCollector;
		private var _infoRibbon:InfoRibbon;
		private var _playersInfoBar:PlayersRibbon;
		private var gameRibbonPH:Sprite;
		private var _disable:Boolean;
		private var _titleTF:TextField;
		private var _titleTween:Tween;
		private var settingsWindow:SettingsWindow;
		private var storeWindow:StoreWindow;
		private var _eventMessagesManager:EventMessagesManager;
		private var allianceRequestWindow:AllianceRequestWindow;
		private var hintTween:Tween;
		
		public function UILayer() 
		{
			
		}
		
		public function activate():void
		{
			_eventMessagesManager = new EventMessagesManager();
			addChild(_eventMessagesManager);
			
			
			gameRibbonPH = new Sprite()
			this.addChild(gameRibbonPH);
			
			gameRibbonPH.addChild(new Image(MainGlobals.assetsManger.getTexture(AssetsEnum.RIBBON_BASE))) as Image;
			
			_endTurnButn = new Button(MainGlobals.assetsManger.getTexture(AssetsEnum.END_TURN_BUTTON));
			
			_endTurnButn.addEventListener(Event.TRIGGERED, endRoundClick);
			
			_endTurnButn.pivotX = _endTurnButn.width / 2;
			_endTurnButn.pivotY = _endTurnButn.height / 2;
			_endTurnButn.x = stage.stageWidth - (_endTurnButn.width/2 + 10);
			_endTurnButn.y = (gameRibbonPH.height - _endTurnButn.height / 2) / 2 + 15;
			_endTurnButn.alphaWhenDisabled = .2;
			gameRibbonPH.addChild(_endTurnButn);
			
			_playersInfoBar = gameRibbonPH.addChild(new PlayersRibbon()) as PlayersRibbon;
			_playersInfoBar.x = 50;
			_playersInfoBar.y = 20;// (gameRibbonPH.height - _playersInfoBar.height) / 2
			gameRibbonPH.y = stage.stageHeight - 100;
			
			_infoRibbon = this.addChild(new InfoRibbon()) as InfoRibbon;
			
			_settingsButn = new Button(MainGlobals.assetsManger.getTexture(AssetsEnum.SETTINGS_BUTTON));
			_settingsButn.addEventListener(Event.TRIGGERED, settingsClick);
			this.addChild(_settingsButn);
			_settingsButn.y = 40;
			
			/*_coinButn = new Button(TopLevel.assets.getTexture(AssetsEnum.COIN_BUTTON));
			this.addChild(_coinButn);
			_coinButn.x = stage.stageWidth - _coinButn.width;
			_coinButn.y = _settingsButn.y;*/
			
			
			_coinCollector = new CoinsCollector();
			_coinCollector.addEventListener(Event.TRIGGERED, storeButnClicked);
			addChild(_coinCollector);
			_coinCollector.x = stage.stageWidth;// - _starsCollector.width / 2;
			_coinCollector.y = 140;
			
			_starsCollector = new StarsCollector();
			addChild(_starsCollector);
			_starsCollector.x = stage.stageWidth;// - _starsCollector.width / 2;
			_starsCollector.y = _coinCollector.y + _coinCollector.height;
			
			_titleTF = new TextField(stage.stageWidth, 100, "", FontManager.Badaboom, -2, 0xffff00);
			_titleTF.autoScale = true;
			_titleTF.y = 50;
			_titleTF.touchable = false;
			
			
			_eventMessagesManager.x = this.stage.stageWidth - _eventMessagesManager.width;
			_eventMessagesManager.y = gameRibbonPH.y - _eventMessagesManager.height;
		}
		
		public function addTitle(str:String,removeAfter:Number=0):void 
		{
			_titleTF.text = str;
			_titleTF.alpha = 0;
			this.addChild(_titleTF);
			
			_titleTween = new Tween(_titleTF, .8, Transitions.EASE_OUT);
			_titleTween.fadeTo(1);
			
			Starling.juggler.add(_titleTween);
			
			if (removeAfter)
			{
				Starling.juggler.add(new DelayedCall(removeTitle, removeAfter));
			}
		}
		
		public function removeTitle():void
		{
			_titleTween = new Tween(_titleTF, .5, Transitions.EASE_IN);
			_titleTween.fadeTo(0);
			_titleTween.onComplete = function():void
			{
				Starling.juggler.remove(_titleTween);
				_titleTF.removeFromParent();
			}
			
			Starling.juggler.add(_titleTween);
		}
		
		public function openAllianceRequestWindow(player:Player):AllianceRequestWindow 
		{
			allianceRequestWindow = new AllianceRequestWindow(player);
			allianceRequestWindow.addEventListener(Event.CLOSE, allianceRequestWindowClosed);
			PopUpManager.addPopUp(allianceRequestWindow);
			
			return allianceRequestWindow;
		}
		
		public function hintTheEndButn():void 
		{
			hintTween = new Tween(_endTurnButn, .5, Transitions.EASE_IN_OUT);
			hintTween.scaleTo(1.05);
			hintTween.reverse = true;
			hintTween.repeatCount = int.MAX_VALUE;
			
			Starling.juggler.add(hintTween)
		}
	
		private function allianceRequestWindowClosed(e:Event):void 
		{
			LoggerHandler.getInstance.info(this,"WHAT HE FUCKKK 2222!!!");
			
			removeAllianceRequestWindow()
		}
		
		private function removeAllianceRequestWindow():void 
		{
			PopUpManager.removePopUp(allianceRequestWindow);
			allianceRequestWindow.removeEventListeners();
			allianceRequestWindow.removeFromParent(true);
		}
		
		
		private function storeButnClicked(e:Event):void 
		{
			this.openStoreWindow();
		}
		
		private function openStoreWindow():void 
		{
			storeWindow = new StoreWindow();
			storeWindow.addEventListener(Event.CLOSE, storeClosed);
			PopUpManager.addPopUp(storeWindow);
		}
		
		private function storeClosed(e:Event):void 
		{
			removeStoreWindow()
		}
		
		private function removeStoreWindow():void
		{
			PopUpManager.removePopUp(storeWindow);
			storeWindow.removeEventListeners();
			storeWindow.removeFromParent(true);
		}
		
		private function settingsClick(e:Event):void 
		{
			this.openSettingsWindow();
		}
		
		private function openSettingsWindow():void 
		{
			settingsWindow = new SettingsWindow();
			settingsWindow.addEventListener(Event.CLOSE, settingsClosed);
			PopUpManager.addPopUp(settingsWindow);
		}
		
		private function settingsClosed(e:Event):void 
		{
			removeSettingsWindow()
		}
		
		private function removeSettingsWindow():void
		{
			PopUpManager.removePopUp(settingsWindow);
			settingsWindow.removeEventListeners();
			settingsWindow.removeFromParent(true);
		}
		
		/*private function storeClick(e:Event):void 
		{
			//WindowManger.openStore();
		}*/
		
		private function endRoundClick(e:Event):void 
		{
			
			GlobalEventManger.dispatchEvent(GlobalEventsEnum.END_ROUND_CLICKED);
		}
		
		public function set disable(value:Boolean):void 
		{
			_disable = value;
			//_endTurnButn.touchable = !value;
			if (_endTurnButn)
			{
				_endTurnButn.enabled = !value;
				_playersInfoBar.touchable = !value;
			}
			
			if (hintTween && value)
			{
				Starling.juggler.remove(hintTween);
				_endTurnButn.scaleX = _endTurnButn.scaleY = 1;
				hintTween = null;
			}
			//_storeButn.disable = value;
			//newGameButn.disable = value;
		}
		
		/*static public function get tileInfoBar():TileInfoBar 
		{
			return _tileInfoBar;
		}
		
		static public function get playerInfoBar():PlayerInfoBar 
		{
			return _playerInfoBar;
		}*/
		
		public function get playersInfoBar():PlayersRibbon 
		{
			return _playersInfoBar;
		}
		
		public function get infoRibbon():InfoRibbon 
		{
			return _infoRibbon;
		}
		
		public function get starsCollector():StarsCollector 
		{
			return _starsCollector;
		}
		
		public function get coinCollector():CoinsCollector 
		{
			return _coinCollector;
		}
		
		public function get eventMessagesManager():EventMessagesManager 
		{
			return _eventMessagesManager;
		}
		
		
		
	}

}