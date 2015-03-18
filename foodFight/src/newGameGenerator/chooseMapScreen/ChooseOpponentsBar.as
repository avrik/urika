package newGameGenerator.chooseMapScreen 
{
	import ascb.util.ArrayUtilities;
	import assets.AssetsEnum;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class ChooseOpponentsBar extends ViewComponent 
	{
		private var _choosens:Vector.<int> = new Vector.<int>;
		private var _container:ScrollContainer;
		private var _tabs:Vector.<ChooseOppItem>
		
		public function ChooseOpponentsBar() 
		{
			
		}
		
		public function activate():void
		{
			var assetsMC:MovieClip = new MovieClip(TopLevel.getAssets.getTextureAtlas(AssetsEnum.SCREEN_MAP_PICK_ASSETS).getTextures());

			this._container = new ScrollContainer();
			
			_tabs = new Vector.<ChooseOppItem>();
			
			var from:int = GamePlayManager.userArmyNum == 0?1:0;
			var to:int = GamePlayManager.userArmyNum == 5?5:6;
			
			var oppArr:Array = new Array();
			for (var i:int = from; i < to; i++) 
			{
				if (i == GamePlayManager.userArmyNum)
				{
					i ++;
				}
				//var id:int = i

				oppArr.push(i);
				/*oppArr.push(id);
				var tab:ChooseOppItem = new ChooseOppItem(id);
				tab.addEventListener(Event.SELECT, tabSelected);

				this._container.addChild(tab);
				_tabs.push(tab);*/
			}
			
			oppArr = ArrayUtilities.randomize(oppArr);

			var chooseItem:ChooseOppItem;
			for (var k:int = 0; k < oppArr.length; ++k) 
			{	
				chooseItem = new ChooseOppItem(oppArr[k]);
				chooseItem.addEventListener(Event.SELECT, tabSelected);

				this._container.addChild(chooseItem);
				_tabs.push(chooseItem);
			}
			
			addChild(this._container);
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.useVirtualLayout = true;
			layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT;
			layout.paddingTop = 15;
			layout.paddingBottom = 20;
			layout.paddingRight = -250;
			layout.gap = -15;

			//layout.typicalItemWidth = 0;
			
			this._container.layout = layout;
			this._container.width = 350;// _tabs[0].width;
			this._container.height = 420;
			
			var topSkin:Image = new Image(assetsMC.getFrameTexture(0));
			topSkin.touchable = false;
			addChild(topSkin);
			
			this._container.x = -5;
			this._container.y = 50;

			var length:int = _tabs.length;
			for (var j:int = 1; j <length  ; j++)
			{
				_tabs[j].choosen = true;
				_choosens.push(_tabs[j].id);
			}
		}
		
		private function tabSelected(e:Event):void 
		{
			var tab:ChooseOppItem = e.currentTarget as ChooseOppItem;
			
			if (!tab.choosen)
			{
				tab.choosen = true;
				_choosens.push(tab.id);
			} else 
			{
				if (_choosens.length > 1)
				{
					tab.choosen = false;
					_choosens.splice(_choosens.indexOf(tab.id), 1);
				}
				
			}
		}
		
		public function get choosens():Vector.<int> 
		{
			return _choosens;
		}

	}
}