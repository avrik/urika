package game.board 
{
	import flash.geom.Point;
	import starling.display.Graphics;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class BoardView extends Sprite 
	{
		private var _nodes:Vector.<Node> = new Vector.<Node>;
		private var _totalNodes:int = 10;
		
		public function BoardView() 
		{
			super();
			init();
		}
		
		private function init():void 
		{
			var newNode:Node;
			var grid:Vector.<Point> = new Vector.<Point> ;
			var tileWidth:Number = 90;
			for (var j:int = 0; j < 14; j++) 
			{
				for (var k:int = 0; k < 7; k++) 
				{

					grid.push(new Point(j*tileWidth, k*tileWidth));
				}
			}
			
			var randomPoint:Point 
			
			for (var i:int = 0; i < _totalNodes; i++) 
			{
				var index:int = Math.random() * (grid.length) - 1;
				//trace("index ==" + index);
				randomPoint = grid[index];
				grid.splice(grid.indexOf(randomPoint),1);
				newNode = new Node();
				newNode.x = 40 + randomPoint.x;
				newNode.y = 40 + randomPoint.y;
				_nodes.push(newNode);
				addChild(newNode);
			}
			
			createLinkes();
		}
		
		private function createLinkes():void 
		{
			var pickedNodesArr:Vector.<Node> = new Vector.<Node>;
			pickedNodesArr=pickedNodesArr.concat(_nodes);
			
			var linksArr:Array = [5, 2, 2, 2, 1, 1, 1];
			//var linkesArr:Array = [2, 1];
			var nodePicked:Node;
			var nodePicked2:Node;
			
			for (var i:int = 0; i < linksArr.length; i++) 
			{
				nodePicked = pickedNodesArr.pop();
				for (var j:int = 0; j < linksArr[i]; j++) 
				{
					do
					{
						var rand:int = Math.random()*_nodes.length-1
						nodePicked2 = _nodes[rand];
					} while (nodePicked.isLinkedTo(nodePicked2)) 
					
					linkNodes(nodePicked,nodePicked2);
				}
			}
		}
		
		private function linkNodes(nodeA:Node,nodeB:Node):void
		{
			var link:Graphics = new Graphics(this);
			link.lineStyle(10, 0x999999,.5);
			link.moveTo(nodeA.x, nodeA.y);
			link.lineTo(nodeB.x, nodeB.y);
			
			nodeA.addLinked(nodeB)
			nodeB.addLinked(nodeA)
		}
		
	}

}