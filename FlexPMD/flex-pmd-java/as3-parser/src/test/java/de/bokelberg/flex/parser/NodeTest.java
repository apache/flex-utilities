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

public class NodeTest extends AbstractAs3ParserTest
{
   @Test
   public void testFindPrimaryStatementsFromNameInChildren() throws TokenException
   {
      final Node ast = parseFunction( "function set a( value : int ) : void { trace(\"lala\")}" );

      assertEquals( 2,
                    ast.findPrimaryStatementsFromNameInChildren( new String[]
                    { "trace",
                                "\"lala\"" } ).size() );
   }

   @Test
   public void testToString() throws TokenException
   {
      final Node ast = parseFunction( "function set a( value : int ) : void { trace(\"lala\")}" );

      assertEquals( "content set mod-list  a  parameter-list parameter name-type-init "
                          + "value  int     void  block call trace  arguments \"lala\"      ",
                    ast.toString() );
   }

   private Node parseFunction( final String input ) throws TokenException
   {
      scn.setLines( new String[]
      { "{",
                  input,
                  "}",
                  "__END__" } );
      asp.nextToken(); // first call
      asp.nextToken(); // skip {
      return asp.parseClassContent();
   }
}
