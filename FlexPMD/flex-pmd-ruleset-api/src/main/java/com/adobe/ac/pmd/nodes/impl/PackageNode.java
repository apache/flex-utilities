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
import java.util.List;

import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.IPackage;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.NodeKind;

/**
 * @author xagnetti
 */
class PackageNode extends AbstractNode implements IPackage
{
   private IClass                    classNode;
   private final List< IFunction >   functions;
   private final List< IParserNode > imports;
   private String                    name;

   /**
    * @param node
    */
   protected PackageNode( final IParserNode node )
   {
      super( node );

      imports = new ArrayList< IParserNode >();
      functions = new ArrayList< IFunction >();
      classNode = null;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.impl.AbstractNode#compute()
    */
   @Override
   public PackageNode compute()
   {
      final IParserNode classWrapperNode = getClassNodeFromCompilationUnitNode( getInternalNode(),
                                                                                3 );
      final IParserNode firstChild = getInternalNode().getChild( 0 );

      if ( firstChild.numChildren() > 0
            && firstChild.getChild( 0 ).getStringValue() != null )
      {
         name = firstChild.getChild( 0 ).getStringValue();
      }
      else
      {
         name = "";
      }
      if ( classWrapperNode != null )
      {
         classNode = new ClassNode( classWrapperNode ).compute();
      }

      if ( firstChild.numChildren() > 1
            && firstChild.getChild( 1 ).numChildren() != 0 )
      {
         final List< IParserNode > children = firstChild.getChild( 1 ).getChildren();

         for ( final IParserNode node : children )
         {
            if ( node.is( NodeKind.IMPORT ) )
            {
               imports.add( node );
            }
         }
      }
      return this;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IPackage#getClassNode()
    */
   public IClass getClassNode()
   {
      return classNode;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IPackage#getFullyQualifiedClassName()
    */
   public String getFullyQualifiedClassName()
   {
      if ( !"".equals( name ) )
      {
         return name
               + "." + classNode.getName();
      }
      return classNode == null ? ""
                              : classNode.getName();
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IPackage#getFunctions()
    */
   public List< IFunction > getFunctions()
   {
      return functions;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.IPackage#getImports()
    */
   public List< IParserNode > getImports()
   {
      return imports;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.nodes.INamable#getName()
    */
   public String getName()
   {
      return name;
   }

   private IParserNode getClassNodeFromCompilationUnitNode( final IParserNode node,
                                                            final int depth )
   {
      if ( depth == 0
            || node.numChildren() == 0 )
      {
         return null;
      }
      for ( final IParserNode child : node.getChildren() )
      {
         if ( child.is( NodeKind.CLASS )
               || child.is( NodeKind.INTERFACE ) )
         {
            return child;
         }
         final IParserNode localClassNode = getClassNodeFromCompilationUnitNode( child,
                                                                                 depth - 1 );

         if ( localClassNode != null )
         {
            return localClassNode;
         }
      }
      return null;
   }
}
