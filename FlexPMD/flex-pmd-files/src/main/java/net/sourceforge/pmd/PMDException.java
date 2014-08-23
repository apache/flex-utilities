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

/**
 * A convenience exception wrapper. Contains the original exception, if any.
 * Also, contains a severity number (int). Zero implies no severity. The higher
 * the number the greater the severity.
 * 
 * @author Donald A. Leckie
 * @version $Revision: 5681 $, $Date: 2007-11-30 14:00:56 -0800 (Fri, 30 Nov
 *          2007) $
 * @since August 30, 2002
 */
public class PMDException extends Exception
{
   private static final long serialVersionUID = 6938647389367956874L;

   private int               severity;

   /**
    * @param message
    */
   public PMDException( final String message )
   {
      super( message );
   }

   /**
    * @param message
    * @param reason
    */
   public PMDException( final String message,
                        final Exception reason )
   {
      super( message, reason );
   }

   /**
    * Returns the cause of this exception or <code>null</code>
    * 
    * @return the cause of this exception or <code>null</code>
    * @deprecated use {@link #getCause()} instead
    */
   @Deprecated
   public Exception getReason()
   {
      return ( Exception ) getCause();
   }

   /**
    * @return
    */
   public int getSeverity()
   {
      return severity;
   }

   /**
    * @param severityToBeSet
    */
   public void setSeverity( final int severityToBeSet )
   {
      severity = severityToBeSet;
   }
}
