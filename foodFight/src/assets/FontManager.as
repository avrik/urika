package assets 
{
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Avrik
	 */
	public class FontManager 
	{
		[Embed(source="../../lib/fonts/badaboomBM.fnt", mimeType="application/octet-stream")]
		public static const FontXml:Class;
		 
		[Embed(source="../../lib/fonts/badaboomBM_0.png")]
		public static const FontTexture:Class;
		
		static public var Badaboom:String = "BadaBoom BB";
		

		public function FontManager() 
		{
 
			
		}
		
		public static function setFont():void
		{
			
			var texture:Texture = Texture.fromBitmap(new FontTexture());
			var xml:XML = XML(new FontXml());
			TextField.registerBitmapFont(new BitmapFont(texture, xml));
		}

		
	}

}