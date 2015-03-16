package game 
{
	import game.cards.CardData;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.events.Event;
	import game.cubes.Cube;
	/**
	 * ...
	 * @author Avrik
	 */
	public class CubeColumn 
	{
		private var _id:int;
		private var _cubes:Vector.<Cube>;
		
		public function CubeColumn(id:int) 
		{
			this._id = id;
			_cubes = new Vector.<Cube>;
		}
		
		public function addCube(cube:Cube):void 
		{
			if (_cubes.length > 1)
			{
				var blockCube:Cube 
				
				if (_cubes[_cubes.length - 1].cardData.isBlock)
				{
					blockCube = _cubes[_cubes.length - 1];
				}
				
				
				//trace("BLOCK CHECK 111 === " + _cubes[_cubes.length - 1].cardData.isBlock);
				//trace("BLOCK CHECK 222 === " + _cubes[_cubes.length - 2].cardData.isBlock);
				
				
				//if (blockCube && blockCube.isStatic)
				/*if (blockCube)
				{
					trace("[ --- BLOCK SPOTED!!!!!!!!!! --- ]");
					Starling.juggler.add(new DelayedCall(dropComplete, .3, [blockCube]));
				}*/
				
			}
			
			Starling.juggler.add(new DelayedCall(dropComplete, .3, [cube]));
			
			_cubes.push(cube);
			cube.yPos = _cubes.length - 1;
		}
		
		//private function dropComplete(e:Event):void 
		private function dropComplete(cube:Cube):void 
		{
			//trace("BLOCK CHANGE DROP COMPLETE");
			
			/*var cube:Cube = e.currentTarget as Cube;
			cube.removeEventListener(Cube.DROP_COMPLETE, dropComplete);
			
			var blockCube:Cube = _cubes[_cubes.indexOf(cube) - 1];*/
			
			/*Tracer.alert("BLOCK FUNCKING COMPLETE === " + blockCube.imgNumer);
			
			if (blockCube.imgNumer >= CardData.BLOCK_NUM + 2)
			{
				Tracer.alert("BLOCK FUNCKING DESTROY!!1!!!!!!!!!!!111111111");
				blockCube.destroy();
			} else
			{
				blockCube.imgNumer++;
			}*/
			
			//Tracer.alert("VVVVVVVVVVVVVVVV === " + cube.yPos);
			
			rearangeCubes();
		}
		
		public function removeCube(cube:Cube):void 
		{
			_cubes.splice(_cubes.indexOf(cube), 1);
			
			rearangeCubes();
		}
		
		private function rearangeCubes():void
		{
			var item:Cube;
			for (var i:int = 0; i <_cubes.length ; ++i) 
			{
				item = _cubes[i];
				item.yPos = i;
				if (item.cardData.isBlock)
				{
					/*if (item.imgNumer >= (CardData.BLOCK_NUM + 4))
					{
						item.destroy();
					} else
					{
						Tracer.alert("QQQQQQQQQQQQQQQQQQ ==== " + i);
						//item.cardData.typeNumber = 
						item.imgNumer = CardData.BLOCK_NUM + (5 - i);
					}*/
					
					if (item.yPos <= 1)
					{
						//item.destroy();
						
						Starling.juggler.add(new DelayedCall(item.destroy, .3));
						
					} else
					if (item.yPos <=2)
					{
						item.imgNumer = CardData.BLOCK_NUM +2;
					} else if (item.yPos <=3)
					{
						
						item.imgNumer = CardData.BLOCK_NUM +1;
					}
					
					
					
					/*if (item.yPos >=3)
					{
						item.destroy();
					} else
					if (item.yPos >=2)
					{
						item.imgNumer = CardData.BLOCK_NUM +2;
					} else if (item.yPos >=1)
					{
						item.imgNumer = CardData.BLOCK_NUM +1;
					}*/
				}
			}
		}
		
		public function getCubeByIndex(index:int):Cube 
		{
			return index < _cubes.length?_cubes[index]:null;
		}
	}

}