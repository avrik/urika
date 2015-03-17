package newGameGenerator.chooseArmyScreen 
{
	import assets.AssetsEnum;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class PickArmyButton extends ViewComponent 
	{
		static public const QUICK_START:String = "quickStart";
		private var _assetsMC:MovieClip;
		private var _id:int;
		private var butn:Button;
		private var _picked:Boolean;
		private var num:int;
		private var textImage:Image;
		private var charImg:Image;
		private var content:Sprite;
		//private var _clickAgainTF:TextField;
		
		public function PickArmyButton(id:int,assetsMC:MovieClip) 
		{
			this._id = id;
			this._assetsMC = assetsMC;
		}
		
		override protected function init():void 
		{
			super.init();
			
			content = addChild(new Sprite()) as Sprite;
			switch (_id)
			{
				case 0:
					num = 2;
					break;
				case 5:
					num = 4;
					break;
				default:
					num = 3;
			}
			
			var texture:Texture = _assetsMC.getFrameTexture(num);
			butn = new Button(texture);
			butn.scaleWhenDown = 1;
			content.addChild(butn);
			butn.addEventListener(Event.TRIGGERED, butnClicked);
			
			var charMC:MovieClip = new MovieClip(TopLevel.assets.getTextureAtlas(AssetsEnum.CHARS_SH).getTextures());
			charImg = content.addChild(new Image(charMC.getFrameTexture(_id))) as Image;
			
			charImg.pivotX = 50;
			charImg.pivotY = 50;
			charImg.x = charImg.width / 2+20;
			charImg.y = 80
			charImg.touchable = false;
			
			textImage = content.addChild(new Image(_assetsMC.getFrameTexture(9 + _id))) as Image;
			textImage.touchable = false;
			textImage.pivotX = 80;
			textImage.pivotY = 200;
			textImage.x = 80;
			textImage.y = 200;
			
			/*_clickAgainTF = new TextField(200, 50, "Tap (quick start)", "Arial", 20, 0,true);
			addChild(_clickAgainTF);
			_clickAgainTF.x = 5;
			_clickAgainTF.y = this.height - 52;
			_clickAgainTF.visible = false;*/
		}
		
		private function butnClicked(e:Event):void 
		{
			/*if (_picked)
			{
				dispatchEvent(new Event(QUICK_START,true));
			} else
			{*/
				dispatchEvent(new Event(Event.SELECT,true));
			//}
		}
		
		public function get picked():Boolean 
		{
			return _picked;
		}
		
		public function set picked(value:Boolean):void 
		{
			if (_picked != value)
			{
				_picked = value;
				var texture:Texture = _assetsMC.getFrameTexture(value?(num + 3):num);
				butn.upState = texture;
				butn.downState = texture;
				
				//charImg.scaleX = charImg.scaleY = value?1.5:1;
				//charImg.x = value? 10:charImg.width / 2 - 20;
				//charImg.y = value? 0:20;
				
				textImage.texture = _assetsMC.getFrameTexture(value?15 + _id:9 + _id);
				
				//_clickAgainTF.visible = value;
				if (value)
				{
					var tween:Tween = new Tween(textImage, .4, Transitions.EASE_OUT_BACK);
					textImage.scaleX = textImage.scaleY = .5;
					tween.scaleTo(1);
					
					Starling.juggler.add(tween);
					
					var tween2:Tween = new Tween(charImg,.2,Transitions.EASE_OUT_BACK);
					//textImage.scaleX = textImage.scaleY = .5;
					tween2.scaleTo(1.5);
					
					Starling.juggler.add(tween2);
				} else
				{
					
					var tween3:Tween = new Tween(charImg,.3,Transitions.EASE_OUT);
					//textImage.scaleX = textImage.scaleY = .5;
					tween3.scaleTo(1);
					
					Starling.juggler.add(tween3);
					
					var tween4:Tween = new Tween(textImage, .3, Transitions.EASE_OUT);
					textImage.scaleX = textImage.scaleY = .2;
					tween4.scaleTo(1);
					
					Starling.juggler.add(tween4);
				}
				
			}
			
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		
		
	}

}