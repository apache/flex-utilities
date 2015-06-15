package org.apache.flex.runtimelocale.command {
	import flash.events.Event;
	import mx.collections.ArrayCollection;
	import org.apache.flex.runtimelocale.event.ReferenceLocaleRequestEvent;
	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;
	import org.as3commons.asblocks.dom.IASCompilationUnit;
	import org.as3commons.asblocks.impl.ASTASClassType;
	import org.as3commons.asblocks.impl.ASTASMethod;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IList;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class LocaleFileReadyCommand extends AbstractApplicationModelAwareBaseCommand {

		public static const LOCALE_METHOD_PREFIX:String = "install_";
		public static const LOCALE_METHOD_PREFIX_LEN:int = "install_".length;

		private static const logger:ILogger = getClassLogger(LocaleFileReadyCommand);

		public function LocaleFileReadyCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var unit:IASCompilationUnit = applicationModel.localeCompilationUnit;
			var type:ASTASClassType = unit.getType() as ASTASClassType;
			var localeMethods:Vector.<ASTASMethod> = filterOutLocaleMethods(type.getMethods());
			makeLocaleList(localeMethods);
			extractLocaleDataFromMethods(localeMethods);
			dispatchEvent(new ReferenceLocaleRequestEvent(ReferenceLocaleRequestEvent.REFERENCE_LOCALE_REQUEST, "en_US"));
		}

		private function extractLocaleDataFromMethods(localeMethods:Vector.<ASTASMethod>):void {
			logger.info("Creating locale data from install methods");
			var list:Vector.<LocaleDataVO> = new Vector.<LocaleDataVO>();
			for each (var method:ASTASMethod in localeMethods) {
				var name:String = method.getName().substr(-5, 5);
				list[list.length] = new LocaleDataVO(method, name);
			}
			applicationModel.localeData = list;
		}

		private function filterOutLocaleMethods(methods:IList):Vector.<ASTASMethod> {
			var result:Vector.<ASTASMethod> = new Vector.<ASTASMethod>();
			var iterator:IIterator = methods.iterator();
			while (iterator.hasNext()) {
				var method:ASTASMethod = iterator.next();
				if (method.getName().substr(0, LOCALE_METHOD_PREFIX_LEN) == LOCALE_METHOD_PREFIX) {
					result[result.length] = method;
				}
			}
			return result;
		}

		private function makeLocaleList(localeMethods:Vector.<ASTASMethod>):void {
			logger.info("Extracting locale list");
			var locales:Array = [];
			for each (var method:ASTASMethod in localeMethods) {
				var name:String = method.getName().substr(-5, 5);
				locales[locales.length] = name;
				logger.info("Extracting locale name '{0}' for list", [name]);
			}
			applicationModel.availableLocales = new ArrayCollection(locales);
		}
	}
}
