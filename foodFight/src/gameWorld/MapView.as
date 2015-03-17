package gameWorld 
{
	import assets.AssetsEnum;
	import gameWorld.territories.TerritoryView;
	import starling.display.Image;
	import starling.display.Sprite;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */

	public class MapView extends ViewComponent
	{
		private var _landPH:Sprite;
		
		public function MapView()
		{
			addChild(new Image(TopLevel.assets.getTexture(AssetsEnum.MAP_BG))) as Image;
			_landPH = addChild(new Sprite()) as Sprite;
		}
		
		override protected function init():void 
		{
			//_landPH.x = (this.stage.stageWidth - _landPH.width) / 2 - 25;
			_landPH.x = 120;
			_landPH.y = 95;
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