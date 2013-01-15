package org.apache.flex.runtimelocale.model {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;
	import org.as3commons.asblocks.dom.IASCompilationUnit;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import spark.components.WindowedApplication;

	public class ApplicationModel extends EventDispatcher {

		public static const APP_INIT_STATE:String = "appInitState";
		public static const APP_READY_STATE:String = "appReadyState";

		private static const logger:ILogger = getClassLogger(ApplicationModel);

		public function ApplicationModel() {
			super();
			logger.info("Application model created.");
		}

		private var _availableLocales:ArrayCollection;
		private var _configurationProperties:Object;

		private var _currentLocalFilePath:String;
		private var _localeCompilationUnit:IASCompilationUnit;
		private var _localeData:Vector.<LocaleDataVO>;
		private var _referenceLocale:LocaleDataVO;

		[Bindable(event="availableLocalesChanged")]
		public function get availableLocales():ArrayCollection {
			return _availableLocales;
		}

		public function set availableLocales(value:ArrayCollection):void {
			if (_availableLocales !== value) {
				_availableLocales = value;
				dispatchEvent(new Event("availableLocalesChanged"));
			}
		}

		public function get configurationProperties():Object {
			return _configurationProperties;
		}

		public function set configurationProperties(value:Object):void {
			_configurationProperties = value;
		}

		[Bindable(event="currentLocalFilePathChanged")]
		public function get currentLocalFilePath():String {
			return _currentLocalFilePath;
		}

		public function set currentLocalFilePath(value:String):void {
			if (_currentLocalFilePath !== value) {
				_currentLocalFilePath = value;
				dispatchEvent(new Event("currentLocalFilePathChanged"));
			}
		}

		public function get currentState():String {
			return (FlexGlobals.topLevelApplication as WindowedApplication).currentState;
		}

		public function set currentState(value:String):void {
			if (value != (FlexGlobals.topLevelApplication as WindowedApplication).currentState) {
				(FlexGlobals.topLevelApplication as WindowedApplication).currentState = value;
			}
		}

		[Bindable(event="localeCompilationUnitChanged")]
		public function get localeCompilationUnit():IASCompilationUnit {
			return _localeCompilationUnit;
		}

		public function set localeCompilationUnit(value:IASCompilationUnit):void {
			if (_localeCompilationUnit !== value) {
				_localeCompilationUnit = value;
				currentState = (_localeCompilationUnit) ? APP_READY_STATE : APP_INIT_STATE;
				dispatchEvent(new Event("localeCompilationUnitChanged"));
			}
		}

		[Bindable(event="localeDataChanged")]
		public function get localeData():Vector.<LocaleDataVO> {
			return _localeData;
		}

		public function set localeData(value:Vector.<LocaleDataVO>):void {
			if (_localeData !== value) {
				_localeData = value;
				dispatchEvent(new Event("localeDataChanged"));
			}
		}

		[Bindable(event="referenceLocaleChanged")]
		public function get referenceLocale():LocaleDataVO {
			return _referenceLocale;
		}

		public function set referenceLocale(value:LocaleDataVO):void {
			if (_referenceLocale !== value) {
				_referenceLocale = value;
				dispatchEvent(new Event("referenceLocaleChanged"));
			}
		}
	}
}
