package ui.uiLayer 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Rectangle;
	import gamePlay.Alliance;
	import players.Player;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.VAlign;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class AllianceRequestWindow extends ViewComponent 
	{
		static public const ACCEPT:String = "accept";
		static public const DECLINE:String = "decline";
		
		private var _closeButn:Button;
		private var _yesButn:Button;
		private var _noButn:Button;
		private var _answerTF:TextField;
		private var _playerRequest:Player;
		
		public function AllianceRequestWindow(playerRequest:Player) 
		{
			this._playerRequest = playerRequest;
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			var texture:Texture = TopLevel.getAssets.getTexture(AssetsEnum.SETTINGS_WINDOW_BASE);
			var rect:Rectangle = new Rectangle(50,50, texture.width-100, texture.height-100);
			
			var sale9Textures:Scale9Textures = new Scale9Textures(texture, rect);
			var img:Scale9Image = new Scale9Image(sale9Textures, TopLevel.getAssets.scaleFactor);
			
			addChild(img)
			
			var txt:String = "The " + _playerRequest.army.armyData.name + " army\nis requesting to establish an alliance with us\n\nwhat sould we do?";

			_answerTF = new TextField(this.width - 40, 350, txt , FontManager.Badaboom, -1, 0xffffff);
			_answerTF.vAlign = VAlign.TOP;
			_answerTF.x = 10;
			_answerTF.y = 20;
			
			
			addChild(_answerTF);
			
			img.width = _answerTF.bounds.left + _answerTF.bounds.right;
			img.height = 200;
			
			_closeButn = new Button(TopLevel.getAssets.getTexture(AssetsEnum.SETTINGS_WINDOW_CLOSE_BUTN));
			_yesButn = new Button(Texture.empty(100,64));
			_yesButn.text = "ACCEPT";
			_yesButn.fontColor = Color.LIME;
			_yesButn.fontName = FontManager.Badaboom;
			_yesButn.fontSize = -1;
			_yesButn.addEventListener(Event.TRIGGERED, yesButnClicked);
			_yesButn.x = 200;
			_yesButn.y = img.height - 60;
			
			_noButn = new Button(Texture.empty(100,64));
			_noButn.text = "DECLINE";
			_noButn.fontColor = Color.TEAL;
			_noButn.fontName = FontManager.Badaboom;
			_noButn.fontSize = -1;
			_noButn.addEventListener(Event.TRIGGERED, noButnClicked);
			_noButn.x = 300;
			_noButn.y = img.height - 60;
			
			addChild(_yesButn);
			addChild(_noButn);
			
			_closeButn.addEventListener(Event.TRIGGERED, closeButnClick);
			_closeButn.x = img.width - (_closeButn.width / 2+15);
			_closeButn.y = -_closeButn.height / 2 + 15;
			
			addChild(_closeButn);
			
			var charsMC:MovieClip = new MovieClip(TopLevel.getAssets.getTextureAtlas(AssetsEnum.CHARS_FRAME_SH).getTextures());
			var charImg:Image = new Image(charsMC.getFrameTexture(this._playerRequest.army.armyData.id-1));
			charImg.pivotX = charImg.width / 2-10;
			charImg.pivotY = charImg.height / 2-10;
			addChild(charImg);
		}
		
		private function noButnClicked(e:Event):void 
		{
			dispatchEvent(new Event(DECLINE));
			close();
		}
		
		private function yesButnClicked(e:Event):void 
		{
			dispatchEvent(new Event(ACCEPT));
			close();
		}
		
		private function closeButnClick(e:Event):void 
		{
			
			dispatchEvent(new Event(DECLINE));
			close();
		}
		
		private function close():void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		
	}

}