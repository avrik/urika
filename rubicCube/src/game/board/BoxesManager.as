package game.board 
{
	import game.board.boxes.BoxController;
	import game.board.boxes.BoxModel;
	import game.board.boxes.BoxView;
	import game.board.events.BoxTouchEvent;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.TouchEvent;
	import starling.utils.Color;
	import urikatils.LoggerHandler;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class BoxesManager extends EventDispatcher
	{
		static public const BOXES_IN_ROW_SIGHT:int = 9;
		static public const BOXES_IN_ROW:int = 11;
		static public const BOXES_IN_COLUMN_SIGHT:int = 6;
		static public const BOXES_IN_COLUMN:int = 6;
		
		private static var colors:Array = [Color.BLUE, Color.GREEN, Color.YELLOW, Color.RED, Color.WHITE, Color.PURPLE];
		
		private var _boxArr:Vector.<BoxController> 
		private var _boxViewArr:Vector.<BoxView>
		private var _boxesLocationArr:Array;
		
		public function BoxesManager() 
		{
			
		}
		
		public function arangeBoxes():void
		{
			_boxArr = new Vector.<BoxController>;
			_boxViewArr = new Vector.<BoxView>;
			var boxModel:BoxModel;
			var myColor:uint;
			var boxController:BoxController;
			var boxView:BoxView;
			
			_boxesLocationArr = new Array();
			for (var q:int = 0; q < BOXES_IN_ROW; q++) 
			{
				_boxesLocationArr[q] = new Array();
				for (var w:int = 0; w <BOXES_IN_COLUMN ; w++) 
				{
					var num:int= q% 9;
					if ( w < 3)
					{
						myColor = colors[Math.floor(num / 3)];
					} else
					{
						myColor = colors[Math.floor(num / 3)+3]
					}
					
					boxModel = new BoxModel(q, w, myColor);
					boxView = new BoxView(boxModel);
					boxView.setLocation(boxModel.xStartPos * (BoxView.WIDTH + 2), boxModel.yStartPos * (BoxView.HEIGHT + 2));
					//boxView.addEventListener(TouchEvent.TOUCH, boxTouch);
					boxView.addEventListener(Event.TRIGGERED, boxClicked);
					boxController = new BoxController(boxView, boxModel);
					
					_boxArr.push(boxController);
					_boxViewArr.push(boxView);
					
					_boxesLocationArr[q][w] = boxController;
				}
				
			}
		}
		
		
		
		public function getBoxesOnRow(num:int):Vector.<BoxController> 
		{
			var arr:Vector.<BoxController> = new Vector.<BoxController>;
			for (var i:int = 0; i <BOXES_IN_ROW ; i++) 
			{
				arr.push(_boxesLocationArr[i][num]);
			}
			
			return arr;
		}
		
		private function boxClicked(e:Event):void 
		{
			var box:BoxView = e.currentTarget as BoxView;
			LoggerHandler.getInstance.info(this, "boxClicked " + box.model.xPos);
			
			moveRow(box.model.yPos);
		}
		
		private function moveRow(num:int):void 
		{
			var arr:Vector.<BoxController> = getBoxesOnRow(num);

			for each (var item:BoxController in arr) 
			{
				var b:BoxController;
				 
				if (item.model.yPos % 2)
				{
					if (item.model.xPos == 0)
					{
						b = getBoxByXY((BOXES_IN_ROW-1), item.model.yPos)
						b.model.color = item.model.color;
						b.view.draw();
					}
					item.view.addEventListener(BoxView.BOX_MOVE_LEFT_COMPLETE, boxMoveLeftComplete);
					item.view.slideLeft();
				} else
				{
					
					if (item.model.xPos == (BOXES_IN_ROW-1))
					{
						b = getBoxByXY(0, item.model.yPos)
						b.model.color = item.model.color;
						b.view.draw();
					}
					
					item.view.addEventListener(BoxView.BOX_MOVE_RIGHT_COMPLETE, boxMoveRightComplete);
					item.view.slideRight();
				}
				
				
			}
			
		}
		
		private function boxMoveRightComplete(e:Event):void 
		{
			var boxView:BoxView = e.currentTarget as BoxView;
			boxView.removeEventListener(BoxView.BOX_MOVE_RIGHT_COMPLETE, boxesMoveComplete);
			
			if (boxView.model.xPos > (BOXES_IN_ROW-1))
			{
				boxView.setLocation(0 * (BoxView.WIDTH + 2), boxView.y);
				boxView.model.xPos = 0;
			}
		}
		
		
		private function boxMoveLeftComplete(e:Event):void 
		{
			var boxView:BoxView = e.currentTarget as BoxView;
			boxView.removeEventListener(BoxView.BOX_MOVE_LEFT_COMPLETE, boxesMoveComplete);

			if (boxView.model.xPos < 0)
			{
				boxView.setLocation(boxView.x + ((BOXES_IN_ROW) * (BoxView.WIDTH + 2)), boxView.y);
				boxView.model.xPos = BOXES_IN_ROW-1;
			}
			
			
		}
		
		private function boxesMoveComplete(e:Event):void 
		{
			var boxView:BoxView = e.currentTarget as BoxView;
			boxView.removeEventListener(BoxView.BOX_MOVE_COMPLETE, boxesMoveComplete);
			
			var box1:BoxController = getBoxByXY(1, boxView.model.yPos);
			box1.view.setLocation(box1.view.x+(1) * (BoxView.WIDTH + 2), box1.view.y+2);
			box1.model.xPos = BOXES_IN_ROW;
		}
		
		private function getBoxByXY(xpos:int,ypos:int):BoxController 
		{
			for each (var item:BoxController in _boxArr) 
			{
				if (item.model.xPos == xpos && item.model.yPos == ypos) return item;
			}
			
			return null;
		}
		
		
		private function boxTouch(e:TouchEvent):void 
		{
			var box:BoxView = e.currentTarget as BoxView;
			
			LoggerHandler.getInstance.info(this,"BOX touch "+box.model.xPos);
			dispatchEvent(new BoxTouchEvent(BoxTouchEvent.BOX_TOUCHED,box))
		}
		
		public function get boxArr():Vector.<BoxController> 
		{
			return _boxArr;
		}
		
		public function get boxViewArr():Vector.<BoxView> 
		{
			return _boxViewArr;
		}
		
	}

}