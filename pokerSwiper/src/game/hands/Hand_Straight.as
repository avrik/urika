package game.hands 
{
	import game.cards.CardData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Hand_Straight extends Hand implements IHand 
	{
		
		public function Hand_Straight() 
		{
			super();
			
			this._index = 4;
			this._scoreWorth = 40;
			this._name="Straight";
			this.cubesInHand = 5;
			this._addToTime = 10;
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