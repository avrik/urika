package gameWorld 
{
	import armies.ArmyUnit;
	import armies.ArmyUnitView;
	import armies.UnitStatusEnum;
	import flash.geom.Point;
	import gameWorld.territories.Territory;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class WorldActionLayer extends ViewComponent 
	{
		private var _actionObjects:Vector.<DisplayObject>;
		private var highDepthLevelPH:Sprite;
		private var lowDepthLevelPH:Sprite;
		
		private var _armyUnitViews:Vector.<ArmyUnitView>;
		private var _pickedUnitsForPoll:Vector.<ArmyUnitView>;
		
		public function WorldActionLayer() 
		{
			_actionObjects = new Vector.<DisplayObject>;
			_armyUnitViews = new Vector.<ArmyUnitView>;
			
			lowDepthLevelPH = new Sprite();
			highDepthLevelPH = new Sprite();
		}
		
		override protected function init():void 
		{
			super.init();
			
			addChild(lowDepthLevelPH);
			addChild(highDepthLevelPH);
			
			lowDepthLevelPH.stage.addEventListener(TouchEvent.TOUCH, onMapTouch);
		}
		
		private function onMapTouch(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(lowDepthLevelPH.stage);
			
			if (touch)
			{
				var point:Point = new Point(touch.globalX - MapView.MAP_OFFSET_POINT.x, touch.globalY - MapView.MAP_OFFSET_POINT.y);

				switch (touch.phase) 
				{
					case TouchPhase.MOVED:
						if (_pickedUnitsForPoll)
						{
							checkForUnitInteraction(point);
						}
						break;
						
					case TouchPhase.ENDED:
						trace("STOP TOUCH " + _pickedUnitsForPoll);
						if (readyForAttack)
						{
							trace("ATTACK!!!!!!!!!!!");
							//MainGameApp.getInstance.game.warManager.setBattle(_pickedUnitsForPoll[0].armyUnit, _pickedUnitsForPoll[_pickedUnitsForPoll.length - 1].armyUnit);
							//MainGameApp.getInstance.game.warManager.startWar();
							var attackUnits:Vector.<ArmyUnit> = new Vector.<ArmyUnit>
							
							for (var i:int = 0; i < (_pickedUnitsForPoll.length-1); i++) 
							{
								attackUnits.push(_pickedUnitsForPoll[i].armyUnit);
							}
							
							MainGameApp.getInstance.game.warManager.fight(attackUnits, _pickedUnitsForPoll[_pickedUnitsForPoll.length - 1].armyUnit);
							_pickedUnitsForPoll = null;
						} else
						{
							_pickedUnitsForPoll = null;
							markSelected();
						}
						
						break;
						
					case TouchPhase.BEGAN:
						trace("BEGAN TOUCH");
						checkForUnitInteraction(point, true);
						break;
				}
			}
		}
		
		private function checkForUnitInteraction(point:Point, firstInteraction:Boolean = false):void
		{		
			var isHuman:Boolean;
			
			for each (var item:ArmyUnitView in _armyUnitViews) 
			{
				if (item.bounds.contains(point.x,point.y))
				{
					if (!lastPickedUnit || lastPickedUnit.armyUnit.onTerritory.isNeighborOf(item.armyUnit.onTerritory))
					{
						isHuman = item.armyUnit.myArmy.myPlayer.isHuman;
						
						if (!firstInteraction || (firstInteraction && isHuman))
						{
							if (!_pickedUnitsForPoll) {
								_pickedUnitsForPoll = new Vector.<ArmyUnitView>;
							}
							
							if (_pickedUnitsForPoll.indexOf(item) == -1)
							{
								if (!lastPickedUnit || (lastPickedUnit && lastPickedUnit.armyUnit.myArmy.myPlayer.isHuman))
								{
									_pickedUnitsForPoll.push(item);
									markSelected();
								}
								
								break;
							} else
							{
								_pickedUnitsForPoll.splice(_pickedUnitsForPoll.indexOf(lastPickedUnit), 1);
								markSelected();
								break;
							}
						}
					}
				}
			}
		}
		
		private function get readyForAttack():Boolean
		{
			if (!lastPickedUnit) return false;
			return  (!lastPickedUnit.armyUnit.myArmy.myPlayer.isHuman)
		}
		
		private function get lastPickedUnit():ArmyUnitView
		{
			if (!_pickedUnitsForPoll || !_pickedUnitsForPoll.length) return null;
			return _pickedUnitsForPoll[_pickedUnitsForPoll.length - 1]
		}
		
		private function markSelected():void
		{
			for each (var item:ArmyUnitView in _armyUnitViews) 
			{
				item.armyUnit.status = UnitStatusEnum.IDLE
				if (!_pickedUnitsForPoll)
				{
					//item.armyUnit.status = UnitStatusEnum.IDLE
				} else
				{
					if (_pickedUnitsForPoll.indexOf(item) != -1)
					{
						item.armyUnit.status = UnitStatusEnum.SELECTED_FOR_ACTION
					} else
					{
						item.armyUnit.status = UnitStatusEnum.HIDE_FROM_ACTION
					}
				}
			}

			if (lastPickedUnit && lastPickedUnit.armyUnit.myArmy.myPlayer.isHuman)
			{
				
				for each (var ter:Territory in lastPickedUnit.armyUnit.onTerritory.neighborsArr) 
				{
					if (ter.armyUnit.status == UnitStatusEnum.HIDE_FROM_ACTION)
					{
						ter.armyUnit.status = UnitStatusEnum.READY_TO_BE_SELECTED
					}
				}
			}

		}
		
		
		
		
		
		
		
		public function addObject(obj:DisplayObject, x:Number = -1, y:Number = -1, depthLevel:int = 0,zSorting:Boolean=true):DisplayObject
		{
			if (depthLevel>0)
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
			//LoggerHandler.getInstance.info(this,"CHECK " + obj + " Y == " + obj.y);
			var length:int = _actionObjects.length;
			
			for (var i:int = 0; i < length; ++i) 
			{
				_actionObjects[i].parent.addChild(_actionObjects[i]);
			}
		}
		
		public function addArmyUnit(view:ArmyUnitView, x:Number, y:Number):void 
		{
			addObject(view, x, y);
			_armyUnitViews.push(view)
		}
		
	}

}