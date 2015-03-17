package  
{
	import starling.display.Sprite;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class GameView extends ViewComponent 
	{
		public var topLayerPH:Sprite;
		public var gamePlayPH:Sprite;
		
		public function GameView() 
		{
			gamePlayPH = addChild(new Sprite()) as Sprite;
			topLayerPH = addChild(new Sprite()) as Sprite;
		}
		
		override protected function init():void 
		{
			super.init();
			
			
		}
		
	}

}