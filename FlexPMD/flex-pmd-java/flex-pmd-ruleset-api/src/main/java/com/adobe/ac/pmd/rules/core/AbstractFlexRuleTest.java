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
package com.adobe.ac.pmd.rules.core;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.parser.exceptions.TokenException;

public abstract class AbstractFlexRuleTest extends FlexPmdTestBase
{
   final static class AssertPosition
   {
      public static AssertPosition create( final String message,
                                           final int expectedLine,
                                           final int actualLine )
      {
         return new AssertPosition( message, expectedLine, actualLine );
      }

      public int    actualLine;
      public int    expectedLine;
      public String message;

      private AssertPosition( final String messageToBeSet,
                              final int expectedLineToBeSet,
                              final int actualLineToBeSet )
      {
         super();
         message = messageToBeSet;
         expectedLine = expectedLineToBeSet;
         actualLine = actualLineToBeSet;
      }
   }

   protected final static class ExpectedViolation
   {
      protected String              file;
      protected ViolationPosition[] positions;

      public ExpectedViolation( final String fileToBeSet,
                                final ViolationPosition[] positionsToBeSet )
      {
         super();
         file = fileToBeSet;
         positions = positionsToBeSet;
      }
   }

   protected static StringBuffer buildFailuresMessage( final List< AssertPosition > failures )
   {
      final StringBuffer message = new StringBuffer( 42 );

      for ( final AssertPosition assertPosition : failures )
      {
         message.append( assertPosition.message
               + ": expected <" + assertPosition.expectedLine + "> but actually <"
               + assertPosition.actualLine + ">\n" );
      }
      return message;
   }

   protected static List< AssertPosition > buildFailureViolations( final String resourcePath,
                                                                   final ViolationPosition[] expectedPositions,
                                                                   final List< IFlexViolation > violations )
   {
      List< AssertPosition > failures;
      failures = new ArrayList< AssertPosition >();

      for ( int i = 0; i < expectedPositions.length; i++ )
      {
         final IFlexViolation violation = violations.get( i );
         final ViolationPosition expectedPosition = expectedPositions[ i ];

         if ( expectedPosition.getBeginLine() != violation.getBeginLine() )
         {
            failures.add( AssertPosition.create( BEGIN_LINE_NOT_CORRECT
                                                       + " at " + i + "th violation on " + resourcePath,
                                                 expectedPosition.getBeginLine(),
                                                 violation.getBeginLine() ) );
         }
         if ( expectedPosition.getEndLine() != violation.getEndLine() )
         {
            failures.add( AssertPosition.create( END_LINE_NOT_CORRECT
                                                       + " at " + i + "th violation on " + resourcePath,
                                                 expectedPosition.getEndLine(),
                                                 violation.getEndLine() ) );
         }
      }
      return failures;
   }

   protected static StringBuffer buildMessageName( final Map< String, List< IFlexViolation >> violatedFiles )
   {
      final StringBuffer buffer = new StringBuffer( 100 );

      for ( final String violatedFileName : violatedFiles.keySet() )
      {
         final List< IFlexViolation > violations = violatedFiles.get( violatedFileName );

         buffer.append( violatedFileName
               + " should not contain any violations " + " (" + violations.size() + " found" );

         if ( violations.size() == 1 )
         {
            buffer.append( " at "
                  + violations.get( 0 ).getBeginLine() + ":" + violations.get( 0 ).getEndLine() );
         }
         buffer.append( ")\n" );
      }
      return buffer;
   }

   /**
    * Test case which contains non-concerned files by the given rule
    * 
    * @throws TokenException
    * @throws IOException
    */
   @Test
   public final void testProcessNonViolatingFiles() throws IOException,
                                                   TokenException
   {
      final Map< String, List< IFlexViolation >> violatedFiles = extractActualViolatedFiles();
      final StringBuffer buffer = buildMessageName( violatedFiles );

      if ( !violatedFiles.isEmpty() )
      {
         fail( buffer.toString() );
      }
   }

   /**
    * Test case which contains violating files
    */
   @Test
   public final void testProcessViolatingFiles()
   {
      final Map< String, ViolationPosition[] > expectedPositions = computeExpectedViolations( getExpectedViolatingFiles() );

      for ( final String fileName : expectedPositions.keySet() )
      {
         assertViolations( fileName,
                           expectedPositions.get( fileName ) );
      }
   }

   protected abstract ExpectedViolation[] getExpectedViolatingFiles();

   protected List< String > getIgnoreFiles()
   {
      return new ArrayList< String >();
   }

   protected abstract AbstractFlexRule getRule();

   protected List< IFlexViolation > processFile( final String resourcePath ) throws IOException,
                                                                            TokenException
   {
      if ( !getIgnoreFiles().contains( resourcePath ) )
      {
         return getRule().processFile( getTestFiles().get( resourcePath ),
                                       null,
                                       getTestFiles() );
      }
      return new ArrayList< IFlexViolation >();
   }

   private void assertViolations( final String resourcePath,
                                  final ViolationPosition[] expectedPositions )
   {
      try
      {
         final List< IFlexViolation > violations = processFile( resourcePath );

         assertEquals( VIOLATIONS_NUMBER_NOT_CORRECT
                             + " for " + resourcePath,
                       expectedPositions.length,
                       violations.size() );

         if ( expectedPositions.length != 0 )
         {
            printFailures( buildFailureViolations( resourcePath,
                                                   expectedPositions,
                                                   violations ) );
         }
      }
      catch ( final IOException e )
      {
         fail( e.getMessage() );
      }
      catch ( final TokenException e )
      {
         fail( e.getMessage() );
      }
   }

   private Map< String, ViolationPosition[] > computeExpectedViolations( final ExpectedViolation[] expectedViolatingFiles )
   {
      final Map< String, ViolationPosition[] > expectedViolations = new LinkedHashMap< String, ViolationPosition[] >();

      for ( final ExpectedViolation expectedViolatingFile : expectedViolatingFiles )
      {
         expectedViolations.put( expectedViolatingFile.file,
                                 expectedViolatingFile.positions );
      }
      return expectedViolations;
   }

   private Map< String, List< IFlexViolation >> extractActualViolatedFiles() throws IOException,
                                                                            TokenException
   {
      final Map< String, List< IFlexViolation > > violatedFiles = new LinkedHashMap< String, List< IFlexViolation > >();
      final Map< String, ViolationPosition[] > expectedPositions = computeExpectedViolations( getExpectedViolatingFiles() );

      for ( final Map.Entry< String, IFlexFile > fileNameEntry : getTestFiles().entrySet() )
      {
         if ( !expectedPositions.containsKey( fileNameEntry.getKey() ) )
         {
            final List< IFlexViolation > violations = processFile( fileNameEntry.getKey() );

            if ( !violations.isEmpty() )
            {
               violatedFiles.put( fileNameEntry.getKey(),
                                  violations );
            }
         }
      }
      return violatedFiles;
   }

   private void printFailures( final List< AssertPosition > failures )
   {
      if ( !failures.isEmpty() )
      {
         fail( buildFailuresMessage( failures ).toString() );
      }
   }
}