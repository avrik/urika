package newGameGenerator.chooseMapScreen 
{
	import ascb.util.NumberUtilities;
	import assets.AssetsEnum;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class ChooseOppItem extends ViewComponent 
	{
		private var _id:int;
		//private var _assetsMC:MovieClip;
		private var charImg:Image;
		private var textImage:Image;
		private var _choosen:Boolean;
		//private var bgImage:Image;
		private var butn:Button;
		private var assetsMC:MovieClip;
		
		public function ChooseOppItem(id:int) 
		{
			//this._assetsMC = assetsMC;
			this._id = id;
		}
		
		override protected function init():void 
		{
			super.init();

			assetsMC = new MovieClip(TopLevel.assets.getTextureAtlas(AssetsEnum.SCREEN_OPP_PICK_ASSETS).getTextures());

			//bgImage = addChild(new Image(_assetsMC.getFrameTexture(1))) as Image;
			butn = new Button(assetsMC.getFrameTexture(0));
			butn.addEventListener(Event.TRIGGERED, clicked);
			butn.scaleWhenDown = 1;
			addChild(butn);

			var charMC:MovieClip = new MovieClip(TopLevel.assets.getTextureAtlas(AssetsEnum.CHARS_SH).getTextures());
			
			charImg = this.addChild(new Image(charMC.getFrameTexture(_id))) as Image;
			charImg.x = 10;
			charImg.y = 0;
			charImg.scaleX = charImg.scaleY = .8;
			charImg.touchable = false;
			
			textImage = this.addChild(new Image(assetsMC.getFrameTexture(2 + _id))) as Image;
			textImage.touchable = false;
			textImage.x = 100;
			//textImage.y = 2;
			
			//Tracer.alert("AAAAAAAAAAAAAA === " + butn.height);
		}
		
		private function clicked(e:Event):void 
		{
			//this.choosen = !this.choosen;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function get choosen():Boolean 
		{
			return _choosen;
		}
		
		public function set choosen(value:Boolean):void 
		{
			_choosen = value;
			var texture:Texture = assetsMC.getFrameTexture(value?1:0);
			butn.upState = texture;
			butn.downState = texture;
			
			//dispatchEvent(new Event(Event.SELECT));
		}
		
		public function get id():int 
		{
			return _id;
		}
		
	}

}