package armies 
{
	import armies.data.ArmyData;
	import assets.AssetsEnum;
	import assets.AssetsLoader;
	import assets.FontManager;
	import flash.geom.Point;
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
		
		public static function getSoldierView(num:int):Texture
		{
			var refSoldier:MovieClip = new MovieClip(TopLevel.assets.getTextureAtlas(AssetsEnum.SOLDIERS_SS).getTextures());
			return refSoldier.getFrameTexture(num);
		}
		/*override protected function init():void 
		{
			super.init();
			
			//startPos = new Point(this._myArmyUnit.getLocationPoint().x, this._myArmyUnit.getLocationPoint().y);
				
			var soldiersMC:MovieClip = AssetsLoader.getArmyUnitsMC();
			_mySprite = new Sprite();
			var img:Image = new Image(soldiersMC.getFrameTexture(this.armyData.id - 1));
			mySprite.addChild(img);
			mySprite.scaleX = mySprite.scaleY = scale;
			//mySprite.x = startPos.x;
			//mySprite.y = startPos.y-10;				
			totalTF = new TextField(img.width, img.height, "1", FontManager.Badaboom, -1, 0xffffff);
			totalTF.autoScale = true;
			totalTF.y = -5;
			totalTF.x = -2;
			totalTF.hAlign = "center";

			totalTF.alpha = .8;
			//totalTF.filter = BlurFilter.createGlow(0);
			totalTF.touchable = false;
			mySprite.addChild(totalTF);
		}*/
		
		/*public function getVisual(scale:Number = 1):Sprite
		{
			if (!_mySprite)
			{
				startPos = new Point(this._myArmyUnit.getLocationPoint().x, this._myArmyUnit.getLocationPoint().y);
				
				var soldiersMC:MovieClip = AssetsLoader.getArmyUnitsMC();
				_mySprite = new Sprite();
				var img:Image = new Image(soldiersMC.getFrameTexture(this._myArmyUnit.myArmy.armyData.id - 1));
				mySprite.addChild(img);
				
				mySprite.scaleX = mySprite.scaleY = scale;
				mySprite.x = startPos.x;
				mySprite.y = startPos.y-10;				
				totalTF = new TextField(img.width, img.height, "1", FontManager.Badaboom, -1, 0xffffff);
				totalTF.autoScale = true;
				totalTF.y = -5;
				totalTF.x = -2;
				totalTF.hAlign = "center";

				totalTF.alpha = .8;
				//totalTF.filter = BlurFilter.createGlow(0);
				totalTF.touchable = false;
				mySprite.addChild(totalTF);
				
				Game.worldMap.view.armyUnitsPH.addChild(mySprite) as Image;
			}
			
			return mySprite;
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