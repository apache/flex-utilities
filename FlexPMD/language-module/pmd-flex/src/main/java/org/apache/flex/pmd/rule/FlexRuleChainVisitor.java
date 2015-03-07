package org.apache.flex.pmd.rule;

import net.sourceforge.pmd.Rule;
import net.sourceforge.pmd.RuleContext;
import net.sourceforge.pmd.lang.ast.Node;
import net.sourceforge.pmd.lang.rule.AbstractRuleChainVisitor;

import java.util.List;

/**
 * Created by christoferdutz on 06.03.15.
 */
public class FlexRuleChainVisitor extends AbstractRuleChainVisitor {

    @Override
    protected void visit(Rule rule, Node node, RuleContext ruleContext) {

    }

    @Override
    protected void indexNodes(List<Node> list, RuleContext ruleContext) {

    }

}
