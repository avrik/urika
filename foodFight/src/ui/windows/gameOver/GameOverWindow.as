package ui.windows.gameOver 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class GameOverWindow extends ViewComponent 
	{
		private var _leaderBoardContainer:ScrollContainer;
		private var _rows:Vector.<LeaderBoardRow>;
		
		public function GameOverWindow() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			var img:Image = addChild(new Image(TopLevel.assets.getTexture(AssetsEnum.GAME_OVER_WINDOW_BASE))) as Image;
			
			_leaderBoardContainer = new ScrollContainer();
			
			this.addChild(_leaderBoardContainer)
			
			_leaderBoardContainer.x = 10;
			_leaderBoardContainer.y = 115;
			_leaderBoardContainer.width = img.width;
			_leaderBoardContainer.height = img.height - 225;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			//layout.verticalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			//layout.paddingTop = 40;
			layout.gap = 5;
			//layout.paddingLeft = -70;

			_leaderBoardContainer.layout = layout;
			
			_rows = new Vector.<LeaderBoardRow>;
			
			for (var i:int = 0; i < GameApp.game.playersManager.playersArr.length; i++) 
			{
				var row:LeaderBoardRow = new LeaderBoardRow(i + 1, GameApp.game.playersManager.playersArr[i]);
				_leaderBoardContainer.addChild(row);
				row.y = i * (row.height + 5);
				_rows.push(row);
			}
			
			var okTF:TextField = new TextField(200, 100, "NEW GAME", FontManager.Badaboom, -2, 0xffffff);
			okTF.autoScale = true;
			okTF.hAlign = HAlign.CENTER;
			
			var okTFDown:TextField = new TextField(okTF.width, okTF.height, okTF.text, okTF.fontName, -1.5, okTF.color);
			okTFDown.autoScale = true;
			okTFDown.hAlign = HAlign.CENTER;
		
			var newGameButn:Button = new Button();
			newGameButn.defaultSkin = okTF;
			newGameButn.downSkin = okTFDown;
			newGameButn.x = (this.width -200) / 2;
			newGameButn.y = this.height - 100;
			newGameButn.addEventListener(Event.TRIGGERED, okClicked);

			addChild(newGameButn);
		}
		
		private function okClicked(e:Event):void 
		{
			//trace("CLICK");
			removeFromParent(true);
			//TopLevel.initNewGame();
			//GlobalEventManger.dispatchEvent(GlobalEventsEnum.NEW_GAME);
			GameApp.startNewGame();
		}
		
	}

}