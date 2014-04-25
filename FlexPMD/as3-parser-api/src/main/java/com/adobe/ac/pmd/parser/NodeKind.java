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
public enum NodeKind
{
   ADD("add"),
   AND("and"),
   ARGUMENTS("arguments"),
   ARRAY("array"),
   ARRAY_ACCESSOR("arr-acc"),
   AS("as"),
   AS_DOC("as-doc"),
   ASSIGN("assign"),
   B_AND("b-and"),
   B_NOT("b-not"),
   B_OR("b-or"),
   B_XOR("b-xor"),
   BLOCK("block"),
   CALL("call"),
   CASE("case"),
   CASES("cases"),
   CATCH("catch"),
   CLASS("class"),
   COMPILATION_UNIT("compilation-unit"),
   COND("cond"),
   CONDITION("condition"),
   CONDITIONAL("conditional"),
   CONST("const"),
   CONST_LIST("const-list"),
   CONTENT("content"),
   DEFAULT("default"),
   DELETE("delete"),
   DO("do"),
   DOT("dot"),
   E4X_ATTR("e4x-attr"),
   E4X_FILTER("e4x-filter"),
   E4X_STAR("e4x-star"),
   ENCAPSULATED("encapsulated"),
   EQUALITY("equality"),
   EXPR_LIST("expr-list"),
   EXTENDS("extends"),
   FINALLY("finally"),
   FOR("for"),
   FOREACH("foreach"),
   FORIN("forin"),
   FUNCTION("function"),
   GET("get"),
   IF("if"),
   IMPLEMENTS("implements"),
   IMPLEMENTS_LIST("implements-list"),
   IMPORT("import"),
   IN("in"),
   INCLUDE("include"),
   INIT("init"),
   INTERFACE("interface"),
   ITER("iter"),
   LAMBDA("lambda"),
   LEFT_CURLY_BRACKET("{"),
   META("meta"),
   META_LIST("meta-list"),
   MINUS("minus"),
   MOD_LIST("mod-list"),
   MODIFIER("mod"),
   MULTI_LINE_COMMENT("multi-line-comment"),
   MULTIPLICATION("mul"),
   NAME("name"),
   NAME_TYPE_INIT("name-type-init"),
   NEW("new"),
   NOT("not"),
   OBJECT("object"),
   OP("op"),
   OR("or"),
   PACKAGE("package"),
   PARAMETER("parameter"),
   PARAMETER_LIST("parameter-list"),
   PLUS("plus"),
   POST_DEC("post-dec"),
   POST_INC("post-inc"),
   PRE_DEC("pre-dec"),
   PRE_INC("pre-inc"),
   PRIMARY("primary"),
   PROP("prop"),
   RELATION("relation"),
   REST("rest"),
   RETURN("return"),
   SET("set"),
   SHIFT("shift"),
   STAR("star"),
   STMT_EMPTY("stmt-empty"),
   SWITCH("switch"),
   SWITCH_BLOCK("switch-block"),
   TRY("try"),
   TYPE("type"),
   TYPEOF("typeof"),
   USE("use"),
   VALUE("value"),
   VAR("var"),
   VAR_LIST("var-list"),
   VECTOR("vector"),
   VOID("void"),
   WHILE("while");

   private String name;

   private NodeKind( final String nameToBeSet )
   {
      name = nameToBeSet;
   }

   /*
    * (non-Javadoc)
    * @see java.lang.Enum#toString()
    */
   @Override
   public String toString()
   {
      return name;
   }
}
