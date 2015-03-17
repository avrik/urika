package debug 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class CheatData 
	{
		public var strongest:Boolean;
		public var richest:Boolean;
		public var unlimitedMoves:Boolean;
		
		public function CheatData(data:Object) 
		{
			CONFIG::debug
			{
				if (data)
				{
					strongest = data.strongest == "true"?true:false;
					richest = data.richest == "true"?true:false;
					unlimitedMoves = data.unlimitedMoves == "true"?true:false;
				}
			}
			
		}
		
	}

}