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
public enum KeyWords
{
   AS("as"),
   CASE("case"),
   CATCH("catch"),
   CLASS("class"),
   CONST("const"),
   DEFAULT("default"),
   DELETE("delete"),
   DO("do"),
   DYNAMIC("dynamic"),
   EACH("each"),
   ELSE("else"),
   EOF("__END__"),
   EXTENDS("extends"),
   FINAL("final"),
   FINALLY("finally"),
   FOR("for"),
   FUNCTION("function"),
   GET("get"),
   IF("if"),
   IMPLEMENTS("implements"),
   IMPORT("import"),
   IN("in"),
   INCLUDE("include"),
   INCLUDE_AS2("#include"),
   INSTANCE_OF("instanceof"),
   INTERFACE("interface"),
   INTERNAL("internal"),
   INTRINSIC("intrinsic"),
   IS("is"),
   NAMESPACE("namespace"),
   NEW("new"),
   OVERRIDE("override"),
   PACKAGE("package"),
   PRIVATE("private"),
   PROTECTED("protected"),
   PUBLIC("public"),
   RETURN("return"),
   SET("set"),
   STATIC("static"),
   SUPER("super"),
   SWITCH("switch"),
   TRY("try"),
   TYPEOF("typeof"),
   USE("use"),
   VAR("var"),
   VOID("void"),
   WHILE("while");

   private final String name;

   private KeyWords( final String nameToBeSet )
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
