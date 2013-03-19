package
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.bit101.components.Window;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.stardotstar.utils.CustomEvent;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	
	[SWF(width="944", height="577", frameRate="60", backgroundColor="0x777777")] 
	public class PhysicsEditor extends Sprite
	{
		private var title:String = "BIG BONE EDITOR";
		private var win:Window;
		private var loadImgBtn:PushButton;
		private var loadDataBtn:PushButton;
		private var imgFile:File;
		private var imgFilter:FileFilter;
		private var img:ImageLoader;
		private var saveDataBtn:PushButton;
		private var points:PointCanvas;
		private var container:Sprite;
		private var copyBtn:PushButton;
		private var pasteBtn:PushButton;
		private var clearAll:PushButton;
		private var info:Label;
		private var mouseInfo:Label;
		private var dropper:Sprite;
		private var cursor:Sprite;
		
		public function PhysicsEditor()
		{
			trace("Hello");
			
			stage.align = "TL";
			stage.scaleMode = "noScale";
			
			Mouse.hide();
			makeCursor();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			onEnterFrame(null);
			
			initSettings();
			
			container = new Sprite();
			
			points = new PointCanvas();
			container.addChild(points);
			
			addChildAt(container, 0);
			
			points.init();
			points.addEventListener("STATUS_EVENT", onStatusUpdate);
			
			imgFile = new File();
			imgFilter = new FileFilter("Image", "*.png;*.jpg", "*.png;*.jpg");
			
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
			
			addEventListener(Event.ADDED, onAdded);
			
			
			stage.nativeWindow.title = title;
		}
		
		private function makeCursor():void
		{
			cursor = new Sprite();
			
			var size:int = 10;
			
			with(cursor.graphics) {
				lineStyle(0.2, 0x00ff00, .7);
				moveTo(-size, 0);
				lineTo(size, 0);
				moveTo(0, -size);
				lineTo(0, size);
			}
			cursor.mouseEnabled = false;
			cursor.mouseChildren = false;
			
			addChild(cursor);
		}
		
		protected function onEnterFrame(e:Event):void
		{
			cursor.x = mouseX;
			cursor.y = mouseY;
			setChildIndex(cursor, numChildren-1);
		}
		
		protected function onAdded(event:Event):void
		{
			trace("added");
			container.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragIn);
			container.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);
		}
		
		private function onDragIn(e:NativeDragEvent):void
		{
			trace("hello");
			NativeDragManager.acceptDragDrop(container);
		}
		
		private function onDrop(e:NativeDragEvent):void {
			
			var dropfiles:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			
			for each (var file:File in dropfiles){
				switch (file.extension.toLowerCase()){
					case "png" :
					case "jpg" :
					case "jpeg" :
					case "gif" :
						loadImageFromFile(file);
						break;
					default:
						// wrong file type
				}
			}
		}
		
		protected function onStatusUpdate(e:CustomEvent):void
		{
			if(points.selected) info.text = "SELECTED POINT: " + points.selected.x + ","+points.selected.y;
			else info.text = "NO POINT SELECTED";
			
			mouseInfo.text = "MOUSE XY: "+points.mouseX+","+points.mouseY;
			
			mouseInfo.x = stage.stageWidth - (info.width+10);
			mouseInfo.y = info.y = stage.stageHeight - (info.height + 10);
		}
		
		protected function onResize(e:Event):void
		{
			container.x = stage.stageWidth >> 1;
			container.y = stage.stageHeight >> 1;
			
			container.graphics.beginFill(0xffffff, 0);
			container.graphics.drawRect(-stage.stageWidth>>1,-stage.stageHeight>>1,stage.stageWidth,stage.stageHeight);
			container.graphics.endFill();
		}
		
		private function initSettings():void
		{
			win = new Window(this, 0,0,"Control Panel");
			win.width = 110;
			win.height = 140;
			loadImgBtn = new PushButton(win,5,5,"Load Image", loadImg);
			pasteBtn = new PushButton(win,5,30,"Paste Data", loadData);
			copyBtn = new PushButton(win,5,55,"Copy Data", saveData);
			info = new Label(this, 10, 0, "INFO PANEL");
			mouseInfo = new Label(this, stage.stageWidth, 0, "MOUSE XY");
			clearAll = new PushButton(win,5,95,"CLEAR ALL", clearData);
		}
		
		private function clearData(e:Event):void
		{
			trace("CLEAR ALL!");
			points.clearAll();
		}
		
		private function saveData(e:Event):void
		{
			trace("SAVE DATA");
			
			points.save();
		}
		
		private function loadImg(e:Event):void
		{
			trace("LOAD DATA");
			imgFile.browse([imgFilter]);
			imgFile.addEventListener(Event.SELECT, onFileSelect);
		}
		
		protected function onFileSelect(e:Event):void
		{
			loadImageFromFile(imgFile);	
		}
		
		private function loadImageFromFile(f:File):void
		{
			imgFile = f;
			trace(imgFile.url);
			if(img) {
				if(img.content.parent) img.content.parent.removeChild(img.content);
				img.dispose(true);
			}
			
			img = new ImageLoader(imgFile.url, {onComplete:onImageLoaded});
			img.load(true);
		}
		
		private function onImageLoaded(e:LoaderEvent):void
		{
			container.addChildAt(img.content,0);
			
	//		img.content.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER,onDragIn);
	//		img.content.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP,onDrop);
			
			img.content.x = -(img.content.width >> 1);
			img.content.y = -(img.content.height >> 1);
			
			stage.nativeWindow.title = title + " - " + imgFile.name;
		}
		
		private function loadData(e:Event):void
		{
			points.load();
		}
	}
}