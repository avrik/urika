package ui.windows.settings 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import flash.events.MouseEvent;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class SettingsWindow extends ViewComponent 
	{
		private var _closeButn		:Button;
		
		private var _newGameButn	:Button;
		private var _restartGameButn:Button;
		private var _quitButn		:Button;
		
		public function SettingsWindow() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			var bgImg:Image = addChild(new Image(TopLevel.getAssets.getTexture(AssetsEnum.SETTINGS_WINDOW_BASE))) as Image;
			
			_closeButn = new Button(TopLevel.getAssets.getTexture(AssetsEnum.SETTINGS_WINDOW_CLOSE_BUTN));
			
			_closeButn.addEventListener(Event.TRIGGERED, closeButnClick);
			_closeButn.x = bgImg.width - (_closeButn.width / 2+15);
			_closeButn.y = -_closeButn.height / 2+15;
			
			addChild(_closeButn)

			_newGameButn = addTextButn("NEW GAME", 30, newGameButnClick);
			_restartGameButn = addTextButn("RESTART GAME", 130, restartGameClick);
			_quitButn = addTextButn("QUIT", 230, quitButnClick);
		}
		
		private function addTextButn(txt:String, y:Number, func:Function):Button
		{
			//var butnTF:TextField = new TextField(this.width, 100, txt, FontManager.Badaboom, -2, 0xfffc00);
			//butnTF.autoScale = true;
			//butnTF.touchable = false;

			var butn:Button = new Button(Texture.empty(this.width, 100),txt);
			butn.fontName = FontManager.Badaboom;
			butn.fontSize = -2;
			butn.fontColor = 0xfffc00;
			butn.addEventListener(Event.TRIGGERED, func);
			//butn.addChild(butnTF);
			butn.y = y;
			
			addChild(butn);
			
			return butn;
		}
		
		private function quitButnClick(e:Event):void 
		{
			GameApp.quit();
		}
		
		private function newGameButnClick(e:Event):void 
		{
			close();
			GameApp.startNewGame();
		}
		
		private function restartGameClick(e:Event):void 
		{
			GameApp.restartGame();
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