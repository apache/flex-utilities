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
package de.bokelberg.flex.parser;

import java.util.ArrayList;
import java.util.List;

import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.NodeKind;

/**
 * @author xagnetti
 */
class NestedNode
{
   private List< IParserNode > children;
   private NodeKind            nodeId;

   /**
    * @param idToBeSet
    */
   protected NestedNode( final NodeKind idToBeSet )
   {
      nodeId = idToBeSet;
   }

   /**
    * @param idToBeSet
    * @param childToBeSet
    */
   protected NestedNode( final NodeKind idToBeSet,
                         final IParserNode childToBeSet )
   {
      this( idToBeSet );
      addChild( childToBeSet );
   }

   /**
    * @return
    */
   public final int computeCyclomaticComplexity()
   {
      int cyclomaticComplexity = 0;

      if ( is( NodeKind.FOREACH )
            || is( NodeKind.FORIN ) || is( NodeKind.CASE ) || is( NodeKind.DEFAULT ) )
      {
         cyclomaticComplexity++;
      }
      else if ( is( NodeKind.IF )
            || is( NodeKind.WHILE ) || is( NodeKind.FOR ) )
      {
         cyclomaticComplexity++;
         cyclomaticComplexity += getChild( 0 ).countNodeFromType( NodeKind.AND );
         cyclomaticComplexity += getChild( 0 ).countNodeFromType( NodeKind.OR );
      }

      if ( numChildren() > 0 )
      {
         for ( final IParserNode child : getChildren() )
         {
            cyclomaticComplexity += child.computeCyclomaticComplexity();
         }
      }

      return cyclomaticComplexity;
   }

   /**
    * @param type
    * @return
    */
   public final int countNodeFromType( final NodeKind type )
   {
      int count = 0;

      if ( is( type ) )
      {
         count++;
      }
      if ( numChildren() > 0 )
      {
         for ( final IParserNode child : getChildren() )
         {
            count += child.countNodeFromType( type );
         }
      }
      return count;
   }

   /**
    * @param index
    * @return
    */
   public final IParserNode getChild( final int index )
   {
      return getChildren() == null
            || getChildren().size() <= index ? null
                                            : getChildren().get( index );
   }

   /**
    * @return
    */
   public List< IParserNode > getChildren()
   {
      return children;
   }

   /**
    * @return
    */
   public NodeKind getId()
   {
      return nodeId;
   }

   /**
    * @return
    */
   public IParserNode getLastChild()
   {
      final IParserNode lastChild = getChild( numChildren() - 1 );

      return lastChild != null
            && lastChild.numChildren() > 0 ? lastChild.getLastChild()
                                          : lastChild;
   }

   /**
    * @param expectedType
    * @return
    */
   public final boolean is( final NodeKind expectedType ) // NOPMD
   {
      return getId().equals( expectedType );
   }

   /**
    * @return
    */
   public final int numChildren()
   {
      return getChildren() == null ? 0
                                  : getChildren().size();
   }

   /**
    * @param child
    * @return
    */
   final IParserNode addChild( final IParserNode child )
   {
      if ( child == null )
      {
         return child; // skip optional children
      }

      if ( children == null )
      {
         children = new ArrayList< IParserNode >();
      }
      children.add( child );
      return child;
   }

   /**
    * @param childId
    * @param childLine
    * @param childColumn
    * @param nephew
    * @return
    */
   final IParserNode addChild( final NodeKind childId,
                               final int childLine,
                               final int childColumn,
                               final IParserNode nephew )
   {
      return addChild( Node.create( childId,
                                    childLine,
                                    childColumn,
                                    nephew ) );
   }

   /**
    * @param childId
    * @param childLine
    * @param childColumn
    * @param value
    * @return
    */
   final IParserNode addChild( final NodeKind childId,
                               final int childLine,
                               final int childColumn,
                               final String value )
   {
      return addChild( Node.create( childId,
                                    childLine,
                                    childColumn,
                                    value ) );
   }

   /**
    * @param idToBeSet
    */
   final void setId( final NodeKind idToBeSet )
   {
      nodeId = idToBeSet;
   }
}
