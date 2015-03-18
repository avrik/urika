package game 
{
	import game.cards.CardData;
	import game.hands.Hand;
	import game.hands.Hand_FiveOfAKind;
	import game.hands.Hand_Flush;
	import game.hands.Hand_FourOfAKind;
	import game.hands.Hand_FullHouse;
	import game.hands.Hand_Pair;
	import game.hands.Hand_Pairs;
	import game.hands.Hand_Straight;
	import game.hands.Hand_StraightFlush;
	import game.hands.Hand_ThreeOfAKind;
	import game.hands.IHand;
	/**
	 * ...
	 * @author Avrik
	 */
	public class HandChecker 
	{
		private static var hands:Array =
		[
			new Hand_StraightFlush(),
			new Hand_Straight(),
			new Hand_Flush(),
			new Hand_FiveOfAKind(),
			new Hand_FullHouse(),
			new Hand_FourOfAKind(),
			new Hand_ThreeOfAKind(),
			new Hand_Pairs(),
			new Hand_Pair(),
		]
		
		public function HandChecker() 
		{
			
		}
		
		public static function chkIsHand(handArr:Vector.<CardData>):Hand
		{
			for each (var item:IHand in hands) 
			{
				if (item.chkMatch(handArr))
				{
					return item as Hand;
				}
			}
			
			return null;
		}
		
		public static function getHandsByIndex():Array
		{
			var arr:Array = new Array();
			arr = arr.concat(hands);
			
			
			
			return arr.sort(sortByIndex);
			
		}
		
		static private function sortByIndex(a:Hand, b:Hand):int 
		{
			if (a.index < b.index)
			{
				return -1
			} else if (a.index > b.index)
			{
				return 1
			} else
			{
				return 0;
			}
		}
		
		
		public static function getHandByIndex(index:int):Hand
		{
			return hands[index];
		}
	}

}