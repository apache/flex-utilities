package org.apache.flex.runtimelocale.command {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import org.apache.flex.runtimelocale.IStatusReporter;
	import org.as3commons.async.command.ICommand;

	public class AbstractBaseCommand extends EventDispatcher implements ICommand, IStatusReporter {
		private var _event:Event;

		public function AbstractBaseCommand(event:Event) {
			super();
			_event = event;
		}

		public function get event():Event {
			return _event;
		}

		public function set event(value:Event):void {
			_event = value;
		}

		public function execute():* {
			return null;
		}
	}
}
