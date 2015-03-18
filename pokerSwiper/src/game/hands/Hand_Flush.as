package game.hands 
{
	import game.cards.CardData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Hand_Flush extends Hand implements IHand 
	{
		
		public function Hand_Flush() 
		{
			this._index = 5;
			this._scoreWorth = 50;
			this._name="Flush";
			this.cubesInHand = 5;
			this._addToTime = 15;
		}
		
		public function chkMatch(arr:Vector.<CardData>):Boolean 
		{
			if (arr.length != cubesInHand) return false;
			if (gotBlock(arr)) return false;
			
			this.addToScore(arr);
			
			//var newArr:Vector.<CardData> = getJockerlessArr(arr);
			
			for (var i:String in arr) 
			{
				var num:int = parseInt(i);
				if (num)
				{
					/*if ((arr[num].suit != (arr[num - 1].suit)) && (!oneIsJoker(arr[num], arr[num - 1])))
					//if ((arr[num].number != (arr[num - 1].number + 1)) || (arr[num].suit != (arr[num - 1].suit)) && (!oneIsJoker(arr[num], arr[num - 1])))
					{
						return false;
					}*/
					if (!HandComparer.compare(arr[num], arr[num - 1], HandComparer.MATCH_SUIT))
					{
						return false;
					}
					
				}
			}
			return true;
		}
		
	}

}