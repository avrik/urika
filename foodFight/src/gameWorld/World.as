package gameWorld 
{
	import armies.ArmyUnit;
	import flash.geom.Point;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	import interfaces.IDisposable;
	import interfaces.IStorable;
	import storedGameData.ISavedData;
	import storedGameData.SavedGameData_World;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	/**
	 * ...
	 * @author Avrik
	 */
	public class World implements IDisposable,IStorable
	{
		private var _map			:Map;
		private var _actionLayer	:WorldActionLayer;
		private var _view			:WorldView;
		
		public function World() 
		{
			_view = new WorldView();
			
			GlobalEventManger.addEvent(GlobalEventsEnum.ACTION_LAYER_CLICKED, actionLayerClicked);
		}
		
		public function setMap(map:Map):void 
		{
			_map = map;
			
			_map.view.scaleX = map.view.scaleY = 1;
			_map.view.x = map.view.y = 0;
			
			_actionLayer = new WorldActionLayer();
			//_actionLayer.scaleX =_actionLayer.scaleY = _map.view.scaleX;

			Tracer.alert("SET NEW MAP!!");
		}
		
		public function activate():void
		{
			_view.addChild(_map.view);
			_view.addChild(actionLayer);
			
			_map.activate();
			actionLayer.x = _map.view.landPH.x;
			actionLayer.y = _map.view.landPH.y;
		}
		
		private function actionLayerClicked():void 
		{
			if (this.view.zoomFactor != 1)
			{
				this.view.zoomOut();
				this.map.clearTerritoriesFocus();
				//GameApp.game.unitsController.clearPicked();
			}
		}
		
		
		public function getDataTranslateObject():XMLNode 
		{
			var worldNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "world");
			
			worldNode.appendChild(map.getDataTranslateObject())
			
			return worldNode;
		}
		
		public function translateBackFromData(data:ISavedData):void 
		{
			var translateData:SavedGameData_World = data as SavedGameData_World;

			var map:Map = new Map();
			map.translateBackFromData(translateData.mapData)
			setMap(map);
		}
			
		/* INTERFACE interfaces.IDisposable */
		
		public function dispose():void 
		{
			if (map)
			{
				_map.dispose();
				_map = null;
			}
		}
		
		public function get map():Map 
		{
			return _map;
		}
		
		public function get view():WorldView 
		{
			return _view;
		}
		
		public function get actionLayer():WorldActionLayer 
		{
			return _actionLayer;
		}
		
	}

}