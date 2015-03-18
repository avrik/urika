package game.hands
{
	import game.cards.CardData;
	
	public class Hand_FourOfAKind extends Hand implements IHand
	{
		public function Hand_FourOfAKind()
		{
			super();
			this._index = 7;
			this._scoreWorth = 90;
			this._name = "Four of a kind";
			this.cubesInHand = 4;
			this._addToTime = 20;
		}
		
		public function chkMatch(arr:Vector.<CardData>):Boolean
		{
			if (arr.length != cubesInHand) return false;
			if (!arr || !arr.length) return false;
			if (gotBlock(arr)) return false;
			this.addToScore(arr);
			
			/*for (var i:int = 1; i < arr.length; i++)
			{
				//if (arr[i].number != arr[0].number)
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