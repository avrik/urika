package game.hands 
{
	import game.cards.CardData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class HandComparer 
	{
		static public const MATCH_NUMBER:String = "matchNumber";
		static public const MATCH_ALL:String = "matchAll";
		static public const MATCH_SUIT:String = "matchSuit";
		static public const DESCENDING:String = "descending";
		static public const ASCENDING:String = "ascending";
		

		public static function compare(a:CardData, b:CardData, matchBy:String = MATCH_NUMBER):Boolean
		{
			if (a.isJoker || b.isJoker) return true;
			
			switch (matchBy) 
			{
				case MATCH_NUMBER:
					if (a.number == b.number) return true;
					break;
				case MATCH_SUIT:
					if (a.suit == b.suit) return true;
					break;
				case MATCH_ALL:
					if (a.suit == b.suit && a.number == b.number) return true;
					break;	
				case ASCENDING:
					if (a.number == 0 && b.number == 12) return true;
					if (a.number == (b.number + 1)) return true;
					break;
				case DESCENDING:
					if (a.number == 12 && b.number == 0) return true;
					if (a.number == (b.number - 1)) return true;
					break;
			}
			
			return false;
		}
		
		static public function compareArr(arr:Vector.<CardData>):Boolean 
		{
			var length:int = arr.length;
			for (var i:int = 1; i <length ; ++i) 
			{
				if (!compare(arr[i], arr[i - 1]) || !compare(arr[i], arr[0]))
				{
					return false;
				}
			}
			
			return true;
		}
		
	}

}