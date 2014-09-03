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
package com.adobe.ac.pmd.files;

import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.Callable;
import java.util.concurrent.CancellationException;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.logging.Logger;

import net.sourceforge.pmd.PMDException;

import com.adobe.ac.pmd.nodes.IPackage;
import com.adobe.ac.pmd.nodes.impl.NodeFactory;
import com.adobe.ac.pmd.parser.IAS3Parser;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.exceptions.TokenException;

import de.bokelberg.flex.parser.AS3Parser;

/**
 * @author xagnetti
 */
public final class FileSetUtils
{
   private static final ThreadPoolExecutor EXECUTOR = ( ThreadPoolExecutor ) Executors.newFixedThreadPool( 5 );
   private static final Logger             LOGGER   = Logger.getLogger( FileSetUtils.class.getName() );

   /**
    * @param file
    * @return
    * @throws PMDException
    */
   public static IParserNode buildAst( final IFlexFile file ) throws PMDException
   {
      IParserNode rootNode = null;

      try
      {
         rootNode = tryToBuildAst( file );
      }
      catch ( final IOException e )
      {
         throw new PMDException( "While building AST: Cannot read "
               + file.getFullyQualifiedName(), e );
      }
      catch ( final TokenException e )
      {
         throw new PMDException( "TokenException thrown while building AST on "
               + file.getFullyQualifiedName() + " with message: " + e.getMessage(), e );
      }
      return rootNode;
   }

   /**
    * @param file
    * @return
    * @throws PMDException
    * @throws InterruptedException
    * @throws ExecutionException
    */
   public static IParserNode buildThreadedAst( final IFlexFile file ) throws PMDException,
                                                                     InterruptedException,
                                                                     ExecutionException
   {
      final List< Callable< Object >> toRun = new ArrayList< Callable< Object >>();
      toRun.add( new Callable< Object >()
      {
         public Object call() throws PMDException
         {
            return buildAst( file );
         }
      } );
      final List< Future< Object >> futures = EXECUTOR.invokeAll( toRun,
                                                                  5,
                                                                  TimeUnit.SECONDS );
      return ( IParserNode ) futures.get( 0 ).get();
   }

   /**
    * @param files
    * @return
    * @throws PMDException
    */
   public static Map< String, IPackage > computeAsts( final Map< String, IFlexFile > files ) throws PMDException
   {
      final Map< String, IPackage > asts = new LinkedHashMap< String, IPackage >();

      for ( final Entry< String, IFlexFile > fileEntry : files.entrySet() )
      {
         final IFlexFile file = fileEntry.getValue();

         try
         {
            final IParserNode node = buildThreadedAst( file );

            asts.put( file.getFullyQualifiedName(),
                      NodeFactory.createPackage( node ) );
         }
         catch ( final InterruptedException e )
         {
            LOGGER.warning( buildLogMessage( file,
                                             e.getMessage() ) );
         }
         catch ( final NoClassDefFoundError e )
         {
            LOGGER.warning( buildLogMessage( file,
                                             e.getMessage() ) );
         }
         catch ( final ExecutionException e )
         {
            LOGGER.warning( buildLogMessage( file,
                                             e.getMessage() ) );
         }
         catch ( final CancellationException e )
         {
            LOGGER.warning( buildLogMessage( file,
                                             e.getMessage() ) );
         }
      }
      return asts;
   }

   /**
    * @param file
    * @param message
    * @return
    */
   protected static String buildLogMessage( final IFlexFile file,
                                            final String message )
   {
      return "While building AST on "
            + file.getFullyQualifiedName() + ", an error occured: " + message;
   }

   private static IParserNode tryToBuildAst( final IFlexFile file ) throws IOException,
                                                                   TokenException
   {
      IParserNode rootNode;
      final IAS3Parser parser = new AS3Parser();
      if ( file instanceof IMxmlFile )
      {
         rootNode = parser.buildAst( file.getFilePath(),
                                     ( ( IMxmlFile ) file ).getScriptBlock() );
      }
      else
      {
         rootNode = parser.buildAst( file.getFilePath() );
      }
      return rootNode;
   }

   private FileSetUtils()
   {
   }
}
