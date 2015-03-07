package org.apache.flex.pmd.rule;

import net.sourceforge.pmd.Rule;
import net.sourceforge.pmd.RuleContext;
import net.sourceforge.pmd.RuleViolation;
import net.sourceforge.pmd.lang.ast.Node;
import net.sourceforge.pmd.lang.rule.AbstractRuleViolationFactory;
import net.sourceforge.pmd.lang.rule.RuleViolationFactory;
import org.apache.flex.pmd.parser.ast.FlexNode;

/**
 * Created by christoferdutz on 06.03.15.
 */
public class FlexRuleViolationFactory extends AbstractRuleViolationFactory {

    public static final RuleViolationFactory INSTANCE = new FlexRuleViolationFactory();

    @Override
    protected RuleViolation createRuleViolation(Rule rule, RuleContext ruleContext, Node node, String message) {
        return new FlexRuleViolation(rule, ruleContext, (FlexNode) node, message);
    }

    @Override
    protected RuleViolation createRuleViolation(Rule rule, RuleContext ruleContext, Node node, String message, int beginLine, int endLine) {
        return new FlexRuleViolation(rule, ruleContext, (FlexNode) node, message, beginLine, endLine);
    }

}
