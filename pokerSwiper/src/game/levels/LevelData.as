package game.levels 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class LevelData 
	{
		public var totalPacks:int;
		public var totalNumbersInSuit:int;
		public var totalBlocks:int;
		public var scoreFactor:int;
		
		public function LevelData(index:int) 
		{
			//totalNumbersInSuit = 13;
			//scoreFactor = index > 1 ? index * 2:1;
			scoreFactor = index;
			totalPacks = 1;
			
			Tracer.alert("NEW LEVEL DATA == " +index);
			

			switch (index) 
			{
				case 1:
					totalNumbersInSuit = 7;
					totalBlocks = 0;
					totalPacks = 2;
				break;
				
				case 2:
					totalNumbersInSuit = 8;
					totalBlocks = 1;
				break;
				
				case 3:
					totalNumbersInSuit = 9;
					totalBlocks = 1;
				break;
				
				case 4:
				case 5:
					totalNumbersInSuit = 10;
					totalBlocks = 1;
				break;
				
				case 5:
				case 6:
				case 7:
					totalNumbersInSuit = 11;
					totalBlocks = 1;
				break;
				
				case 8:
				case 9:
				case 10:
					totalNumbersInSuit = 12;
					totalBlocks = 2;
				break;
				
				default:
					totalNumbersInSuit = 13;
					totalBlocks = 2;
			}
		}	
		
		public function getTotalCard():int
		{
			return totalNumbersInSuit * 4;
		}
	}
}