package org.apache.flex.pmd.rule;

import net.sourceforge.pmd.Rule;
import net.sourceforge.pmd.RuleContext;
import net.sourceforge.pmd.lang.rule.ParametricRuleViolation;
import org.apache.flex.pmd.parser.ast.FlexNode;

/**
 * Created by christoferdutz on 06.03.15.
 */
public class FlexRuleViolation extends ParametricRuleViolation<FlexNode> {

    public FlexRuleViolation(Rule rule, RuleContext ctx, FlexNode node, String message, int beginLine, int endLine) {
        this(rule, ctx, node, message);

        setLines(beginLine, endLine);
    }

    public FlexRuleViolation(Rule theRule, RuleContext ctx, FlexNode node, String message) {
        super(theRule, ctx, node, message);
    }

}
