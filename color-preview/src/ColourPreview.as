package
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	[SWF(frameRate = "8", width="240", height="180")]
	public class ColourPreview extends Sprite
	{
		public var copyDown:Boolean;
		public var vDown:Boolean;
		private var prevString:String = "";
		private var _squares:Array;
		private var squareSize:int = 30;
		private var margin:int = 3;
		private var colours:Array;
		private var bmp:Bitmap;
		private var rect:Sprite;
		
		public function ColourPreview()
		{
			stage.align = "TL";
			stage.scaleMode = "noScale";
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.nativeWindow.alwaysInFront = true;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			bmp = new Bitmap(new BitmapData(1,1,false, 0x00000000));
			
			rect = new Sprite();
			//rect.graphics.beginFill(0xFFFFFF, 1);
			rect.graphics.lineStyle(3,0x000000,1);
			rect.graphics.drawRect(0,0,squareSize,squareSize);
			rect.graphics.endFill();
			addChild(rect);
		}
		
		protected function onMouseMove(e:MouseEvent):void
		{
			var mtx:Matrix = new Matrix();
			mtx.tx = -mouseX;
			mtx.ty = -mouseY;
			
			bmp.bitmapData.draw(this, mtx);
			stage.nativeWindow.title = "#"+bmp.bitmapData.getPixel(0,0).toString(16);
			
			rect.x = mouseX - mouseX%squareSize;
			rect.y = mouseY - mouseY%squareSize;
		}
		
		protected function onEnterFrame(e:Event):void
		{
			if(Clipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)) {
				var clipboardtextvalue:String = String(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT));
				//trace(clipboardtextvalue);
				
				//var colourIndex:int = clipboardtextvalue.indexOf("0x");
				//var colour:String = colourIndex == -1 ? "" : clipboardtextvalue.substring(colourIndex, 8);
				//trace(colour);
				
				_findColours(clipboardtextvalue);
				/*
				if(colour != "") {
					graphics.clear();
					graphics.beginFill(uint(colour), 1);
					graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);
					graphics.endFill();
					
					stage.nativeWindow.title = colour;
				}
				*/
				//trace(clipboardtextvalue);
			}
		}
		
		private function _makeColour():Sprite
		{
			var s:Sprite = new Sprite();
			var tf:TextField = new TextField();
			tf.text = "col";
			tf.setTextFormat(new TextFormat("arial", 11, 0x000000));
			
			s.addChild(tf);
			return s;
		}
		
		private function _findColours(clipboard:String):void
		{
			if(clipboard == prevString) return void;
			
			//var results:int = clipboard.search("#" || "0x");
			//trace(results);
			colours = [];
			var r:RegExp = /\#|0x/g;
			var match:Object;
			while((match = r.exec(clipboard)) != null)
			{
				var colour:String = clipboard.substr(match.index, match[0].length + 6);
				colours.push(colour);
			}
			
			if(!colours.length) return void;
			
			trace(colours);
			graphics.clear();
			
			var i:int = 0;
			var cols:int = Math.max(5, Math.floor(colours.length/2));
			
			while(colours.length) {
				for(var j:int = 0; j < cols; ++j) {
					if(colours.length) {
						var colourInt:uint = uint(colours.shift());
						graphics.beginFill(colourInt, 1);
						graphics.drawRect(j*squareSize,i*squareSize,squareSize, squareSize);
						graphics.endFill();
					} else {
						break;
					}
				}
				
				++i;
			}
			
			stage.nativeWindow.width = Math.max(240, cols*squareSize);
			stage.nativeWindow.height = Math.max(180,(i+1)*squareSize);
			
			prevString = clipboard;
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.ESCAPE) {
				stage.nativeWindow.close();
			}
		}
		
		protected function onKeyUp(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.COMMAND) {
				copyDown = false;
			} else if (e.keyCode == Keyboard.V) {
				vDown = false;
			}
			
			if(copyDown == false && vDown == false) {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}
	}
}