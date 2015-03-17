package newGameGenerator.chooseMapScreen 
{
	import assets.FontManager;
	import gameWorld.maps.data.MapsData;
	import starling.display.Button;
	import starling.display.Graphics;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import storedGameData.SavedGameData_Territory;
	import storedGameData.SavedGameData_Tile;
	import ui.ViewComponent;
	
	/**
	 * ...   
	 * @author Avrik
	 */
	
	public class MapThumb extends ViewComponent 
	{
		private var _id:int;
		
		public function MapThumb(id:int) 
		{
			this._id = id;
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			var g:Graphics = new Graphics(this)
			g.lineStyle(1, 0);
			g.beginFill(Color.BLUE);
			g.drawRect(0, 0, 120, 70);
			g.endFill();

			var sprite:Sprite = new Sprite();
			sprite.touchable = false;
			
			addChild(sprite);

			var tf:TextField = new TextField(this.width, 50, this._id.toString(), FontManager.Badaboom, -1,0xffff00);
			tf.text = MapsData.mapsDataArr[this._id].name;
			sprite.addChild(tf);
			/*var shape:Graphics = new Graphics(sprite);
			
			var size:int = 4;
			
			for each (var item:SavedGameData_Territory in MapsData.mapsDataArr[this._id].territoriesData.territories) 
			{
				for each (var tileItem:SavedGameData_Tile in item.tiles) 
				{
					
					shape.beginFill(0xffff00);
					shape.drawRect(tileItem.xpos * size, tileItem.ypos * size, size, size);
					shape.endFill();
				}
			}

			sprite.x = (this.width-sprite.width) / 2;
			sprite.y = (this.height-sprite.height) / 2;*/

			var butn:Button = new Button(Texture.empty(this.width, this.height));
			butn.addEventListener(Event.TRIGGERED, clicked);
			addChild(butn);
			
			
		}
		
		private function clicked(e:Event):void 
		{
			dispatchEvent(new Event(Event.SELECT, true));
		}
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}