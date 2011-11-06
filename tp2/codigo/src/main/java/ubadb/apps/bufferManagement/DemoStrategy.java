package ubadb.apps.bufferManagement;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.io.InputStreamReader;
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

	private static final long PAUSE_BETWEEN_REFERENCES = 1;
	private static final String TRACES_PATH = "./traces/";
	private static final PageReplacementStrategy[] STRATEGIES = {new LRUReplacementStrategy(), new MRUReplacementStrategy(), new FIFOReplacementStrategy()};
	private static boolean printBuffer = false;
	private static boolean printHitRate = true;

	public static void main(String[] args) throws IOException, InterruptedException, BufferManagerException {
		DemoStrategy instance = new DemoStrategy();
		instance.execTest();
	}

	private void execTest(){

		System.out.print(
			"Elija que opción correr:\n" +
			"[0] Test File Scan\n" +
			"[1] Test Index Clustered\n" +
			"[2] Test Index Unclustered\n" +
			"[3] Test BNLJ\n" +
			"[7] "+(printHitRate ? "Desactivar" : "Activar")+" impresión del Hit-Rate\n" +
			"[8] "+(printBuffer ? "Desactivar" : "Activar")+" impresión del estado del Buffer\n" +
			"[9] Exit\n" +
			"> "
		);

		BufferedReader reader	= new BufferedReader(new InputStreamReader(System.in));
		String response			= null;
		try {
			response = reader.readLine();
		} catch (IOException e) {
			System.out.println("Error inesperado!");
			System.exit(-1);
		}

		if(response.matches("^[0-9]$")){
			Integer option = Integer.valueOf(response); 

			switch(option){
				case 0: 
					runFileTest("fileScan2Times.txt",4,10);
					break;
				case 7:
					printHitRate = !printHitRate;
					break;
				case 8:
					printBuffer = !printBuffer;
					break;
				default:
					System.out.println("Chaucito!");
					System.exit(0);
			}

			//new DemoStrategy().demo();
			//new DemoStrategy().demoBNLJ();
			
		}else{
			System.out.println("Usted debe escribir una opción válida");
		}		

		execTest();
	}

	private void runFileTest(final String fileFilter, int minBSize, int maxBSize) {
		try {
			PageReferenceTraceReader reader = new PageReferenceTraceReader();

			File tracesDir = new File(TRACES_PATH);

			File[] tracesList = tracesDir.listFiles(new FileFilter() {

				public boolean accept(File pathname) {
					return pathname.getAbsolutePath().endsWith(fileFilter);
				}
			});

			for (File file : tracesList) 
			{
				System.out.println("File: " + file);
				for (int bufferSize = minBSize; bufferSize <= maxBSize; bufferSize++)
				{
					PageReferenceTrace trace = reader.read(file);

					for(PageReplacementStrategy straregy : STRATEGIES)
					{
						testTrace(file.getName(), trace, bufferSize, straregy);
					}
				}
			}	
		}catch(Exception e){
			System.out.println(e.toString());
			System.out.println(	"Ocurrió un error inesperado, ¿puede fijarse si el archivo " + fileFilter +
								" existe en el sistema y ningún otro programa está utilizandolo?");
		}
		
	}




	private void demoBNLJ() throws IOException, InterruptedException, BufferManagerException {


		List<PageReferenceTrace> traces = new ArrayList<PageReferenceTrace>();

		for (int b=2; b<=40; b++){
			PageReferenceTrace lrt = new PageReferenceTraceGenerator().generateBNLJ("R", 100, "S", 500, b);	
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
				if(printBuffer)
				{
					if (basicBufferPool.isPageInPool(pageReference.getPageId()))
						System.out.print(">> H : ");
					else
						System.out.print(">> M : ");
				}

				bufferManager.readPage(pageReference.getPageId());
				requestsCount++;
				
				if(printBuffer)
					System.out.println(basicBufferPool.toString());
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

		if(printHitRate)
			System.out.println(idTrace+"\t"+maxBufferPoolSize+"\t"+pageReplacementStrategy.getClass().getSimpleName()+"\t"+format(hitRate));

	}

	private String format(double hitRate) 
	{	
		BigDecimal BigHitRate = new BigDecimal(hitRate);
		// No queremos utilizar notación decimal que aparece en números menores a 10^-6
		BigDecimal workingMin = new BigDecimal(1.0E-6);
		BigHitRate = BigHitRate.min(workingMin)==workingMin ? BigHitRate : new BigDecimal(0);

		String hitRateString = BigHitRate.toString();
		return hitRateString
				.replace('.',',')// Queremos mostrar una coma como separador decimal
				.replaceAll("(,\\d\\d).+","$1")// Solo queremos presicion de 2 digitos decimales
				.replaceAll(",0+$",",")// No queremos 0's al final de la representación decimal
				.replaceAll(",$","");// No queremos "," sin representación decimal
	}


	private static double calculateHitRate(int faults, int requests)
	{
		return (double)(requests - faults)/(double)requests;
	}
}
