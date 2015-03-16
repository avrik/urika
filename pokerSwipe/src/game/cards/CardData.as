package game.cards
{
	public class CardData
	{
		static public const JOKER_NUM:int = 52;
		static public const BLOCK_NUM:int = 53;
		
		public var _totalNumbersForSuit:int = 13;
		
		private var color:uint;
		private var _number:int;
		private var _suit:String
		private var _typeNumber:int;
		private var _scoreWorth:int;
		public var isJoker:Boolean;
		public var isBlock:Boolean;
		
		//public function CardData(totalNumbersForSuit:int = 13)
		public function CardData(num:int)
		{
			//_totalNumbersForSuit = totalNumbersForSuit;

			typeNumber = num;
		}
		
		public function get typeNumber():int 
		{
			return _typeNumber;
		}
		
		public function set typeNumber(value:int):void 
		{
			_typeNumber = value;
			
			if (_typeNumber < totalRegularCards())
			{
				this._number = _typeNumber % _totalNumbersForSuit;
				this._scoreWorth = this._number + 2;
				
				if (value < 13)
				{
					this._suit = SuitEnum.SPADES;
				} else if (value < 26)
				{
					this._suit = SuitEnum.HEARTS;
				} else if (value < 39)
				{
					this._suit = SuitEnum.CLUBS;
				} else if (value < 52)
				{
					this._suit = SuitEnum.DIAMONDS;
				}
				//this._suit = String(_typeNumber % 4);
			} else if (_typeNumber == JOKER_NUM)
			{
				isJoker = true;
				this._scoreWorth = 15;
			//} else if (_typeNumber > totalRegularCards())
			} else if (_typeNumber >= BLOCK_NUM)
			{
				isBlock = true;
				this._scoreWorth = 20;
			}
		}
		
		public function setNumberAndSuit(num:int, suitId:int):void
		{
			this._number = num;
			switch (suitId) 
			{
				case 0:
					this._suit = SuitEnum.SPADES;
					break;
				case 1:
					this._suit = SuitEnum.HEARTS;
					break;
				case 2:
					this._suit = SuitEnum.CLUBS;
					break;
				case 3:
					this._suit = SuitEnum.DIAMONDS;
					break;

			}
		}
		
		private function totalRegularCards():int 
		{
			return _totalNumbersForSuit * 4;
		}
		
		public function get number():int 
		{
			return _number;
		}
		
		public function get suit():String 
		{
			return _suit;
		}
		
		public function get scoreWorth():int 
		{
			return _scoreWorth;
		}
	}
}