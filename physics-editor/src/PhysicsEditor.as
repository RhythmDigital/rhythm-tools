package
{
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Text;
	import com.bit101.components.Window;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.stardotstar.utils.CustomEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.ui.Keyboard;
	
	[SWF(width="944", height="577", frameRate="30", backgroundColor="0xc2c2c2")] 
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
		
		public function PhysicsEditor()
		{
			trace("Hello");
			
			stage.align = "TL";
			stage.scaleMode = "noScale";
			
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
			
			
			
			stage.nativeWindow.title = title;
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