package ubadb.components.bufferManager.bufferPool.replacementStrategies.lru;

import ubadb.common.Page;
import ubadb.components.bufferManager.bufferPool.BufferFrame;

public class LRUBufferFrame extends BufferFrame 
{
	private long accessCounter;
	private static long maxAccessCounter = 0;
	
	public LRUBufferFrame(Page page) {
		super(page);
		accessCounter = ++maxAccessCounter;
	}

	@Override
	public void unpin() {
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