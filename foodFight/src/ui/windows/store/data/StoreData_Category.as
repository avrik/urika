package ui.windows.store.data 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class StoreData_Category 
	{
		public var items:Vector.<StoreData_Item>
		public var name:String;
		
		public function StoreData_Category(data:Object)
		{
			var length:int = data.item.length();
			name = data.@name;
			if (length)
			{
				items = new Vector.<StoreData_Item>;
				for (var i:int = 0; i <length ; ++i) 
				{
					items.push(new StoreData_Item(data.item[i]));
				}
			}
		}
		
	}

}