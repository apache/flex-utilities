package org.apache.flex.runtimelocale.event {
	import flash.events.Event;

	public class InitializeApplicationEvent extends Event {
		public static const APP_INITIALIZE:String = "initializeApplication";

		public function InitializeApplicationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
