package com.actionsnippet.collisions.events {
	
	import Box2D.Dynamics.b2Body;
	import flash.events.Event;
	import Box2D.Collision.b2ContactPoint;
	
	/**
	 * Collision event for QuickBox2D collision handling
	 * @author Devon O.
	 */
	public class QBCollisionEvent extends Event {
		
		public static const ADD:String			= "add";
		public static const REMOVE:String		= "remove";
		public static const PERSIST:String		= "persist";
		public static const RESULT:String		= "result";
		
		private var _body1:b2Body;
		private var _body2:b2Body;
	//	private var _position:b2ContactPoint;
		
		public function QBCollisionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) { 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event {
			var evt:QBCollisionEvent = new QBCollisionEvent(type, bubbles, cancelable);
			evt.body1 = _body1;
			evt.body2 = _body2;
			//evt.position = _position;
			return evt;
		} 
		
		public override function toString():String { 
			return formatToString("QBCollisionEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get body1():b2Body { return _body1; }
		
		public function set body1(value:b2Body):void {
			_body1 = value;
		}
		
		public function get body2():b2Body { return _body2; }
		
		public function set body2(value:b2Body):void {
			_body2 = value;
		}
	}
}