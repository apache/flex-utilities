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
package com.adobe.ac.pmd.ant;

import java.io.File;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Project;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;

public class FlexPmdAntTaskTest extends FlexPmdTestBase
{
   private static final String TARGET = "target";

   @Test(expected = BuildException.class)
   public void testExecuteWithFailOnError()
   {
      final FlexPmdAntTask task = new FlexPmdAntTask();
      final Project project = new Project();

      task.setFailOnError( true );
      task.setSourceDirectory( getTestDirectory() );
      task.setOutputDirectory( new File( TARGET ) );
      task.setProject( project );
      task.execute();
   }

   @Test(expected = BuildException.class)
   public void testExecuteWithFailOnViolation()
   {
      final FlexPmdAntTask task = new FlexPmdAntTask();
      final Project project = new Project();

      task.setFailOnRuleViolation( true );
      task.setPackageToExclude( "" );
      task.setRuleSet( null );
      task.setSourceDirectory( getTestDirectory() );
      task.setOutputDirectory( new File( TARGET ) );
      task.setProject( project );
      task.execute();
   }

   @Test(expected = BuildException.class)
   public void testExecuteWithoutSettingParameters()
   {
      final FlexPmdAntTask task = new FlexPmdAntTask();
      final Project project = new Project();

      task.setProject( project );
      task.execute();
   }

   @Test
   public void testExecuteWithParameters()
   {
      final FlexPmdAntTask task = new FlexPmdAntTask();
      final Project project = new Project();

      task.setSourceDirectory( getTestDirectory() );
      task.setOutputDirectory( new File( TARGET ) );
      task.setProject( project );
      task.execute();
      new File( TARGET
            + "/pmd.xml" ).delete();
   }
}
