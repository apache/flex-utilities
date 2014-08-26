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

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;

import org.junit.Ignore;
import org.junit.Test;

import com.adobe.ac.pmd.files.impl.FileUtils;

import de.bokelberg.flex.parser.AS3Scanner.Token;

public class TestAS3ScannerWithFiles extends AbstractAs3ParserTest
{

   @Test()
   @Ignore("Simple.as has the completely wrong structure ... have to fix this first.")
   public void testSimple() throws IOException,
                           URISyntaxException
   {
      final String[] expected = new String[]
      { "package",
                  "simple",
                  "{",
                  "public",
                  "class",
                  "Simple",
                  "{",
                  "public",
                  "function",
                  "Simple",
                  "(",
                  ")",
                  "{",
                  "trace",
                  "(",
                  "\"Simple\"",
                  ")",
                  ";",
                  "}",
                  "}" };
/*      assertFile( expected,
                  "Simple.as" );
*/   }

   private void assertFile( final String[] expected,
                            final String fileName ) throws IOException,
                                                   URISyntaxException
   {
      final String[] lines = FileUtils.readLines( new File( getClass().getResource( "/examples/unformatted/" )
                                                                       .toURI()
                                                                       .getPath()
            + fileName ) );
      assertLines( expected,
                   lines );
   }

   private void assertLines( final String[] expected,
                             final String[] lines )
   {
      scn.setLines( lines );
      for ( int i = 0; i < expected.length; i++ )
      {
         assertText( Integer.toString( i ),
                     expected[ i ] );
      }
   }

   private void assertText( final String message,
                            final String text )
   {
      Token token = null;
      token = scn.nextToken();
      assertEquals( message,
                    text,
                    token.getText() );
   }
}
