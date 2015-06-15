package org.apache.flex.runtimelocale.command {
	import flash.events.Event;

	import mx.controls.Alert;

	import org.apache.flex.runtimelocale.event.ApplicationStatusEvent;

	public class ApplicationErrorStatusCommand extends AbstractBaseCommand {
		public function ApplicationErrorStatusCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var errorEvent:ApplicationStatusEvent = event as ApplicationStatusEvent;
			if (errorEvent) {
				Alert.show(errorEvent.statusMessage, errorEvent.caption);
			}
		}
	}
}
