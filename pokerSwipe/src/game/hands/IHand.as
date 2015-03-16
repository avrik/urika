package game.hands 
{
	import game.cards.CardData;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public interface IHand 
	{
		function chkMatch(arr:Vector.<CardData>):Boolean
	}
	
}