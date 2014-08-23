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
package com.adobe.ac.cpd;

import java.io.File;
import java.util.HashSet;
import java.util.Set;

import net.sourceforge.pmd.cpd.SourceCode;
import net.sourceforge.pmd.cpd.TokenEntry;
import net.sourceforge.pmd.cpd.Tokenizer;
import net.sourceforge.pmd.cpd.Tokens;

import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.files.IMxmlFile;
import com.adobe.ac.pmd.files.impl.FileUtils;
import com.adobe.ac.pmd.parser.KeyWords;
import com.adobe.ac.pmd.parser.Operators;

import de.bokelberg.flex.parser.AS3Parser;
import de.bokelberg.flex.parser.AS3Scanner;
import de.bokelberg.flex.parser.AS3Scanner.Token;

public class FlexTokenizer implements Tokenizer
{
   public static final int            DEFAULT_MINIMUM_TOKENS = 25;
   private static final Set< String > IGNORED_TOKENS;
   private static final Set< String > IGNORING_LINE_TOKENS;

   static
   {
      IGNORED_TOKENS = new HashSet< String >();
      IGNORED_TOKENS.add( Operators.SEMI_COLUMN.toString() );
      IGNORED_TOKENS.add( Operators.LEFT_CURLY_BRACKET.toString() );
      IGNORED_TOKENS.add( Operators.RIGHT_CURLY_BRACKET.toString() );
      IGNORED_TOKENS.add( AS3Parser.NEW_LINE );
      IGNORING_LINE_TOKENS = new HashSet< String >();
      IGNORING_LINE_TOKENS.add( KeyWords.IMPORT.toString() );
      IGNORING_LINE_TOKENS.add( KeyWords.PACKAGE.toString() );
   }

   private static boolean isTokenIgnored( final String tokenText )
   {
      return IGNORED_TOKENS.contains( tokenText )
            || tokenText.startsWith( AS3Parser.MULTIPLE_LINES_COMMENT )
            || tokenText.startsWith( AS3Parser.SINGLE_LINE_COMMENT );
   }

   private static boolean isTokenIgnoringLine( final String tokenText )
   {
      return IGNORING_LINE_TOKENS.contains( tokenText );
   }

   public void tokenize( final SourceCode tokens,
                         final Tokens tokenEntries )
   {
      try
      {
         final AS3Scanner scanner = initializeScanner( tokens );
         Token currentToken = scanner.moveToNextToken();
         int inImportLine = 0;

         while ( currentToken != null
               && currentToken.getText().compareTo( KeyWords.EOF.toString() ) != 0 )
         {
            final String currentTokenText = currentToken.getText();
            final int currentTokenLine = currentToken.getLine();

            if ( !isTokenIgnored( currentTokenText ) )
            {
               if ( isTokenIgnoringLine( currentTokenText ) )
               {
                  inImportLine = currentTokenLine;
               }
               else
               {
                  if ( inImportLine == 0
                        || inImportLine != currentTokenLine )
                  {
                     inImportLine = 0;
                     tokenEntries.add( new TokenEntry( currentTokenText, // NOPMD
                                                       tokens.getFileName(),
                                                       currentTokenLine ) );
                  }
               }
            }
            currentToken = scanner.moveToNextToken();
         }
      }
      catch ( final Exception e )
      {
      }
      finally
      {
         tokenEntries.add( TokenEntry.getEOF() );
      }
   }

   private AS3Scanner initializeScanner( final SourceCode tokens )
   {
      final AS3Scanner scanner = new AS3Scanner();

      final IFlexFile flexFile = FileUtils.create( new File( tokens.getFileName() ),
                                                   new File( "" ) );

      if ( flexFile instanceof IMxmlFile )
      {
         final IMxmlFile mxml = ( IMxmlFile ) flexFile;

         scanner.setLines( mxml.getScriptBlock() );
      }
      else
      {
         scanner.setLines( tokens.getCode().toArray( new String[ tokens.getCode().size() ] ) );
      }
      return scanner;
   }
}
