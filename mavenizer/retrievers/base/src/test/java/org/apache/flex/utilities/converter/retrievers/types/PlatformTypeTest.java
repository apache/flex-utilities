package org.apache.flex.utilities.converter.retrievers.types;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.rule.PowerMockRule;

import java.util.Arrays;
import java.util.Collection;

import static org.easymock.EasyMock.expect;
import static org.junit.Assert.assertEquals;
import static org.powermock.api.easymock.PowerMock.*;

/**
 * @author: Frederic Thomas
 * Date: 12/05/2015
 * Time: 01:34
 */
@PrepareForTest( { PlatformType.class })
@RunWith(Parameterized.class)
public class PlatformTypeTest {

	private String osName;
	private PlatformType platformType;

	@Rule
	public PowerMockRule powerMockRule = new PowerMockRule();

	@Parameterized.Parameters
	public static Collection<Object[]> data() {

		return Arrays.asList(new Object[][]{
				{PlatformType.WINDOWS_OS, PlatformType.WINDOWS},
				{PlatformType.MAC_OS, PlatformType.MAC},
				{PlatformType.MAC_OS_DARWIN, PlatformType.MAC},
				{PlatformType.FREE_BSD, PlatformType.LINUX},
				{PlatformType.LINUX_OS, PlatformType.LINUX},
				{PlatformType.NET_BSD, PlatformType.LINUX},
				{PlatformType.SOLARIS_OS, PlatformType.LINUX}
		});
	}

	public PlatformTypeTest(String osName, PlatformType platformType) {
		this.osName = osName;
		this.platformType = platformType;
	}

	@Test
	public void it_returns_the_current_platform_type() throws Exception {
		mockStatic(System.class);

		expect(System.getProperty("os.name")).andReturn(osName).anyTimes();
		replayAll();

		assertEquals(platformType, PlatformType.getCurrent());
		verifyAll();
	}
}
