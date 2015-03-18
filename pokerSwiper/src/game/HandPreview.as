package game 
{
	import assets.FontManager;
	import game.cards.CardData;
	import game.cubes.Cube;
	import game.hands.Hand;
	import starling.display.BlendMode;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class HandPreview extends ViewComponent 
	{
		private var _previewCubes:Vector.<Cube>;
		private var _cards:Vector.<CardData>;
		private var _tf:TextField;
		private var _cubesPH:Sprite;
		
		public function HandPreview() 
		{
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			_cubesPH = new Sprite();
			addChild(_cubesPH);
			
			_previewCubes = new Vector.<Cube>;
			_cards = new Vector.<CardData>;
			var cube:Cube;
			
			for (var i:int = 0; i < 5; ++i) 
			{
				cube = new Cube();
				_previewCubes.push(cube);
				cube.visible = false;
				_cubesPH.addChild(cube);
				cube.scaleX = cube.scaleY = .7;
				cube.x = (i * cube.width);
				
			}
			
			_tf = new TextField(stage.width, 100, "", FontManager.Opificio, -1, 0xEBB035);
			//_tf.x = stage.stageWidth / 2;
			//_tf.y = _cubesPH.height + 50;
			_tf.y = 60;
			_tf.x = -30;
			//_tf.pivotX = _tf.width / 2;
			//_tf.pivotY = _tf.height / 2;
			_tf.hAlign = HAlign.LEFT;
			//_tf.text = "test";
			//_cubesPH.addChild(_tf);
		}
		
		
		public function addToPreview(cardData:CardData, index:int):void
		{
			if (index < _previewCubes.length)
			{
				_cards.push(cardData)
				var hand:Hand = HandChecker.chkIsHand(_cards);
				//Tracer.alert("ADD TO PREVIEW!!!!");
				_previewCubes[index].cardData = cardData;
				_previewCubes[index].visible = true;
				_previewCubes[index].showScore();
				
				//_cubesPH.x = (stage.stageWidth - (index * Cube.getCubeSize())) / 2;
				_cubesPH.x = 80;
				
				if (hand)
				{
					_tf.text = hand.name + " ( + " + hand.scoreWorth + " points )";// + " = " + Application.game.calculateScore(hand.score, false);
				} else
				{
					_tf.text = "";
				}
				
				//_tf.x = _previewCubes[index].x + 50;
				
			}
		}
		
		public function clearPreview():void
		{
			for each (var item:Cube in _previewCubes) 
			{
				item.visible = false;
			}

			_cards = new Vector.<CardData>;
		}
		
	}

}