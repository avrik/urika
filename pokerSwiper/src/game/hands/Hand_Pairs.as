package game.hands 
{
	import game.cards.CardData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Hand_Pairs extends Hand implements IHand
	{
		
		public function Hand_Pairs() 
		{
			this._index = 2;
			this._scoreWorth = 15;
			this._name = "Pairs";
			this.cubesInHand = 4;
			this._addToTime = 4;
		}
		
		/* INTERFACE board.hands.IHand */
		
		public function chkMatch(arr:Vector.<CardData>):Boolean 
		{
			if (arr.length != cubesInHand) return false;
			if (gotBlock(arr)) return false;
			this.addToScore(arr);
			
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
					
					//if (secondNum == cubeNum)
					if (HandComparer.compare(secondNumCard, arr[i]))
					{
						num2Arr.push(arr[i].number);
					}
				}
			}
			
			return (num1Arr.length == 2 && num2Arr.length == 2)?true:false;*/
			
			return (HandComparer.compare(arr[0], arr[1]) && HandComparer.compare(arr[2], arr[3]))?true:false;
			
		}
	}

}