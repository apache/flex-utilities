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
package com.adobe.ac.pmd.nodes;

import com.adobe.ac.pmd.parser.KeyWords;

/**
 * @author xagnetti
 */
public enum Modifier
{
   DYNAMIC, FINAL, INTERNAL, OVERRIDE, PRIVATE, PROTECTED, PUBLIC, STATIC, INTRINSIC;

   /**
    * @param name
    * @return
    */
   public static Modifier create( final String name )
   {
      Modifier modifier = null;
      if ( KeyWords.PUBLIC.toString().equals( name ) )
      {
         modifier = Modifier.PUBLIC;
      }
      else if ( KeyWords.PRIVATE.toString().equals( name ) )
      {
         modifier = Modifier.PRIVATE;
      }
      else if ( KeyWords.PROTECTED.toString().equals( name ) )
      {
         modifier = Modifier.PROTECTED;
      }
      else if ( KeyWords.INTERNAL.toString().equals( name ) )
      {
         modifier = Modifier.INTERNAL;
      }
      else if ( KeyWords.DYNAMIC.toString().equals( name ) )
      {
         modifier = Modifier.DYNAMIC;
      }
      else if ( KeyWords.OVERRIDE.toString().equals( name ) )
      {
         modifier = Modifier.OVERRIDE;
      }
      else if ( KeyWords.STATIC.toString().equals( name ) )
      {
         modifier = Modifier.STATIC;
      }
      else if ( KeyWords.FINAL.toString().equals( name ) )
      {
         modifier = Modifier.FINAL;
      }
      // class modifier AS2
      else if ( KeyWords.INTRINSIC.toString().equals( name ) )
      {
         modifier = Modifier.INTRINSIC;
      }
      return modifier;
   }

   private Modifier()
   {
   }
}
