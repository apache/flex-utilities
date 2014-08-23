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

import com.adobe.ac.pmd.nodes.IFieldInitialization;
import com.adobe.ac.pmd.nodes.IIdentifierNode;
import com.adobe.ac.pmd.nodes.IMetaData;
import com.adobe.ac.pmd.nodes.IModifiersHolder;
import com.adobe.ac.pmd.nodes.IVariable;
import com.adobe.ac.pmd.nodes.MetaData;
import com.adobe.ac.pmd.nodes.Modifier;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.NodeKind;

/**
 * Node representing a variable (var i : int = 0) It contains the variable name,
 * its type name, the list of modifiers, the list of metadata, and the
 * initialization expression (if any).
 * 
 * @author xagnetti
 */
class VariableNode extends AbstractNode implements IVariable, IModifiersHolder
{
   private IFieldInitialization                     initializationExpression;
   private final Map< MetaData, List< IMetaData > > metaDataList;
   private final Set< Modifier >                    modifiers;
   private IdentifierNode                           name;
   private IdentifierNode                           type;

   /**
    * @param rootNode
    */
   protected VariableNode( final IParserNode rootNode )
   {
      super( rootNode );

      metaDataList = new LinkedHashMap< MetaData, List< IMetaData > >();
      modifiers = new HashSet< Modifier >();
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
   public VariableNode compute()
   {
      if ( getInternalNode().is( NodeKind.NAME_TYPE_INIT ) )
      {
         computeNameTypeInit( getInternalNode() );
      }
      else
      {
         if ( getInternalNode().numChildren() != 0 )
         {
            for ( final IParserNode child : getInternalNode().getChildren() )
            {
               if ( child.is( NodeKind.NAME_TYPE_INIT ) )
               {
                  computeNameTypeInit( child );
               }
               else if ( child.is( NodeKind.META_LIST ) )
               {
                  computeMetaDataList( this,
                                       child );
               }
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
    * @see com.adobe.ac.pmd.nodes.IVariable#getInitializationExpression()
    */
   public IFieldInitialization getInitializationExpression()
   {
      return initializationExpression;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.nodes.IMetaDataListHolder#getMetaData(com.adobe.ac.pmd
    * .nodes.MetaData)
    */
   public List< IMetaData > getMetaData( final MetaData metaDataName )
   {
      return metaDataList.get( metaDataName );
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
    * @see com.adobe.ac.pmd.nodes.INamable#getName()
    */
   public String getName()
   {
      return name == null ? ""
                         : name.toString();
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IVariable#getType()
    */
   public IIdentifierNode getType()
   {
      return type;
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

   private void computeNameTypeInit( final IParserNode nameTypeInit )
   {
      if ( nameTypeInit.numChildren() != 0 )
      {
         for ( final IParserNode child : nameTypeInit.getChildren() )
         {
            if ( child.is( NodeKind.NAME ) )
            {
               name = IdentifierNode.create( child );
            }
            else if ( child.is( NodeKind.TYPE ) )
            {
               type = IdentifierNode.create( child );
            }
            else if ( child.is( NodeKind.INIT ) )
            {
               initializationExpression = FieldInitializationNode.create( child );
            }
            else
            {
               LOGGER.warning( "unknown node type "
                     + child.toString() );
            }
         }
      }
   }
}
