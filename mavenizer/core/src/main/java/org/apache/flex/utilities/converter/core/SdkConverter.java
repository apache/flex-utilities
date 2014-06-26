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
package org.apache.flex.utilities.converter.core;

import org.apache.flex.utilities.converter.air.AirConverter;
import org.apache.flex.utilities.converter.exceptions.ConverterException;
import org.apache.flex.utilities.converter.flash.FlashConverter;
import org.apache.flex.utilities.converter.flex.FlexConverter;

import java.io.File;

/**
 * Created by cdutz on 24.05.2014.
 */
public class SdkConverter {

    public static void main(String[] args) throws Exception {
        if(args.length != 2) {
            System.out.println("Usage: SDKConverter {source-directory} {target-directory}");
            return;
        }

        final File sourceDirectory = new File(args[0]);
        final File targetDirectory = new File(args[1]);

        if(!sourceDirectory.exists()) {
            throw new Exception("'source-directory' does not exist: " + sourceDirectory.getAbsolutePath());
        }

        if(!targetDirectory.exists()) {
            if(!targetDirectory.mkdirs()) {
                throw new Exception("Could not create 'target-directory': " + targetDirectory.getAbsolutePath());
            }
        }

        try {
            final FlexConverter flexConverter = new FlexConverter(sourceDirectory, targetDirectory);
            flexConverter.convert();
        } catch(ConverterException e) {
            System.out.println("Skipping generation of FLEX SDK");
        }
        try {
            final AirConverter airConverter = new AirConverter(sourceDirectory, targetDirectory);
            airConverter.convert();
        } catch(ConverterException e) {
            System.out.println("Skipping generation of AIR SDK");
        }
        try {
            final FlashConverter flashConverter = new FlashConverter(sourceDirectory, targetDirectory);
            flashConverter.convert();
        } catch(ConverterException e) {
            System.out.println("Skipping generation of Flash SDK");
        }
    }

}
