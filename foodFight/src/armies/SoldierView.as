package armies 
{
	import armies.data.ArmyData;
	import assets.AssetsEnum;
	import assets.AssetsLoader;
	import assets.FontManager;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import globals.MainGlobals;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class SoldierView extends ViewComponent 
	{
		private var totalTF		:TextField;
		private var _mySprite	:Sprite;
		private var armyData:ArmyData;
		public var startPos		:Point;
		
		public function SoldierView(armyData:ArmyData) 
		{
			this.armyData = armyData;
			
		}
		
		override protected function init():void 
		{
			super.init();
			_mySprite = new Sprite();
			addChild(_mySprite);
			
			var refSoldier:MovieClip = new MovieClip(MainGlobals.assetsManger.getTextureAtlas(AssetsEnum.SOLDIERS_SS).getTextures());
			var img:Image = new Image(refSoldier.getFrameTexture(this.armyData.id-1));
			img.scaleX = img.scaleY = .2//Math.random()/2;

			_mySprite.addChild(img);
			
			this.alignPivot();
		}
		/*public static function getSoldierView(num:int):Texture
		{
			var refSoldier:MovieClip = new MovieClip(MainGlobals.assetsManger.getTextureAtlas(AssetsEnum.SOLDIERS_SS).getTextures());
			return refSoldier.getFrameTexture(num);
		}*/

		public function returnToBase():void 
		{
			var tween:Tween = new Tween(mySprite, .5, Transitions.EASE_IN);
			
			tween.moveTo(startPos.x, startPos.y);
			tween.onComplete = returnToBaseComplete;
			
			Starling.juggler.add(tween);
		}
		
		private function returnToBaseComplete():void 
		{
			//this.myArmyUnit.addSoldier(this);
			removeVisualDisplay()
		}
		
		public function removeVisualDisplay():void
		{
			if (mySprite)
			{
				mySprite.removeFromParent(true);
				_mySprite = null;
			}
		}
		

		public function setTotalScore(value:int):void
		{
			this.totalTF.text = value.toString();
		}
		
		public function kill():void 
		{
			if (mySprite)
			{
				var tween:Tween = new Tween(mySprite, .8, Transitions.EASE_OUT_BACK);
			
				tween.moveTo(mySprite.x + mySprite.width / 2, mySprite.y -50);
				tween.scaleTo(.1);
				tween.onComplete = dieComplete;

				Starling.juggler.add(tween);
			}

		}
		
		private function dieComplete():void 
		{
			removeFromParent(true);
		}
		
		public function get mySprite():Sprite 
		{
			return _mySprite;
		}
	}

}