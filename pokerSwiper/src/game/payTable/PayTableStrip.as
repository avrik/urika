package game.payTable 
{
	import assets.FontManager;
	import game.cards.CardData;
	import game.cubes.Cube;
	import game.HandChecker;
	import game.hands.Hand;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class PayTableStrip extends ViewComponent 
	{
		private var _id:int;
		private var _myHand:Hand;
		private var _previewArr:Array;
		
		public function PayTableStrip(id:int, myHand:Hand,previewArr:Array) 
		{
			this._previewArr = previewArr;
			this._myHand = myHand;
			this._id = id;
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			//var bg:Quad = new Quad(this.stage.stageWidth, 75,this._id%2?0xDD1E2E:0xC21A28);
			var bg:Quad = new Quad(this.stage.stageWidth, 75,this._id%2?0x06A2CB:0x058CAF);
			addChild(bg);
			
			var str:String = this._myHand.name + " ( " + this._myHand.scoreWorth + " )";
			//var tf:TextField = new TextField(this.width - 20, this.height, str , FontManager.BubbleGum, -.5, 0xffffff);
			var tf:TextField = new TextField(this.width - 20, this.height, str ,"Verdana", 30, 0xffffff);
			tf.x = 10;
			tf.hAlign = HAlign.LEFT;
			addChild(tf);
			
			var cube:Cube
			var _cubesPH:Sprite = new Sprite();
			addChild(_cubesPH);
			
			
			for (var i:int = 0; i < this._previewArr.length; ++i) 
			{
				cube = new Cube();
				//_previewCubes.push(cube);
				//cube.visible = false;
				_cubesPH.addChild(cube);
				cube.scaleX = cube.scaleY = .5;
				cube.x = (i * cube.width)+cube.width;
				cube.y = 35
				cube.cardData = new CardData(this._previewArr[i]);
			}
			
			_cubesPH.x = stage.stageWidth - (_cubesPH.width + 50);
		}
		
	}

}