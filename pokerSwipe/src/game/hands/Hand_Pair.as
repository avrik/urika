package game.hands 
{
	import game.cards.CardData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Hand_Pair extends Hand implements IHand
	{
		
		public function Hand_Pair() 
		{
			this._index = 1;
			this._scoreWorth = 5;
			this._name = "Pair";
			this._addToTime = 2;
			this.cubesInHand = 2;
		}
		
		/* INTERFACE board.hands.IHand */
		
		public function chkMatch(arr:Vector.<CardData>):Boolean 
		{
			if (arr.length != cubesInHand) return false;
			if (gotBlock(arr)) return false;
			this.addToScore(arr);
			
			//if (arr[0].isJoker || arr[1].isJoker) return true;
			return HandComparer.compare(arr[0], arr[1])
		}
		
		
		
	}

}