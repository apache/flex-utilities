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

import static org.junit.Assert.assertEquals;

import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.Map.Entry;

import net.sourceforge.pmd.cpd.CPD;
import net.sourceforge.pmd.cpd.Match;

import org.junit.Ignore;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.IFlexFile;

public class FlexCpdTest extends FlexPmdTestBase
{
   private class ExpectedMatchInformation
   {
      private final int lineCount;
      private final int markCount;
      private final int tokenCount;

      public ExpectedMatchInformation( final int tokenCountToBeSet,
                                       final int markCountToBeSet,
                                       final int lineCountToBeSet )
      {
         lineCount = lineCountToBeSet;
         tokenCount = tokenCountToBeSet;
         markCount = markCountToBeSet;
      }
   }
   final ExpectedMatchInformation[] EXPECTED = new ExpectedMatchInformation[]
                                             { new ExpectedMatchInformation( 107, 2, 7 ),
               new ExpectedMatchInformation( 79, 2, 17 ),
               new ExpectedMatchInformation( 77, 2, 6 ),
               new ExpectedMatchInformation( 76, 2, 18 ),
               new ExpectedMatchInformation( 64, 2, 7 ),
               new ExpectedMatchInformation( 60, 3, 14 ),
               new ExpectedMatchInformation( 57, 2, 7 ),
               new ExpectedMatchInformation( 54, 2, 9 ),
               new ExpectedMatchInformation( 53, 2, 8 ),
               new ExpectedMatchInformation( 48, 2, 18 ) };

   @Test
   @Ignore
   public void test119() throws IOException
   {
      final CPD cpd = new CPD( 25, new FlexLanguage() );

      cpd.add( new File( "src/test/resources/test/FlexPMD119.mxml" ) );
      cpd.go();

      final Iterator< Match > matchIterator = cpd.getMatches();
      final Match match = matchIterator.next();

      assertEquals( "The first mark is not correct",
                    41,
                    match.getFirstMark().getBeginLine() );
      assertEquals( "The second mark is not correct",
                    81,
                    match.getSecondMark().getBeginLine() );
   }

   @Test
   @Ignore
   public void tokenize() throws IOException
   {
      final Iterator< Match > matchIterator = getMatchIterator();

      for ( int currentIndex = 0; matchIterator.hasNext()
            && currentIndex < EXPECTED.length; currentIndex++ )
      {
         final Match currentMatch = matchIterator.next();

         assertEquals( "The token count is not correct on the "
                             + currentIndex + "th index",
                       EXPECTED[ currentIndex ].tokenCount,
                       currentMatch.getTokenCount() );

         assertEquals( "The mark count is not correct on the "
                             + currentIndex + "th index",
                       EXPECTED[ currentIndex ].markCount,
                       currentMatch.getMarkCount() );

         assertEquals( "The line count is not correct on the "
                             + currentIndex + "th index",
                       EXPECTED[ currentIndex ].lineCount,
                       currentMatch.getLineCount() );
      }
   }

   private Iterator< Match > getMatchIterator() throws IOException
   {
      final CPD cpd = new CPD( 25, new FlexLanguage() );

      for ( final Entry< String, IFlexFile > includedFile : getTestFiles().entrySet() )
      {
         cpd.add( new File( includedFile.getValue().getFilePath() ) );
      }
      cpd.go();

      return cpd.getMatches();
   }
}
