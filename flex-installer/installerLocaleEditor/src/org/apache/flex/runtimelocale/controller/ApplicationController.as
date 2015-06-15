package org.apache.flex.runtimelocale.controller {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;
	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.eventbus.IEventBusAware;
	import org.as3commons.eventbus.IEventBusListener;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;
	import org.springextensions.actionscript.context.IApplicationContext;
	import org.springextensions.actionscript.context.IApplicationContextAware;

	public class ApplicationController extends EventDispatcher implements IEventBusListener, IApplicationContextAware {
		private static const COMMAND:String = "Command";

		private static const logger:ILogger = getClassLogger(ApplicationController);

		public function ApplicationController() {
			super();
		}

		private var _applicationContext:IApplicationContext;

		public function get applicationContext():IApplicationContext {
			return _applicationContext;
		}

		public function set applicationContext(value:IApplicationContext):void {
			_applicationContext = value;
		}

		public function initialize():void {
			if (_applicationContext is IEventBusAware) {
				(_applicationContext as IEventBusAware).eventBus.addListener(this);
				logger.info("ApplicationController initialized...");
			}
		}

		public function onEvent(event:Event):void {
			logger.info("Received event '{0}'", [event.type]);
			var definitionName:String = event.type + COMMAND;
			if (_applicationContext.canCreate(definitionName)) {
				logger.info("Command definition found called '{0}' for event '{1}'", [definitionName, event.type]);
				var command:ICommand = _applicationContext.getObject(definitionName, [event]);
				var operation:IOperation = command.execute();
				logger.info("Command '{0}' executed", [definitionName]);
				if (!operation) {
					_applicationContext.destroyObject(command);
					logger.info("Command '{0}' destroyed", [definitionName]);
				} else {
					operation.addCompleteListener(operationListener);
					operation.addErrorListener(operationListener);
				}
			}
		}

		private function operationListener(event:OperationEvent):void {
			var operation:IOperation = event.operation;
			operation.removeCompleteListener(operationListener);
			operation.removeErrorListener(operationListener);
			_applicationContext.destroyObject(operation.result);
			logger.info("Command destroyed after asynchronous operation");
		}
	}
}
