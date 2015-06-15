package org.apache.flex.runtimelocale.context {
	import org.apache.flex.runtimelocale.view.IInjectableView;
	import org.as3commons.stageprocessing.IObjectSelector;

	public class StageObjectSelector implements IObjectSelector {

		public function StageObjectSelector() {
			super();
		}

		public function approve(object:Object):Boolean {
			var result:Boolean = (object is IInjectableView);
			return result;
		}
	}
}
