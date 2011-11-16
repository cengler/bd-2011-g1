package ubadb.util;

import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class TestUtil
{
	public static final long PAUSE_INTERVAL = 50L;
	
	@Test
	public void equalsTrue()
	{
		boolean isTrue = true;
		assertTrue(isTrue == true);
	}
	
}
