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
package com.adobe.ac.pmd.engines;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.util.List;
import java.util.logging.Logger;

import net.sourceforge.pmd.PMDException;
import net.sourceforge.pmd.RuleSet;
import net.sourceforge.pmd.RuleSetFactory;

import org.apache.commons.lang.StringUtils;
import org.codehaus.plexus.util.IOUtil;

import com.adobe.ac.pmd.FlexPmdParameters;
import com.adobe.ac.pmd.FlexPmdViolations;
import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.utils.StackTraceUtils;

public abstract class AbstractFlexPmdEngine
{
   private static final Logger LOGGER = Logger.getLogger( AbstractFlexPmdEngine.class.getName() );

   private static int computeViolationNumber( final FlexPmdViolations flexPmdViolations )
   {
      int foundViolations = 0;
      for ( final List< IFlexViolation > violations : flexPmdViolations.getViolations().values() )
      {
         foundViolations += violations.size();
      }
      LOGGER.info( "Violations number found: "
            + foundViolations );
      return foundViolations;
   }

   private static File extractDefaultRuleSet() throws URISyntaxException,
                                              IOException
   {
      final String rulesetURI = "/com/adobe/ac/pmd/default_flex.xml";
      final InputStream resourceAsStream = AbstractFlexPmdEngine.class.getResourceAsStream( rulesetURI );
      final File temporaryRuleset = File.createTempFile( "default_flex",
                                                         ".xml" );
      temporaryRuleset.deleteOnExit();
      final FileOutputStream writter = new FileOutputStream( temporaryRuleset );
      IOUtil.copy( resourceAsStream,
                   writter );

      resourceAsStream.close();
      return temporaryRuleset;
   }

   private final File         outputDirectory;
   private final String       packageToExclude;
   private RuleSet            ruleSet;
   private final File         source;
   private final List< File > sourceList;

   public AbstractFlexPmdEngine( final FlexPmdParameters parameters )
   {
      super();

      source = parameters.getSource();
      sourceList = parameters.getSourceList();
      outputDirectory = parameters.getOutputDirectory();
      packageToExclude = parameters.getExcludePackage();
      try
      {
         ruleSet = loadRuleset( parameters.getRuleSet() );
      }
      catch ( final URISyntaxException e )
      {
         LOGGER.warning( StackTraceUtils.print( e ) );
      }
      catch ( final IOException e )
      {
         LOGGER.warning( StackTraceUtils.print( e ) );
      }
   }

   /**
    * @param flexPmdViolations
    * @return The number of violations with the given ruleset and the result
    *         wrapper in case of reuse
    * @throws PMDException
    * @throws URISyntaxException
    * @throws IOException
    */
   public final void executeReport( final FlexPmdViolations flexPmdViolations ) throws PMDException
   {
      if ( source == null
            && sourceList == null )
      {
         throw new PMDException( "unspecified sourceDirectory" );
      }
      if ( outputDirectory == null )
      {
         throw new PMDException( "unspecified outputDirectory" );
      }

      if ( ruleSet != null )
      {
         if ( !flexPmdViolations.hasViolationsBeenComputed() )
         {
            computeViolations( flexPmdViolations );
         }
         computeViolationNumber( flexPmdViolations );
         writeAnyReport( flexPmdViolations );
      }
   }

   public final RuleSet getRuleSet()
   {
      return ruleSet;
   }

   protected File getOutputDirectory()
   {
      return outputDirectory;
   }

   protected abstract void writeReport( final FlexPmdViolations pmd ) throws PMDException;

   private void computeViolations( final FlexPmdViolations flexPmdViolations ) throws PMDException
   {
      final long startTime = System.currentTimeMillis();

      flexPmdViolations.computeViolations( source,
                                           sourceList,
                                           ruleSet,
                                           packageToExclude );
      final long ellapsedTime = System.currentTimeMillis()
            - startTime;
      LOGGER.info( "It took "
            + ellapsedTime + "ms to compute violations" );
   }

   private File extractRuleset( final File ruleSetFile ) throws URISyntaxException,
                                                        IOException
   {
      return ruleSetFile == null ? extractDefaultRuleSet()
                                : ruleSetFile;
   }

   private String getReportType()
   {
      return StringUtils.substringBefore( StringUtils.substringAfter( getClass().getName(),
                                                                      "FlexPmd" ),
                                          "Engine" );
   }

   private RuleSet loadRuleset( final File ruleSetFile ) throws URISyntaxException,
                                                        IOException
   {
      final File realRuleSet = extractRuleset( ruleSetFile );
      final FileInputStream inputStream = new FileInputStream( realRuleSet );
      final RuleSet loadedRuleSet = new RuleSetFactory().createRuleSet( inputStream );

      LOGGER.info( "Ruleset: "
            + realRuleSet.getAbsolutePath() );
      LOGGER.info( "Rules number in the ruleSet: "
            + loadedRuleSet.getRules().size() );
      inputStream.close();

      return loadedRuleSet;
   }

   private void writeAnyReport( final FlexPmdViolations flexPmdViolations ) throws PMDException
   {
      long startTime;
      long ellapsedTime;
      startTime = System.currentTimeMillis();
      writeReport( flexPmdViolations );
      ellapsedTime = System.currentTimeMillis()
            - startTime;

      LOGGER.info( "It took "
            + ellapsedTime + "ms to write the " + getReportType() + " report" );
   }
}