package
{
	import com.stardotstar.utils.CustomEvent;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class PolyPoint extends Sprite
	{
		private var highlight:Boolean;
		public var group:int = 0;
		public var tf:TextField;
		private var col:uint;
		
		public function PolyPoint(col:uint = 0x00ff00, group:int = 0)
		{
			super();
			this.group = group;
			this.col = col;
			
			mouseChildren = false;
			
			tf = new TextField();
			tf.autoSize = "center";
			tf.defaultTextFormat = new TextFormat(null, 14, 0x000000);
			tf.x = -(tf.textWidth>>1);
			tf.y = -(tf.textHeight>>1) - 10;
			addChild(tf);
			tf.mouseEnabled = mouseChildren = false;
			tf.selectable = false;
			
			this.id = id;
			
			drawCircle(col, 0.6);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		protected function onMouseOver(e:MouseEvent):void
		{
			drawCircle(0xffffff, 1);
		}
		
		protected function onMouseOut(e:MouseEvent):void
		{
			if(highlight) {
				selected();
			} else {
				deselect();
			}
		}
		
		public function drawCircle(col:uint, a:Number):void
		{
			graphics.clear();
			//graphics.lineStyle(2, col, a, true);
			graphics.beginFill(col, 0.0);
			graphics.drawCircle(0,0,10);
			graphics.beginFill(col, a);
			graphics.drawCircle(0,0,5);
			graphics.beginFill(0x000000,1);
			graphics.drawCircle(0,0,1);
			graphics.endFill();
		}
		
		public function selected():void
		{
			drawCircle(col, .3);
			scaleX = scaleY = 1.5;
			highlight = true;
		}
		
		public function deselect():void
		{
			drawCircle(col, 0.6);
			scaleX = scaleY = 1;
			highlight = false;
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			this.startDrag(false);
			dispatchEvent(new CustomEvent("DOT_SELECTED", {group:group}, true, true));
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			this.stopDrag();
			dispatchEvent(new CustomEvent("DOT_MOVED", {group:group}, true, true));
		}
		
		public function set id(i:int):void
		{
			tf.text = String(i);
			tf.x = -(tf.textWidth>>1) - 2;
			tf.y = -(tf.textHeight>>1) - 20;
		}
		
		public function get id():int
		{
			return int(tf.text);
		}
	}
}