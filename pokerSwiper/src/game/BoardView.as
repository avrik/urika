package game 
{
	import starling.display.Graphics;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class BoardView extends ViewComponent 
	{
		
		public function BoardView() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			var g:Graphics = new Graphics(this);
			g.beginFill(0xff0000);
			g.drawRoundRect(0, 0, 400, 400, 10);
			g.endFill();
			
			//this.x = (stage.stageWidth - this.width) / 2;
			//this.y = (stage.stageHeight - this.height) / 2;
			
		}
		
	}

}