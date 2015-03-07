package org.apache.flex.pmd.parser.ast;

/**
 * Created by christoferdutz on 06.03.15.
 */
public class Token implements java.io.Serializable {
    public static Token create(final String textContent,
                               final int tokenLine,
                               final int tokenColumn) {
        return new Token(textContent, tokenLine, tokenColumn);
    }

    private final int column;
    private final boolean isNumeric;
    private final int line;
    private final String text;

    /**
     * @param textContent
     * @param tokenLine
     * @param tokenColumn
     */
    public Token(final String textContent,
                 final int tokenLine,
                 final int tokenColumn) {
        this(textContent, tokenLine, tokenColumn, false);
    }

    /**
     * @param textContent
     * @param tokenLine
     * @param tokenColumn
     * @param isNumToSet
     */
    public Token(final String textContent,
                 final int tokenLine,
                 final int tokenColumn,
                 final boolean isNumToSet) {
        text = textContent;
        line = tokenLine + 1;
        column = tokenColumn + 1;
        isNumeric = isNumToSet;
    }

    /**
     * @return
     */
    public int getColumn() {
        return column;
    }

    /**
     * @return
     */
    public int getLine() {
        return line;
    }

    /**
     * @return
     */
    public String getText() {
        return text;
    }

    /**
     * @return
     */
    public boolean isNum() {
        return isNumeric;
    }
}
