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
 * A single node of the ast
 * 
 * @author rbokel
 */
final class Node extends NestedNode implements IParserNode
{
   protected static Node create( final NodeKind idToBeSet,
                                 final int lineToBeSet,
                                 final int columnToBeSet )
   {
      return new Node( idToBeSet, lineToBeSet, columnToBeSet );
   }

   protected static Node create( final NodeKind idToBeSet,
                                 final int lineToBeSet,
                                 final int columnToBeSet,
                                 final IParserNode childToBeSet )
   {
      return new Node( idToBeSet, lineToBeSet, columnToBeSet, childToBeSet );
   }

   protected static Node create( final NodeKind idToBeSet,
                                 final int lineToBeSet,
                                 final int columnToBeSet,
                                 final String valueToBeSet )
   {
      return new Node( idToBeSet, lineToBeSet, columnToBeSet, valueToBeSet );
   }

   private static boolean isNameInArray( final String[] strings,
                                         final String string )
   {
      for ( final String currentName : strings )
      {
         if ( currentName.equals( string ) )
         {
            return true;
         }
      }
      return false;
   }

   private final int    column;
   private final int    line;
   private final String stringValue;

   private Node( final NodeKind idToBeSet,
                 final int lineToBeSet,
                 final int columnToBeSet )
   {
      super( idToBeSet );

      line = lineToBeSet;
      column = columnToBeSet;
      stringValue = null;
   }

   private Node( final NodeKind idToBeSet,
                 final int lineToBeSet,
                 final int columnToBeSet,
                 final IParserNode childToBeSet )
   {
      super( idToBeSet, childToBeSet );

      line = lineToBeSet;
      column = columnToBeSet;
      stringValue = null;
   }

   private Node( final NodeKind idToBeSet,
                 final int lineToBeSet,
                 final int columnToBeSet,
                 final String valueToBeSet )
   {
      super( idToBeSet );

      line = lineToBeSet;
      column = columnToBeSet;
      stringValue = valueToBeSet;
   }

   public List< IParserNode > findPrimaryStatementsFromNameInChildren( final String[] names )
   {
      final List< IParserNode > foundNode = new ArrayList< IParserNode >();

      if ( getStringValue() != null
            && isNameInArray( names,
                              getStringValue() ) )
      {
         foundNode.add( this );
      }
      else if ( numChildren() != 0 )
      {
         for ( final IParserNode child : getChildren() )
         {
            foundNode.addAll( child.findPrimaryStatementsFromNameInChildren( names ) );
         }
      }
      return foundNode;
   }

   public int getColumn()
   {
      return column;
   }

   public int getLine()
   {
      return line;
   }

   public String getStringValue()
   {
      return stringValue;
   }

   @Override
   public String toString()
   {
      final StringBuffer buffer = new StringBuffer();

      if ( getStringValue() == null )
      {
         buffer.append( getId() );
      }
      else
      {
         buffer.append( getStringValue() );
      }

      buffer.append( ' ' );

      if ( getChildren() != null )
      {
         for ( final IParserNode child : getChildren() )
         {
            buffer.append( child.toString() );
            buffer.append( ' ' );
         }
      }
      return buffer.toString();
   }
}