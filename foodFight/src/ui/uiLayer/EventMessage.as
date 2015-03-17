package ui.uiLayer 
{

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class EventMessage extends ViewComponent 
	{
		private var txt:String;
		private var _color:uint;
		private var tween:Tween;
		
		public function EventMessage(txt:String,color:uint) 
		{
			this._color = color;
			this.txt = txt;
			
		}
		
		public function moveUp():void 
		{
			tween = new Tween(this, .5, Transitions.EASE_OUT);
			tween.moveTo(0, this.y - 15);
			
			Starling.juggler.add(tween);
			//this.y -= 20;
		}
		
		override protected function init():void 
		{
			super.init();
			
			var tf:TextField = new TextField(500, 50, txt, "Verdana", 16, this._color);
			tf.touchable = false;
			tf.hAlign = HAlign.RIGHT;
			tf.vAlign = VAlign.BOTTOM;
			tf.autoScale = true;
			
			addChild(tf);
		}
		
	}

}