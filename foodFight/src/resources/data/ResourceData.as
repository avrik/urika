package resources.data 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class ResourceData 
	{
		public var name:String;
		public var code:String;
		public var url:String;
		
		public function ResourceData(data:Object) 
		{
			this.name = data.@name;
			this.code = data.@code;
			this.url = data.@url;
		}
		
	}

}