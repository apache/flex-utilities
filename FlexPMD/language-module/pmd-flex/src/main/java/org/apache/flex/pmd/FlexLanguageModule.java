package org.apache.flex.pmd;

import net.sourceforge.pmd.lang.BaseLanguageModule;
import org.apache.flex.pmd.handler.Flex4LanguageVersionHandler;
import org.apache.flex.pmd.rule.FlexRuleChainVisitor;

/**
 * Created by christoferdutz on 06.03.15.
 */
public class FlexLanguageModule extends BaseLanguageModule {

    public static final String NAME = "Flex";
    public static final String TERSE_NAME = "flex";
    public static final String DEFAULT_VERSION = "flex4";

    public FlexLanguageModule() {
        super(NAME, null, TERSE_NAME, FlexRuleChainVisitor.class, ".as", ".mxml");
        addVersion(DEFAULT_VERSION, new Flex4LanguageVersionHandler(), true);
    }

}
