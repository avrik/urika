package game.hands 
{
	import game.cards.CardData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Hand_FullHouse extends Hand implements IHand 
	{
		
		public function Hand_FullHouse() 
		{
			this._index = 6;
			this._scoreWorth = 75;
			this._name="Full House";
			this.cubesInHand = 5;
			this._addToTime = 15;
		}
		
		/* INTERFACE board.hands.IHand */
		
		public function chkMatch(arr:Vector.<CardData>):Boolean 
		{
			if (arr.length != cubesInHand) return false;
			if (gotBlock(arr)) return false;
			this.addToScore(arr);
			
			/*var num1Arr:Array = new Array();
			var num2Arr:Array = new Array();
			
			var firstNum:int;
			var secondNum:int;
			
			for (var i:String in arr) 
			{
				var cubeNum:int = arr[i].number;
				if (!num1Arr.length)
				{
					firstNum = cubeNum;
				}
				
				if (firstNum == cubeNum)
				{
					num1Arr.push(cubeNum);
				} else
				{
					if (!num2Arr.length)
					{
						secondNum = cubeNum;
					}
					
					if (secondNum == cubeNum)
					{
						num2Arr.push(cubeNum);
					}
				}
			}
			trace("FIRST ARR == "+num1Arr);
			trace("SECOND ARR == "+num2Arr);
			return (num1Arr.length == 3 && num2Arr.length == 2 || num1Arr.length == 2 && num2Arr.length == 3)?true:false;*/
			
			/*var num1Arr:Array = new Array();
			var num2Arr:Array = new Array();

			var secondNumCard:CardData;
			
			for (var i:String in arr) 
			{
				if (HandComparer.compare(arr[0], arr[i]))
				{
					num1Arr.push(arr[i].number);
				} else
				{
					if (!num2Arr.length)
					{
						secondNumCard = arr[i];
					}
					
					if (HandComparer.compare(secondNumCard, arr[i]))
					{
						num2Arr.push(arr[i].number);
					}
				}
			}
			
			
			return (num1Arr.length == 3 && num2Arr.length == 2 || num1Arr.length == 2 && num2Arr.length == 3)?true:false;*/
			
			if (HandComparer.compare(arr[0], arr[1]) && (HandComparer.compare(arr[2], arr[3]) && HandComparer.compare(arr[3], arr[4]))) return true;
			if (HandComparer.compare(arr[0], arr[1]) && HandComparer.compare(arr[1], arr[2]) && (HandComparer.compare(arr[3], arr[4]))) return true;
			return false;
		}
		
	}

}