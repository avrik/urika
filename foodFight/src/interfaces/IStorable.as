package interfaces 
{
	import flash.xml.XMLNode;
	import storedGameData.ISavedData;
	
	/**
	 * ...
	 * @author Avrik
	 */
	public interface IStorable 
	{
		function getDataTranslateObject():XMLNode
		function translateBackFromData(data:ISavedData):void
	}
	
}