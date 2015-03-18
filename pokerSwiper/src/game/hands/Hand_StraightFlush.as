package game.hands
{
	import game.cards.CardData;
	
	public class Hand_StraightFlush extends Hand implements IHand
	{
		public function Hand_StraightFlush()
		{
			super();
			this._index = 8;
			this._scoreWorth = 120;
			this._name = "Straight Flush";
			this.cubesInHand = 5;
			
			this._addToTime = 25;
		}
		
		public function chkMatch(arr:Vector.<CardData>):Boolean
		{
			if (arr.length != cubesInHand) return false;
			if (gotBlock(arr)) return false;
			this.addToScore(arr);
			for (var i:String in arr) 
			{
				if (parseInt(i))
				{
					/*if (arr[i].number != (arr[parseInt(i) - 1].number + 1))
					{
						return false;
					}*/
					
					if (!HandComparer.compare(arr[i], arr[parseInt(i) - 1], HandComparer.MATCH_SUIT))
					{
						return false;
					}
					
					if (!HandComparer.compare(arr[i], arr[parseInt(i) - 1], HandComparer.ASCENDING))
					{
						return false;
					}
					
				}
			}
			return true;
		}
	}
}