package gameWorld 
{
	import assets.AssetsEnum;
	import globals.MainGlobals;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class TileView extends ViewComponent 
	{
		private static var bordersMC:MovieClip;
		
		private var _tileImg:Image;
		private var _myColor:uint;
		private var _tilesMC:MovieClip;
		private var borderSprite:Sprite;
		
		private var bordersArr:Vector.<Image>;
		public var tileWidth:Number;
		public var tileHeight:Number;
		private var _showBorders:Boolean;
		private var _empty:Boolean;
		private var _ownerId:int;
		
		public function TileView() 
		{
			this._tilesMC = new MovieClip(MainGlobals.assetsManger.getTextureAtlas(AssetsEnum.TILES_SS).getTextures());
			//this._tileImg = this.addChild(new Image(TopLevel.assets.getTexture(AssetsEnum.TILE))) as Image;
			this._tileImg = this.addChild(new Image(this._tilesMC.getFrameTexture(0))) as Image;
			this._tileImg.scaleX = this._tileImg.scaleY = .5;
			tileWidth = this._tileImg.width;
			tileHeight = this._tileImg.height;

			//this.addEventListener(TouchEvent.TOUCH, onTileTouch);
		}
		
		/*private function onTileTouch(e:TouchEvent):void 
		{
			trace("FFF");
		}*/
		
		override protected function init():void 
		{
			super.init();
			
			centerPivot();
		}
		
		public function setAsInTerritory():void 
		{
			if (!bordersMC)
			{
				bordersMC = new MovieClip(MainGlobals.assetsManger.getTextureAtlas(AssetsEnum.TILE_BORDER_SH).getTextures());
			}
			
			borderSprite = new Sprite();
			//borderSprite.touchable = false;
			
			bordersArr = new Vector.<Image>;
			
			var img:Image;
			for (var i:int = 0; i < 6; ++i) 
			{
				img = new Image(bordersMC.getFrameTexture(i));
				//img.touchable = false;
				img.visible = false;
				bordersArr.push(img);
				borderSprite.addChild(img) as Image;
			}
			//borderSprite.flatten();

		}
		
		public function setEmpty():void 
		{
			//this.unflatten();
			this._empty = true;
			//this._tileImg.texture = TopLevel.assets.getTexture(AssetsEnum.TILE_EMPTY);
			this._tileImg.texture = this._tilesMC.getFrameTexture(1)
			this._tileImg.alpha = .2;
			
			//this.flatten();
		}
		
		public function setUnEmpty():void 
		{
			this._empty = false;
			//this.unflatten();
			this._tileImg.texture = this._tilesMC.getFrameTexture(0)
			this._tileImg.alpha = 1;
			
			//this.flatten();
		}
		
		public function setOwner(id:int, withCoin:Boolean = false):void
		{
			this._ownerId = id;
			this.unflatten();
			var num:int = id + 1;
			//var num:int = withCoin?id + 7:id + 1;
			this._tileImg.texture = this._tilesMC.getFrameTexture(num);
			this.flatten();
			
		}
		
		public function set myColor(value:uint):void
		{
			_myColor = value;
			_tileImg.color = value;
		}
		
		public function get tileImg():Image 
		{
			return _tileImg;
		}
		
		public function set showBorders(value:Boolean):void 
		{
			_showBorders = value;
			borderSprite.visible = value;
		}
		
		public function get empty():Boolean 
		{
			return _empty;
		}
		
		public function setBorders(arr:Vector.<int>, friendsArr:Vector.<int> = null):void
		{
			this.unflatten();
			//borderSprite.unflatten();
			addChild(borderSprite);
			
			for (var i:int = 0; i < 6; ++i) 
			{

				if (arr.indexOf(i) != -1)
				{
					bordersArr[i].visible = true;
				}  else
				{
					bordersArr[i].visible = false;
				}
				
				//bordersArr[i].alpha = .999;

			}
			//borderSprite.flatten();
			//this.flatten();
		}
		
		override public function dispose():void 
		{
			if (borderSprite)
			{
				borderSprite.removeFromParent(true);
			}
			
			super.dispose();
		}
		
		public function addCoinImage():void 
		{
			/*var img:Image = new Image(TopLevel.assets.getTexture(AssetsEnum.COIN));
			//addChild(img);
			
			img.pivotX = img.width / 2;
			img.pivotY = img.height / 2;
			img.x = this._tileImg.width / 2;
			img.y = this._tileImg.height / 2;
			
			img.scaleX = img.scaleY = .3;*/
			//img.smoothing = TextureSmoothing.BILINEAR;
			
			//this._tileImg.texture = this._tilesMC.getFrameTexture(_ownerId + 7);
		}
		
		
		
		
		
	}

}