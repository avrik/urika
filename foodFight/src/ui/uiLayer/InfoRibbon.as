package ui.uiLayer 
{
	import assets.FontManager;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Graphics;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import ui.ViewComponent;
	import urikatils.LoggerHandler;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class InfoRibbon extends ViewComponent 
	{
		private var scoreTF:TextField;
		//private var movesTF:TextField;
		private var _score:Number = 0;
		private var delay:DelayedCall;
		private var _movesSprite:Sprite;
		
		private var _attacksLeftTF:TextField;
		private var _movesLeftTF:TextField;
		private var _deplomacyLeftTF:TextField;
		
		public function InfoRibbon() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			var graphics:Graphics = new Graphics(this);
			graphics.beginFill(0, .6);
			graphics.drawRect(0, 0, stage.stageWidth, 25);
			graphics.endFill();
			
			scoreTF = new TextField(200, 50, "Score : 0", FontManager.Badaboom, -1, Color.WHITE, true);
			scoreTF.vAlign = VAlign.TOP;
			scoreTF.hAlign = HAlign.LEFT;
			scoreTF.x = 10;
			addChild(scoreTF);
			
			_movesSprite = new Sprite();
			addChild(_movesSprite);
			/*movesTF = new TextField(800, 50, "", FontManager.Badaboom, -1, 0xffffff);
			//movesTF.autoScale = true;
			movesTF.text = "3 Attacks Left   1 Move Left    1 Deplomacy Left";
			movesTF.vAlign = VAlign.TOP;
			movesTF.hAlign = HAlign.LEFT;
			movesTF.x = 200;
			addChild(movesTF);*/
			
			_attacksLeftTF = addMoveTab("Attacks Left", 200);
			_movesLeftTF = addMoveTab("Moves Left", 400);
			_deplomacyLeftTF = addMoveTab("Diplomacy Left", 600);
			
			_movesSprite.x = (this.stage.stageWidth - _movesSprite.width) / 2;
			_movesSprite.visible = false;
		}
		
		private function addMoveTab(txt:String, x:Number):TextField
		{
			var tf:TextField = new TextField(400, 50, txt, FontManager.Badaboom, -1, Color.WHITE);
			tf.vAlign = VAlign.TOP;
			tf.hAlign = HAlign.LEFT;
			tf.x = x;
			_movesSprite.addChild(tf);
			
			var tf2:TextField = new TextField(50, 50, "0", FontManager.Badaboom, -1, Color.YELLOW);
			tf2.vAlign = VAlign.TOP;
			tf2.hAlign = HAlign.RIGHT;
			tf2.x = tf.x - tf2.width - 10;
			_movesSprite.addChild(tf2);
			return tf2;
		}
		
		public function updateInfo():void
		{
			_attacksLeftTF.text = MainGameApp.getInstance.game.playersManager.userPlayer.attacksLeft.toString();
			_attacksLeftTF.color = MainGameApp.getInstance.game.playersManager.userPlayer.attacksLeft?Color.YELLOW:Color.RED;
			
			_movesLeftTF.text = MainGameApp.getInstance.game.playersManager.userPlayer.movesLeft.toString();
			_movesLeftTF.color = MainGameApp.getInstance.game.playersManager.userPlayer.movesLeft?Color.YELLOW:Color.RED;
			
			_deplomacyLeftTF.text = MainGameApp.getInstance.game.playersManager.userPlayer.diplomacyLeft.toString();
			_deplomacyLeftTF.color = MainGameApp.getInstance.game.playersManager.userPlayer.diplomacyLeft?Color.YELLOW:Color.RED;
		}
		
		public function addToScore(value:Number):void
		{
			delay = new DelayedCall(scoreElapsed, .02);
			delay.repeatCount = value;

			Starling.juggler.add(delay);
		}
		
		public function hideTurns():void 
		{
			_movesSprite.visible = false;
		}
		public function showTurns():void 
		{
			_movesSprite.visible = true;
		}
		
		private function scoreElapsed():void 
		{
			score = _score + 1;
			if (delay.isComplete)
			{
				LoggerHandler.getInstance.info(this,"COUNT COMPLETE 2222");
				Starling.juggler.remove(delay);
				delay = null;
			}
		}
		
		public function set score(value:Number):void 
		{
			//trace("ADD TO SCORE =" + value);
			_score = value;
			scoreTF.text = "Score : " + _score;
		}
		
	}

}