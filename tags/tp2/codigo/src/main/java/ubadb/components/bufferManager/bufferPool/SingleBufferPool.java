package ubadb.components.bufferManager.bufferPool;

import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.TreeMap;

import ubadb.common.Page;
import ubadb.common.PageId;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.PageReplacementStrategy;
import ubadb.exceptions.BufferPoolException;

/**
 * A single buffer pool shared by all tables 
 *
 */
public class SingleBufferPool implements BufferPool
{
	private class InternalFrame {
		public BufferFrame bufferFrame;
		public Integer bufferInternalId;

		public InternalFrame(BufferFrame bufferFrame, Integer bufferInternalId){
			this.bufferFrame		= bufferFrame;
			this.bufferInternalId	= bufferInternalId;
		}
	}

	private Map<PageId, InternalFrame> framesMap;
	private LinkedList<Integer> availableIds;
	private PageReplacementStrategy pageReplacementStrategy;
	private final int maxBufferPoolSize;
	
	public SingleBufferPool(int maxBufferPoolSize, PageReplacementStrategy pageReplacementStrategy)
	{
		this.maxBufferPoolSize		= maxBufferPoolSize;
		this.pageReplacementStrategy= pageReplacementStrategy;
		this.framesMap				= new HashMap<PageId, InternalFrame>(maxBufferPoolSize);
		this.availableIds			= new LinkedList<Integer>();
		for(int i=0; i<maxBufferPoolSize; i++){
			this.availableIds.addLast(i);
		}
	}

	private Collection<BufferFrame> getFrames(){
		Collection<BufferFrame> frames = new LinkedList<BufferFrame>();
		for(InternalFrame internalFrame: framesMap.values()){
			frames.add(internalFrame.bufferFrame);
		}
		return frames;
	}
	
	public boolean isPageInPool(PageId pageId)
	{
		return framesMap.containsKey(pageId);
	}
	
	public BufferFrame getBufferFrame(PageId pageId) throws BufferPoolException
	{
		if(isPageInPool(pageId))
			return framesMap.get(pageId).bufferFrame;
		else
			throw new BufferPoolException("The requested page is not in the pool");
	}
	
	public boolean hasSpace()
	{
		return countPagesInPool() < maxBufferPoolSize;
	}

	public BufferFrame addNewPage(Page page) throws BufferPoolException
	{
		if(!hasSpace())
			throw new BufferPoolException("No space in pool for new page");
		else if(isPageInPool(page.getPageId()))
			throw new BufferPoolException("Page already exists in the pool");
		else
		{
			//Add it to pool
			
			BufferFrame bufferFrame = pageReplacementStrategy.createNewFrame(page);
			framesMap.put(page.getPageId(), new InternalFrame(bufferFrame, availableIds.pop()));
			
			return bufferFrame;
		}
	}

	public void removePage(PageId pageId) throws BufferPoolException
	{
		if(isPageInPool(pageId))
		{
			availableIds.addLast(framesMap.get(pageId).bufferInternalId);
			framesMap.remove(pageId);
		}
		else
			throw new BufferPoolException("Cannot remove an unexisting page");
	}

	public BufferFrame findVictim(PageId pageIdToBeAdded) throws BufferPoolException
	{
		try
		{
			return pageReplacementStrategy.findVictim(getFrames());
		}
		catch(Exception e)
		{
			throw new BufferPoolException("Cannot find a victim page for removal",e);
		}
	}

	public int countPagesInPool()
	{
		return framesMap.size();
	}

	public String toString() {
		Map<Integer, BufferFrame> orderedFrames = new TreeMap<Integer, BufferFrame>();
		for(InternalFrame internalFrame: framesMap.values()){
			orderedFrames.put(internalFrame.bufferInternalId, internalFrame.bufferFrame);
		}

		StringBuilder sb = new StringBuilder();
		sb.append("{");
		for (BufferFrame frame: orderedFrames.values()) {
			sb.append("[");
			sb.append(frame.getPage().getPageId());
			sb.append("]");
		}
		sb.append("}");
		return sb.toString();
	}
	
	
}
