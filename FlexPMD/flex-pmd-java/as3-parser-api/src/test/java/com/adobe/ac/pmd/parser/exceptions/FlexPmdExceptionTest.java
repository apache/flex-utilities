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
package com.adobe.ac.pmd.parser.exceptions;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

import com.adobe.ac.pmd.parser.exceptions.UnExpectedTokenException.Position;

public class FlexPmdExceptionTest
{
   private static final String MY_FILE_NAME = "myFileName";

   @Test
   public void testNullTokenException()
   {
      assertEquals( "null token in "
                          + MY_FILE_NAME + ".",
                    new NullTokenException( MY_FILE_NAME ).getMessage() );
   }

   @Test
   public void testTokenException()
   {
      assertEquals( "myMessage",
                    new TokenException( "myMessage" ).getMessage() );
   }

   @Test
   public void testUnexpectedTokenException()
   {
      assertEquals( "Unexpected token: \"tokenText\" in file (myFileName) at 1:1. Expecting \"token\"",
                    new UnExpectedTokenException( "tokenText", new Position( 1, 1 ), MY_FILE_NAME, "token" ).getMessage() );
   }
}
