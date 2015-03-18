package game.hands 
{
	import game.cards.CardData;
	import game.cards.CardData;

	/**
	 * ...
	 * @author Avrik
	 */
	public class Hand 
	{
		static public const NUMBER:String = "number";
		
		internal var cubesInHand:int;
		internal var _scoreWorth:Number;
		internal var _name:String;
		internal var _score:Number;
		internal var _addToTime:int;
		internal var _index:int;
		
		public function Hand() 
		{
			
		}
		
		protected function addToScore(arr:Vector.<CardData>):void
		{
			this._score = this._scoreWorth;
			for each (var item:CardData in arr) 
			{
				this._score += item.scoreWorth;
			}
		}
		
		protected function gotBlock(arr:Vector.<CardData>):Boolean {
			for each (var item:CardData in arr) 
			{
				if (item.isBlock) return true;
			}
			
			return false;
		}
		
		
		protected function oneIsJoker(a:CardData, b:CardData):Boolean
		{
			return (a.isJoker || b.isJoker)?true:false;
		}
		
		protected function compare(a:CardData, b:CardData, by:String = "Number"):Boolean
		{
			if (a.isJoker || b.isJoker) return true;
			if (a.number == b.number) return true;
			
			return false;
		}
		
		
		public function get scoreWorth():Number 
		{
			return _scoreWorth;
		}

		public function get name():String
		{
			return _name;
		}
		
		public function get score():Number
		{
			return _score;
		}
		
		public function get addToTime():Number 
		{
			return _addToTime;
		}
		
		public function get index():int 
		{
			return _index;
		}

		
	}

}