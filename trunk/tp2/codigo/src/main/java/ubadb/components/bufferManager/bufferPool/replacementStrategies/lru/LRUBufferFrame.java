package ubadb.components.bufferManager.bufferPool.replacementStrategies.lru;

import ubadb.common.Page;
import ubadb.components.bufferManager.bufferPool.BufferFrame;
import ubadb.exceptions.BufferFrameException;

public class LRUBufferFrame extends BufferFrame 
{
	private long accessCounter;
	private static long maxAccessCounter = 0;
	
	public LRUBufferFrame(Page page) {
		super(page);
		accessCounter = ++maxAccessCounter;
	}

	public void unpin() throws BufferFrameException
	{
		super.unpin();
		accessCounter = ++maxAccessCounter;
	}

	public long getAccessCounter() {
		return accessCounter;
	}

	public void setAccessCounter(long accessCounter) {
		this.accessCounter = accessCounter;
	}
}
