package gameWorld 
{
	import assets.AssetsEnum;
	import flash.geom.Point;
	import gameWorld.territories.TerritoryView;
	import globals.MainGlobals;
	import starling.display.Image;
	import starling.display.Sprite;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */

	public class MapView extends ViewComponent
	{
		public static const MAP_OFFSET_POINT:Point = new Point(120, 95);
		private var _landPH:Sprite;
		
		public function MapView()
		{
			addChild(new Image(MainGlobals.assetsManger.getTexture(AssetsEnum.MAP_BG))) as Image;
			_landPH = addChild(new Sprite()) as Sprite;
		}
		
		override protected function init():void 
		{
			//_landPH.x = (this.stage.stageWidth - _landPH.width) / 2 - 25;
			_landPH.x = MAP_OFFSET_POINT.x;
			_landPH.y = MAP_OFFSET_POINT.y;
		}

		public function addTile(view:TileView):void 
		{
			_landPH.addChild(view);
		}
		
		public function addTerritory(view:TerritoryView):void 
		{
			_landPH.addChild(view);
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
		
		public function get landPH():Sprite 
		{
			return _landPH;
		}
		
		
		
		
	}

}