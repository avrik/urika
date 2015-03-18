package ui.windows.gameOver 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import starling.display.Button;
	import players.Player;
	import starling.display.Image;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class LeaderBoardRow extends ViewComponent 
	{
		private var _player:Player;
		private var _index:int;
		
		public function LeaderBoardRow(index:int,player:Player) 
		{
			this._index = index;
			this._player = player;
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			addChild(new Image(TopLevel.getAssets.getTexture(AssetsEnum.GAME_OVER_WINDOW_ROW))) as Image;
			
			var placeTF:TextField = new TextField(150, this.height, _index.toString(), FontManager.Badaboom, -1, 0xffffff);
			placeTF.hAlign = HAlign.CENTER;
			addChild(placeTF);
			
			var nameTF:TextField = new TextField(150, this.height, this._player.army.armyData.name, FontManager.Badaboom, -1, 0xffffff);
			nameTF.x = 200;
			nameTF.hAlign = HAlign.CENTER;
			addChild(nameTF);
			
			var scoreTF:TextField = new TextField(150, this.height, this._player.score.toString(), FontManager.Badaboom, -1, 0xffffff);
			scoreTF.x = 500;
			scoreTF.hAlign = HAlign.CENTER;
			addChild(scoreTF);

			
			
		}
		
	}

}