package
{
	import com.actionsnippet.qbox.objects.PolyObject;
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
		public var contacts:Array = [];
		
		private var selection:Array;
		
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
				
				selection = [];
				
				for(var i:int; i < groups.length; ++i) {
					for each(var pt:PolyPoint in groups[i]) {
						if(pt.x == selected.x && pt.y == selected.y) {
							selection.push(pt);
						}
					}
				}
				
				for(var c:int; c < contacts.length; c++) {
					if(contacts[c].x == selected.x && contacts[c].y == selected.y) {
						selection.push(contacts[c]);
					}
				}
				
				
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
				graphics.beginFill(((groups.length-1) == i) ? 0x000000 : 0x00ff00, .1);
				
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
					if(selected) shiftSelection(0, -1);
					break;
				case Keyboard.DOWN:
					if(selected) shiftSelection(0, 1);
					break;
				case Keyboard.LEFT:
					if(selected) shiftSelection(-1, 0);
					break;
				case Keyboard.RIGHT:
					if(selected) shiftSelection(1, 0);
					break;
				case Keyboard.SHIFT:
					snap = true;
					break;
				case Keyboard.NUMBER_0:
				case Keyboard.NUMBER_1:
				case Keyboard.NUMBER_2:
				case Keyboard.NUMBER_3:
				case Keyboard.NUMBER_4:
				case Keyboard.NUMBER_5:
				case Keyboard.NUMBER_6:
				case Keyboard.NUMBER_7:
				case Keyboard.NUMBER_8:
				case Keyboard.NUMBER_9:
					if(selected) {
						//addContactAt(selected, int(String.fromCharCode(e.keyCode)));
					}
					break;
			}
		}
		/*
		private function addContactAt(pt:PolyPoint, id:int):void {
			
			var ptID:int = id;
			var contact:PolyPoint;
			
			for each(var c:PolyPoint in contacts) {
				if(pt.x != c.x || pt.y != c.y) {
					contact = new PolyPoint(0x000000);
				}
			}
			
			
		}
		*/
		private function shiftSelection(vx:int = 0, vy:int = 0):void
		{
			if(selected && selection) {
				for each(var pt:PolyPoint in selection) {
					pt.x += vx;
					pt.y += vy;
				}
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