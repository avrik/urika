package armies 
{
	import armies.data.ArmyData;
	import ascb.util.NumberUtilities;
	import assets.FontManager;
	import flash.geom.Point;
	import interfaces.IBuyItem;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class Soldier extends Sprite implements IBuyItem
	{
		
		private var _attackMaxResult	:int = 6;
		private var _defenceMaxResult	:int = 6;
		private var _health			:int;
		private var _myArmyUnit		:ArmyUnit;
		private var _initData		:ArmyData;
		//private var _exp			:int = 0;
		private var _attackScore	:Number;
		private var _defenceScore	:Number;
		
		public var startPos			:Point;
		private var _attackExp		:Number = 0;
		private var _defenceExp		:Number = 0;
		private var _soldierVisual	:Sprite;
		private var totalTF			:TextField;
		
		private var _view:SoldierView;
		private var soldierTween:Tween;
		
		private var _raiseDefenceFactor:Number = 2;
		private var _raiseAttackFactor:Number = 2;
		
		public function Soldier(initData:ArmyData) 
		{
			_initData = initData;
			
			
		}
		
		private function getAttackPoints():int
		{
			
			return NumberUtilities.random(1, _attackMaxResult);
		}
		
		
		private function getDefencePoints():int
		{
			return NumberUtilities.random(1, _defenceMaxResult);
		}
		
		public function kill():void 
		{
			if (soldierVisual)
			{
				soldierTween = new Tween(soldierVisual, .8, Transitions.EASE_OUT_BACK);
			
				//tween.moveTo(soldierVisual.x + soldierVisual.width / 2, soldierVisual.y + soldierVisual.height / 2);
				soldierTween.moveTo(soldierVisual.x + soldierVisual.width / 2, soldierVisual.y -50);
				soldierTween.scaleTo(.1);
				soldierTween.onComplete = dieComplete;

				Starling.juggler.add(soldierTween);
			}

			//removeVisualDisplay()
			GameApp.game.uiLayer.playersInfoBar.update(this._myArmyUnit.myArmy.myPlayer.id);
		}
		
		private function dieComplete():void 
		{
			removeVisualDisplay()
		}
		
		public function getVisual(scale:Number = 1):Sprite
		{
			if (!_soldierVisual)
			{
				_soldierVisual = new Sprite();
				var img:Image = new Image(SoldierView.getSoldierView(_initData.id - 1));
				img.scaleX = img.scaleY = .25;
				soldierVisual.addChild(img);
				
				soldierVisual.pivotX = soldierVisual.width / 2;
				soldierVisual.pivotY = soldierVisual.height / 2;
				
				soldierVisual.scaleX = soldierVisual.scaleY = scale;
				
				startPos = this._myArmyUnit?new Point(this._myArmyUnit.getLocationPoint().x, this._myArmyUnit.getLocationPoint().y):new Point();
					//soldierVisual.x = startPos.x;// + _myArmyUnit.width / 2;
					//soldierVisual.y = startPos.y;// + _myArmyUnit.height / 2;
				
				totalTF = new TextField(img.width, img.height, "1", FontManager.Badaboom, -1, 0xffffff);
				totalTF.autoScale = true;
				totalTF.hAlign = HAlign.CENTER;
				totalTF.vAlign = VAlign.CENTER;
				totalTF.touchable = false;
				totalTF.y = -20;
				soldierVisual.addChild(totalTF);
				
				GameApp.game.world.actionLayer.addObject(soldierVisual, startPos.x, startPos.y, 1,false);
			}
			
			return soldierVisual;
		}
		
		public function returnToBase():void 
		{
			soldierTween = new Tween(soldierVisual, .5, Transitions.EASE_IN);
			soldierTween.moveTo(startPos.x, startPos.y);
			soldierTween.onComplete = returnToBaseComplete;
			//tween.onCompleteArgs = [attackSoldier,defenceSoldier];
			
			Starling.juggler.add(soldierTween);
		}
		
		private function returnToBaseComplete():void 
		{
			this.myArmyUnit.addSoldier(this);
			removeVisualDisplay()
		}
		
		public function removeVisualDisplay():void
		{
			if (soldierVisual)
			{
				GameApp.game.world.actionLayer.removeObject(soldierVisual);
				//soldierVisual.removeFromParent(true);
				_soldierVisual = null;
			}
		}
		
		public function generateAttackScore():void 
		{
			_attackScore = getAttackPoints();
			//var delay:DelayedCall = new DelayedCall(dice, 0.1);
			//delay.repeatCount = 4;

			//Starling.juggler.add(delay);
			this.totalTF.text = _attackScore.toString();
		}
		
		private function dice():void 
		{
			_attackScore = getAttackPoints();
			//var num:int = NumberUtilities.random(1, 6);
			this.totalTF.text = _attackScore.toString();
		}
		
		public function generateDefenceScore():void 
		{
			
			_defenceScore = getDefencePoints();
			this.totalTF.text = _defenceScore.toString();
		}
		
		/* INTERFACE ui.interfaces.IVisualDisplay */
		
		public function get myArmyUnit():ArmyUnit 
		{
			return _myArmyUnit;
		}
		
		public function set myArmyUnit(value:ArmyUnit):void 
		{
			_myArmyUnit = value;
			
			_attackMaxResult += _myArmyUnit.myArmy.getSoldierAttackBonus();
			_defenceMaxResult += _myArmyUnit.myArmy.getSoldierDefenceBonus();
		}
		
		
		public function get exp():int 
		{
			//return _exp;
			return _attackExp + _defenceExp;
		}
		
		public function get soldierVisual():Sprite 
		{
			return _soldierVisual;
		}
		
		public function get attackScore():Number 
		{
			return _attackScore;
		}
		
		public function get defenceScore():Number 
		{
			return _defenceScore;
		}
		
		
		
		
		public function get attackExp():Number 
		{
			return _attackExp;
		}
		
		public function set attackExp(value:Number):void 
		{
			_attackExp = value;
			
			if (_attackExp % _raiseAttackFactor == 0) {
				_attackMaxResult++;
				_raiseAttackFactor++;
				_attackExp = 0;
			}
			
			//Tracer.alert("ATTACK EXP === " + _attackExp);
			//Tracer.alert("ATTACK MAX RESULT === " + _attackMaxResult);
		}
		
		public function get defenceExp():Number 
		{
			return _defenceExp;
		}
		
		public function set defenceExp(value:Number):void 
		{
			_defenceExp = value;
			
			//Tracer.alert("DEFENCE TESTTTTT === " + _defenceExp % _raiseDefenceFactor);
			if (_defenceExp % _raiseDefenceFactor == 0) {
				_defenceMaxResult++;
				_raiseDefenceFactor++;
				_defenceExp = 0;
			}
			
			//Tracer.alert("DEFENCE EXP === " + _defenceExp);
			//Tracer.alert("DEFENCE MAX RESULT === " + _defenceMaxResult);
		}
		
		public function set attackMaxResult(value:int):void 
		{
			_attackMaxResult = value;
		}
		
		public function set defenceMaxResult(value:int):void 
		{
			_defenceMaxResult = value;
		}
		
		public function get attackMaxResult():int 
		{
			return _attackMaxResult;
		}
		
		public function get defenceMaxResult():int 
		{
			return _defenceMaxResult;
		}
		
	}
}