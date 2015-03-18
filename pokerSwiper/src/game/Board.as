package game 
{
	import assets.FontManager;
	import feathers.controls.ScrollContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import game.cards.CardData;
	import game.cubes.Cube;
	import game.hands.Hand;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import ui.MessageAdder;
	import ui.MessageParams;
	import ui.ScreenMessage;
	import ui.ViewComponent;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Board extends ViewComponent
	{
		public static var CUBES_IN_ROW:int = 5;
		//private var _view:BoardView;
		private var _cubes:Vector.<Cube> = new Vector.<Cube>;
		private var delay:DelayedCall;
		private var _handPickedArr:Vector.<Cube> = new Vector.<Cube>;
		private var _delayCall:DelayedCall;
		
		public static var space:Space;
		
		private var touchPoint:Point;
		private var _hold:Boolean;
		private var _columns:Vector.<CubeColumn> = new Vector.<CubeColumn>;
		private var _floor:Body;
		private var _disable:Boolean;
		private var _container:ScrollContainer;
		private var cubeMatrixPH:Sprite;
		private var touchLayerSprite:Sprite;
		private var _cubesMatrix:Array = new Array();
		
		public function Board() 
		{
			//_view = new BoardView();
			//_view.addEventListener(Event.ADDED_TO_STAGE, boardReady);
			
		}
		
		override protected function init():void 
		{
			var widthNum:Number = Cube.getCubeSize() * CUBES_IN_ROW;

			_container = new ScrollContainer();
			_container.width = widthNum;
			_container.height = widthNum;
			//_container.stopScrolling();
			
			addChild(_container)

			cubeMatrixPH = new Sprite();
			addChild(cubeMatrixPH);
			
			for (var i:int = 0; i < CUBES_IN_ROW; ++i) 
			{
				_columns.push(new CubeColumn(i));
			}

			touchLayerSprite = new Sprite();
			touchLayerSprite.addChild(new Quad(widthNum, widthNum, 0));
			touchLayerSprite.alpha = 0;

			this.x = (this.stage.stageWidth - widthNum) / 2 - 4;
			this.y = (this.stage.stageHeight - widthNum) / 2 - 5;
			cubeMatrixPH.clipRect = new Rectangle(0,0, widthNum, widthNum);
		}
		
		public function activate():void
		{
			var widthNum:Number = Cube.getCubeSize() * CUBES_IN_ROW;

			touchLayerSprite.addEventListener(TouchEvent.TOUCH, handleMouseEvents);
			
			space = new Space(new Vec2(0, 4000));
			
			_floor = new Body(BodyType.KINEMATIC);
			_floor.shapes.add(new Polygon(Polygon.rect(this.x, this.y + this.height, this.width, 10)));
			_floor.space = space;
			
			addChild(touchLayerSprite);
			
			setStartingCubes();
			

			
			
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		public function clearBoard():void
		{
			_floor.position.x = -1000;
		}
		
		private function setStartingCubes():void
		{
			for (var i:int = 0; i < CUBES_IN_ROW; ++i) 
			{
				for (var j:int = CUBES_IN_ROW; j >0; --j) 
				{
					//addNewCube(_cubes.length % CUBES_IN_ROW, (this.y) - (j * Cube.getCubeSize()));
					addNewCube(_cubes.length % CUBES_IN_ROW,  - (j * Cube.getCubeSize()));
				}
			}
		}
		
		private function handleMouseEvents(e:TouchEvent):void 
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if (touch)
			{
				if(touch.phase == TouchPhase.ENDED) //on finger up
				{
					_hold = false;
					trace("release");

					//removeEventListener(Event.ENTER_FRAME, onButtonHold);
					if (!handleHand())
					{
						Application.game.clearPreview();
					}
					
				}
				
				if(touch.phase == TouchPhase.BEGAN)//on finger down
				{
					trace("pressed just now");
					Application.game.clearPreview();
					//addEventListener(Event.ENTER_FRAME, onButtonHold);
					//setCubesForClick();
					_hold = true;
				}

				if (_hold)
				{
					touchPoint = touch.getLocation(stage);

					var a:int = Math.floor((touchPoint.x - this.x) / Cube.getCubeSize());
					var b:int = Math.floor(CUBES_IN_ROW - (touchPoint.y - this.y) / Cube.getCubeSize());
					
					if (a >= _columns.length || a < 0) return;
					if (b >= _columns.length || b < 0) return;
					
					var column:CubeColumn = _columns[a];
					var cube:Cube;
					if (column)
					{
						cube = column.getCubeByIndex(b);
						//if (cube.cardData.isBlock) return;
						if (cube is Cube)
						{
							addToHandPick(cube);
							
						}
					}
				}
			}
		}
		
		
		private function showScoreOnSpot(cube:Cube, score:int, delay:Number,handName:String=""):void
		{
			Starling.juggler.add(new DelayedCall(showCubeScore, delay, [ cube, score,handName]));
		}
		
		private function showCubeScore(cube:Cube, score:int,handName:String):void
		{
			var x:Number = this.x + cube.body.position.x + Cube.getCubeSize() / 2;
			var y:Number = this.y + cube.body.position.y + Cube.getCubeSize() / 2;
			
			/*if (cube.stage)
			{
				var _tf:TextField = new TextField(cube.width - 10, cube.height - 10, score.toString() , FontManager.Opificio, -2, 0xECB036);
				_tf.autoScale = true;
				_tf.x = cube.body.position.x + Cube.getCubeSize() / 2;
				_tf.y = cube.body.position.y + Cube.getCubeSize() / 2;
				_tf.pivotX = _tf.width >> 1;
				_tf.pivotY = _tf.height >> 1;
				
				
				this.cubeMatrixPH.addChild(_tf)
				//cube.bringToFront();
			}*/
			
			//Application.game.hud.showWindicator(x, y, score * Application.game.onLevel.levelData.scoreFactor,handName);
		}
		
		private function handleHand():Boolean 
		{
			var cardDataArr:Vector.<CardData> = new Vector.<CardData>;
			for each (var item:Cube in _handPickedArr) 
			{
				cardDataArr.push(item.cardData);
			}
			
			var hand:Hand = HandChecker.chkIsHand(cardDataArr);
			if (hand)
			{
				Tracer.alert("GOT HAND === " + hand.name);
				//GameTimer.addToTimer(hand.addToTime);
				Application.game.gameTimer.addToTimer(hand.addToTime);
				
				var is5inRowH:Boolean = _handPickedArr.length == 5?true:false;
				var is5inRowV:Boolean = _handPickedArr.length == 5?true:false;
				
				var onYPos:int = _handPickedArr[0].yPos;
				var onXPos:int = _handPickedArr[0].xPos;
				
				for each (var cube:Cube in _handPickedArr) 
				{
					if (cube.yPos != onYPos) is5inRowV = false;
					if (cube.xPos != onXPos) is5inRowH = false;
					removeItem(cube);
				}
				
				var score:int = Application.game.calculateScore(hand.score, is5inRowH || is5inRowV);
				//showCubeScore(_handPickedArr[(_handPickedArr.length - 1)], score);
				
				/*for each (var cubeItem:Cube in _handPickedArr) 
				{
					showCubeScore(cubeItem, cubeItem.cardData.scoreWorth);
				}*/
				/*var cubeItem:Cube;
				for (var i:int = 0; i < _handPickedArr.length; ++i) 
				{
					cubeItem = _handPickedArr[i];
					showScoreOnSpot(cubeItem, cubeItem.cardData.scoreWorth, i / 10);
				}
				
				var lastCubeItem:Cube = _handPickedArr[_handPickedArr.length - 1];
				showScoreOnSpot(lastCubeItem, score, 1,hand.name);*/
				//showScoreOnSpot();
				
				//MessageAdder.addMessage(new ScreenMessage(hand.name +" + " + score, new MessageParams(0xDD1E2E, 0xDD1E2E)), lastCubeItem.body.position.x + this.x + Cube.getCubeSize() / 2, lastCubeItem.body.position.y + this.y + Cube.getCubeSize() / 2);
				//is5inRowH = true;
				if (is5inRowH || is5inRowV)
				{
					MessageAdder.addMessage(new ScreenMessage("FIVE IN A ROW!", new MessageParams(0xffffff, 0xECB036, -.5)), Application.gamePH.stage.stageWidth / 2, Application.gamePH.stage.stageHeight / 2 - 450, .2);
				}
				
				MessageAdder.addMessage(new ScreenMessage(hand.name, new MessageParams(0xffffff, 0xECB036, -.5)), this.stage.stageWidth / 2, this.stage.stageHeight / 2 - 350);
				MessageAdder.addMessage(new ScreenMessage(score.toString(), new MessageParams(0xECB036, 0xffffff,-1)),this.stage.stageWidth/ 2,this.stage.stageHeight / 2 - 400,.1);
				//MessageAdder.addMessage(new ScreenMessage(score.toString(), new MessageParams(0xECB036, 0xffffff)), lastCubeItem.body.position.x + this.x + Cube.getCubeSize() / 2, lastCubeItem.body.position.y + this.y + Cube.getCubeSize() / 2 + 30);
			
			} else
			{
				for each (var cube2:Cube in _handPickedArr) 
				{
					cube2.marked = false;
				}
			}
			
			_handPickedArr = new Vector.<Cube>;
			
			Application.game.reportActionComplete();
			
			return hand?true:false;
		}
		
		/*private function getTotalHandsOnBoard():int
		{
			for each (var item:Cube in _cubes) 
			{
				
			}
			
			return -1;
		}
		
		private function setCubesNeighbors():void
		{
			for each (var item:Cube in _cubes) 
			{
				
			}
		}*/
		
		private function removeItem(cube:Cube):void
		{
			//_columns[cube.xPos].removeCube(cube);
			showCubesScore(cube);
			cube.destroy();
		}
		
		private function showCubesScore(cube:Cube):void
		{
			if (cube.cardData.scoreWorth)
			{
				var str:String = "+" + String(cube.cardData.scoreWorth * Application.game.onLevel.levelData.scoreFactor);
				var _tf:TextField = new TextField(cube.width - 10, cube.height - 10, str , FontManager.BubbleGum, -.6, 0xECB036);
				_tf.autoScale = true;
				_tf.x = this.x + cube.body.position.x;
				_tf.y = 60 + cube.body.position.y;
				_tf.pivotX = _tf.width >> 1;
				_tf.pivotY = _tf.height >> 1;
				_tf.scaleX = _tf.scaleY = 0;
				_tf.alpha = 0;
				
				this.addChild(_tf);
				
				this.setChildIndex(_tf, 0)
				
				var tween2:Tween = new Tween(_tf,.3, Transitions.EASE_OUT);
				tween2.scaleTo(1);
				tween2.fadeTo(1)
				tween2.reverse = true;
				tween2.repeatCount = 2;
				tween2.repeatDelay = .1;
				tween2.onComplete = function():void
				{
					_tf.removeFromParent(true);
				}
				
				Starling.juggler.add(tween2);
				//Starling.juggler.add(new DelayedCall(removeTF, 1, [_tf]));
				
			}
		}
		
		/*private function removeTF(tf:TextField):void 
		{
			tf.removeFromParent(true);
		}*/
		
		private function setCubesForClick():void 
		{
			for each (var item:Cube in _cubes) 
			{
				item.touchable = true;
			}
		}
		
		private function onButtonHold(e:Event):void 
		{
			trace("HOLD");
		}
		
		
		private function loop(e:Event):void 
		{
			space.step(1 / 60);
			
			CONFIG::debug
			if (Application.debugMode)
			{
				Main.debug.clear();
				Main.debug.draw(space);
				Main.debug.flush();
			}
		}
		
		private function addNewCube(xpos:int = 0, ypos:int = 0):void
		{
			var cube:Cube = new Cube(_cubes.length,true);
			
			cubeMatrixPH.addChild(cube);
			cube.cardData = Application.game.deck.getCard();
			cube.addEventListener(Cube.DESTROY, cubeDestroyed);

			cube.body.position.y = ypos?ypos: -Cube.getCubeSize();
			cube.body.position.x = xpos * Cube.getCubeSize();
			cube.xPos = xpos 
			_cubes.push(cube);
			
			_columns[xpos].addCube(cube);
			
			updateCubesMatrix();
		}
		
		private function cubeDestroyed(e:Event):void 
		{
			var cube:Cube = e.currentTarget as Cube;
			
			if (cube.cardData.isBlock)
			{
				Application.game.calculateScore(cube.cardData.scoreWorth);
				showCubesScore(cube);
			}
			
			_columns[cube.xPos].removeCube(cube)
			Starling.juggler.add(new DelayedCall(addNewCube, 0, [cube.xPos]));
			
			updateCubesMatrix();
		}
		
		private function updateCubesMatrix():void
		{
			for each (var item:Cube in _cubes) 
			{
				if (!_cubesMatrix[item.xPos]) _cubesMatrix[item.xPos] = new Array();
				_cubesMatrix[item.xPos][item.yPos] = item;
				
				item.clearNeighbors();
			}
			
			
			setNeighbor();
			
		}
		
		private function setNeighbor():void 
		{
			/*for each (var item:Cube in _cubes) 
			{
				for (var i:int = (item.xPos - 1); i < (item.xPos + 1) ; ++i) 
				{
					for (var j:int =  (item.yPos - 1); j < (item.yPos + 1) ; ++j)
					{
						if (i >= 0 && j >= 0 && i <= CUBES_IN_ROW && j <= CUBES_IN_ROW)
						{
							//item.addNeighbor(_cubesMatrix[i, j] as Cube)
						}
					}
				}
			}*/
		}
		
		private function addToHandPick(cube:Cube):Boolean 
		{
			if (_handPickedArr.indexOf(cube) == -1)
			{
				Tracer.alert("CUBE DETAILS === " + cube.cardData.number + "|" + cube.cardData.suit);
				_handPickedArr.push(cube);
				cube.marked = true;
				//cube.markNeighbors();
				
				Application.game.addToHandPreview(cube.cardData, _handPickedArr.length - 1);
				return true;
			}
			return false;
		}
		
		override public function set touchable(value:Boolean):void 
		{
			super.touchable = value;
			this.alpha = value?1:.9;
		}
		
		public function set disable(value:Boolean):void 
		{
			this.touchable = !value;
			_disable = value;
			
			for each (var item:Cube in _cubes) 
			{
				item.disable = value;
			}
		}
		
		public function get hold():Boolean 
		{
			return _hold;
		}
		
		
		
		
	}

}