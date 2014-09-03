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
package com.adobe.ac.utils;

/**
 * @author xagnetti
 */
public final class StackTraceUtils
{
   /**
    * Pretty print the first two lines of the stacktrace of the given exception
    * 
    * @param exception Exception to print
    * @return The first two lines of the stacktrace
    */
   public static String print( final Exception exception )
   {
      final StringBuffer buffer = new StringBuffer();

      buffer.append( exception.getMessage()
            + " at " + exception.getStackTrace()[ 0 ] + "\n" );
      buffer.append( exception.getStackTrace()[ 1 ]
            + "\n" + exception.getStackTrace()[ 2 ] );
      return buffer.toString();
   }

   /**
    * Pretty print the first two lines of the stacktrace of the given exception,
    * specifying which file the exception was thrown on.
    * 
    * @param fileName current fileName
    * @param exception exception thrown
    * @return error message
    */
   public static String print( final String fileName,
                               final Exception exception )
   {
      return "on "
            + fileName + " " + print( exception );
   }

   private StackTraceUtils()
   {
   }
}
