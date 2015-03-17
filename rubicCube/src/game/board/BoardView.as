package game.board 
{
	import feathers.controls.ScrollContainer;
	import feathers.layout.HorizontalLayout;
	import feathers.layout.VerticalLayout;
	import flash.events.TransformGestureEvent;
	import flash.geom.Rectangle;
	import game.board.boxes.BoxView;
	import mvc.View;
	import starling.display.Sprite;
	import urikatils.LoggerHandler;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class BoardView extends View 
	{
		private var _currentContainer:ScrollContainer;
		
		public function BoardView() 
		{
			super();
			
		}
		
		override public function init():void 
		{
			super.init();
		}
		
		public function show():void 
		{
			
		}
		

		public function placeBoxes(boxViewArr:Vector.<BoxView>):void 
		{
			/*_currentContainer = new ScrollContainer();

			var layout:HorizontalLayout = new HorizontalLayout();

			layout.useVirtualLayout = true;
			layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			
			this.addChild(_currentContainer);
			
			_currentContainer.width = (BoxView.WIDTH+2)*9;
			_currentContainer.height = (BoxView.HEIGHT+2)*6;
			
			_currentContainer.layout = layout;*/
				
			var _itemsMC:Sprite = new Sprite();
			for each (var item:BoxView in boxViewArr) 
			{
				//_currentContainer.addChild(item);
				//_itemsMC.addChild(item);
				this.addChild(item);
				//item.setLocation(item.x 
			}
			//_currentContainer.addChild(_itemsMC);
			
			
			this.clipRect = new Rectangle(0, 0, (BoxView.WIDTH + 2) * (BoxesManager.BOXES_IN_ROW-1), (BoxView.HEIGHT + 2) * BoxesManager.BOXES_IN_COLUMN);
		}
		
	}

}