package assets 
{
	import com.greensock.loading.ImageLoader;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Avrik
	 */
	public class AssetsLoader 
	{
		[Embed(source = "../../lib/assets/bg2.jpg")]
		private static var gameBG:Class;
		
		[Embed(source="../../lib/assets/windicator.png")]
		private static var windicator:Class;
		
		//[Embed(source = "../../lib/assets/cubeSS.png")]
		[Embed(source = "../../lib/assets/cubeSS.png")]
		private static var cubeSS:Class;
		
		//[Embed(source = "../../lib/assets/cubeSS.xml",mimeType="application/octet-stream")]
		[Embed(source = "../../lib/assets/cubeSS.xml",mimeType="application/octet-stream")]
		private static var cubeSS_Data:Class;
		
		
		//[Embed(source = "../../lib/assets/cubeSS.png")]
		[Embed(source = "../../lib/assets/cubeSS_SD.png")]
		private static var cubeSS_SD:Class;
		
		//[Embed(source = "../../lib/assets/cubeSS.xml",mimeType="application/octet-stream")]
		[Embed(source = "../../lib/assets/cubeSS_SD.xml",mimeType="application/octet-stream")]
		private static var cubeSS_Data_SD:Class;
		
		
		
		[Embed(source="../../lib/assets/timerSS.png")]
		private static var timerSS:Class;
		
		[Embed(source = "../../lib/assets/timerSS.xml",mimeType="application/octet-stream")]
		private static var timerSS_Data:Class;
		
		[Embed(source="../../lib/assets/timerSS_SD.png")]
		private static var timerSS_SD:Class;
		
		[Embed(source = "../../lib/assets/timerSS_SD.xml",mimeType="application/octet-stream")]
		private static var timerSS_Data_SD:Class;
		
		
		
		
		
		[Embed(source="../../lib/assets/butnsSS.png")]
		private static var butnsSS:Class;
		
		[Embed(source = "../../lib/assets/butnsSS.xml",mimeType="application/octet-stream")]
		private static var butnsSS_Data:Class;
		
		
		[Embed(source="../../lib/assets/gameFrame.png")]
		private static var frameSS:Class;
		
		[Embed(source = "../../lib/assets/gameFrame.xml",mimeType="application/octet-stream")]
		private static var frameSS_Data:Class;
		
		public function AssetsLoader() 
		{
			
		}
		
		public static  function loadAssets(scaleFactor:int):void
		{
			//Tracer.alert("SCALE FACTOR === " + scaleFactor);
			//var cubeTexture:Texture = scaleFactor == 1?Texture.fromBitmap(new cubeSS_SD()):Texture.fromBitmap(new cubeSS(),true,false,scaleFactor);
			//var cubeData:XML = scaleFactor == 1?XML(new cubeSS_Data_SD()):XML(new cubeSS_Data());
			
			
			var cubeTexture:Texture = Texture.fromBitmap(new cubeSS(),true,false,scaleFactor);
			var cubeData:XML = XML(new cubeSS_Data());
			
			var cubeTextureAtlas:TextureAtlas = new TextureAtlas(cubeTexture , cubeData);
			TopLevel.assets.addTextureAtlas(AssetsEnum.CUBE_SS, cubeTextureAtlas);

			//var timerTexture:Texture = TopLevel.assets.scaleFactor == 1?Texture.fromBitmap(new timerSS_SD()):Texture.fromBitmap(new timerSS(),true,false,scaleFactor);
			//var timerData:XML = TopLevel.assets.scaleFactor == 1?XML(new timerSS_Data_SD()):XML(new timerSS_Data());
			
			var timerTexture:Texture = Texture.fromBitmap(new timerSS(),true,false,scaleFactor);
			var timerData:XML = XML(new timerSS_Data());
			
			var timerTextureAtlas:TextureAtlas = new TextureAtlas(timerTexture , timerData);
			TopLevel.assets.addTextureAtlas(AssetsEnum.TIMER_SS, timerTextureAtlas);
			
			var butnsTextureAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new butnsSS()) , XML(new butnsSS_Data()));
			TopLevel.assets.addTextureAtlas(AssetsEnum.BUTNS_SS, butnsTextureAtlas);
			
			var frameTextureAtlas:TextureAtlas = new TextureAtlas(Texture.fromBitmap(new frameSS()) , XML(new frameSS_Data()));
			TopLevel.assets.addTextureAtlas(AssetsEnum.GAME_FRAME_SS, frameTextureAtlas);
			
			TopLevel.assets.addTexture(AssetsEnum.GAME_BG, getTexture(gameBG));
			TopLevel.assets.addTexture(AssetsEnum.WINDICATOR, getTexture(windicator));
			
		}
		
		private static function getTexture(bitmap:Class):Texture
		{
			return Texture.fromBitmap(new bitmap, false, false, TopLevel.assets.scaleFactor);
		}
		
	}

}