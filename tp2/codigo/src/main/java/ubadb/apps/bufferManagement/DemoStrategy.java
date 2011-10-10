package ubadb.apps.bufferManagement;

import java.io.File;
import java.io.IOException;

import ubadb.components.bufferManager.BufferManager;
import ubadb.components.bufferManager.BufferManagerImpl;
import ubadb.components.bufferManager.bufferPool.BufferPool;
import ubadb.components.bufferManager.bufferPool.SingleBufferPool;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.PageReplacementStrategy;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.fifo.FIFOReplacementStrategy;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.lru.LRUReplacementStrategy;
import ubadb.components.bufferManager.bufferPool.replacementStrategies.mru.MRUReplacementStrategy;
import ubadb.exceptions.BufferManagerException;

public class DemoStrategy {

	private static final long PAUSE_BETWEEN_REFERENCES = 10;
	private static final String TRACES_PATH = "./traces/";
	private static final PageReplacementStrategy[] STRATEGIES = {new LRUReplacementStrategy(), new MRUReplacementStrategy(), new FIFOReplacementStrategy()};
	
	public static void main(String[] args) throws IOException, InterruptedException, BufferManagerException {
		new DemoStrategy().demo();
	}


	private void demo() throws IOException, InterruptedException, BufferManagerException {
		PageReferenceTraceReader reader = new PageReferenceTraceReader();

		File tracesDir = new File(TRACES_PATH);

		File[] tracesList = tracesDir.listFiles();

		for (File file : tracesList) 
		{
			System.out.println("File: " + file);
			for (int bufferSize = 4; bufferSize <= 10; bufferSize++)
			{
				PageReferenceTrace trace = reader.read(file);
	
				for(PageReplacementStrategy straregy : STRATEGIES)
				{
					testTrace(trace, bufferSize, straregy);
				}
			}
		}
	}


	private void testTrace(PageReferenceTrace trace, int maxBufferPoolSize, PageReplacementStrategy pageReplacementStrategy) 
			throws InterruptedException, BufferManagerException {
		
		DiskManagerFaultCounterMock diskManagerFaultCounterMock = new DiskManagerFaultCounterMock();

		BufferPool basicBufferPool = new SingleBufferPool(maxBufferPoolSize, pageReplacementStrategy);

		BufferManager bufferManager = new BufferManagerImpl(diskManagerFaultCounterMock, basicBufferPool);

		int requestsCount = 0;

		for(PageReference pageReference : trace.getPageReferences())
		{
			//Pause references to have different dates in LRU and MRU
			Thread.sleep(PAUSE_BETWEEN_REFERENCES);

			switch(pageReference.getType())
			{
			case REQUEST:
			{
				bufferManager.readPage(pageReference.getPageId());
				requestsCount++;
				break;
			}
			case RELEASE:
			{
				bufferManager.releasePage(pageReference.getPageId());
				break;
			}
			}
		}

		int faultsCount = diskManagerFaultCounterMock.getFaultsCount();
		System.out.println(maxBufferPoolSize+","+pageReplacementStrategy.getClass().getSimpleName()+"," + calculateHitRate(faultsCount, requestsCount));

	}
	
	private static double calculateHitRate(int faults, int requests)
	{
		return (double)(requests - faults)/(double)requests;
	}
}
