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

/**
 * @author xagnetti
 */
public final class ViolationPosition
{
   /**
    * @param beginLineToBeSet
    * @param endLineToBeSet
    * @param beginColumnToBeSet
    * @param endColumnToBeSet
    * @return
    */
   public static ViolationPosition create( final int beginLineToBeSet,
                                           final int endLineToBeSet,
                                           final int beginColumnToBeSet,
                                           final int endColumnToBeSet )
   {
      return new ViolationPosition( beginLineToBeSet, endLineToBeSet, beginColumnToBeSet, endColumnToBeSet );
   }

   private final int beginColumn;
   private final int beginLine;
   private final int endColumn;
   private final int endLine;

   /**
    * @param lineToBeSet
    */
   public ViolationPosition( final int lineToBeSet )
   {
      this( lineToBeSet, lineToBeSet, 0, 0 );
   }

   /**
    * @param beginLineToBeSet
    * @param endLineToBeSet
    */
   public ViolationPosition( final int beginLineToBeSet,
                             final int endLineToBeSet )
   {
      this( beginLineToBeSet, endLineToBeSet, 0, 0 );
   }

   private ViolationPosition( final int beginLineToBeSet,
                              final int endLineToBeSet,
                              final int beginColumnToBeSet,
                              final int endColumnToBeSet )
   {
      super();

      beginLine = beginLineToBeSet;
      beginColumn = beginColumnToBeSet;
      endLine = endLineToBeSet;
      endColumn = endColumnToBeSet;
   }

   /**
    * @return
    */
   public int getBeginColumn()
   {
      return beginColumn;
   }

   /**
    * @return
    */
   public int getBeginLine()
   {
      return beginLine;
   }

   /**
    * @return
    */
   public int getEndColumn()
   {
      return endColumn;
   }

   /**
    * @return
    */
   public int getEndLine()
   {
      return endLine;
   }
}
