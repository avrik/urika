package urikatils 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class VectorUtils 
	{
		
		public function VectorUtils() 
		{
			
		}
		
		public static function randomize(vec:Vector.<Object>):Vector.<Object>
		{
			var newVec:Vector.<Object>=vec.sort( shuffleVector );
			return newVec;
		}
		
		public static function shuffleVector(a:Object, b:Object):int
		{
			return Math.floor( Math.random() * 3 - 1 );
		}
	}

}