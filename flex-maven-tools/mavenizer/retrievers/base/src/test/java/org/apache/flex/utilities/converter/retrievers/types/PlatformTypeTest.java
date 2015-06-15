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

/**
 * @author: Frederic Thomas
 * Date: 12/05/2015
 * Time: 01:34
 */
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
