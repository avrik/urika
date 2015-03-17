package game.board 
{
	import feathers.controls.ScrollContainer;
	import flash.events.TransformGestureEvent;
	import game.board.boxes.BoxController;
	import game.board.boxes.BoxView;
	import game.board.events.BoxTouchEvent;
	import mvc.Controller;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class BoardController extends Controller 
	{
		private var _boardView:BoardView;
		private var _boxesManager:BoxesManager;
		private var _currentContainer:ScrollContainer;
		private var _currentBoxTouched:BoxView;
		
		public function BoardController(boardView:BoardView) 
		{
			super();
			this._boardView = boardView;
			
		}
		
		public function init():void 
		{
			this._boxesManager = new BoxesManager();
			this._boxesManager.addEventListener(BoxTouchEvent.BOX_TOUCHED, boxTouched);
			this._boxesManager.arangeBoxes();
			
			this._boardView.placeBoxes(this._boxesManager.boxViewArr);
			
		}
		
		private function boxTouched(e:BoxTouchEvent):void 
		{
			if (_currentBoxTouched != e.boxView)
			{
				_currentBoxTouched = e.boxView;
				
				//_currentBoxTouched.addEventListener(TransformGestureEvent.GESTURE_SWIPE, boxSwiped);
				//_currentContainer = new ScrollContainer();
				//_currentContainer.setSize(3000, BoxView.WIDTH);
				//_currentContainer.y = e.boxView.y;
				var boxesInRow:Vector.<BoxController> = this._boxesManager.getBoxesOnRow(e.boxView.model.yPos);
				//trace("AAA == " + boxesInRow);
				var boxesMC:Sprite = new Sprite();
				for each (var item:BoxController in boxesInRow) 
				{
					/*if (item)
					{
						boxesMC.addChild(item.view);
					}*/
				}
				//_boardView.addChild(boxesMC);
				/*_currentContainer.addChild(boxesMC);
				var layout:HorizontalLayout = new HorizontalLayout();
				
				
				layout.useVirtualLayout = true;
				layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;

				_currentContainer.width = (BoxView.WIDTH + 2) * 9;
				_currentContainer.height = (BoxView.HEIGHT + 2);
			
				_currentContainer.layout = layout;

				_boardView.addChild(_currentContainer);*/
				
			}
		}
		
		private function boxSwiped(e:TransformGestureEvent):void 
		{
			trace("222");
			var box:BoxView = e.currentTarget as BoxView;
			var tween:Tween = new Tween(box, .5, Transitions.EASE_OUT);
			tween.moveTo(box.x - (BoxView.WIDTH + 2),box.y);
			Starling.juggler.add(tween);
		}
		
	}

}