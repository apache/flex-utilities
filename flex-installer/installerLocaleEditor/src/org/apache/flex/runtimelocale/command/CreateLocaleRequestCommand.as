package org.apache.flex.runtimelocale.command {
	import flash.events.Event;
	import mx.controls.Alert;
	import org.antlr.runtime.TokenConstants;
	import org.apache.flex.runtimelocale.event.ApplicationStatusEvent;
	import org.apache.flex.runtimelocale.event.LocaleEvent;
	import org.apache.flex.runtimelocale.model.locale.LocaleDataVO;
	import org.apache.flex.runtimelocale.model.locale.LocaleItemDataVO;
	import org.as3commons.asblocks.dom.IASMethod;
	import org.as3commons.asblocks.dom.IASStatement;
	import org.as3commons.asblocks.dom.Visibility;
	import org.as3commons.asblocks.impl.AS3FragmentParser;
	import org.as3commons.asblocks.impl.ASTASClassType;
	import org.as3commons.asblocks.impl.ASTASExpressionStatement;
	import org.as3commons.asblocks.impl.ASTASField;
	import org.as3commons.asblocks.impl.ASTASMethod;
	import org.as3commons.asblocks.impl.ASTASStringLiteral;
	import org.as3commons.asblocks.impl.ASTScriptElement;
	import org.as3commons.asblocks.impl.ContainerDelegate;
	import org.as3commons.asblocks.impl.TokenBuilder;
	import org.as3commons.asblocks.parser.antlr.LinkedListToken;
	import org.as3commons.asblocks.parser.antlr.LinkedListTree;
	import org.as3commons.asblocks.parser.antlr.as3.AS3Parser;
	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class CreateLocaleRequestCommand extends AbstractApplicationModelAwareBaseCommand {

		private static const INSTALL_METHOD_PREFIX:String = "install_";

		private static const logger:ILogger = getClassLogger(CreateLocaleRequestCommand);

		public function CreateLocaleRequestCommand(event:Event) {
			super(event);
		}

		override public function execute():* {
			var localeEvent:LocaleEvent = event as LocaleEvent;
			if (localeEvent) {
				if (applicationModel.availableLocales.getItemIndex(localeEvent.localeName) > -1) {
					event.preventDefault();
					logger.info("'{0}' already exists, aborting CreateLocaleRequestCommand", [localeEvent.localeName]);
					Alert.show(localeEvent.localeName + " already exists");
				} else {
					createLocale(localeEvent.localeName);
				}
			}
		}

		private function addContentStatements(method:IASMethod):void {
			for each (var localeItem:LocaleItemDataVO in applicationModel.referenceLocale.content) {
				addKey(localeItem.key, method);
			}
		}

		private function addField(type:ASTASClassType, localeName:String):void {
			var field:ASTASField = type.newField(localeName.toUpperCase(), Visibility.PUBLIC, "String") as ASTASField;
			field.setStatic(true);
			field.setConstant(true);
			var literal:ASTASStringLiteral = new ASTASStringLiteral(AS3FragmentParser.parseExpression('"' + localeName + '"'));
			field.setInitializer(literal);
			logger.info("Added static constant field to .as file: {0}", [field.toString()]);
		}

		private function addKey(key:String, method:IASMethod):void {
			var newStatement:ASTASExpressionStatement = new ASTASExpressionStatement(AS3FragmentParser.parseExprStatement('		content[' + key + ']="";'));
			method.addStatement(newStatement);
		}

		private function addMethod(type:ASTASClassType, localeName:String):ASTASMethod {
			var method:ASTASMethod = type.newMethod(INSTALL_METHOD_PREFIX + localeName, Visibility.PRIVATE, "void") as ASTASMethod;

			var ast:LinkedListTree = AS3FragmentParser.parseStatement("var locale:String = " + localeName.toUpperCase() + ";");
			method.addStatement(new ASTASExpressionStatement(ast));

			ast = AS3FragmentParser.parseStatement("var resource:ResourceBundle = new ResourceBundle(locale, ViewResourceConstants.BUNDLE_NAME);");
			method.addStatement(new ASTASExpressionStatement(ast));

			ast = AS3FragmentParser.parseStatement("var content:Object = resource.content;");
			method.addStatement(new ASTASExpressionStatement(ast));

			addContentStatements(method);
			ast = AS3FragmentParser.parseStatement("_resourceManager.addResourceBundle(resource);");
			method.addStatement(new ASTASExpressionStatement(ast));
			logger.info("Added method to .as file: {0}()", [INSTALL_METHOD_PREFIX + localeName]);
			return method;
		}

		private function addMethodInvocation(type:ASTASClassType, localeName:String):void {
			var method:ASTASMethod = type.getMethod("installResources") as ASTASMethod;
			var newAST:LinkedListTree = AS3FragmentParser.parseStatement(INSTALL_METHOD_PREFIX + localeName + "();");
			for (var i:int = 0; i < 4; ++i) {
				var tab:LinkedListToken = TokenBuilder.newToken(AS3Parser.WS, "\t");
				tab.channel = TokenConstants.HIDDEN_CHANNEL;
				newAST.addToken(0, tab);
			}
			newAST.addToken(0, TokenBuilder.newNewline());
			insertInvocation(method.getStatements() as ArrayList, method, newAST);
			logger.info("Added invocation of method '{0}'() to method '{1}' to .as file", [INSTALL_METHOD_PREFIX + localeName, "installResources()"]);
		}

		private function createLocale(localeName:String):void {
			logger.info("Creating new locale '{0}', using '{1}' as the reference locale", [localeName, applicationModel.referenceLocale.name]);
			var type:ASTASClassType = applicationModel.localeCompilationUnit.getType() as ASTASClassType;
			addField(type, localeName);
			var method:ASTASMethod = addMethod(type, localeName);
			var data:LocaleDataVO = new LocaleDataVO(method, localeName);
			applicationModel.localeData[applicationModel.localeData.length] = data;

			addMethodInvocation(type, localeName);

			dispatchEvent(new LocaleEvent(LocaleEvent.LOCALE_CREATED, null, data));
			logger.info("Finished creating locale '{0}'", [localeName]);
			dispatchEvent(new ApplicationStatusEvent(ApplicationStatusEvent.APPLICATION_INFO_STATUS, "New locale '" + localeName + "' created succesfully!"));
		}

		private function insertInvocation(statements:ArrayList, container:ASTScriptElement, newAST:LinkedListTree):void {
			var iterator:IIterator = statements.iterator();
			var idx:int = 0;
			while (iterator.hasNext()) {
				var statement:IASStatement = iterator.next();
				if (statement is ContainerDelegate) {
					insertInvocation((statement as ContainerDelegate).getStatements() as ArrayList, statement as ASTScriptElement, newAST);
				} else {
					if (statement is ASTASExpressionStatement) {
						var expr:ASTASExpressionStatement = statement as ASTASExpressionStatement;
						if (expr.toString().substr(0, INSTALL_METHOD_PREFIX.length) == INSTALL_METHOD_PREFIX) {
							var containerAST:LinkedListTree = container.getAST();
							containerAST = containerAST.getChild(containerAST.childCount - 1) as LinkedListTree;
							containerAST.addChildAtWithTokens(idx + 1, newAST);
							break;
						}
					}
				}
				idx++;
			}
		}
	}
}
