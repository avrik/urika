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
		[Embed(source="../../lib/fonts/Optficio.fnt", mimeType="application/octet-stream")]
		private static const OptficioXml:Class;
		 

		[Embed(source="../../lib/fonts/Optficio_0.png")]
		private static const OptficioTexture:Class;
		
		
		
		[Embed(source="../../lib/fonts/arcade.fnt", mimeType="application/octet-stream")]
		private static const ArcadeXml:Class;

		[Embed(source="../../lib/fonts/arcade_0.png")]
		private static const ArcadeTexture:Class;
		
		
		[Embed(source = "../../lib/fonts/Disco.fnt", mimeType = "application/octet-stream")]
		private static const DiscoXml:Class;

		[Embed(source="../../lib/fonts/Disco_0.png")]
		private static const DiscoTexture:Class;
		
		
		static public var Opificio:String = "Opificio";
		static public var Arcade:String = "Arcade";
		static public var BubbleGum:String = "BubbleGum";

		public static function setFonts():void
		{
			
			
			var texture2:Texture = Texture.fromBitmap(new ArcadeTexture());
			var xml2:XML = XML(new ArcadeXml());
			TextField.registerBitmapFont(new BitmapFont(texture2, xml2));
			
			var texture:Texture = Texture.fromBitmap(new OptficioTexture());
			var xml:XML = XML(new OptficioXml());
			TextField.registerBitmapFont(new BitmapFont(texture, xml));
			
			
			var texture3:Texture = Texture.fromBitmap(new DiscoTexture());
			var xml3:XML = XML(new DiscoXml());
			TextField.registerBitmapFont(new BitmapFont(texture3, xml3));
		}
		
	}

}