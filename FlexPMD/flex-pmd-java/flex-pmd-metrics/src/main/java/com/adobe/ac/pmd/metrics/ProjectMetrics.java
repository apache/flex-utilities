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
package com.adobe.ac.pmd.metrics;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public final class ProjectMetrics
{
   private AverageFunctionMetrics        averageFunctions;
   private AverageClassMetrics           averageObjects;
   private final List< ClassMetrics >    classMetrics;
   private final String                  date;
   private final List< FunctionMetrics > functionMetrics;
   private final List< PackageMetrics >  packageMetrics;
   private final String                  time;
   private TotalPackageMetrics           totalPackages;

   public ProjectMetrics()
   {
      super();

      final Date now = new Date();

      date = new SimpleDateFormat( "yyyy-M-d", Locale.US ).format( now );
      time = new SimpleDateFormat( "k:m:s", Locale.US ).format( now );
      classMetrics = new ArrayList< ClassMetrics >();
      functionMetrics = new ArrayList< FunctionMetrics >();
      packageMetrics = new ArrayList< PackageMetrics >();
   }

   public AverageFunctionMetrics getAverageFunctions()
   {
      return averageFunctions;
   }

   public AverageClassMetrics getAverageObjects()
   {
      return averageObjects;
   }

   public List< ClassMetrics > getClasses()
   {
      return classMetrics;
   }

   public List< ClassMetrics > getClassMetrics()
   {
      return classMetrics;
   }

   public String getDate()
   {
      return date;
   }

   public List< FunctionMetrics > getFunctionMetrics()
   {
      return functionMetrics;
   }

   public List< FunctionMetrics > getFunctions()
   {
      return functionMetrics;
   }

   public List< PackageMetrics > getPackageMetrics()
   {
      return packageMetrics;
   }

   public List< PackageMetrics > getPackages()
   {
      return packageMetrics;
   }

   public String getTime()
   {
      return time;
   }

   public TotalPackageMetrics getTotalPackages()
   {
      return totalPackages;
   }

   public void setAverageFunctions( final AverageFunctionMetrics averageFunctionsToBeSet )
   {
      averageFunctions = averageFunctionsToBeSet;
   }

   public void setAverageObjects( final AverageClassMetrics averageObjectsToBeSet )
   {
      averageObjects = averageObjectsToBeSet;
   }

   public void setTotalPackages( final TotalPackageMetrics totalPackagesToBeSet )
   {
      totalPackages = totalPackagesToBeSet;
   }
}
