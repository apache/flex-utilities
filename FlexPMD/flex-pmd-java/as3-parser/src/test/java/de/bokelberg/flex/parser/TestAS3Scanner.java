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

import de.bokelberg.flex.parser.AS3Scanner.Token;

public class TestAS3Scanner extends AbstractAs3ParserTest
{
   @Test
   public void testAssignments()
   {
      final String[] lines = new String[]
      { "=",
                  "+=",
                  "-=",
                  "%=",
                  "^=",
                  "&=",
                  "|=",
                  "/=" };
      scn.setLines( lines );

      for ( int i = 0; i < lines.length; i++ )
      {
         assertText( Integer.toString( i ),
                     lines[ i ] );
         assertText( "\n" );
      }
   }

   @Test
   public void testBooleanOperators()
   {
      final String[] lines = new String[]
      { "&&",
                  "&=",
                  "||",
                  "|=" };
      scn.setLines( lines );

      for ( int i = 0; i < lines.length; i++ )
      {
         assertText( Integer.toString( i ),
                     lines[ i ] );
         assertText( "\n" );
      }
   }

   @Test
   public void testComparisonOperators()
   {
      final String[] lines = new String[]
      { ">",
                  ">>>=",
                  ">>>",
                  ">>=",
                  ">>",
                  ">=",
                  "===",
                  "==",
                  "!==",
                  "!=" };
      scn.setLines( lines );

      for ( int i = 0; i < lines.length; i++ )
      {
         assertText( Integer.toString( i ),
                     lines[ i ] );
         assertText( "\n" );
      }
   }

   @Test
   public void testIdentifiers()
   {
      final String[] lines = new String[]
      { "a",
                  "a.b.*",
                  "a.b::c",
                  "a.E" };
      scn.setLines( lines );

      assertText( "1",
                  lines[ 0 ] );
      assertText( "\n" );

      assertText( "2",
                  "a" );
      assertText( "2",
                  "." );
      assertText( "2",
                  "b" );
      assertText( "2",
                  "." );
      assertText( "2",
                  "*" );
      assertText( "\n" );

      assertText( "3",
                  "a" );
      assertText( "3",
                  "." );
      assertText( "3",
                  "b" );
      assertText( "3",
                  "::" );
      assertText( "3",
                  "c" );
      assertText( "\n" );

      assertText( "4",
                  "a" );
      assertText( "4",
                  "." );
      assertText( "4",
                  "E" );
   }

   @Test
   public void testIsDecimalChar()
   {
      final String decimalString = "0123456789";
      for ( int i = 0; i < decimalString.length(); i++ )
      {
         assertTrue( "",
                     AS3Scanner.isDecimalChar( decimalString.charAt( i ) ) );
      }
      assertFalse( "",
                   AS3Scanner.isDecimalChar( ( char ) 0 ) );

   }

   @Test
   public void testIsHex()
   {
      assertTrue( "",
                  scn.isHexChar( '0' ) );
      assertTrue( "",
                  scn.isHexChar( '9' ) );
      assertTrue( "",
                  scn.isHexChar( 'A' ) );
      assertTrue( "",
                  scn.isHexChar( 'a' ) );
      assertTrue( "",
                  scn.isHexChar( 'F' ) );
      assertTrue( "",
                  scn.isHexChar( 'f' ) );
      assertFalse( "",
                   scn.isHexChar( ';' ) );
      assertFalse( "",
                   scn.isHexChar( ']' ) );
      assertFalse( "",
                   scn.isHexChar( ' ' ) );
   }

   @Test
   public void testMultiLineComment()
   {
      final String[] lines = new String[]
      { "/* this is a multi line comment, not really */",
                  "/** now for real",
                  "/* now for real",
                  "*/" };
      scn.setLines( lines );

      assertText( lines[ 0 ] );
      assertText( "\n" );
      assertText( "/** now for real\n/* now for real\n*/" );
   }

   @Test
   public void testMultilineXML()
   {
      final String[] lines = new String[]
      { "<?xml version=\"1.0\"?>",
                  "<a>",
                  "<b>test</b>",
                  "</a>" };
      scn.setLines( lines );
      assertText( join( lines,
                        "\n" ) );
   }

   @Test
   public void testMultipleWords()
   {
      final String[] lines = new String[]
      { "word1 word2 word3",
                  "word4",
                  "word5 word6" };
      scn.setLines( lines );

      assertText( "word1" );
      assertText( "word2" );
      assertText( "word3" );
      assertText( "\n" );
      assertText( "word4" );
      assertText( "\n" );
      assertText( "word5" );
      assertText( "word6" );
   }

   @Test
   public void testNumbers()
   {
      final String[] lines = new String[]
      { "0",
                  "1.2",
                  "1.2E5",
                  "0xffgg" };
      scn.setLines( lines );

      assertText( lines[ 0 ] );
      assertText( "\n" );
      assertText( lines[ 1 ] );
      assertText( "\n" );
      assertText( lines[ 2 ] );
      assertText( "\n" );
      assertText( lines[ 3 ] );
   }

   @Test
   public void testPlusSymbols()
   {
      final String[] lines = new String[]
      { "++",
                  "+=",
                  "+",
                  "--",
                  "-=",
                  "-" };
      scn.setLines( lines );

      for ( int i = 0; i < lines.length; i++ )
      {
         assertText( Integer.toString( i ),
                     lines[ i ] );
         assertText( "\n" );
      }
   }

   @Test
   public void testSingleCharacterSymbols()
   {
      final String[] lines = "{}()[]:;,?~".split( "" );
      scn.setLines( lines );

      // the first entry is empty, so we skip it
      for ( int i = 1; i < lines.length; i++ )
      {
         assertText( "\n" );
         assertText( Integer.toString( i ),
                     lines[ i ] );
      }
   }

   @Test
   public void testSingleLineComment()
   {
      final String[] lines = new String[]
      { "//this is a single line comment",
                  "word //another single line comment" };
      scn.setLines( lines );

      assertText( lines[ 0 ] );
      assertText( "\n" );
      assertText( "word" );
      assertText( "//another single line comment" );
   }

   @Test
   public void testSingleWord()
   {
      final String[] lines = new String[]
      { "word" };
      scn.setLines( lines );

      assertText( lines[ 0 ] );
   }

   @Test
   public void testStrings()
   {
      final String[] lines = new String[]
      { "\"string\"",
                  "\'string\'",
                  "\"string\\\"\"" };
      scn.setLines( lines );

      assertText( "1",
                  lines[ 0 ] );
      assertText( "\n" );
      assertText( "2",
                  lines[ 1 ] );
      assertText( "\n" );
      assertText( "3",
                  lines[ 2 ] );
   }

   @Test
   public void testXML()
   {
      final String[] lines = new String[]
      { "<root/>",
                  "<root>test</root>",
                  "<?xml version=\"1.0\"?><root>test</root>" };
      scn.setLines( lines );
      for ( int i = 0; i < lines.length; i++ )
      {
         assertText( Integer.toString( i ),
                     lines[ i ] );
         assertText( "\n" );
      }
   }

   private void assertText( final String text )
   {
      assertText( "",
                  text );
   }

   private void assertText( final String message,
                            final String text )
   {
      Token tokent = null;
      tokent = scn.nextToken();
      assertEquals( message,
                    text,
                    tokent.getText() );
   }

   private String join( final String[] lines,
                        final String delimiter )
   {
      final StringBuffer result = new StringBuffer();
      for ( int i = 0; i < lines.length; i++ )
      {
         if ( i > 0 )
         {
            result.append( delimiter );
         }
         result.append( lines[ i ] );
      }
      return result.toString();
   }
}
