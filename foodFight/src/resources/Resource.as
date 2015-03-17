package resources 
{
	import resources.data.ResourceData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Resource 
	{
		public var addPerTurn:int;
		private var _data:ResourceData;
		private var _amount:int;
		
		public function Resource(data:ResourceData) 
		{
			this._data = data;
			
		}
		
		public function get data():ResourceData 
		{
			return _data;
		}
		
		public function get amount():int 
		{
			return _amount;
		}
		
		public function set amount(value:int):void 
		{
			_amount = value;
		}
		
	}

}