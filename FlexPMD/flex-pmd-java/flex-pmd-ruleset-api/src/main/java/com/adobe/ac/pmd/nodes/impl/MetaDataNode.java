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
package com.adobe.ac.pmd.nodes.impl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.adobe.ac.pmd.nodes.IMetaData;
import com.adobe.ac.pmd.parser.IParserNode;

/**
 * @author xagnetti
 */
class MetaDataNode extends AbstractNode implements IMetaData
{
   private List< String >          attributeNames;
   private String                  name;
   private String                  parameter;
   private Map< String, String[] > parameters;

   /**
    * @param node
    */
   protected MetaDataNode( final IParserNode node )
   {
      super( node );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.impl.AbstractNode#compute()
    */
   @Override
   public MetaDataNode compute()
   {
      final String stringValue = getInternalNode().getStringValue();

      name = stringValue.indexOf( " ( " ) > -1 ? stringValue.substring( 0,
                                                                        stringValue.indexOf( " ( " ) )
                                              : stringValue;
      parameter = stringValue.indexOf( "( " ) > -1 ? stringValue.substring( stringValue.indexOf( "( " ) + 2,
                                                                            stringValue.lastIndexOf( " )" ) )
                                                  : "";

      computeAttributeNames();
      return this;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IMetaData#getAttributeNames()
    */
   public List< String > getAttributeNames()
   {
      return attributeNames;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IMetaData#getDefaultValue()
    */
   public String getDefaultValue()
   {
      return parameter;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.INamable#getName()
    */
   public String getName()
   {
      return name;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IMetaData#getProperty(java.lang.String)
    */
   public String[] getProperty( final String property )
   {
      return parameters.containsKey( property ) ? parameters.get( property )
                                               : new String[]
                                               {};
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IMetaData#getPropertyAsList(java.lang.String)
    */
   public List< String > getPropertyAsList( final String property )
   {
      return Arrays.asList( getProperty( property ) );
   }

   private void computeAttributeNames()
   {
      attributeNames = new ArrayList< String >();
      parameters = new LinkedHashMap< String, String[] >();

      final String[] pairs = getPairs();

      for ( final String pair : pairs )
      {
         final String[] pairSplit = pair.split( "=" );

         if ( pairSplit.length == 2 )
         {
            attributeNames.add( pairSplit[ 0 ].trim() );
            parameters.put( pairSplit[ 0 ].trim(),
                            pairSplit[ 1 ].trim().replaceAll( "\'",
                                                              "" ).replaceAll( "\"",
                                                                               "" ).split( "," ) );
         }
      }
   }

   private String[] getPairs()
   {
      return parameter.split( "," );
   }
}
