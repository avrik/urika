package game.cubes 
{
	import assets.AssetsEnum;
	import assets.FontManager;
	import flash.geom.Point;
	import game.Board;
	import game.cards.CardData;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.phys.Material;
	import nape.shape.Polygon;
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import ui.ViewComponent;
	
	/**
	 * ...
	 * @author Avrik
	 */
	
	public class Cube extends ViewComponent
	{
		//public static var getCubeSize():int = 60;
		static public const TOUCH_ME:String = "touchMe";
		static public const DESTROY:String = "destroy";
		static public const DROP_COMPLETE:String = "dropComplete";
		
		public var xPos:int;
		public var yPos:int;
		private var _disable:Boolean;
		private var _marked:Boolean;
		//private var _view:CubeView;
		private var _body:Body;
		private var cubeMC:MovieClip;
		private var _id:int;
		private var p:Point;
		private var _cardData:CardData;
		private var img:Image;
		private var _imgNumer:int;
		private var sprite:Sprite;
		//private var _static:Boolean;
		//private var _markFrame:Sprite;
		private var _addBody:Boolean;
		private var scoreTf:TextField;
		private var _neighbors:Vector.<Cube> = new Vector.<Cube>;
		private var _destroyed:Boolean;
		//private var _tfTween:Tween;
		
		public function Cube(id:int=-1,addBody:Boolean=false) 
		{
			this._addBody = addBody;
			this._id = id;
			//_view = new CubeView();
			//_view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.touchable = false;
			cubeMC = new MovieClip(TopLevel.assets.getTextureAtlas(AssetsEnum.CUBE_SS).getTextures());
			
			//_static = false;
		}
		
		
		public static function getCubeSize():Number
		{
			//return 60 * TopLevel.assets.scaleFactor;
			return 120;
		}
		
		
		override protected function init():void 
		{
			super.init();
			
			/*_markFrame = new Sprite();
			var g:Graphics = new Graphics(_markFrame);
			g.lineStyle(2, Color.WHITE);
			g.drawRect(0, 0, getCubeSize(), getCubeSize());
			_markFrame.pivotX = _markFrame.width >> 1;
			_markFrame.pivotY = _markFrame.height >> 1;
			_markFrame.visible = false;*/

			img = new Image(cubeMC.getFrameTexture(0));
			img.pivotX = img.width >> 1;
			img.pivotY = img.height >> 1;
			this.x = getCubeSize() / 2;
			this.y = getCubeSize() / 2;

			sprite = new Sprite();
			
			addChild(sprite);
			sprite.addChild(img);
			//sprite.addChild(_markFrame);
			
			if (this._addBody)
			{
				setBody();
			}
			
			//scoreTf = new TextField(50, 50, "0", FontManager.Opificio, 25);
			scoreTf = new TextField(this.width, 80, "0", FontManager.BubbleGum, -.7);
			scoreTf.autoScale = true;
			scoreTf.vAlign = VAlign.TOP;
			scoreTf.hAlign = HAlign.LEFT;

			scoreTf.color = 0xEBB035;
			scoreTf.x = -this.width / 4;
			//scoreTf.y = this.height/2 * -1 + 2;
			scoreTf.y = this.height - 50;
			
			scoreTf.touchable = false;
		}
		
		private function setBody():void
		{
			_body = new Body(BodyType.DYNAMIC, new Vec2(0,0));
			_body.shapes.add(new Polygon(Polygon.rect(this.parent.parent.x, this.parent.parent.y, getCubeSize(), getCubeSize()), new Material(.1)));
			
			_body.space = Board.space;
			_body.graphic = sprite;
			_body.graphicUpdate = onUpadte;
			_body.allowRotation = false;
			_body.allowMovement = true;
		}
		
		public function get imgNumer():int 
		{
			return _imgNumer;
		}
		
		public function set imgNumer(value:int):void 
		{
			_imgNumer = value;
			//Tracer.alert("IMG NUM === " + value)
			img.texture = cubeMC.getFrameTexture(value + 1);
			_cardData.typeNumber = value;
		}
		
		public function destroy():void 
		{
			//Board.space.bodies.remove(_body);
			if (!_destroyed)
			{
				_destroyed = true;
				
				var tween:Tween = new Tween(img,.3, Transitions.EASE_OUT);
				tween.scaleTo(.2);
				tween.fadeTo(0);
				tween.onComplete = destroyComplete;
				Starling.juggler.add(tween);
			}
			
		}
		
		public function showScore():void 
		{
			sprite.addChild(scoreTf);
			scoreTf.text = "+" + this._cardData.scoreWorth;
		}
		
		public function addNeighbor(cube:Cube):void 
		{
			_neighbors.push(cube);
		}
		
		public function clearNeighbors():void 
		{
			this._neighbors = new Vector.<Cube>();
		}
		
		private function destroyComplete():void 
		{
			Board.space.bodies.remove(_body);
			
			Starling.juggler.add(new DelayedCall(removeMe, .3));
			dispatchEvent(new Event(DESTROY))
			
		}
		
		private function removeMe():void 
		{
			removeFromParent(true);
		}
		
		private function onUpadte(b:Body):void 
		{
			/*if (b.graphic.y == b.position.y)
			{
				if (!_static)
				{
					//trace("STOPED");
					_static = true;
					dispatchEvent(new Event(DROP_COMPLETE));
				}
			} else
			{
				_static = false;
			}*/
			
			
			b.graphic.x = b.position.x
			b.graphic.y = b.position.y
			//b.graphic.rotation = b.rotation
			
		}
		

		/*private function addedToStage(e:Event):void 
		{
			_view.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			
		}
		
		public function get view():CubeView 
		{
			return _view;
		}*/
		
		public function get body():Body 
		{
			return _body;
		}
		
		/*public function get cubeId():int 
		{
			return _cubeId;
		}*/
		
		public function markNeighbors():void
		{
			for each (var item:Cube in _neighbors) 
			{
				item.marked = true;
			}
		}
		
		
		public function set marked(value:Boolean):void 
		{
			_marked = value;
			
			//this.alpha = value?.8:1;
			//img.scaleX = img.scaleY = value?1.1:1;
			//_markFrame.visible = value;
			
			if (value)
			{
				/*img.setVertexColor(0, 0xFFBE3A);
				img.setVertexColor(1, 0xFFBE3A);
				img.setVertexColor(2, 0xFFBE3A);
				img.setVertexColor(3, 0xFFBE3A);*/
				img.color = 0xFFE9BD;
				//img.setVertexColor(1, 0);
				//img.setVertexAlpha(0, .5);
				//img.setVertexAlpha(3, .5);
				bringToFront();
			} else
			{
				/*img.setVertexColor(0, 0xffffff);
				img.setVertexColor(1, 0xffffff);
				img.setVertexColor(2, 0xffffff);
				img.setVertexColor(3, 0xffffff);*/
				//img.setVertexColor(1, 0xffffff);
				img.color = 0xffffff;
				//img.setVertexAlpha(0, 1);
				//img.setVertexAlpha(3, 1);
			}
		}
		
		public function get marked():Boolean 
		{
			return _marked;
		}
		
		public function get cardData():CardData 
		{
			return _cardData;
		}
		
		public function set cardData(value:CardData):void 
		{
			_cardData = value;
			imgNumer = value.typeNumber;
		}
		
		
		
		
		public function set disable(value:Boolean):void 
		{
			_disable = value;
			img.texture = cubeMC.getFrameTexture(value?0:_imgNumer + 1);
			//img.alpha = value?0:1;
			//img.color = value?0:;
			//img.blendMode = value?BlendMode.ERASE:BlendMode.NONE;
		}
		
		/*public function get isStatic():Boolean 
		{
			return _static;
		}*/
		
		
		
		
		
	}

}