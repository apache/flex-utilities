/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.adobe.ac.pmd.parser;

/**
 * @author xagnetti
 */
public enum Operators
{
   AND("&&"),
   AND_AS2("and"),
   AND_EQUAL("&="),
   AT("@"),
   B_AND("&"),
   B_OR("|"),
   B_XOR("^"),
   COLUMN(":"),
   COMMA(","),
   DECREMENT("--"),
   DIVIDED_EQUAL("/="),
   DOT("."),
   DOUBLE_COLUMN("::"),
   DOUBLE_EQUAL("=="),
   DOUBLE_EQUAL_AS2("eq"),
   DOUBLE_QUOTE("\""),
   DOUBLE_SHIFT_LEFT("<<"),
   DOUBLE_SHIFT_RIGHT(">>"),
   EQUAL("="),
   INCREMENT("++"),
   INFERIOR("<"),
   INFERIOR_AS2("lt"),
   INFERIOR_OR_EQUAL("<="),
   INFERIOR_OR_EQUAL_AS2("le"),
   LEFT_CURLY_BRACKET("{"),
   LEFT_PARENTHESIS("("),
   LEFT_SQUARE_BRACKET("["),
   LOGICAL_OR("||"),
   LOGICAL_OR_AS2("or"),
   MINUS("-"),
   MINUS_EQUAL("-="),
   MODULO("%"),
   MODULO_EQUAL("%="),
   NON_EQUAL("!="),
   NON_EQUAL_AS2_1("ne"),
   NON_EQUAL_AS2_2("<>"),
   NON_STRICTLY_EQUAL("!=="),
   OR_EQUAL("|="),
   PLUS("+"),
   PLUS_AS2("add"),
   PLUS_EQUAL("+="),
   QUESTION_MARK("?"),
   REST_PARAMETERS("..."),
   RIGHT_CURLY_BRACKET("}"),
   RIGHT_PARENTHESIS(")"),
   RIGHT_SQUARE_BRACKET("]"),
   SEMI_COLUMN(";"),
   SIMPLE_QUOTE("'"),
   SLASH("/"),
   STRICTLY_EQUAL("==="),
   SUPERIOR(">"),
   SUPERIOR_AS2("gt"),
   SUPERIOR_OR_EQUAL(">="),
   SUPERIOR_OR_EQUAL_AS2("ge"),
   TIMES("*"),
   TIMES_EQUAL("*="),
   TRIPLE_SHIFT_LEFT("<<<"),
   TRIPLE_SHIFT_RIGHT(">>>"),
   VECTOR_START(".<"),
   XOR_EQUAL("^=");

   private String symbol;

   private Operators( final String symbolToBeSet )
   {
      symbol = symbolToBeSet;
   }

   /*
    * (non-Javadoc)
    * @see java.lang.Enum#toString()
    */
   @Override
   public String toString()
   {
      return symbol;
   }
}
