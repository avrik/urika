package ui 
{
	import assets.FontManager;
	import starling.display.Quad;
	import starling.text.TextField;
	/**
	 * ...
	 * @author Avrik
	 */
	public class ScreenMessage extends ViewComponent 
	{
		private var _txt:String;
		private var messageBox:Quad;
		private var _tf:TextField;
		
		public function ScreenMessage(txt:String, messageParams:MessageParams) 
		{
			this._txt = txt;
			
			_tf = new TextField(500,100, txt, FontManager.BubbleGum, messageParams.fontSize, messageParams.fontColor);
			_tf.pivotX = _tf.width >> 1;
			_tf.pivotY = _tf.height >> 1;
			
			messageBox = new Quad(_tf.textBounds.width + 30, _tf.textBounds.height + 5, messageParams.bgColor);
			//messageBox.x = _tf.textBounds.left - 25;
			//messageBox.y = _tf.textBounds.top - 2;
			messageBox.pivotX = messageBox.width >> 1;
			messageBox.pivotY = messageBox.height >> 1;

			//addChild(messageBox);
			
			
			addChild(_tf);
			this.touchable = false;
			//centerPivot();
		}
		
		override protected function init():void 
		{
			super.init();
		}
		
	}

}