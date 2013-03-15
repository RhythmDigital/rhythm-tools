package
{
	import com.greensock.easing.CustomEase;
	import com.stardotstar.utils.CustomEvent;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import flash.ui.Keyboard;
	
	public class PointCanvas extends Sprite
	{
		public var numGroups:int;
		public var groups:Array = [];
		public var groupColours:Array = [];
		public var groupsClosed:Array = [];
		public var selected:PolyPoint;
		public var snap:Boolean;
		
		public function PointCanvas()
		{
			super();
			
			trace("Points!");
		}
		
		public function load():void
		{
			trace("load data");
			
			try {
				if(Clipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)) {
					var clipboardtextvalue:String = String(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT));
					parseClipboard(clipboardtextvalue);
				} else {
					trace("no data");
				}
			} catch(e:Error) {
				trace(e);
			}
		}
		
		private function parseClipboard(data:String):void
		{
			clearAll();
			
			
			trace("Parse Data: " + data);
			
			var rex:RegExp = /[\s\r\n]*/gim;
			data = data.replace(rex,'');
			
			var splitGroups:Array = data.split("n");
			
			for each(var groupStr:String in splitGroups) {
				var points:Array = groupStr.split(","); 
				addGroup();
				
				var i:int = 0;
				
				for(i; i < points.length; i+=2) {
					var px:int = int(points[i]);
					var py:int = int(points[i+1]);
					addPoint(px,py,groups.length-1);
					trace(groups.length, px,py);
				}
			}
			
		}
		
		public function clearAll():void
		{
			// clear current
			for each (var g:Array in groups) {
				while(g.length) {
					removeChild(g[0]);
					g.shift();
				}
			}
			
			while(groups.length) {
				groups.shift();
			}
		}
		
		public function save():void
		{
			if(!groups.length) return;
			
			if(!groups[groups.length-1].length) {
				groups.pop();
			}
			
			var output:String = "";
			for(var i:int = 0; i < groups.length; ++i) {
				//trace("group " + i + ": ");
				if(i != 0) {
					output+="n";
				}
				
				for(var j:int = 0; j < groups[i].length; j++) {
					output+=groups[i][j].x+", "+groups[i][j].y;
					
					if(j < groups[i].length-1) {
						output+=", ";
					} else {
						
					}
					//trace("\t"+i+" >> "+groups[i][j].x+","+groups[i][j].y);
					//if(i < groups.length) {
					//output+="n";
					//}
				}
				
				
			}
			
			System.setClipboard(output);
			trace(output);
		}
		
		public function init():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener("DOT_SELECTED", onDotSelected);
		}
		
		protected function onKeyUp(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.SHIFT) snap = false;
		}
		
		protected function onDotSelected(e:CustomEvent):void
		{
			if(!snap) {
				if(selected) selected.deselect();
				selected = PolyPoint(e.target);
				selected.selected();
			} else {
				if(e.target.group != groups.length-1) {
					addNextPoint(e.target.x, e.target.y);
				}
				
			}
		}
		
		protected function onEnterFrame(e:Event):void
		{
			// draw lines
			graphics.clear();
			
			for(var i:int = 0; i < groups.length; ++i) {
				
				graphics.lineStyle(1, groupColours[i]);
				graphics.beginFill(((groups.length-1) == i) ? 0xff0000 : 0x00ff00, .4);
				
				for(var j:int = 0; j < groups[i].length; j++) {
					
					if(j == 0) {
						graphics.moveTo(groups[i][j].x,groups[i][j].y);
					} else {
						graphics.lineTo(groups[i][j].x,groups[i][j].y);
					}
				}
				
				if(groups[i].length) graphics.lineTo(groups[i][0].x,groups[i][0].y);
			}
			
			dispatchEvent(new CustomEvent("STATUS_EVENT", {}, true, true));
		}
		
		private function addNextPoint(x:int, y:int):void
		{
			if(!groups.length)
				addGroup();
			addPoint(x, y, groups.length-1);
		}
		
		protected function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode) {
				case Keyboard.ENTER:
					addGroup();
					break;
				case Keyboard.SPACE:
					addNextPoint(mouseX, mouseY);
					break;
				case Keyboard.BACKSPACE:
					if(selected) {
						deleteSelected();
					}
					break;
				case Keyboard.UP:
					if(selected) selected.y--;
					break;
				case Keyboard.DOWN:
					if(selected) selected.y++;
					break;
				case Keyboard.LEFT:
					if(selected) selected.x--;
					break;
				case Keyboard.RIGHT:
					if(selected) selected.x++;
					break;
				case Keyboard.SHIFT:
					snap = true;
					break;
			}
		}
		
		private function deleteSelected():void
		{
			if(!selected) return;
			
			selected.deselect();
			trace(selected.id);
			
			var a:Array  = groups[selected.group];
			var ind:int = a.indexOf(selected);
			removeChild(selected);
			selected = null;
			
			a.splice(ind, 1);
			
			if(a.length == 0) {
				trace("remove group");
				groups.splice(groups.indexOf(a),1);
			} else {
				for(var i:int = 0; i < a.length; i++) {
					a[i].id = i;
				}
			}
		}
		
		private function addGroup():void
		{
			if(((groups.length > 0 && groups[groups.length-1].length > 1) || !groups.length)) {
				trace("Num groups: " + groups.length);
				groups.push([]);
				groupColours.push(Math.random()*0xFFFFFF);
			} else {
				trace("No need to add another group.");
			}
			
		}
		
		private function addPoint(x:int, y:int, group:int):void
		{
			var pt:PolyPoint = new PolyPoint(groupColours[group], group);
			pt.x = x;
			pt.y = y;
			
			groups[group].push(pt);
			pt.id = groups[group].length - 1;
			addChild(pt);
		}
	}
}