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

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.xml.XMLConstants;
import javax.xml.namespace.NamespaceContext;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.utils.StackTraceUtils;

/**
 * @author xagnetti
 */
public abstract class AbstractXpathRelatedRule extends AbstractFlexRule
{
   /**
    * @author xagnetti
    */
   public class NamespaceContextMap implements NamespaceContext
   {
      private final Map< String, String > prefixMap;

      /**
       * Constructor that takes a map of XML prefix-namespaceURI values. A
       * defensive copy is made of the map. An IllegalArgumentException will be
       * thrown if the map attempts to remap the standard prefixes defined in
       * the NamespaceContext contract.
       * 
       * @param prefixMappings a map of prefix:namespaceURI values
       */
      public NamespaceContextMap( final Map< String, String > prefixMappings )
      {
         prefixMap = createPrefixMap( prefixMappings );
      }

      /**
       * Convenience constructor.
       * 
       * @param mappingPairs pairs of prefix-namespaceURI values
       */
      public NamespaceContextMap( final String... mappingPairs )
      {
         this( toMap( mappingPairs ) );
      }

      /*
       * (non-Javadoc)
       * @see
       * javax.xml.namespace.NamespaceContext#getNamespaceURI(java.lang.String)
       */
      public String getNamespaceURI( final String prefix )
      {
         prefixMap.get( prefix );
         return prefixMap.get( prefix );
      }

      /*
       * (non-Javadoc)
       * @see javax.xml.namespace.NamespaceContext#getPrefix(java.lang.String)
       */
      public String getPrefix( final String namespaceURI )
      {
         return null;
      }

      /*
       * (non-Javadoc)
       * @see javax.xml.namespace.NamespaceContext#getPrefixes(java.lang.String)
       */
      public Iterator< String > getPrefixes( final String namespaceURI )
      {
         return null;
      }

      private void addConstant( final Map< String, String > map,
                                final String prefix,
                                final String nsURI )
      {
         map.put( prefix,
                  nsURI );
      }

      private Map< String, String > createPrefixMap( final Map< String, String > prefixMappings )
      {
         final Map< String, String > map = new LinkedHashMap< String, String >( prefixMappings );
         addConstant( map,
                      XMLConstants.XML_NS_PREFIX,
                      XMLConstants.XML_NS_URI );
         addConstant( map,
                      XMLConstants.XMLNS_ATTRIBUTE,
                      XMLConstants.XMLNS_ATTRIBUTE_NS_URI );
         return Collections.unmodifiableMap( map );
      }

   }

   protected static final Logger LOGGER = Logger.getLogger( AbstractXpathRelatedRule.class.getName() );

   private static Map< String, String > toMap( final String... mappingPairs )
   {
      final Map< String, String > prefixMappings = new LinkedHashMap< String, String >( mappingPairs.length / 2 );
      for ( int i = 0; i < mappingPairs.length; i++ )
      {
         prefixMappings.put( mappingPairs[ i ],
                             mappingPairs[ ++i ] );
      }
      return prefixMappings;
   }

   /**
    * @param doc
    * @param xPath
    * @return
    * @throws XPathExpressionException
    */
   protected abstract Object evaluate( final Document doc,
                                       final XPath xPath ) throws XPathExpressionException;

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractFlexRule#findViolationsInCurrentFile()
    */
   @Override
   protected List< IFlexViolation > findViolationsInCurrentFile()
   {
      final ArrayList< IFlexViolation > violations = new ArrayList< IFlexViolation >();

      try
      {
         final Document doc = buildDocument();
         final XPath xPath = buildXPath();

         onEvaluated( violations,
                      doc,
                      xPath );
      }
      catch ( final XPathExpressionException e )
      {
         LOGGER.warning( StackTraceUtils.print( getCurrentFile().getFilename(),
                                                e ) );
      }
      catch ( final FileNotFoundException e )
      {
         LOGGER.warning( StackTraceUtils.print( getCurrentFile().getFilename(),
                                                e ) );
      }
      catch ( final ParserConfigurationException e )
      {
         LOGGER.warning( StackTraceUtils.print( getCurrentFile().getFilename(),
                                                e ) );
      }
      catch ( final SAXException e )
      {
         LOGGER.warning( StackTraceUtils.print( getCurrentFile().getFilename(),
                                                e ) );
      }
      catch ( final IOException e )
      {
         LOGGER.warning( StackTraceUtils.print( getCurrentFile().getFilename(),
                                                e ) );
      }

      return violations;
   }

   /**
    * @return
    */
   protected abstract String getXPathExpression();

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractFlexRule#isConcernedByTheCurrentFile()
    */
   @Override
   protected boolean isConcernedByTheCurrentFile()
   {
      return getCurrentFile().isMxml();
   }

   /**
    * @param violations
    * @param doc
    * @param xPath
    * @throws XPathExpressionException
    */
   protected abstract void onEvaluated( final List< IFlexViolation > violations,
                                        final Document doc,
                                        final XPath xPath ) throws XPathExpressionException;

   private Document buildDocument() throws ParserConfigurationException,
                                   SAXException,
                                   IOException
   {
      final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
      factory.setNamespaceAware( true );
      final DocumentBuilder builder = factory.newDocumentBuilder();
      return builder.parse( getCurrentFile().getFilePath() );
   }

   private XPath buildXPath()
   {
      final XPathFactory xPathFactory = XPathFactory.newInstance();
      final XPath xPath = xPathFactory.newXPath();
      xPath.setNamespaceContext( new NamespaceContextMap( "mx", "http://www.adobe.com/2006/mxml" ) );
      return xPath;
   }

}