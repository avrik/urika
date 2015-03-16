package game.hands
{
	import game.cards.CardData;
	
	public class Hand_FiveOfAKind extends Hand implements IHand
	{
		public function Hand_FiveOfAKind()
		{
			super();
			this._index = 9;
			this._scoreWorth = 150;
			this._name = "Five of a kind";
			this.cubesInHand = 5;
			
			this._addToTime = 25;
		}
		
		public function chkMatch(arr:Vector.<CardData>):Boolean
		{
			if (arr.length != cubesInHand) return false;
			if (!arr || !arr.length) return false;
			if (gotBlock(arr)) return false;
			this.addToScore(arr);
			
			/*for (var i:int = 1; i < arr.length; i++)
			{
				//if (arr[i].number != arr[0].number && (!arr[i].isJoker && !arr[0].isJoker))
				if (!HandComparer.compare(arr[i], arr[0]))
				{
					return false;
				}
			}
			
			return true;*/
			
			return HandComparer.compareArr(arr);
		}
	}
}