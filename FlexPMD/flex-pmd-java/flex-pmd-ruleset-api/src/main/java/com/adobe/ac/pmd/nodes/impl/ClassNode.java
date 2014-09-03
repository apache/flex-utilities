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
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

import com.adobe.ac.pmd.nodes.IAttribute;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IConstant;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.IMetaData;
import com.adobe.ac.pmd.nodes.MetaData;
import com.adobe.ac.pmd.nodes.Modifier;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.NodeKind;

/**
 * @author xagnetti
 */
class ClassNode extends AbstractNode implements IClass
{
   private IParserNode                              asDoc;
   private final List< IAttribute >                 attributes;
   private IParserNode                              block;
   private final List< IConstant >                  constants;
   private IFunction                                constructor;
   private String                                   extensionName;
   private final List< IFunction >                  functions;
   private List< IParserNode >                      implementations;
   private final Map< MetaData, List< IMetaData > > metaDataList;
   private final Set< Modifier >                    modifiers;
   private final List< IParserNode >                multiLinesComments;
   private IdentifierNode                           name;

   /**
    * @param node
    */
   protected ClassNode( final IParserNode node )
   {
      super( node );

      modifiers = new HashSet< Modifier >();
      metaDataList = new LinkedHashMap< MetaData, List< IMetaData > >();
      implementations = new ArrayList< IParserNode >();
      constants = new ArrayList< IConstant >();
      attributes = new ArrayList< IAttribute >();
      functions = new ArrayList< IFunction >();
      multiLinesComments = new ArrayList< IParserNode >();
      name = null;
      asDoc = null;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.nodes.IMetaDataListHolder#add(com.adobe.ac.pmd.nodes.
    * IMetaData)
    */
   public void add( final IMetaData metaData )
   {
      final MetaData metaDataImpl = MetaData.create( metaData.getName() );

      if ( !metaDataList.containsKey( metaDataImpl ) )
      {
         metaDataList.put( metaDataImpl,
                           new ArrayList< IMetaData >() );
      }
      metaDataList.get( metaDataImpl ).add( metaData );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.nodes.IModifiersHolder#add(com.adobe.ac.pmd.nodes.Modifier
    * )
    */
   public void add( final Modifier modifier )
   {
      modifiers.add( modifier );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.impl.AbstractNode#compute()
    */
   @Override
   public ClassNode compute()
   {
      if ( getInternalNode().numChildren() != 0 )
      {
         for ( final IParserNode node : getInternalNode().getChildren() )
         {
            if ( node.is( NodeKind.CONTENT ) )
            {
               computeClassContent( node );
            }
            else if ( node.is( NodeKind.MOD_LIST ) )
            {
               computeModifierList( this,
                                    node );
            }
            else if ( node.is( NodeKind.NAME ) )
            {
               name = IdentifierNode.create( node );
            }
            else if ( node.is( NodeKind.META_LIST ) )
            {
               computeMetaDataList( this,
                                    node );
            }
            else if ( node.is( NodeKind.AS_DOC ) )
            {
               asDoc = node;
            }
            else if ( node.is( NodeKind.MULTI_LINE_COMMENT ) )
            {
               multiLinesComments.add( node );
            }
            detectImplementations( node );
            detectExtensions( node );
         }
         for ( final IFunction function : functions )
         {
            if ( name.toString().equals( function.getName() ) )
            {
               constructor = function;
            }
         }
      }
      return this;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IMetaDataListHolder#getAllMetaData()
    */
   public List< IMetaData > getAllMetaData()
   {
      final List< IMetaData > list = new ArrayList< IMetaData >();

      for ( final Entry< MetaData, List< IMetaData > > entry : metaDataList.entrySet() )
      {
         list.addAll( entry.getValue() );
      }

      return list;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IAsDocHolder#getAsDoc()
    */
   public IParserNode getAsDoc()
   {
      return asDoc;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IClass#getAttributes()
    */
   public List< IAttribute > getAttributes()
   {
      return attributes;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IClass#getAverageCyclomaticComplexity()
    */
   public double getAverageCyclomaticComplexity()
   {
      if ( functions.isEmpty() )
      {
         return 0;
      }
      int totalCcn = 0;

      for ( final IFunction function : functions )
      {
         totalCcn += function.getCyclomaticComplexity();
      }

      return totalCcn
            / functions.size();
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IClass#getBlock()
    */
   public final IParserNode getBlock()
   {
      return block;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IClass#getConstants()
    */
   public List< IConstant > getConstants()
   {
      return constants;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IClass#getConstructor()
    */
   public IFunction getConstructor()
   {
      return constructor;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IClass#getExtensionName()
    */
   public String getExtensionName()
   {
      return extensionName;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IClass#getFunctions()
    */
   public List< IFunction > getFunctions()
   {
      return functions;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IClass#getImplementations()
    */
   public List< IParserNode > getImplementations()
   {
      return implementations;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.nodes.IMetaDataListHolder#getMetaData(com.adobe.ac.pmd
    * .nodes.MetaData)
    */
   public List< IMetaData > getMetaData( final MetaData metaDataName )
   {
      if ( metaDataList.containsKey( metaDataName ) )
      {
         return metaDataList.get( metaDataName );
      }
      else
      {
         return new ArrayList< IMetaData >();
      }
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IMetaDataListHolder#getMetaDataCount()
    */
   public int getMetaDataCount()
   {
      return metaDataList.size();
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.ICommentHolder#getMultiLinesComment()
    */
   public List< IParserNode > getMultiLinesComment()
   {
      return multiLinesComments;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.INamable#getName()
    */
   public String getName()
   {
      return name.toString();
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.nodes.IModifiersHolder#is(com.adobe.ac.pmd.nodes.Modifier
    * )
    */
   public boolean is( final Modifier modifier ) // NOPMD
   {
      return modifiers.contains( modifier );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IClass#isBindable()
    */
   public boolean isBindable()
   {
      return metaDataList.get( MetaData.BINDABLE ) != null;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IClass#isFinal()
    */
   public boolean isFinal()
   {
      return is( Modifier.FINAL );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IVisible#isPublic()
    */
   public boolean isPublic()
   {
      return is( Modifier.PUBLIC );
   }

   private void computeClassContent( final IParserNode classContentNode )
   {
      if ( classContentNode.numChildren() != 0 )
      {
         for ( final IParserNode node : classContentNode.getChildren() )
         {
            detectBlock( node );
            detectFunction( node );
            detectAttribute( node );
            detectConstant( node );
            if ( node.is( NodeKind.MULTI_LINE_COMMENT ) )
            {
               multiLinesComments.add( node );
            }
         }
      }
   }

   private void detectAttribute( final IParserNode node )
   {
      if ( node.is( NodeKind.VAR_LIST ) )
      {
         attributes.add( new AttributeNode( node ).compute() );
      }
   }

   private void detectBlock( final IParserNode node )
   {
      if ( node.is( NodeKind.BLOCK ) )
      {
         block = node;
      }
   }

   private void detectConstant( final IParserNode node )
   {
      if ( node.is( NodeKind.CONST_LIST ) )
      {
         constants.add( new ConstantNode( node ).compute() );
      }
   }

   private void detectExtensions( final IParserNode node )
   {
      if ( node.is( NodeKind.EXTENDS ) )
      {
         extensionName = node.getStringValue();
      }
   }

   private void detectFunction( final IParserNode node )
   {
      if ( node.is( NodeKind.FUNCTION )
            || node.is( NodeKind.GET ) || node.is( NodeKind.SET ) )
      {
         functions.add( new FunctionNode( node ).compute() );
      }
   }

   private void detectImplementations( final IParserNode node )
   {
      if ( node.is( NodeKind.IMPLEMENTS_LIST ) )
      {
         implementations = node.getChildren();
      }
   }
}
