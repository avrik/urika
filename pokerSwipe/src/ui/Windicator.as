package ui 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Avrik
	 */
	public class Windicator extends ViewComponent 
	{
		private var _amount:int;
		private var _tf:TextField;
		private var _tween:Tween;
		private var _sprite:Sprite;
		private var _handName:String;
		
		public function Windicator(amount:int, handName:String) 
		{
			this._handName = handName;
			_sprite = new Sprite();
			addChild(_sprite);
			this._amount = amount;
			
			if (_handName != "")
			{
				this.scaleX = this.scaleY = 2;
			}
			
			
		}
		
		override protected function init():void 
		{
			super.init();
			
			var img:Image = new Image(TopLevel.assets.getTexture(AssetsEnum.WINDICATOR));
			_sprite.addChild(img);
			
			this.touchable = false;
			
			img.pivotX = img.width >> 1;
			img.pivotY = img.height >> 1;
			
			//var str:String = _handName != ""?  _handName + " " + this._amount.toString() :this._amount.toString();
			var str:String = this._amount.toString();
			_tf = new TextField(this.width - 10, this.height - 10, str , FontManager.Opificio, -1, 0xECB036);
			_tf.autoScale = true;
			_tf.x = 5;
			_tf.y = 5;
			_tf.pivotX = _tf.width >> 1;
			_tf.pivotY = _tf.height >> 1;
			
			_sprite.addChild(_tf);
			
			showAnimation();
		}
		
		private function showAnimation():void 
		{
			_sprite.scaleX = _sprite.scaleY = 0;
			
			_tween = new Tween(_sprite, .5, Transitions.EASE_OUT_BACK)
			_tween.scaleTo(1);
			
			/*_tween.onComplete = function():void
			{
				_tween = new Tween(_sprite, .5, Transitions.EASE_IN_BACK);
				//_tween.delay = .2;
				_tween.animate("y", _sprite.y - 150);
				
				//_tween.fadeTo(0);
				//_tween.onComplete = destroy;
				
				Starling.juggler.add(_tween);
			}*/
			
			Starling.juggler.add(_tween);
		}
		
		private function destroy():void 
		{
			this.removeFromParent(true);
		}
		
		
		
	}

}