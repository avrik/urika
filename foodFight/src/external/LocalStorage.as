package external 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.xml.XMLDocument;
	/**
	 * ...
	 * @author Avrik
	 */
	public class LocalStorage 
	{
		
		public function LocalStorage() 
		{
			
		}
		
		//write an Object to a file
		/*static public function saveMap(map:Map):void {
			var object:Object = new Object();//create an object to store
			object.value =  map;// asObject.text; //set the text field value to the value property
			object.territories =  map.territories;// asObject.text; //set the text field value to the value property
			//create a file under the application storage folder
			var file:File = File.applicationStorageDirectory.resolvePath("urika.file");
			if (file.exists)
				file.deleteFile();
			var fileStream:FileStream = new FileStream(); //create a file stream
			fileStream.open(file, FileMode.WRITE);// and open the file for write
			fileStream.writeObject(object);//write the object to the file
			fileStream.close();
		}
		
		//read an object stored into a file
		static public function getSavedMap():void {
			//read the file
			var file:File = File.applicationStorageDirectory.resolvePath("urika.file");
			if (!file.exists) {
				Tracer.alert("There is no object saved!");
				return;
			}
			
			
			//create a file stream and open it for reading
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var object:Object = fileStream.readObject(); //read the object
			Tracer.alert("The text member has this value: " + object.value);
			Tracer.alert("The text member has this value 22: " + object.territories);
		}*/
		
		static public function saveGame(xmlStr:String):void 
		{
			var object:Object = new Object();//create an object to store
			object.lastGameXML =  xmlStr;// asObject.text; //set the text field value to the value property

			var file:File = File.applicationStorageDirectory.resolvePath("urika.file");
			if (file.exists)
				file.deleteFile();
			
			try
			{
				var fileStream:FileStream = new FileStream(); //create a file stream
				fileStream.open(file, FileMode.WRITE);// and open the file for write
				fileStream.writeObject(object);//write the object to the file
				fileStream.close();
			} catch (err:Error)
			{
				Tracer.alert(err.message);
			}
			
		}
		
		static public function loadSavedGame():XML {
			//read the file
			var file:File = File.applicationStorageDirectory.resolvePath("urika.file");
			if (!file.exists) {
				Tracer.alert("There is no object saved!");
				return null;
			}
			
			//create a file stream and open it for reading
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var object:Object = fileStream.readObject(); //read the object
			Tracer.alert("Game xml loaded: " + object.lastGameXML)
			
			var result:XMLDocument = new XMLDocument();
            result.ignoreWhite = true;
            result.parseXML(object.lastGameXML);

			return new XML(result.firstChild);
		}
		
		static public function clearStorage():void 
		{
			var file:File = File.applicationStorageDirectory.resolvePath("urika.file");
			if (file.exists)
				file.deleteFile();
		}
		
		
	}

}