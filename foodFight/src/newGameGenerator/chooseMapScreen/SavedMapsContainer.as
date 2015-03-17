package newGameGenerator.chooseMapScreen 
{
	import feathers.controls.ScrollContainer;
	import feathers.layout.HorizontalLayout;
	import gameWorld.maps.data.MapsData;
	import starling.events.Event;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class SavedMapsContainer extends ViewComponent 
	{
		private var container:ScrollContainer;
		private var _thumbs:Vector.<MapThumb>
		private var _selected:MapThumb;
		
		public function SavedMapsContainer() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			_thumbs = new Vector.<MapThumb>;
			container = new ScrollContainer();
			
			this.addChild(container)
			
			container.x = 14;
			
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			//layout.paddingTop = 74;
			//layout.paddingLeft = -70;

			container.layout = layout;
			
			var mapThumb:MapThumb;
			var len:int = MapsData.mapsDataArr.length;
			for (var i:int = 0; i <len ; ++i) 
			{
				mapThumb = new MapThumb(i);
				mapThumb.addEventListener(Event.SELECT, thumbSelected);
				
				container.addChild(mapThumb);
				mapThumb.x = i * mapThumb.width;
				_thumbs.push(mapThumb);
			}
			
			container.width = 502;
			container.height = mapThumb.height;
		}
		
		private function thumbSelected(e:Event):void 
		{
			this._selected = e.currentTarget as MapThumb;
		}
		
		public function get selected():MapThumb 
		{
			return _selected;
		}
		
	}

}