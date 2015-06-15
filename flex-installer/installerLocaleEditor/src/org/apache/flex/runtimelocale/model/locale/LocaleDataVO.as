package org.apache.flex.runtimelocale.model.locale {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	import org.as3commons.asblocks.dom.IASExpression;
	import org.as3commons.asblocks.dom.IASStatement;
	import org.as3commons.asblocks.impl.AS3FragmentParser;
	import org.as3commons.asblocks.impl.ASTASArrayAccessExpression;
	import org.as3commons.asblocks.impl.ASTASAssignmentExpression;
	import org.as3commons.asblocks.impl.ASTASExpressionStatement;
	import org.as3commons.asblocks.impl.ASTASMethod;
	import org.as3commons.asblocks.impl.ASTASStringLiteral;
	import org.as3commons.asblocks.impl.TokenBuilder;
	import org.as3commons.asblocks.parser.antlr.LinkedListToken;
	import org.as3commons.asblocks.parser.antlr.LinkedListTree;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IList;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	public class LocaleDataVO extends EventDispatcher {

		private static const logger:ILogger = getClassLogger(LocaleDataVO);

		public function LocaleDataVO(method:ASTASMethod, name:String) {
			super();
			logger.info("Creating LocaleDataVO for locale '" + name + "'");
			_method = method;
			extractLocaleData(method);
			_name = name;
		}

		private var _content:ArrayCollection;
		private var _lookup:Object = {};
		private var _method:ASTASMethod;
		private var _missingKeys:ArrayCollection;
		private var _name:String;

		public function addKey(key:String):void {
			if ((!StringUtils.hasText(key)) || (_lookup[key])) {
				return;
			}

			logger.info("Adding translation key: {0}", [key]);
			var code:String = 'content[' + key + ']="";';
			logger.info("AS3 code snippet for translation key: {0}", [code]);

			var newAST:LinkedListTree = AS3FragmentParser.parseExprStatement(code);
			var statements:IList = _method.getStatements();

			for (var i:int = 0; i < 3; ++i) {
				var tab:LinkedListToken = TokenBuilder.newTab();
				newAST.addToken(0, tab);
			}
			newAST.addToken(0, TokenBuilder.newNewline());

			var methodAST:LinkedListTree = _method.getAST();
			methodAST = methodAST.getChild(methodAST.childCount - 1) as LinkedListTree;
			methodAST.addChildAtWithTokens(methodAST.childCount - 1, newAST);

			var newStatement:ASTASExpressionStatement = new ASTASExpressionStatement(newAST);
			var item:LocaleItemDataVO = addItem(newStatement);
			_content.addItem(item);
		}

		public function get content():ArrayCollection {
			return _content;
		}

		public function getItemByKey(key:String):LocaleItemDataVO {
			return _lookup[key];
		}

		[Bindable(event="missingKeysChanged")]
		public function get missingKeys():ArrayCollection {
			return _missingKeys;
		}

		public function set missingKeys(value:ArrayCollection):void {
			if (_missingKeys !== value) {
				_missingKeys = value;
				dispatchEvent(new Event("missingKeysChanged"));
			}
		}

		public function get name():String {
			return _name;
		}

		public function removeItem(item:LocaleItemDataVO):void {
			removeStatement(item.statement);
			var idx:int = _content.getItemIndex(item);
			if (idx > -1) {
				_content.removeItemAt(idx);
				delete _lookup[item.key];
				logger.info("Deleted translation key '{0}'", [item.key]);
			}
		}

		public function removeStatement(statement:IASStatement):void {
			var statements:IList = _method.getStatements();
			statements.remove(statement);
		}

		private function addItem(expressionStatement:ASTASExpressionStatement):LocaleItemDataVO {
			var asExpression:IASExpression = expressionStatement.getExpression();
			var expression:ASTASAssignmentExpression = asExpression as ASTASAssignmentExpression;
			if (expression != null) {
				var leftExpression:ASTASArrayAccessExpression = expression.getLeftExpression() as ASTASArrayAccessExpression;
				var rightExpression:ASTASStringLiteral = expression.getRightExpression() as ASTASStringLiteral;
				if ((leftExpression != null) && (rightExpression != null)) {
					var item:LocaleItemDataVO = new LocaleItemDataVO(leftExpression, rightExpression, expressionStatement);
					_lookup[leftExpression.getSubscript().toString()] = item;
					return item;
				}
			}
			return null;
		}

		private function extractLocaleData(method:ASTASMethod):void {
			logger.info("Extracting translation keys from the AST");
			var statements:IList = method.getStatements();
			var iterator:IIterator = statements.iterator();
			var result:Array = [];
			while (iterator.hasNext()) {
				var statement:IASStatement = iterator.next();
				if (statement is ASTASExpressionStatement) {
					var item:LocaleItemDataVO = addItem(statement as ASTASExpressionStatement);
					if (item) {
						result[result.length] = item;
						logger.info("Extracted translation from code snippet '" + statement.toString() + "'");
					}
				}
			}
			_content = new ArrayCollection(result);
		}
	}
}
