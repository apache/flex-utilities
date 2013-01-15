package org.apache.flex.runtimelocale.model.locale {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.as3commons.asblocks.impl.ASTASArrayAccessExpression;
	import org.as3commons.asblocks.impl.ASTASExpressionStatement;
	import org.as3commons.asblocks.impl.ASTASStringLiteral;

	public class LocaleItemDataVO extends EventDispatcher {

		public function LocaleItemDataVO(left:ASTASArrayAccessExpression, right:ASTASStringLiteral, statement:ASTASExpressionStatement=null) {
			super();
			_left = left;
			_right = right;
			_statement = statement;
		}

		private var _left:ASTASArrayAccessExpression;
		private var _right:ASTASStringLiteral;
		private var _statement:ASTASExpressionStatement;

		public function get key():String {
			return (_left) ? _left.getSubscript().toString() : "";
		}

		public function get statement():ASTASExpressionStatement {
			return _statement;
		}

		public function set statement(value:ASTASExpressionStatement):void {
			_statement = value;
		}

		public function get value():String {
			return ((_right) && (_right.getAST())) ? _right.getValue() : "";
		}

		[Bindable(event="valueChanged")]
		public function set value(val:String):void {
			if ((val != value) && (_right)) {
				_right.setValue(val);
				dispatchEvent(new Event("valueChanged"));
			}
		}
	}
}
