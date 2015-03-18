package ui.windows.store 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Rectangle;
	import starling.display.Button;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.VAlign;
	import ui.ViewComponent;
	import ui.windows.store.data.StoreData_Item;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class StoreItem extends ViewComponent
	{
		static public const BUY_CLICK:String = "buyClick";
		private var _itemData:StoreData_Item;
		private var pickButn:Button;
		private var buyButn:Button;
		//private var _uiDisplay:MovieClip;
		
		public function StoreItem(itemData:StoreData_Item) 
		{
			this._itemData = itemData;
			
		}
		
		override protected function init():void 
		{
			super.init();

			var texture:Texture = TopLevel.getAssets.getTexture(AssetsEnum.SETTINGS_WINDOW_BASE);
			var rect:Rectangle = new Rectangle(50,50, texture.width-100, texture.height-100);
			
			var sale9Textures:Scale9Textures = new Scale9Textures(texture, rect);
			var img:Scale9Image = new Scale9Image(sale9Textures, TopLevel.getAssets.scaleFactor);
			img.touchable = false;
			
			addChild(img);
			
			img.width = 150;
			img.height = 200;
			
			pickButn = new Button(Texture.empty(img.width, img.height));
			pickButn.addEventListener(Event.TRIGGERED, itemClicked);
			
			buyButn = new Button(Texture.empty(img.width, 50));
			buyButn.addEventListener(Event.TRIGGERED, itemBuyClick);
			buyButn.fontName = FontManager.Badaboom;
			buyButn.fontSize = -1;
			buyButn.fontColor = Color.YELLOW;
			buyButn.text = "buy";
			buyButn.y = img.height -60;
			buyButn.enabled = GameApp.game.playersManager.userPlayer.coinsAmount >= _itemData.price?true:false;
			
			img.color = Color.WHITE;
			
			
			
			
			var tf:TextField = new TextField(this.width - 10, 100, this.itemData.name, FontManager.Badaboom, -1, Color.WHITE);
			//tf.autoScale = true;
			tf.touchable = false;
			tf.vAlign = VAlign.TOP;
			tf.y = 20;
			tf.x = 5;
			addChild(tf);
			
			var tf2:TextField = new TextField(this.width, 50, "price : " + this.itemData.price, FontManager.Badaboom, -1, Color.YELLOW);
			tf2.touchable = false;
			tf2.y = 90;
			addChild(tf2);
			
			addChild(pickButn);
			addChild(buyButn);
		}
		
		private function itemClicked(e:Event):void 
		{
			dispatchEvent(new Event(Event.SELECT));
			
		}
		
		private function itemBuyClick(e:Event):void 
		{
			dispatchEvent(new Event(BUY_CLICK));
			
		}
		
		public function get itemData():StoreData_Item 
		{
			return _itemData;
		}
		
	}

}