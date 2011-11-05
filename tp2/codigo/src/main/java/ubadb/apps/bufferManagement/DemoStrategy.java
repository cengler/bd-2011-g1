package ubadb.apps.bufferManagement;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

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
	
	private static final long PAUSE_BETWEEN_REFERENCES = 0;
	private static final String TRACES_PATH = "./traces/";
	private static final PageReplacementStrategy[] STRATEGIES = {new LRUReplacementStrategy(), new MRUReplacementStrategy(), new FIFOReplacementStrategy()};
	
	public static void main(String[] args) throws IOException, InterruptedException, BufferManagerException {
		//new DemoStrategy().demo();
		new DemoStrategy().demoBNLJ();
	}


	private void demo() throws IOException, InterruptedException, BufferManagerException {
		PageReferenceTraceReader reader = new PageReferenceTraceReader();

		File tracesDir = new File(TRACES_PATH);

		File[] tracesList = tracesDir.listFiles(new FileFilter() {
			
			public boolean accept(File pathname) {
				return pathname.getAbsolutePath().endsWith("BNLJ-5R-2S-4B.txt");
			}
		});

		for (File file : tracesList) 
		{
			System.out.println("File: " + file);
			for (int bufferSize = 4; bufferSize <= 4; bufferSize++)
			{
				PageReferenceTrace trace = reader.read(file);
	
				for(PageReplacementStrategy straregy : STRATEGIES)
				{
					testTrace(file.getName(), trace, bufferSize, straregy);
				}
			}
		}
	}


	
	
	private void demoBNLJ() throws IOException, InterruptedException, BufferManagerException {


		List<PageReferenceTrace> traces = new ArrayList<PageReferenceTrace>();
		
		for (int b=2; b<=40; b++){
			PageReferenceTrace lrt = new PageReferenceTraceGenerator().generateBNLJ("R", 10, "S", 50, b);	
			traces.add(lrt);
		}
		
		int traceIndex = 2;
		for (PageReferenceTrace trace : traces) 
		{
			for (int bufferSize=41; bufferSize <=41; bufferSize++)
			{
	
				for(PageReplacementStrategy straregy : STRATEGIES)
				{
					testTrace(Integer.toString(traceIndex), trace, bufferSize, straregy);
				}
			}
			traceIndex++;
		}
	}

	private void testTrace(String idTrace, PageReferenceTrace trace, int maxBufferPoolSize, PageReplacementStrategy pageReplacementStrategy) 
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
				/*if (basicBufferPool.isPageInPool(pageReference.getPageId()))
					System.out.print(">> H : ");
				else
					System.out.print(">> M : ");
				*/
				
				bufferManager.readPage(pageReference.getPageId());
				requestsCount++;
				//System.out.println(basicBufferPool.toString());
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
		double hitRate = calculateHitRate(faultsCount, requestsCount);
		
		
		//System.out.println(idTrace+"|"+maxBufferPoolSize+"|"+pageReplacementStrategy.getClass().getSimpleName()+"|"+format(hitRate));
		System.out.println(idTrace+"\t"+maxBufferPoolSize+"\t"+pageReplacementStrategy.getClass().getSimpleName()+"\t"+format(hitRate));

	}
	
	private String format(double hitRate) 
	{	
		//String hitRateString = Double.toString(hitRate);
		String hitRateString = (new BigDecimal(hitRate)).toString();
		return hitRateString.replace('.',',').replaceAll("(,\\d\\d).+","$1").replaceAll(",0+$","");
	}


	private static double calculateHitRate(int faults, int requests)
	{
		return (double)(requests - faults)/(double)requests;
	}
}
