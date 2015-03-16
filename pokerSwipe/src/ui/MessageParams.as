package ui
{
	
	/**
	 * ...
	 * @author Avrik
	 */
	public class MessageParams
	{
		public var bgColor:uint;
		public var fontColor:uint;
		public var fontSize:Number;
		
		public function MessageParams(bgColor:uint, fontColor:uint, fontSize:Number=-1)
		{
			this.fontSize = fontSize;
			this.bgColor = bgColor;
			this.fontColor = fontColor;
			
		}
	
	}

}