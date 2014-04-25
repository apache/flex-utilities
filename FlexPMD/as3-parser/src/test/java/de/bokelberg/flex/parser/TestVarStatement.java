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
package de.bokelberg.flex.parser;

import org.junit.Test;

import com.adobe.ac.pmd.parser.exceptions.TokenException;

public class TestVarStatement extends AbstractStatementTest
{
   @Test
   public void testFlexPMD211() throws TokenException
   {
      assertStatement( "",
                       "var a:Vector.<String> = new Vector.<String>();\nvar i:int;",
                       "<var-list line=\"1\"><name-type-init line=\"1\"><name line=\"1\">a</name>"
                             + "<vector line=\"1\"><type line=\"1\">String</type></vector>"
                             + "<init line=\"1\"><new line=\"1\"><primary line=\"1\">Vector</primary>"
                             + "<vector line=\"1\"><vector line=\"1\"><type line=\"1\">String</type>"
                             + "</vector></vector><arguments line=\"1\"></arguments></new></init>"
                             + "</name-type-init></var-list>" );
   }

   @Test
   public void testFullFeaturedVar() throws TokenException
   {
      assertStatement( "1",
                       "var a : int = 4",
                       "<var-list line=\"1\">"
                             + "<name-type-init line=\"1\">"
                             + "<name line=\"1\">a</name><type line=\"1\">int</type>"
                             + "<init line=\"1\"><primary line=\"1\">4</primary>"
                             + "</init></name-type-init></var-list>" );

      assertStatement( "1",
                       "var a : int = 4, b : int = 2;",
                       "<var-list line=\"1\"><name-type-init line=\"1\">"
                             + "<name line=\"1\">a</name><type line=\"1\">int</type>"
                             + "<init line=\"1\"><primary line=\"1\">4</primary></init>"
                             + "</name-type-init><name-type-init line=\"1\">"
                             + "<name line=\"1\">b</name><type line=\"1\">int</type>"
                             + "<init line=\"1\"><primary line=\"1\">2</primary></init>"
                             + "</name-type-init></var-list>" );

      assertStatement( "with array",
                       "var colors:Array = [0x2bc9f6, 0x0086ad];",
                       "<var-list line=\"1\">"
                             + "<name-type-init line=\"1\">"
                             + "<name line=\"1\">colors</name><type line=\"1\">Array</type>"
                             + "<init line=\"1\">" + "<primary line=\"1\"><array line=\"1\">"
                             + "<primary line=\"1\">0x2bc9f6</primary>"
                             + "<primary line=\"1\">0x0086ad</primary>"
                             + "</array></primary></init></name-type-init></var-list>" );
   }

   @Test
   public void testInitializedVar() throws TokenException
   {
      assertStatement( "1",
                       "var a = 4",
                       "<var-list line=\"1\"><name-type-init line=\"1\">"
                             + "<name line=\"1\">a</name><type line=\"1\">"
                             + "</type><init line=\"1\"><primary line=\"1\">4</primary>"
                             + "</init></name-type-init></var-list>" );
   }

   @Test
   public void testSimpleVar() throws TokenException
   {
      assertStatement( "1",
                       "var a",
                       "<var-list line=\"1\"><name-type-init line=\"1\">"
                             + "<name line=\"1\">a</name><type line=\"2\">"
                             + "</type></name-type-init></var-list>" );
   }

   @Test
   public void testTypedVar() throws TokenException
   {
      assertStatement( "1",
                       "var a : Object",
                       "<var-list line=\"1\"><name-type-init line=\"1\">"
                             + "<name line=\"1\">a</name><type line=\"1\">Object</type>"
                             + "</name-type-init></var-list>" );
   }

   @Test
   public void testVector() throws TokenException
   {
      assertStatement( "vector",
                       "var v:Vector.<DisplayObject> = new Vector.<Sprite>();",
                       "<var-list line=\"1\"><name-type-init line=\"1\"><name line=\"1\">v</name><vector line=\"1\"><type line=\"1\">DisplayObject</type></vector><init line=\"1\"><new line=\"1\"><primary line=\"1\">Vector</primary><vector line=\"1\"><vector line=\"1\"><type line=\"1\">Sprite</type></vector></vector><arguments line=\"1\"></arguments></new></init></name-type-init></var-list>" );

      assertStatement( "vector",
                       "var v:Vector.< Vector.< String > >",
                       "<var-list line=\"1\"><name-type-init line=\"1\">"
                             + "<name line=\"1\">" + "v</name><vector line=\"1\"><vector line=\"1\""
                             + "><type line=\"1\""
                             + ">String</type></vector></vector></name-type-init></var-list>" );

      assertStatement( "vector",
                       "var v:Vector.<Vector.<String>>;",
                       "<var-list line=\"1\"><name-type-init line=\"1\">"
                             + "<name line=\"1\">"
                             + "v</name><vector line=\"1\"><vector line=\"1\"><type line=\"1\""
                             + ">String</type></vector></vector></name-type-init></var-list>" );

      assertStatement( "",
                       "var HT:Vector.<BitString> = new Vector.<BitString>(251, true);",
                       "<var-list line=\"1\"><name-type-init line=\"1\"><name line=\"1\">HT</name><vector line=\"1\"><type line=\"1\">BitString</type></vector><init line=\"1\"><new line=\"1\"><primary line=\"1\">Vector</primary><vector line=\"1\"><vector line=\"1\"><type line=\"1\">BitString</type></vector></vector><arguments line=\"1\"><primary line=\"1\">251</primary><primary line=\"1\">true</primary></arguments></new></init></name-type-init></var-list>" );
   }
}
