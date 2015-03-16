package game.hands 
{
	import game.cards.CardData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Hand_ThreeOfAKind extends Hand implements IHand
	{
		
		public function Hand_ThreeOfAKind() 
		{
			this._index = 3;
			this._scoreWorth = 20;
			this._name="Three of a Kind";
			this.cubesInHand = 3;
			this._addToTime = 5;
		}
		
		/* INTERFACE board.hands.IHand */
		
		public function chkMatch(arr:Vector.<CardData>):Boolean 
		{
			if (arr.length != cubesInHand) return false;
			if (gotBlock(arr)) return false;
			this.addToScore(arr);
			
			/*if (HandComparer.compareArr(arr)) {
				return true;
			} else
			{
				return false;
			}*/
			
			return HandComparer.compareArr(arr);

			//return (arr[0].number == arr[1].number &&  arr[1].number == arr[2].number)?true:false;
			
			//return true;
		}
		
	}

}