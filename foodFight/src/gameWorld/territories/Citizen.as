package gameWorld.territories 
{
	import armies.data.ArmyData;
	import gameWorld.territories.Territory;
	import gameWorld.Tile;
	import interfaces.IDisposable;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Citizen extends EventDispatcher implements IDisposable
	{
		static public const PATROL_COMPLETE:String = "patrolComplete";
		private var _disable:Boolean;
		private var _view:CitizenView;
		private var _inBase:Boolean = true;
		private var _onTerritory:Territory;
		private var _onPatrol:Boolean;
		
		public function Citizen(onTerritory:Territory) 
		{
			this._onTerritory = onTerritory;
			_view = new CitizenView(this);
		}
		
		/* INTERFACE interfaces.IDisposable */
		
		public function dispose():void 
		{
			if (_onPatrol)
			{
				completePatrol()
			}
			if (_view)
			{
				//_view.removeFromParent(true);
				_view.removeEventListeners();
				GameApp.game.world.actionLayer.removeObject(_view);
				_view = null;
			}
			this.removeEventListeners();
		}
		
		public function move(x:Number, y:Number):void 
		{
			_view.x = x;
			_view.y = y;
		}
		
		public function stopPatrol():void 
		{
			_onPatrol = false;
			_view.stopPatrol();
		}
		
		public function startPatrol(tilesToPatrol:Vector.<Tile>):void 
		{
			_inBase = true;
			_onPatrol = true;
			_view.startPatrol(tilesToPatrol);
		}
		
		public function completePatrol():void
		{
			_onPatrol = false;
			dispatchEvent(new Event(PATROL_COMPLETE));
		}
		
		public function backToBase():void
		{
			if (!_inBase)
			{
				_inBase = true;
				_view.returnToBase();
			}
			
		}
		
		public function get view():CitizenView 
		{
			return _view;
		}
		
		public function talk(str:String):void
		{
			view.showTalkBaloon(str)
		}
		
		
		public function set disable(value:Boolean):void 
		{
			if (_disable == value) return;
			_disable = value;
			
			if (value)
			{
				_view.stopPatrol();
			} else
			{
				_view.continuePatrol();
			}
		}
		
		public function set inBase(value:Boolean):void 
		{
			_inBase = value;
		}
		
		public function get armyData():ArmyData 
		{
			return this._onTerritory.owner.armyData;
		}
		
		public function get inBase():Boolean 
		{
			return _inBase;
		}
		
		public function get onTerritory():Territory 
		{
			return _onTerritory;
		}
		
	}

}