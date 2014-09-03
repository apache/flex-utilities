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

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class StackTraceUtilsTest
{
   @SuppressWarnings("serial")
   private static class CustomException extends Exception
   {
      public CustomException( final String message )
      {
         super( message );
      }
   }

   @Test
   public void testPrint()
   {
      final Exception exception = new CustomException( "message" );

      assertEquals( "stackTrace is not correct",
                    "message at com.adobe.ac.utils.StackTraceUtilsTest.testPrint(StackTraceUtilsTest.java:37)\n"
                          + "sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)\n"
                          + "sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)",
                    StackTraceUtils.print( exception ) );
   }
}
