package game.board 
{
	import starling.display.Button;
	import starling.display.Graphics;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class Node extends Sprite 
	{
		private var _linked:Vector.<Node> = new Vector.<Node>;
		private var _graphics:Graphics;
		private var _spots:Vector.<NodeSpot> = new Vector.<NodeSpot>;
		private var _totalSpots:int;
		private var _spotsPH:Sprite;
		private var _basePH:Sprite;
		
		private static const spotsPositionArr:Array = [
							[0,20],
							[20,0],
							[40, 20],
							
							[20,20],
							[20,40],
							[0,40],
							[40,40]
							]
		
							
		
		public function Node() 
		{
			super();
			_basePH = new Sprite();
			_basePH.touchable = false;
			addChild(_basePH)
			_graphics = new Graphics(_basePH);
			_graphics.lineStyle(2, 0);
			
			
			_spotsPH = new Sprite();
			addChild(_spotsPH);
			
			
			var spotsOptionArr:Array = [3, 5, 7];
			var index:int = Math.random() * spotsOptionArr.length;
			
			_totalSpots = spotsOptionArr[index];
			
			
			putSpots();

		}
		
		
		
		public function addLinked(node:Node):void 
		{
			_linked.push(node);
			
			setNewSize(_linked.length * 10);
		}
		
		private function putSpots():void
		{
			var newSpot:NodeSpot;
			for (var i:int = 0; i < _totalSpots; i++) 
			{
				newSpot = new NodeSpot();
				newSpot.x = spotsPositionArr[i][0];
				newSpot.y = spotsPositionArr[i][1];
				_spotsPH.addChild(newSpot);
				_spots.push(newSpot);
			}
		}
		
		public function isLinkedTo(nodePicked:Node):Boolean 
		{
			return _linked.indexOf(nodePicked) != -1?true:false;
		}
		
		private function setNewSize(size:Number):void 
		{
			_graphics.clear();
			_graphics.beginFill(0x999999);
			_graphics.drawCircle(0, 0, 25+size);
			_graphics.endFill();
		}
		
	}

}