package org.apache.flex.runtimelocale.command {
	import flash.events.Event;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import org.apache.flex.runtimelocale.event.ApplicationStatusEvent;
	import org.apache.flex.runtimelocale.event.LocaleEvent;
	import org.apache.flex.runtimelocale.model.ApplicationModel;
	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;
	import org.as3commons.asblocks.dom.IASStatement;
	import org.as3commons.asblocks.impl.ASTASClassType;
	import org.as3commons.asblocks.impl.ASTASExpressionStatement;
	import org.as3commons.asblocks.impl.ASTASMethod;
	import org.as3commons.asblocks.impl.ContainerDelegate;
	import org.as3commons.async.operation.impl.AbstractOperation;
	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IList;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class RemoveLocaleRequestCommand extends AbstractApplicationModelAwareBaseCommand {

		private static const logger:ILogger = getClassLogger(RemoveLocaleRequestCommand);

		public function RemoveLocaleRequestCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var operation:AbstractOperation = new AbstractOperation();
			var localeEvent:LocaleEvent = event as LocaleEvent;
			if (localeEvent) {
				var appModel:ApplicationModel = applicationModel;
				var closeHandler:Function = function(closeEvent:CloseEvent):void {
					removeLocale(appModel, localeEvent.localeData);
					dispatchEvent(new LocaleEvent(LocaleEvent.LOCALE_REMOVED, null, localeEvent.localeData));
					dispatchEvent(new ApplicationStatusEvent(ApplicationStatusEvent.APPLICATION_INFO_STATUS, "Locale " + localeEvent.localeData.name + " was removed successfully!"));
					operation.dispatchCompleteEvent(this);
					logger.info("Executed RemoveLocaleRequestCommand");
				};
				Alert.show("Are you sure you want to completely remove the locale '" + localeEvent.localeData.name + "'?", "Confirmation", Alert.YES | Alert.NO, null, closeHandler);
			}
			return operation;
		}

		private function findInvocation(statements:IList, localeName:String, container:*):void {
			var iterator:IIterator = statements.iterator();
			var idx:int = 0;
			while (iterator.hasNext()) {
				var statement:IASStatement = iterator.next();
				if (statement is ContainerDelegate) {
					findInvocation((statement as ContainerDelegate).getStatements() as ArrayList, localeName, statement);
				} else {
					if (statement is ASTASExpressionStatement) {
						var str:String = statement.toString();
						if (str == "install_" + localeName + "();") {
							container.removeStatement(statement);
							break;
						}
					}
				}
				idx++;
			}
		}

		private function removeLocale(appModel:ApplicationModel, localeData:LocaleDataVO):void {
			var idx:int = appModel.localeData.indexOf(localeData);
			if (idx > -1) {
				appModel.localeData.splice(idx, 1);
				removeLocaleFromAS3File(appModel.localeCompilationUnit.getType() as ASTASClassType, localeData.name);
			}
		}

		private function removeLocaleFromAS3File(type:ASTASClassType, localeName:String):void {
			type.removeMethod("install_" + localeName);
			logger.info("Removed method '{0}' from. as file", ["install_" + localeName]);
			type.removeField(localeName.toUpperCase());
			logger.info("Removed constant static field '{0}' from. as file", [localeName.toUpperCase()]);
			var method:ASTASMethod = type.getMethod("installResources") as ASTASMethod;
			findInvocation(method.getStatements() as ArrayList, localeName, method);
			logger.info("Removed invocation method '{0}'() from. as file", ["install_" + localeName]);
		}
	}
}
