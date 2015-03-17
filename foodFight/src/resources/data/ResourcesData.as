package resources.data 
{
	/**
	 * ...
	 * @author Avrik
	 */
	public class ResourcesData 
	{
		public var resources:Vector.<ResourceData>;
		
		public function ResourcesData(data:Object) 
		{
			resources = new Vector.<ResourceData>;
			if (data.resource.length())
			{
				for (var i:int = 0; i < data.resource.length(); i++) 
				{
					resources.push(new ResourceData(data.resource[i]));
				}
			}
		}
		
	}

}