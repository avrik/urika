package preloader 
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