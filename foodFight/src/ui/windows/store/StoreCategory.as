package ui.windows.store 
{
	import assets.FontManager;
	import starling.display.Button;
	import starling.events.Event;
	import starling.textures.Texture;
	import ui.ViewComponent;
	import ui.windows.store.data.StoreData_Category;
	/**
	 * ...
	 * @author Avrik
	 */
	public class StoreCategory extends ViewComponent
	{
		private var _data:StoreData_Category;
		private var _id:int;
		private var catButton:Button;
		
		public function StoreCategory(id:int,data:StoreData_Category) 
		{
			this._id = id;
			this._data = data;
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			catButton = new Button(Texture.empty(150,150));
			catButton.text = _data.name;
			catButton.fontColor = 0xffff00;
			catButton.fontName = FontManager.Badaboom;
			catButton.fontSize = -1;
			catButton.x = 10 + this._id  * 150;
			catButton.y = 60;
			//catButton.addEventListener(Event.TRIGGERED, catClicked);
			
			addChild(catButton);
		}
		
		/*private function catClicked(e:Event):void 
		{
			
		}*/
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}