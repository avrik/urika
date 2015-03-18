package  
{
	import feathers.core.PopUpManager;
	import starling.events.Event;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class AppHud extends ViewComponent 
	{
		//private var _newGameButn:Button;
		//private var butnsMC:MovieClip;
		//private var tween:Tween;
		private var _startWindow:StartWindow;
		
		public function AppHud() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();

			_startWindow = new StartWindow();
			_startWindow.addEventListener(Event.TRIGGERED, newGameClick);
			_startWindow.addEventListener(StartWindow.REMOVED, removeWindow);
			
			PopUpManager.addPopUp(_startWindow)
			
			_startWindow.show("Tap to start");
		}
		
		private function removeWindow(e:Event):void 
		{
			PopUpManager.removePopUp(_startWindow);
			Application.startNewGame();
		}
		
		private function newGameClick(e:Event):void 
		{
			//PopUpManager.removePopUp(_startWindow)
			_startWindow.remove();
			
		}
		
		public function showNewGameButn():void
		{
			Application.newGame();
			
			PopUpManager.addPopUp(_startWindow);
			_startWindow.show("Time's up!\nTry Again");
		}
	}

}