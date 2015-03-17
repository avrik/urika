package debug 
{
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.getTimer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class DebugInfoWindow extends ViewComponent 
	{
		private var frames:int;
		private var prevTimer:Number;
		private var curTimer:Number;
		private var _TF:TextField;
		private var fpsStr:String;
		
		public function DebugInfoWindow() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			frames=0;
			prevTimer=0;
			curTimer = 0;
			fpsStr = "";
			_TF = new TextField(200, 50, "", "Arial", 12, 0xffffff);
			_TF.hAlign = HAlign.RIGHT;
			_TF.x = stage.stageWidth - 200;
			_TF.y = -15
			addChild(_TF);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			dispInfo();
		}
		
		private function dispInfo(e:Event=null):void {

			frames += 1;
			curTimer = getTimer();

			
			if (curTimer - prevTimer >= 1000) {

				fpsStr = "FPS: " + String(Math.round(frames * 1000 / (curTimer - prevTimer)));
				prevTimer = curTimer;
				frames = 0;
			}
			 
			var memStr:String = "MEM :" + String(Math.round(1000 * System.totalMemory / 1048576) / 1000);
			//trace("MEM in MB:" + String(Math.round(1000 * System.totalMemory / 1048576) / 1000));
			
			_TF.text = fpsStr +" | " + memStr;
		}
		
	}

}