package com.stardotstar.gui 
{	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import juniorvet.Constants;
	import juniorvet.tabbing.ITabbable;


	/**
	 *	CheckBox class
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author Adam Palmer
	 *	@since  12.10.2008
	 */

	public class CheckBox extends MovieClip implements ITabbable
	{
		protected var currentState:int; // 1 = checked, 0 = unchecked
		

		public function CheckBox():void
		{
			currentState = 0;
			gotoAndStop("unchecked");
			
			buttonMode = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}

		protected function onRollOver(e:MouseEvent):void
		{
			if (currentState == 0) gotoAndStop("uncheckedOver");
			else gotoAndStop("checkedOver");
			dispatchEvent(new Event(Constants.BUTTON_OVER_SOUND, true, false));
		}
		
		protected function onRollOut(e:MouseEvent):void
		{
			if (currentState == 0) gotoAndStop("unchecked");
			else gotoAndStop("checked");
			addEventListener(MouseEvent.MOUSE_OVER, onRollOver);
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			if (currentState == 0)
			{
				currentState = 1;
				gotoAndStop("checkedDown");
			} else {
				currentState = 0;
				gotoAndStop("uncheckedDown");
			}
			
			removeEventListener(MouseEvent.MOUSE_OVER, onRollOver);
			dispatchEvent(new Event('checkbox clicked', true));
			dispatchEvent(new Event(Constants.BUTTON_DOWN_SOUND, true, false));
		}		

		public function get state():int
		{
			return currentState;
		}
		
		public function set state(newState:int):void
		{
			currentState = newState;
			if (currentState == 1) gotoAndStop("checked");
			else gotoAndStop("unchecked");
		}
		
		public function tabUp():void
		{
			onRollOut(null);
			// dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
		}
		
		public function tabOver():void
		{
			onRollOver(null);
			
			// dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
		}
		
		public function tabDown():void
		{
			onMouseDown(null);
			// dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
		}

		public override function toString():String
		{
			return "CheckBox";
		};
	}
}