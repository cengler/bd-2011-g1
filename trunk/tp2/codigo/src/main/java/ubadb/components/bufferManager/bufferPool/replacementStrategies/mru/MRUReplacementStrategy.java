package ubadb.components.bufferManager.bufferPool.replacementStrategies.mru;

import java.util.Collection;

import ubadb.common.Page;
import ubadb.components.bufferManager.bufferPool.BufferFrame;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.PageReplacementStrategy;
import ubadb.exceptions.PageReplacementStrategyException;

public class MRUReplacementStrategy implements PageReplacementStrategy
{
	@Override
	public BufferFrame findVictim(Collection<BufferFrame> bufferFrames)
			throws PageReplacementStrategyException {
		
		MRUBufferFrame victim = null;
		long newestAccessCounter = 0;
		
		for(BufferFrame bufferFrame : bufferFrames)
		{
			MRUBufferFrame mruBufferFrame = (MRUBufferFrame) bufferFrame; //safe cast as we know all frames are of this type
			if(mruBufferFrame.canBeReplaced() && mruBufferFrame.getAccessCounter() > newestAccessCounter )
			{
				victim = mruBufferFrame;
				newestAccessCounter = mruBufferFrame.getAccessCounter();
			}
		}
		
		if(victim == null)
			throw new PageReplacementStrategyException("No page can be removed from pool");
		else
			return victim;
	}

	@Override
	public BufferFrame createNewFrame(Page page) {
		MRUBufferFrame bufferFrame = new MRUBufferFrame(page);
		return bufferFrame;
	}
}
