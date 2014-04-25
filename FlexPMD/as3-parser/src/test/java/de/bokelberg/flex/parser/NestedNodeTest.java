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

import org.junit.Before;
import org.junit.Test;

import com.adobe.ac.pmd.parser.NodeKind;
import com.adobe.ac.pmd.parser.exceptions.TokenException;

public class NestedNodeTest extends AbstractAs3ParserTest
{
   private NestedNode function;

   @Override
   @Before
   public void setUp()
   {
      super.setUp();

      final String code = "public function foo() : void     {"
            + "while(i>0){" + "while(true){" + "switch(a){" + "case 1:break;default:return;" + "}" + "}"
            + "}" + "}";
      final Node classNode = parseClass( code );

      function = ( Node ) classNode.getChild( 0 );
   }

   @Test
   public void testComputeCyclomaticComplexity()
   {
      assertEquals( 5,
                    function.computeCyclomaticComplexity() );
   }

   @Test
   public void testCountNodeFromType()
   {
      assertEquals( 2,
                    function.countNodeFromType( NodeKind.WHILE ) );
   }

   @Test
   public void testGetLastChild()
   {
      assertEquals( NodeKind.RETURN,
                    function.getLastChild().getId() );

      assertNull( function.getChild( Integer.MAX_VALUE ) );
   }

   @Test
   public void testIs()
   {
      assertFalse( function.is( null ) );
   }

   private Node parseClass( final String input )
   {
      scn.setLines( new String[]
      { "{",
                  input,
                  "}",
                  "__END__" } );
      try
      {
         asp.nextToken();
         asp.nextToken(); // skip {
         return asp.parseClassContent();
      }
      catch ( final TokenException e )
      {
         e.printStackTrace();
      }
      return null;
   }
}
