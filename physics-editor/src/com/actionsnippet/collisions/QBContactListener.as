package com.actionsnippet.collisions {
	
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2ContactResult;
	import com.actionsnippet.collisions.events.QBCollisionEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * Contact listener for QuickBox2D - for handling custom collision detection
	 * @author Devon O.
	 */
	public class QBContactListener extends b2ContactListener implements IEventDispatcher {
		
		private var _dispatcher:EventDispatcher;
		
		public function QBContactListener() {
			_dispatcher = new EventDispatcher(this);
		}
		
		override public function Add(point:b2ContactPoint):void {
			super.Add(point);
			var evt:QBCollisionEvent = new QBCollisionEvent(QBCollisionEvent.ADD);
			evt.body1 = point.shape1.GetBody();
			evt.body2 = point.shape2.GetBody();
			dispatchEvent(evt);
		}
		
		override public function Remove(point:b2ContactPoint):void {
			super.Remove(point);
			var evt:QBCollisionEvent = new QBCollisionEvent(QBCollisionEvent.REMOVE);
			evt.body1 = point.shape1.GetBody();
			evt.body2 = point.shape2.GetBody();
			dispatchEvent(evt);
		}
		
		override public function Persist(point:b2ContactPoint):void {
			super.Persist(point);
			var evt:QBCollisionEvent = new QBCollisionEvent(QBCollisionEvent.PERSIST);
			evt.body1 = point.shape1.GetBody();
			evt.body2 = point.shape2.GetBody();
			dispatchEvent(evt);
		}
		
		override public function Result(point:b2ContactResult):void {
			super.Result(point);
			var evt:QBCollisionEvent = new QBCollisionEvent(QBCollisionEvent.RESULT);
			evt.body1 = point.shape1.GetBody();
			evt.body2 = point.shape2.GetBody();
			dispatchEvent(evt);
		}
		
		/* INTERFACE flash.events.IEventDispatcher */
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void{
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return _dispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean {
			return _dispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			_dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean {
			return _dispatcher.willTrigger(type);
		}
	}
}