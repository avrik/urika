package ui.uiLayer 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Rectangle;
	import gamePlay.Alliance;
	import globals.MainGlobals;
	import players.Player;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class AllianceRequestAnswerWindow extends ViewComponent 
	{
		private var _closeButn:Button;
		private var _answerTF:TextField;
		private var _accept:Boolean;
		private var _playerRequest:Player;
		private var _playerAnswer:Player;
		
		public function AllianceRequestAnswerWindow(accept:Boolean, playerRequest:Player, playerAnswer:Player)
		{
			this._playerAnswer = playerAnswer;
			this._playerRequest = playerRequest;
			this._accept = accept;
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			var texture:Texture = MainGlobals.assetsManger.getTexture(AssetsEnum.SETTINGS_WINDOW_BASE);
			var rect:Rectangle = new Rectangle(50,50, texture.width-100, texture.height-100);
			
			var sale9Textures:Scale9Textures = new Scale9Textures(texture, rect);
			var img:Scale9Image = new Scale9Image(sale9Textures, MainGlobals.assetsManger.scaleFactor);
			
			addChild(img)
			
			var txt:String = this._accept?"Request accepted":"Request denied";
			if (this._accept)
			{
				txt += "\n\n" + _playerRequest.army.armyData.name + " & " + _playerAnswer.army.armyData.name + " are now allies.";
				txt += "\n" + "this non attack Agreement will be valid\nfor the next " + Alliance.validForTurns + " turns";
			}
			
			_answerTF = new TextField(this.width - 40, 350, txt , FontManager.Badaboom, -1, 0xffffff);
			_answerTF.vAlign = VAlign.TOP;
			_answerTF.x = 10;
			_answerTF.y = 20;
			
			addChild(_answerTF);
			
			img.width = _answerTF.bounds.left + _answerTF.bounds.right;
			img.height = 200;
			
			_closeButn = new Button(MainGlobals.assetsManger.getTexture(AssetsEnum.SETTINGS_WINDOW_CLOSE_BUTN));
			
			_closeButn.addEventListener(Event.TRIGGERED, closeButnClick);
			_closeButn.x = img.width - (_closeButn.width / 2+15);
			_closeButn.y = -_closeButn.height / 2 + 15;
			
			addChild(_closeButn);
			
			var charsMC:MovieClip = new MovieClip(MainGlobals.assetsManger.getTextureAtlas(AssetsEnum.CHARS_FRAME_SH).getTextures());
			var charImg:Image = new Image(charsMC.getFrameTexture(this._playerAnswer.army.armyData.id-1));
			charImg.pivotX = charImg.width / 2-10;
			charImg.pivotY = charImg.height / 2-10;
			addChild(charImg);
		}
		
		private function closeButnClick(e:Event):void 
		{
			close();
			
		}
		
		private function close():void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
	}

}