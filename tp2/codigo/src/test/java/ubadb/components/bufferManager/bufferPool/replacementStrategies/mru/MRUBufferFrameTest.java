package ubadb.components.bufferManager.bufferPool.replacementStrategies.mru;

import static org.junit.Assert.assertTrue;

import org.junit.Test;

import ubadb.mocks.MockObjectFactory;
import ubadb.util.TestUtil;

public class MRUBufferFrameTest
{
	@Test
	public void testAccessCounterVsPinCounter() throws Exception
	{
		MRUBufferFrame bufferFrame0 = new MRUBufferFrame(MockObjectFactory.PAGE);
		Thread.sleep(TestUtil.PAUSE_INTERVAL); //Sleep to guarantee that the second frame is created some time after the first one
		MRUBufferFrame bufferFrame1 = new MRUBufferFrame(MockObjectFactory.PAGE);
		
		bufferFrame0.pin();
		bufferFrame0.unpin();
		bufferFrame1.pin();
		bufferFrame1.unpin();
		bufferFrame0.pin();
		
		assertTrue("bufferFrame0.getPinCount()!=2", bufferFrame0.getPinCount() == 1);
		assertTrue("bufferFrame1.getPinCount()!=1", bufferFrame1.getPinCount() == 0);
		assertTrue("bufferFrame0.getAccessCounter()!=5", bufferFrame0.getAccessCounter() == 3);
		assertTrue("bufferFrame1.getAccessCounter()!=4", bufferFrame1.getAccessCounter() == 4);
	}
}
