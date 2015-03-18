package game 
{
	import game.cards.CardData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Deck 
	{
		private var _cardsArr:Vector.<CardData> 
		private var _cardsInSuit:int;
		
		
		public function Deck() 
		{
			//Tracer.alert("  ------ NEW PACK -------" + cardsInSuit);
			//this._cardsInSuit = cardsInSuit;
			newPack();
		}
		
		private function newPack():void
		{
			var cardsInSuit:int = Application.game.onLevel.levelData.totalNumbersInSuit;
			var totalPacks:int = Application.game.onLevel.levelData.totalPacks;
			Tracer.alert(" ----------------- NEW PACK  === " + cardsInSuit);
			_cardsArr = new Vector.<CardData>;

			var cardData:CardData;
			
			for (var l:int = 0; l < totalPacks; l++) 
			{
				for (var i:int = 0; i < 4; ++i) 
				{
					for (var j:int = 0; j < cardsInSuit; ++j) 
					{
						//cardData = new CardData((i * 13) + j + (12 - cardsInSuit));
						cardData = new CardData((i * 13) + j + (13 - cardsInSuit));
						_cardsArr.push(cardData);
					}
				}
				
				_cardsArr.push(new CardData(CardData.JOKER_NUM));
				
				for (var k:int = 0; k < Application.game.onLevel.levelData.totalBlocks ; ++k)
				{
					_cardsArr.push(new CardData(CardData.BLOCK_NUM));
				}
			}
			
			
			
			//_cardsArr.reverse();
			shuffle();
		}
		
		public function shuffle():void
		{
			_cardsArr.sort(sortByRandom);
		}
		
		private function sortByRandom(a:CardData, b:CardData):int
		{
			return Math.floor( Math.random() * 3 - 1 );
		}
		
		public function getCard():CardData
		{
			if (!_cardsArr.length)
			{
				Application.game.newLevel();
				newPack();
			}
			
			//Tracer.alert("CARDS LEFT === " + _cardsArr.length);
			
			Application.game.hud.updateCardsLeft(_cardsArr.length);
			return _cardsArr.pop();
		}
		
		
		/*public function get cardsArr():Vector.<CardData> 
		{
			return _cardsArr;
		}*/
		
	}

}