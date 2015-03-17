package ui.windows.store.data 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class StoreData_Item 
	{
		public var name:String;
		public var code:int;
		public var price:int;
		public var description:String;
		public var bonusType:int;
		public var id:int;
		
		public function StoreData_Item(data:Object) 
		{
			if (data)
			{
				this.id = data.@id;
				this.name = data.@name;
				this.code = parseInt(data.@code);
				this.bonusType = parseInt(data.@bonusType);
				this.price = parseInt(data.@price);
				this.description = data.@description;
			}
		}
		
	}

}