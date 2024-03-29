package ubadb.components.bufferManager.bufferPool.replacementStrategies.lru;

import java.util.Collection;

import ubadb.common.Page;
import ubadb.components.bufferManager.bufferPool.BufferFrame;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.PageReplacementStrategy;
import ubadb.exceptions.PageReplacementStrategyException;

public class LRUReplacementStrategy implements PageReplacementStrategy
{
	
	public BufferFrame findVictim(Collection<BufferFrame> bufferFrames)
			throws PageReplacementStrategyException {
		
		LRUBufferFrame victim = null;
		long oldestAccessCounter = Long.MAX_VALUE;
		
		for(BufferFrame bufferFrame : bufferFrames)
		{
			LRUBufferFrame lruBufferFrame = (LRUBufferFrame) bufferFrame; //safe cast as we know all frames are of this type
			if(lruBufferFrame.canBeReplaced() && lruBufferFrame.getAccessCounter() < oldestAccessCounter )
			{
				victim = lruBufferFrame;
				oldestAccessCounter = lruBufferFrame.getAccessCounter();
			}
		}
		
		if(victim == null)
			throw new PageReplacementStrategyException("No page can be removed from pool");
		else
			return victim;
	}

	
	public BufferFrame createNewFrame(Page page) {
		LRUBufferFrame bufferFrame = new LRUBufferFrame(page);
		return bufferFrame;
	}
}
