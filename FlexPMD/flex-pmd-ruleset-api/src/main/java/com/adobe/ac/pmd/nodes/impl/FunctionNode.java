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

import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.IIdentifierNode;
import com.adobe.ac.pmd.nodes.IMetaData;
import com.adobe.ac.pmd.nodes.IParameter;
import com.adobe.ac.pmd.nodes.MetaData;
import com.adobe.ac.pmd.nodes.Modifier;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.KeyWords;
import com.adobe.ac.pmd.parser.NodeKind;

/**
 * @author xagnetti
 */
class FunctionNode extends AbstractNode implements IFunction
{
   private IParserNode                              asDoc;
   private IParserNode                              body;
   private int                                      cyclomaticComplexity;
   private final Map< String, IParserNode >         localVariables;
   private final Map< MetaData, List< IMetaData > > metaDataList;
   private final Set< Modifier >                    modifiers;
   private final List< IParserNode >                multiLinesComments;
   private IdentifierNode                           name;
   private final List< IParameter >                 parameters;
   private IIdentifierNode                          returnType;

   /**
    * @param node
    */
   protected FunctionNode( final IParserNode node )
   {
      super( node );

      modifiers = new HashSet< Modifier >();
      metaDataList = new LinkedHashMap< MetaData, List< IMetaData > >();
      localVariables = new LinkedHashMap< String, IParserNode >();
      parameters = new ArrayList< IParameter >();
      name = null;
      multiLinesComments = new ArrayList< IParserNode >();
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
   public FunctionNode compute()
   {
      if ( getInternalNode().numChildren() != 0 )
      {
         for ( final IParserNode node : getInternalNode().getChildren() )
         {
            if ( node.is( NodeKind.BLOCK ) )
            {
               computeFunctionContent( node );
            }
            else if ( node.is( NodeKind.NAME ) )
            {
               name = IdentifierNode.create( node );
            }
            else if ( node.is( NodeKind.MOD_LIST ) )
            {
               computeModifierList( this,
                                    node );
            }
            else if ( node.is( NodeKind.PARAMETER_LIST ) )
            {
               computeParameterList( node );
            }
            else if ( node.is( NodeKind.TYPE ) )
            {
               returnType = IdentifierNode.create( node );
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
         }
      }
      return this;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.nodes.IFunction#findPrimaryStatementInBody(java.lang.
    * String[])
    */
   public List< IParserNode > findPrimaryStatementInBody( final String[] primaryNames )
   {
      return body == null ? null
                         : body.findPrimaryStatementsFromNameInChildren( primaryNames );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.nodes.IFunction#findPrimaryStatementsInBody(java.lang
    * .String)
    */
   public List< IParserNode > findPrimaryStatementsInBody( final String primaryName )
   {
      return body == null ? new ArrayList< IParserNode >()
                         : body.findPrimaryStatementsFromNameInChildren( new String[]
                         { primaryName } );
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
    * @see com.adobe.ac.pmd.nodes.IFunction#getBody()
    */
   public IParserNode getBody()
   {
      return body;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IFunction#getCyclomaticComplexity()
    */
   public int getCyclomaticComplexity()
   {
      return cyclomaticComplexity;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IFunction#getLocalVariables()
    */
   public Map< String, IParserNode > getLocalVariables()
   {
      return localVariables;
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
    * @see com.adobe.ac.pmd.nodes.IFunction#getParameters()
    */
   public List< IParameter > getParameters()
   {
      return parameters;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IFunction#getReturnType()
    */
   public IIdentifierNode getReturnType()
   {
      return returnType;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IFunction#getStatementNbInBody()
    */
   public int getStatementNbInBody()
   {
      return 1 + getStatementInNode( body );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IFunction#getSuperCall()
    */
   public IParserNode getSuperCall()
   {
      if ( body != null
            && body.numChildren() != 0 )
      {
         for ( final IParserNode childContent : body.getChildren() )
         {
            if ( NodeKind.CALL.equals( childContent.getId() )
                  || NodeKind.DOT.equals( childContent.getId() ) )
            {
               for ( final IParserNode childCall : childContent.getChildren() )
               {
                  if ( KeyWords.SUPER.toString().equals( childCall.getStringValue() ) )
                  {
                     return childContent;
                  }
               }
            }
         }
      }
      return null;
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

   //@Override
   public boolean isEventHandler()
   {
      return getParameters().size() == 1
            && getParameters().get( 0 ).getType().toString().contains( "Event" );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IFunction#isGetter()
    */
   public boolean isGetter()
   {
      return getInternalNode().is( NodeKind.GET );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IFunction#isOverriden()
    */
   public boolean isOverriden()
   {
      return is( Modifier.OVERRIDE );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IVisible#isPublic()
    */
   public boolean isPublic()
   {
      return is( Modifier.PUBLIC );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IFunction#isSetter()
    */
   public boolean isSetter()
   {
      return getInternalNode().is( NodeKind.SET );
   }

   private void computeCyclomaticComplexity()
   {
      cyclomaticComplexity = 1 + body.computeCyclomaticComplexity();
   }

   private void computeFunctionContent( final IParserNode functionBodyNode )
   {
      body = functionBodyNode;

      computeCyclomaticComplexity();
      if ( body.numChildren() > 0 )
      {
         for ( final IParserNode node : body.getChildren() )
         {
            if ( node.is( NodeKind.MULTI_LINE_COMMENT ) )
            {
               multiLinesComments.add( node );
            }
         }
      }
      computeVariableList( body );
   }

   private void computeParameterList( final IParserNode node )
   {
      if ( node.numChildren() != 0 )
      {
         for ( final IParserNode parameterNode : node.getChildren() )
         {
            parameters.add( FormalNode.create( parameterNode ) );
         }
      }
   }

   private void computeVariableList( final IParserNode node )
   {
      if ( node.is( NodeKind.VAR_LIST ) )
      {
         localVariables.put( node.getChild( 0 ).getChild( 0 ).getStringValue(),
                             node );
      }
      else if ( node.numChildren() > 0 )
      {
         for ( final IParserNode child : node.getChildren() )
         {
            computeVariableList( child );
         }
      }
   }

   private int getStatementInNode( final IParserNode node )
   {
      int statementNb = 0;

      if ( node != null
            && node.numChildren() != 0 )
      {
         int lastLine = node.getChild( 0 ).getLine();
         for ( final IParserNode childContent : node.getChildren() )
         {
            if ( childContent.getLine() != lastLine )
            {
               lastLine = childContent.getLine();
               statementNb++;
            }
            statementNb += getStatementInNode( childContent );
         }
      }

      return statementNb;
   }
}
