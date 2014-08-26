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
package com.adobe.ac.pmd;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import com.martiansoftware.jsap.FlaggedOption;
import com.martiansoftware.jsap.JSAP;
import com.martiansoftware.jsap.JSAPException;

public final class CommandLineUtils
{
   public static List< File > computeSourceList( final String source )
   {
      if ( !source.contains( "," ) )
      {
         return null;
      }
      final List< File > sourceList = new ArrayList< File >();
      for ( int i = 0; i < source.split( "," ).length; i++ )
      {
         sourceList.add( new File( source.split( "," )[ i ] ) ); // NOPMD
      }
      return sourceList;
   }

   public static void registerParameter( final JSAP jsap,
                                         final ICommandLineOptions option,
                                         final boolean required ) throws JSAPException
   {
      final String optionName = option.toString();

      jsap.registerParameter( new FlaggedOption( optionName ).setStringParser( JSAP.STRING_PARSER )
                                                             .setRequired( required )
                                                             .setShortFlag( optionName.charAt( 0 ) )
                                                             .setLongFlag( optionName ) );
   }

   private CommandLineUtils()
   {
   }
}
