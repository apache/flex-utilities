package org.apache.flex.runtimelocale.model {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.apache.flex.runtimelocale.event.LocaleEvent;
	import org.apache.flex.runtimelocale.event.LocaleFileEvent;
	import org.apache.flex.runtimelocale.event.ReferenceLocaleRequestEvent;
	import org.apache.flex.runtimelocale.event.ShowHelpRequestEvent;
	import org.apache.flex.runtimelocale.event.ShowLogFileRequestEvent;
	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;
	import org.apache.flex.runtimelocale.view.LocaleView;
	import org.apache.flex.runtimelocale.view.MainView;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class MainViewPM extends EventDispatcher {

		private static const logger:ILogger = getClassLogger(MainViewPM);

		public function MainViewPM() {
			super();
		}

		private var _applicationModel:ApplicationModel;
		private var _mainView:MainView;

		public function addLocale():void {
			dispatchEvent(new LocaleEvent(LocaleEvent.NEW_LOCALE_REQUEST));
		}

		[Bindable(event="applicationModelChanged")]
		public function get applicationModel():ApplicationModel {
			return _applicationModel;
		}

		public function set applicationModel(value:ApplicationModel):void {
			if (value !== _applicationModel) {
				_applicationModel = value;
				if (_applicationModel.localeData == null) {
					_applicationModel.addEventListener("localeDataChanged", handleLocaleDataChange);
				} else {
					createLocaleViews(_applicationModel.localeData);
				}
				dispatchEvent(new Event("applicationModelChanged"));
			}
		}

		public function handleNewLocale(event:LocaleEvent):void {
			var view:LocaleView = createLocaleView(event.localeData);
			_mainView.localesTab.selectedChild = view;
			logger.info("Handled {0} event for locale '{1}'", [event.type, event.localeData.name]);
		}

		public function handleRemovedLocale(event:LocaleEvent):void {
			var len:int = _mainView.localesTab.numChildren;
			for (var i:int = 0; i < len; ++i) {
				var view:LocaleView = _mainView.localesTab.getChildAt(i) as LocaleView;
				if (view) {
					if (view.localeData === event.localeData) {
						_mainView.localesTab.removeChild(view);
						logger.info("Handled {0} event, removed tab for locale '{1}'", [event.type, event.localeData.name]);
						break;
					}
				}
			}
		}

		public function initialize(view:MainView):void {
			_mainView = view;
			logger.info("MainViewPM initialized");
		}

		public function requestReferenceLocale(localeName:String):void {
			dispatchEvent(new ReferenceLocaleRequestEvent(ReferenceLocaleRequestEvent.REFERENCE_LOCALE_REQUEST, localeName));
		}

		public function saveLocaleFile():void {
			dispatchEvent(new LocaleFileEvent(LocaleFileEvent.FILE_SAVE_REQUEST));
		}

		public function showHelp():void {
			dispatchEvent(new ShowHelpRequestEvent(ShowHelpRequestEvent.SHOW_HELP_REQUEST));
		}

		public function showLocaleFile():void {
			dispatchEvent(new LocaleFileEvent(LocaleFileEvent.FILE_SHOW_REQUEST));
		}

		public function showLogFile():void {
			dispatchEvent(new ShowLogFileRequestEvent(ShowLogFileRequestEvent.SHOW_LOG_FILE_REQUEST));
		}

		private function createLocaleView(localeData:LocaleDataVO):LocaleView {
			var view:LocaleView = new LocaleView();
			view.localeData = localeData;
			view.percentHeight = 100;
			view.percentWidth = 100;
			_mainView.localesTab.addChild(view);
			logger.info("Created tab for locale '{0}'", [localeData.name]);
			return view;
		}

		private function createLocaleViews(localeDataCollection:Vector.<LocaleDataVO>):void {
			for each (var localeData:LocaleDataVO in localeDataCollection) {
				createLocaleView(localeData);
			}
		}

		private function handleLocaleDataChange(event:Event):void {
			if (_applicationModel.localeData != null) {
				_applicationModel.removeEventListener("localeDataChanged", handleLocaleDataChange);
				createLocaleViews(_applicationModel.localeData);
			}
		}
	}
}
