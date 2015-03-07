package org.apache.flex.pmd.handler;

import net.sourceforge.pmd.lang.AbstractLanguageVersionHandler;
import net.sourceforge.pmd.lang.Parser;
import net.sourceforge.pmd.lang.ParserOptions;
import net.sourceforge.pmd.lang.rule.RuleViolationFactory;
import org.apache.flex.pmd.parser.impl.AS3Parser;
import org.apache.flex.pmd.rule.FlexRuleViolationFactory;

/**
 * Created by christoferdutz on 06.03.15.
 */
public class Flex4LanguageVersionHandler extends AbstractLanguageVersionHandler {

    @Override
    public RuleViolationFactory getRuleViolationFactory() {
        return FlexRuleViolationFactory.INSTANCE;
    }

    @Override
    public Parser getParser(ParserOptions parserOptions) {
        return new AS3Parser(parserOptions);
    }

}
