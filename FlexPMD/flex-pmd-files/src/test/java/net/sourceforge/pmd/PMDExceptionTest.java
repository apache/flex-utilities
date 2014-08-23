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
package net.sourceforge.pmd;

import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class PMDExceptionTest
{
   @SuppressWarnings("deprecation")
   @Test
   public void testGetReason()
   {
      final Exception reason = new Exception();
      final PMDException exception = new PMDException( "message", reason );

      assertEquals( reason,
                    exception.getReason() );
   }

   @Test
   public void testPMDExceptionString()
   {
      assertEquals( "message",
                    new PMDException( "message" ).getMessage() );
   }

   @Test
   public void testPMDExceptionStringException()
   {
      final PMDException exception = new PMDException( "message", new Exception() );

      assertEquals( "message",
                    exception.getMessage() );
   }

   @Test
   public void testSetSeverity()
   {
      final PMDException exception = new PMDException( "message" );

      exception.setSeverity( 1 );
      assertEquals( Integer.valueOf( 1 ),
                    Integer.valueOf( exception.getSeverity() ) );
   }
}
