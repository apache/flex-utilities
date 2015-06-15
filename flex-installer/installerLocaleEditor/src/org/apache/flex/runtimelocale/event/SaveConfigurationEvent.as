package org.apache.flex.runtimelocale.event {
	import flash.events.Event;

	public class SaveConfigurationEvent extends Event {

		public static const SAVE_CONFIGURATION_REQUEST:String = "saveConfigurationRequest";

		public function SaveConfigurationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
