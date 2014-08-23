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
package com.adobe.ac.pmd.maven;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.logging.Logger;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.maven.project.MavenProject;
import org.apache.maven.reporting.AbstractMavenReport;
import org.apache.maven.reporting.MavenReportException;
import org.codehaus.doxia.site.renderer.SiteRenderer;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import com.adobe.ac.pmd.FlexPmdParameters;
import com.adobe.ac.pmd.FlexPmdViolations;
import com.adobe.ac.pmd.LoggerUtils;
import com.adobe.ac.pmd.engines.AbstractFlexPmdEngine;
import com.adobe.ac.pmd.engines.FlexPmdXmlEngine;
import com.adobe.ac.pmd.engines.PmdEngineUtils;

abstract class AbstractFlexPmdMojo extends AbstractMavenReport
{
   protected static final Logger LOGGER      = Logger.getLogger( AbstractFlexPmdMojo.class.getName() );

   private static final String   OUTPUT_NAME = "flexpmd";

   protected static ResourceBundle getBundle( final Locale locale )
   {
      return ResourceBundle.getBundle( "flexPmd",
                                       locale,
                                       FlexPmdReportMojo.class.getClassLoader() ); // NOPMD
   }

   /**
    * Location of the file.
    * 
    * @parameter expression="${flexpmd.excludePackage}"
    */
   private String       excludePackage = "";

   /**
    * Build fails if an violation error occurs.
    * 
    * @parameter expression="${flexpmd.failOnError}"
    */
   private boolean      failOnError;

   /**
    * Build fails if an violation error occurs.
    * 
    * @parameter expression="${flexpmd.failOnRuleViolation}"
    */
   private boolean      failOnRuleViolation;

   /**
    * Location of the file.
    * 
    * @parameter expression="${project.build.directory}"
    * @required
    */
   private File         outputDirectory;

   /**
    * @parameter expression="${project}"
    * @required
    * @readonly
    */
   private MavenProject project;

   /**
    * Location of the file.
    * 
    * @parameter expression="${flexpmd.ruleset}"
    */
   private File         ruleSet;

   /**
    * @parameter 
    *            expression="${component.org.codehaus.doxia.site.renderer.SiteRenderer}"
    * @required
    * @readonly
    */
   private SiteRenderer siteRenderer;

   /**
    * Specifies the location of the source files to be used.
    * 
    * @parameter expression="${project.build.sourceDirectory}"
    * @required
    */
   private File         sourceDirectory;

   /**
    * URL of the file
    * 
    * @parameter expression="${flexpmd.url}"
    */
   private URL          url;

   public AbstractFlexPmdMojo()
   {
      super();
      excludePackage = "";
   }

   public AbstractFlexPmdMojo( final MavenProject projectToBeSet,
                               final FlexPmdParameters parameters )
   {
      this();

      project = projectToBeSet;
      outputDirectory = parameters.getOutputDirectory();
      ruleSet = parameters.getRuleSet();
      sourceDirectory = parameters.getSource();
      failOnError = parameters.isFailOnError();
      failOnRuleViolation = parameters.isFailOnRuleViolation();
      excludePackage = parameters.getExcludePackage();
   }

   public final String getDescription( final Locale locale )
   {
      return getBundle( locale ).getString( "report.flexPmd.description" );
   }

   public final String getName( final Locale locale )
   {
      return getBundle( locale ).getString( "report.flexPmd.name" );
   }

   public final String getOutputName()
   {
      return OUTPUT_NAME;
   }

   @Override
   protected final void executeReport( final Locale locale ) throws MavenReportException
   {
      new LoggerUtils().loadConfiguration();
      getLog().info( "FlexPmdMojo starts" );
      getLog().info( "   failOnError     "
            + failOnError );
      getLog().info( "   ruleSet         "
            + ruleSet );
      getLog().info( "   sourceDirectory "
            + sourceDirectory );
      getLog().info( "   ruleSetURL      "
            + url );
      try
      {
         final AbstractFlexPmdEngine engine = new FlexPmdXmlEngine( new FlexPmdParameters( excludePackage,
                                                                                           failOnError,
                                                                                           failOnRuleViolation,
                                                                                           outputDirectory,
                                                                                           getRuleSet(),
                                                                                           sourceDirectory ) );
         final FlexPmdViolations violations = new FlexPmdViolations();
         engine.executeReport( violations );

         onXmlReportExecuted( violations,
                              locale );
      }
      catch ( final Exception e )
      {
         throw new MavenReportException( "A system exception has been thrown", e );
      }
   }

   protected final String getExcludePackage()
   {
      return excludePackage;
   }

   @Override
   protected final String getOutputDirectory()
   {
      return outputDirectory.getAbsolutePath();
   }

   protected final File getOutputDirectoryFile()
   {
      return outputDirectory;
   }

   @Override
   protected final MavenProject getProject()
   {
      return project;
   }

   protected final File getRuleSet()
   {
      if ( ruleSet == null )
      {
         try
         {
            getRulesetFromURL();
         }
         catch ( final IOException ioe )
         {
            throw new RuntimeException( "Could not get ruleset from URL", ioe );
         }
         catch ( final Exception e )
         {
            // if this goes wrong, we're experiencing an unrecoverable
            // error, so we'll fall back on the default rules
         }
      }
      return ruleSet;
   }

   @Override
   protected final SiteRenderer getSiteRenderer()
   {
      return siteRenderer;
   }

   protected final File getSourceDirectory()
   {
      return sourceDirectory;
   }

   protected void onXmlReportExecuted( final FlexPmdViolations violations,
                                       final Locale locale ) throws MavenReportException
   {
      if ( failOnError )
      {
         final String message = PmdEngineUtils.findFirstViolationError( violations );

         if ( message.length() > 0 )
         {
            throw new MavenReportException( message );
         }
      }
      if ( failOnRuleViolation
            && !violations.getViolations().isEmpty() )
      {
         throw new MavenReportException( "At least one violation has been found" );
      }
   }

   protected final void setSiteRenderer( final SiteRenderer siteRendererToBeSet ) // NO_UCD
   {
      this.siteRenderer = siteRendererToBeSet;
   }

   /**
    * @throws ParserConfigurationException
    * @throws SAXException
    * @throws SAXException
    * @throws TransformerException
    * @throws TransformerFactoryConfigurationError
    * @throws IOException
    */
   private void getRulesetFromURL() throws ParserConfigurationException,
                                   SAXException,
                                   TransformerFactoryConfigurationError,
                                   TransformerException,
                                   IOException
   {
      getLog().info( "getting RuleSet from URL" );
      if ( url == null )
      {
         getLog().info( "Ruleset URL is not set" );
         return;
      }
      ruleSet = File.createTempFile( "pmdRuleset",
                                     "" );

      final DocumentBuilder db = DocumentBuilderFactory.newInstance().newDocumentBuilder();

      try
      {
         final Document pmdRules = db.parse( url.toExternalForm() );
         writeToFile( pmdRules,
                      ruleSet );
      }
      catch ( final SAXException sax )
      {
         saveUTF8SafeXML();
      }
   }

   private void saveUTF8SafeXML() throws IOException,
                                 FileNotFoundException
   {
      final InputStream inputstream = url.openStream();
      final OutputStream outputstream = new FileOutputStream( ruleSet );
      int thisByteAsInt;
      while ( ( thisByteAsInt = inputstream.read() ) != -1 )
      {
         outputstream.write( stripNonValidXMLCharacters( ( byte ) thisByteAsInt ) );

      }
      inputstream.close();
      outputstream.flush();
      outputstream.close();
   }

   private byte stripNonValidXMLCharacters( final byte in )
   {
      byte current; // Used to reference the current character.

      current = in;
      if ( current == 0x9
            || current == 0xA || current == 0xD || current >= 0x20 && current <= 0xD7FF || current >= 0xE000
            && current <= 0xFFFD || current >= 0x10000 && current <= 0x10FFFF )
      {
         return current;
      }
      return '\n';
   }

   private void writeToFile( final Document pmdRules,
                             final File ruleSet ) throws TransformerFactoryConfigurationError,
                                                 IOException,
                                                 TransformerException
   {
      final Transformer transformer = TransformerFactory.newInstance().newTransformer();
      transformer.setOutputProperty( OutputKeys.INDENT,
                                     "yes" );
      final StreamResult result = new StreamResult( new FileWriter( ruleSet ) );
      final DOMSource source = new DOMSource( pmdRules );
      transformer.transform( source,
                             result );

   }
}