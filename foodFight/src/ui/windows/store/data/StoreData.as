package ui.windows.store.data 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class StoreData 
	{
		public var categories:Vector.<StoreData_Category>;
		public var items:Vector.<StoreData_Item>
		
		public function StoreData(data:Object) 
		{
			if (data)
			{
				var length:int = data.category.length();
				if (length)
				{
					categories = new Vector.<StoreData_Category>;
					items = new Vector.<StoreData_Item>;
					
					var cat:StoreData_Category
					for (var i:int = 0; i <length ; ++i) 
					{
						cat = new StoreData_Category(data.category[i]);
						categories.push(cat);
						
						items = items.concat(cat.items);
					}
				}
			}
		}
		
	}

}