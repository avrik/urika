package ui 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class Tooltip extends Sprite 
	{
		private var _timeout:uint;
		private var _parentMC:MovieClip
		private var _txt:String;
		private var _tf:TextField;
		private var mc:MovieClip;
		
		public function Tooltip(txt:String) 
		{
			this._txt = txt;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void 
		{
			_parentMC = MovieClip(parent);
			_parentMC.addEventListener(MouseEvent.MOUSE_OUT, parentOut);
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this._timeout = setTimeout(show, 300);
		}
		
		private function parentOut(e:MouseEvent):void 
		{
			//destroy()
		}
		
		private function show():void 
		{
			mc = new MovieClip();
			mc.graphics.beginFill(0x99FFCC);
			mc.graphics.drawRect(0, 0, 300, 100);
			mc.graphics.endFill();
			
			this._tf = new TextField();
			this._tf.text = this._txt;
			mc.addChild(this._tf);
		}
		
		private function destroy():void
		{
			_parentMC.removeEventListener(MouseEvent.MOUSE_OUT, parentOut);
			clearTimeout(this._timeout);
			this.parent.removeChild(this);
		}
		
	}

}