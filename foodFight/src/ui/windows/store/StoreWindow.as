package ui.windows.store 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import feathers.controls.ScrollContainer;
	import feathers.display.Scale9Image;
	import feathers.layout.HorizontalLayout;
	import feathers.textures.Scale9Textures;
	import flash.geom.Rectangle;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.Color;
	import ui.ViewComponent;
	import ui.windows.store.data.StoreData;
	import ui.windows.store.data.StoreData_Item;
	import utils.events.GlobalEvent;
	import utils.events.GlobalEventManger;
	import utils.events.GlobalEventsEnum;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class StoreWindow extends ViewComponent
	{
		private var _storeItems:Vector.<StoreItem>
		private var _closeButn:Button;
		private var _container:ScrollContainer;
		private var _itemsPH:Sprite;
		private var _categories:Vector.<StoreCategory>;
		private var _onCategory:StoreCategory;
		private var _itemPicked:StoreItem;
		private var _descriptionTF:TextField;
		
		
		public function StoreWindow() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();

			//var bgImg:Image = addChild(new Image(TopLevel.assets.getTexture(AssetsEnum.SETTINGS_WINDOW_BASE))) as Image;
			
			var texture:Texture = TopLevel.getAssets.getTexture(AssetsEnum.SETTINGS_WINDOW_BASE);
			var rect:Rectangle = new Rectangle(50, 50, texture.width - 100, texture.height - 100);
			
			var sale9Textures:Scale9Textures = new Scale9Textures(texture, rect);
			var img:Scale9Image = new Scale9Image(sale9Textures, TopLevel.getAssets.scaleFactor);
			
			addChild(img)
			
			
			var titleTF:TextField = new TextField(this.width - 20, 50, "Bakery", FontManager.Badaboom, -1, 0xffff00);
			titleTF.x = 10;
			titleTF.y = 10;
			addChild(titleTF);
			
			_closeButn = new Button(TopLevel.getAssets.getTexture(AssetsEnum.SETTINGS_WINDOW_CLOSE_BUTN));
			
			_closeButn.addEventListener(Event.TRIGGERED, closeButnClick);
			_closeButn.x = img.width - (_closeButn.width / 2 + 15);
			_closeButn.y = -_closeButn.height / 2 + 15;
			
			_container = new ScrollContainer();
			addChild(_container);
			
			_container.x = 10;
			_container.y = 150;
			_container.width = img.width - 20;
			_container.height = 200;
			
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.horizontalAlign = HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			//layout.paddingTop = 74;
			layout.paddingLeft = 10;
			//layout.paddingRight = -20;

			_container.layout = layout;
			
			this.initCategories();
			this.showCategory();
			
			addChild(_closeButn);
			
			_descriptionTF = new TextField(this.width, 100, "", FontManager.Badaboom, -1, Color.WHITE);
			_descriptionTF.touchable = false;
			_descriptionTF.y = _container.y + _container.height;
			addChild(_descriptionTF);
			
			img.height = this.height-50;
		}
		
		
		
		private function initCategories():void 
		{
			_categories = new Vector.<StoreCategory>;
			var length:int = ConfigurationData.storeData.categories.length;
			
			var cat:StoreCategory;
			for (var i:int = 0; i < length; ++i) 
			{
				cat = new StoreCategory(i, ConfigurationData.storeData.categories[i]);
				cat.addEventListener(Event.TRIGGERED, catClicked);
				addChild(cat);
				
				_categories.push(cat);
			}
		}
		
		private function catClicked(e:Event):void 
		{
			var cat:StoreCategory = e.currentTarget as StoreCategory;
			if (this._onCategory != cat)
			{
				showCategory(cat);
			}
			
		}
		
		private function showCategory(cat:StoreCategory = null):void
		{
			this._onCategory = cat?cat:_categories[0];
			
			var id:int = this._onCategory.id;
			if (_itemsPH)
			{
				_itemsPH.removeFromParent(true);
				
			}
			_itemsPH = new Sprite();
			_container.addChild(_itemsPH);
			
			var length:int = ConfigurationData.storeData.categories[id].items.length;
			var item:StoreItem;
			_storeItems = new Vector.<StoreItem>;
			
			
			for (var i:int = 0; i < length; ++i) 
			{
				item = new StoreItem(ConfigurationData.storeData.categories[id].items[i]);
				item.addEventListener(Event.SELECT, itemSelected);
				item.addEventListener(StoreItem.BUY_CLICK, buyItemClick);
				
				_itemsPH.addChild(item);
				item.x = 0 + i * (item.width+10);
				
				_storeItems.push(item);
			}
			
			_container.horizontalScrollPosition = 0;
		}
		
		private function buyItemClick(e:Event):void 
		{
			_itemPicked = e.currentTarget as StoreItem;
			GlobalEventManger.dispatchEvent(GlobalEventsEnum.BUY_ITEM, _itemPicked.itemData);
			close();
		}
		
		private function itemSelected(e:Event):void 
		{
			_itemPicked = e.currentTarget as StoreItem;
			
			//close();
			showDescription(_itemPicked.itemData)
		}
		
		private function showDescription(itemData:StoreData_Item):void
		{
			_descriptionTF.text = itemData.description;
		}
		
		
		private function closeButnClick(e:Event):void 
		{
			close();
			
		}
		
		private function close():void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		
		
	}

}