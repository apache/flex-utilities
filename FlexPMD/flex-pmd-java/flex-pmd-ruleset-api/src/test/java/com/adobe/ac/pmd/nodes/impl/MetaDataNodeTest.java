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

import static org.junit.Assert.assertEquals;
import net.sourceforge.pmd.PMDException;

import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.nodes.IMetaDataListHolder;
import com.adobe.ac.pmd.nodes.MetaData;
import com.adobe.ac.pmd.parser.IParserNode;

public class MetaDataNodeTest extends FlexPmdTestBase
{
   private final IMetaDataListHolder modelLocator;
   private final IMetaDataListHolder unboundMetaData;

   public MetaDataNodeTest() throws PMDException
   {
      super();

      IParserNode ast = FileSetUtils.buildAst( getTestFiles().get( "cairngorm.BindableModelLocator.as" ) );
      modelLocator = NodeFactory.createPackage( ast ).getClassNode();
      ast = FileSetUtils.buildAst( getTestFiles().get( "UnboundMetadata.as" ) );
      unboundMetaData = NodeFactory.createPackage( ast ).getClassNode();
   }

   @Test
   public void testEmbed() throws PMDException
   {
      final IParserNode titleNode = FileSetUtils.buildAst( getTestFiles().get( "Title.as" ) );

      final IMetaDataListHolder show = NodeFactory.createPackage( titleNode )
                                                  .getClassNode()
                                                  .getConstants()
                                                  .get( 0 );
      assertEquals( MetaData.EMBED.toString(),
                    show.getMetaData( MetaData.EMBED ).get( 0 ).getName() );

   }

   @Test
   public void testGetAttributeNames()
   {
      assertEquals( 2,
                    unboundMetaData.getMetaData( MetaData.EVENT ).get( 0 ).getAttributeNames().size() );
      assertEquals( "name",
                    unboundMetaData.getMetaData( MetaData.EVENT ).get( 0 ).getAttributeNames().get( 0 ) );
      assertEquals( "type",
                    unboundMetaData.getMetaData( MetaData.EVENT ).get( 0 ).getAttributeNames().get( 1 ) );
   }

   @Test
   public void testGetDefaultValue()
   {
      assertEquals( "",
                    modelLocator.getMetaData( MetaData.BINDABLE ).get( 0 ).getDefaultValue() );
      assertEquals( "name = \"dayChange\" , type = \'mx.events.StateChangeEvent\'",
                    unboundMetaData.getMetaData( MetaData.EVENT ).get( 0 ).getDefaultValue() );
   }

   @Test
   public void testGetMetaDataName()
   {
      assertEquals( MetaData.BINDABLE.toString(),
                    modelLocator.getMetaData( MetaData.BINDABLE ).get( 0 ).getName() );
      assertEquals( MetaData.EVENT.toString(),
                    unboundMetaData.getMetaData( MetaData.EVENT ).get( 0 ).getName() );
   }

   @Test
   public void testGetProperty()
   {
      assertEquals( 1,
                    unboundMetaData.getMetaData( MetaData.EVENT ).get( 0 ).getProperty( "name" ).length );
      assertEquals( "dayChange",
                    unboundMetaData.getMetaData( MetaData.EVENT ).get( 0 ).getProperty( "name" )[ 0 ] );
      assertEquals( 1,
                    unboundMetaData.getMetaData( MetaData.EVENT ).get( 0 ).getProperty( "type" ).length );
      assertEquals( "mx.events.StateChangeEvent",
                    unboundMetaData.getMetaData( MetaData.EVENT ).get( 0 ).getProperty( "type" )[ 0 ] );
   }

   @Test
   public void testGetPropertyAsList()
   {
      assertEquals( 1,
                    unboundMetaData.getMetaData( MetaData.EVENT ).get( 0 ).getPropertyAsList( "name" ).size() );
      assertEquals( "dayChange",
                    unboundMetaData.getMetaData( MetaData.EVENT )
                                   .get( 0 )
                                   .getPropertyAsList( "name" )
                                   .get( 0 ) );
      assertEquals( 1,
                    unboundMetaData.getMetaData( MetaData.EVENT ).get( 0 ).getPropertyAsList( "type" ).size() );
      assertEquals( "mx.events.StateChangeEvent",
                    unboundMetaData.getMetaData( MetaData.EVENT )
                                   .get( 0 )
                                   .getPropertyAsList( "type" )
                                   .get( 0 ) );
   }
}
