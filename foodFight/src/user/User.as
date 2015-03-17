package user 
{
	import flash.xml.XMLNodeType;
	import storedGameData.ISavedData;
	import flash.xml.XMLNode;
	import interfaces.IStorable;
	import storedGameData.SavedUserData;
	/**
	 * ...
	 * @author Avrik
	 */
	public class User implements IStorable
	{
		public var data:SavedUserData
		
		public function User(userData:SavedUserData) 
		{
			data = userData?userData:new SavedUserData();
		}
		
		/* INTERFACE interfaces.IStorable */
		
		public function getDataTranslateObject():XMLNode 
		{
			var userNode:XMLNode = new XMLNode(XMLNodeType.ELEMENT_NODE, "user");
			var userAtt:Object = new Object();
			userAtt.name = data.name;
			userAtt.level = data.level;
			userAtt.totalCredits = data.totalCredits;
			userAtt.totalScore = data.totalScore;
			userAtt.highScore = data.highScore;
			
			userNode.attributes = userAtt;
			return userNode;
		}
		
		public function translateBackFromData(data:ISavedData):void 
		{
			var translateData:SavedUserData = data as SavedUserData;
		}
		
	}

}