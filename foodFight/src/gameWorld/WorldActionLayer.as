package gameWorld 
{
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import ui.ViewComponent;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class WorldActionLayer extends ViewComponent 
	{
		private var _actionObjects:Vector.<DisplayObject>;
		private var butn:Button;
		private var highDepthLevelPH:Sprite;
		private var lowDepthLevelPH:Sprite;
		//private var _touchPad:Quad;
		
		public function WorldActionLayer() 
		{
			_actionObjects = new Vector.<DisplayObject>;
			
			lowDepthLevelPH = new Sprite();
			highDepthLevelPH = new Sprite();
		}
		
		override protected function init():void 
		{
			super.init();
			
			//_touchPad = new Quad(stage.stageWidth, stage.stageHeight, 0);
			//_touchPad.alpha = 0;
			//_touchPad.addEventListener(Event.TRIGGERED, padClicked);
			butn = new Button(Texture.empty(stage.stageWidth, stage.stageHeight));
			butn.addEventListener(Event.TRIGGERED, padClicked);
			
			this.addEventListener(TransformGestureEvent.GESTURE_ZOOM , onZoom);
			addChild(butn);
			addChild(lowDepthLevelPH);
			addChild(highDepthLevelPH);
			//addEventListener(Event.ENTER_FRAME, chk);
		}
		
		private function onZoom(e:TransformGestureEvent):void 
		{
			this.alpha = .2;
		}
		
		private function padClicked(e:Event):void 
		{
			GlobalEventManger.dispatchEvent(GlobalEventsEnum.ACTION_LAYER_CLICKED);
		}
		
		public function addObject(obj:DisplayObject, x:Number = -1, y:Number = -1, depthLevel:int = 0,zSorting:Boolean=true):DisplayObject
		{
			if (depthLevel)
			{
				this.highDepthLevelPH.addChild(obj);
			} else
			{
				this.lowDepthLevelPH.addChild(obj);
			}
			obj.x = x != -1?x:obj.x;
			obj.y = y != -1?y:obj.y;
			
			if (zSorting)
			{
				_actionObjects.push(obj);
				updateDepths();
			}
			
			return obj;
		}
		
		public function getObjectGlobalCord(obj:DisplayObject):Point
		{
			return new Point(obj.x-obj.parent.x-obj.parent.parent.x-obj.parent.parent.parent.x,obj.y-obj.parent.y-obj.parent.parent.y-obj.parent.parent.parent.y)
		}
		
		private function sortByY(a:DisplayObject,b:DisplayObject):Number 
		{
			if (a.y > b.y)
			{
				return -1;
			} else if (a.y < b.y)
			{
				return 1;
			} else
			{
				return 0;
			}
		}
		
		public function removeObject(obj:DisplayObject):void
		{
			obj.removeFromParent(true);
			
			if (_actionObjects.indexOf(obj) != -1)
			{
				_actionObjects.splice(_actionObjects.indexOf(obj), 1);
			}
			
		}
		
		override public function dispose():void 
		{
			var length:int = _actionObjects.length;
			for (var i:int = 0; i < length; ++i) 
			{
				_actionObjects[i].removeFromParent(true);
			}
			super.dispose();
		}
		
		public function bringObjectToFrontOf(objToFront:DisplayObject, objToBack:DisplayObject=null):void 
		{
			if (objToBack == null)
			{
				var index:int = objToFront.parent.getChildIndex(objToFront);
				
				objToFront.parent.addChild(_actionObjects[index]);
				_actionObjects.splice(index, 1);
				return
			}
			
			var index1:int = objToFront.parent.getChildIndex(objToFront);
			var index2:int = objToBack.parent.getChildIndex(objToBack);
			
			objToFront.parent.setChildIndex(objToFront, index2);
			objToBack.parent.setChildIndex(objToBack, index1);
		}
		
		public function updateDepths():void 
		{
			_actionObjects.sort(sortByY)
			
			_actionObjects = _actionObjects.reverse();
			//Tracer.alert("CHECK " + obj + " Y == " + obj.y);
			var length:int = _actionObjects.length;
			
			for (var i:int = 0; i < length; ++i) 
			{
				_actionObjects[i].parent.addChild(_actionObjects[i]);
			}
		}
		
	}

}