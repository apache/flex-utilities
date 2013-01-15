package org.apache.flex.runtimelocale.command {
	import flash.events.Event;
	import org.apache.flex.runtimelocale.model.ApplicationModel;
	import org.apache.flex.runtimelocale.model.IApplicationModelAware;

	public class AbstractApplicationModelAwareBaseCommand extends AbstractBaseCommand implements IApplicationModelAware {

		public function AbstractApplicationModelAwareBaseCommand(event:Event) {
			super(event);
		}

		private var _applicationModel:ApplicationModel;

		public function get applicationModel():ApplicationModel {
			return _applicationModel;
		}

		public function set applicationModel(value:ApplicationModel):void {
			_applicationModel = value;
		}
	}
}
