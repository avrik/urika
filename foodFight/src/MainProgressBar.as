package 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import starling.animation.DelayedCall;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
    

    public class MainProgressBar extends Sprite
    {
        private var mBar:Quad;
        private var mBackground:Image;
        
        public function MainProgressBar(width:int, height:int)
        {
            init(width, height);
        }
        
        private function init(width:int, height:int):void
        {
            var scale:Number = Starling.contentScaleFactor;
            var padding:Number = height * 0.2;
            var cornerRadius:Number = padding * scale * 2;
            
            // create black rounded box for background
            
            var bgShape:Shape = new Shape();
            bgShape.graphics.beginFill(0x0, 0.6);
            bgShape.graphics.drawRoundRect(0, 0, width*scale, height*scale, cornerRadius, cornerRadius);
            bgShape.graphics.endFill();
            
            var bgBitmapData:BitmapData = new BitmapData(width * scale, height * scale, true, 0x0);
            bgBitmapData.draw(bgShape);
            var bgTexture:Texture = Texture.fromBitmapData(bgBitmapData, false, false, scale);
            
            mBackground = new Image(bgTexture);
            addChild(mBackground);
            
            // create progress bar quad
            
            mBar = new Quad(width - 2 * padding, height - 2 * padding, 0xff00c0);
           // mBar.setVertexColor(2, 0xff00c0);
           // mBar.setVertexColor(3, 0xaaaaaa);
            mBar.x = padding;
            mBar.y = padding;
            mBar.scaleX = 0;
            addChild(mBar);
			
			ratio = 0;
			
			
			
			/*var progress:ProgressBar = new ProgressBar();
			progress.minimum = 0;
			progress.maximum = 100;
			progress.value = 10;
			var bgImg:Image=new Image(Texture.fromBitmap(new ProgreesBarBase, false, false, sAssets.scaleFactor));
			progress.backgroundSkin = bgImg
			
			var bgShape:Shape = new Shape();
            bgShape.graphics.beginFill(0xff00c0, 0.8);
            bgShape.graphics.drawRoundRect(0, 0, 100, 50,30,30);
            bgShape.graphics.endFill();
            
            var bgBitmapData:BitmapData = new BitmapData(bgShape.width, bgShape.height, true, 0xff00c0);
            bgBitmapData.draw(bgShape);
           // var fillTexture:Scale9Textures = Texture.fromBitmapData(bgBitmapData, false, false);
            var fillTexture:Scale9Textures = new Scale9Textures(Texture.fromBitmapData(bgBitmapData, false, false),new Rectangle(20,5,bgShape.width-20,bgShape.height-5))
            
			
			var fillSkin:Scale9Image = new Scale9Image(fillTexture);
			fillSkin.width = 150;
			
			progress.fillSkin = fillSkin
			progress.paddingTop = 12;
			progress.paddingRight = 15
			progress.paddingBottom = 12;
			progress.paddingLeft = 8;
			
			addChild(progress);
			progress.pivotX = bgImg.width / 2;
			progress.x = (stage.stageWidth)/2;
			progress.y = (stage.stageHeight) - 200;*/
			var dc:DelayedCall = new DelayedCall(addRatio,.2)
			dc.repeatCount = 10;
			Starling.juggler.add(dc);
			
        }
		
		private function addRatio():void 
		{
			ratio += .2;
		}
        
        public function get ratio():Number { return mBar.scaleX; }
        public function set ratio(value:Number):void 
        { 
            mBar.scaleX = Math.max(0.0, Math.min(1.0, value)); 
        }
    }
}