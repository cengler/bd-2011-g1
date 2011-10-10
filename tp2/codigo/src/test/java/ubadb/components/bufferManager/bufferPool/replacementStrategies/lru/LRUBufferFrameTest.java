package ubadb.components.bufferManager.bufferPool.replacementStrategies.lru;

import static org.junit.Assert.assertTrue;

import org.junit.Test;

import ubadb.mocks.MockObjectFactory;
import ubadb.util.TestUtil;

public class LRUBufferFrameTest
{
	@Test
	public void testAccessCounterVsPinCounter() throws Exception
	{
		LRUBufferFrame bufferFrame0 = new LRUBufferFrame(MockObjectFactory.PAGE);
		Thread.sleep(TestUtil.PAUSE_INTERVAL); //Sleep to guarantee that the second frame is created some time after the first one
		LRUBufferFrame bufferFrame1 = new LRUBufferFrame(MockObjectFactory.PAGE);
		
		bufferFrame0.pin();
		bufferFrame1.pin();
		bufferFrame0.pin();
		
		assertTrue(bufferFrame0.getPinCount() == 2);
		assertTrue(bufferFrame1.getPinCount() == 1);
		assertTrue(bufferFrame0.getAccessCounter() == 3);
		assertTrue(bufferFrame1.getAccessCounter() == 2);
	}
}
