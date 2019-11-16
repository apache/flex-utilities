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
package org.apache.flex.utilities.converter.retrievers.types;

import junitparams.JUnitParamsRunner;
import junitparams.Parameters;
import org.apache.commons.lang3.SystemUtils;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.Arrays;
import java.util.Collection;

import static org.junit.Assert.assertEquals;

@RunWith(JUnitParamsRunner.class)
public class PlatformTypeTest {

	private Class<SystemUtils> systemUtilsClass;

	public static Collection<Object[]> platformParameters() {
		return Arrays.asList(new Object[][]{
				{"IS_OS_WINDOWS", PlatformType.WINDOWS},
				{"IS_OS_MAC", PlatformType.MAC},
				{"IS_OS_MAC_OSX", PlatformType.MAC},
				{"IS_OS_UNIX", PlatformType.LINUX}
		});
	}

	@Before
	public void setUp() throws Exception {
		systemUtilsClass = SystemUtils.class;

		setFinalStatic(systemUtilsClass.getField("IS_OS_WINDOWS"), false);
		setFinalStatic(systemUtilsClass.getField("IS_OS_MAC"), false);
		setFinalStatic(systemUtilsClass.getField("IS_OS_MAC_OSX"), false);
		setFinalStatic(systemUtilsClass.getField("IS_OS_UNIX"), false);
	}

	@Test
	@Parameters(method = "platformParameters")
	public void it_detects_the_current_platform_type(String fieldName, PlatformType platformType) throws Exception {

		setFinalStatic(systemUtilsClass.getField(fieldName), true);
		assertEquals(platformType, PlatformType.getCurrent());
	}

	@Test(expected = Exception.class)
	public void it_throws_an_exception_when_it_can_not_detect_the_current_platform_type() throws Exception {
		PlatformType.getCurrent();
	}

	private static void setFinalStatic(Field field, Object newValue) throws Exception {
		field.setAccessible(true);

		// remove final modifier from field
		Field modifiersField = Field.class.getDeclaredField("modifiers");
		modifiersField.setAccessible(true);
		modifiersField.setInt(field, field.getModifiers() & ~Modifier.FINAL);

		field.set(null, newValue);
	}
}
