package org.apache.flex.pmd.utils;

import org.apache.commons.lang3.StringUtils;

import java.util.regex.Pattern;

/**
 * Created by christoferdutz on 06.03.15.
 */
public final class RegexUtils {

    public static boolean isMatch(Pattern pattern, String input) {
        return ((pattern != null) && StringUtils.isNotBlank(input)) && pattern.matcher(input).find();
    }

}
