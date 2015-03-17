package gameWorld 
{
	import ascb.util.NumberUtilities;
	import gameWorld.territories.Territory;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Continent 
	{
		private var _territories:Vector.<Territory> = new Vector.<Territory>;
		
		public function Continent() 
		{
			
		}
		
		public function addTerritory(territory:Territory):void
		{
			territory.onContinent = this;
			this._territories.push(territory);
			
			for each (var item:Territory in territory.neighborsArr) 
			{
				if (!item.onContinent)
				{
					addTerritory(item);
				}
			}
		}
		
		public function getCoastTerritories():Vector.<Territory> 
		{
			var arr:Vector.<Territory> = new Vector.<Territory>;
			
			var length:int = _territories.length;
			
			for (var i:int = 0; i < length; ++i) 
			{
				if (_territories[i].isCoastTerriroty())
				{
					//return item;
					arr.push(_territories[i]);
				}
			}
			return arr;
		}
		
		public function getRandomCoastTerritory():Territory 
		{
			var arr:Vector.<Territory> = getCoastTerritories();
			if (arr.length)
			{
				return arr[NumberUtilities.random(0, arr.length - 1)];
			}
			
			
			return null;
		}
		
		public function get territories():Vector.<Territory> 
		{
			return _territories;
		}
		
	}

}