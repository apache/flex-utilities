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

public class TestIfStatement extends AbstractStatementTest
{
   @Test
   public void testBug232() throws TokenException
   {
      assertStatement( "",
                       "if (true || /* comment */!false) ) )",
                       "<if line=\"1\"><condition line=\"1\"><or line=\"1\"><primary line=\"1\">"
                             + "true</primary><op line=\"1\">||</op><not line=\"1\"><primary "
                             + "line=\"1\">false</primary></not></or></condition><primary "
                             + "line=\"1\">)</primary></if>" );
   }

   @Test
   public void testIf() throws TokenException
   {
      assertStatement( "1",
                       "if( true ){ trace( true ); }",
                       "<if line=\"1\">"
                             + "<condition line=\"1\">" + "<primary line=\"1\">true</primary></condition>"
                             + "<block line=\"1\"><call line=\"1\">" + "<primary line=\"1\">trace"
                             + "</primary><arguments line=\"1\">" + "<primary line=\"1\">true</primary>"
                             + "</arguments></call></block></if>" );

      assertStatement( "1",
                       "if( \"i\" in oaderContext ){ }",
                       "<if line=\"1\"><condition line=\"1\">"
                             + "<relation line=\"1\"><primary line=\"1\">"
                             + "\"i\"</primary><op line=\"1\">in</op>"
                             + "<primary line=\"1\">oaderContext</primary>"
                             + "</relation></condition><block line=\"1\"></block></if>" );

      assertStatement( "internal",
                       "if (col.mx_internal::contentSize) {col.mx_internal::_width = NaN;}",
                       "<if line=\"1\"><condition line=\"1\">"
                             + "<dot line=\"1\"><primary line=\"1\">col"
                             + "</primary><dot line=\"1\"><primary line=\"1\">"
                             + "mx_internal</primary><primary line=\"1\">contentSize"
                             + "</primary></dot></dot></condition><block line=\"1\">"
                             + "<dot line=\"1\"><primary line=\"1\">col"
                             + "</primary><dot line=\"1\"><primary line=\"1\">"
                             + "mx_internal</primary><assign line=\"1\">"
                             + "<primary line=\"1\">_width</primary>"
                             + "<op line=\"1\">=</op><primary line=\"1\">"
                             + "NaN</primary></assign></dot></dot></block></if>" );
   }

   @Test
   public void testIfElse() throws TokenException
   {
      assertStatement( "1",
                       "if( true ){ trace( true ); } else { trace( false )}",
                       "<if line=\"1\"><condition line=\"1\">"
                             + "<primary line=\"1\">true" + "</primary></condition><block line=\"1\">"
                             + "<call line=\"1\"><primary line=\"1\">trace"
                             + "</primary><arguments line=\"1\">"
                             + "<primary line=\"1\">true</primary></arguments>"
                             + "</call></block><block line=\"1\">" + "<call line=\"1\">"
                             + "<primary line=\"1\">trace</primary>" + "<arguments line=\"1\">"
                             + "<primary line=\"1\">false</primary>" + "</arguments></call></block></if>" );
   }

   @Test
   public void testIfWithArrayAccessor() throws TokenException
   {
      assertStatement( "",
                       "if ( chart.getItemAt( 0 )[ xField ] > targetXFieldValue ){}",
                       "<if line=\"1\"><condition line=\"1\"><dot line=\"1\""
                             + "><primary line=\"1\">chart</primary><relation line=\"1\""
                             + "><call line=\"1\"><primary line=\"1\""
                             + ">getItemAt</primary><arguments line=\"1\"" + "><primary line=\"1\""
                             + ">0</primary></arguments><array line=\"1\"" + "><primary line=\"1\""
                             + ">xField</primary></array></call><op line=\"1\"" + ">&gt;</op><primary "
                             + "line=\"1\">targetXFieldValue</primary>"
                             + "</relation></dot></condition><block line=\"1\"" + "></block></if>" );
   }

   @Test
   public void testIfWithEmptyStatement() throws TokenException
   {
      assertStatement( "1",
                       "if( i++ ); ",
                       "<if line=\"1\"><condition line=\"1\">"
                             + "<post-inc line=\"1\"><primary line=\"1\">"
                             + "i</primary></post-inc></condition><stmt-empty line=\"1\">;"
                             + "</stmt-empty></if>" );
   }

   @Test
   public void testIfWithoutBlock() throws TokenException
   {
      assertStatement( "1",
                       "if( i++ ) trace( i ); ",
                       "<if line=\"1\"><condition line=\"1\">"
                             + "<post-inc line=\"1\"><primary line=\"1\">i"
                             + "</primary></post-inc></condition><call line=\"1\">"
                             + "<primary line=\"1\">trace</primary><arguments line=\"1\""
                             + "><primary line=\"1\">i</primary>" + "</arguments></call></if>" );
   }

   @Test
   public void testIfWithReturn() throws TokenException
   {
      assertStatement( "",
                       "if ( true )return;",
                       "<if line=\"1\"><condition line=\"1\"><primary line=\"1\""
                             + ">true</primary></condition><return line=\"2\"" + "></return></if>" );

      assertStatement( "",
                       "if ( true )throw new Error();",
                       "<if line=\"1\"><condition line=\"1\"><primary line=\"1\""
                             + ">true</primary></condition><primary line=\"1\">" + "throw</primary></if>" );
   }
}
