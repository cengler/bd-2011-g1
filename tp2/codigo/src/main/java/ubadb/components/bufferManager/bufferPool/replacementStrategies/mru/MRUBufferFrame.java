package ubadb.components.bufferManager.bufferPool.replacementStrategies.mru;

import ubadb.common.Page;
import ubadb.components.bufferManager.bufferPool.BufferFrame;

public class MRUBufferFrame extends BufferFrame 
{
	private long accessCounter;
	private static long maxAccessCounter = 0;
	
	public MRUBufferFrame(Page page) {
		super(page);
		accessCounter = ++maxAccessCounter;
	}

	@Override
	public void pin() {
		super.pin();
		accessCounter = ++maxAccessCounter;
	}

	public long getAccessCounter() {
		return accessCounter;
	}

	public void setAccessCounter(long accessCounter) {
		this.accessCounter = accessCounter;
	}
}
