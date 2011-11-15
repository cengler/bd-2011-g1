package ubadb.apps.bufferManagement;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	private static final String TRACES_PATH = "./classes/traces/";
	private static final PageReplacementStrategy[] STRATEGIES = {new LRUReplacementStrategy(), new MRUReplacementStrategy(), new FIFOReplacementStrategy()};
	private static boolean printBuffer = false;
	private static boolean printHitRate = true;

	/**
	 * Main. Ejecuta el selector interactivo de tests.
	 * 
	 * @param args argumenos (no se esperan)
	 * @throws Exception ante errores al ejecutar los test.
	 */
	public static void main(String[] args) throws Exception
	{
		DemoStrategy instance = new DemoStrategy();
		instance.execTest();
	}

	/**
	 * Selector interactivo del test a correr.
	 */
	private void execTest(){

		System.out.print(
				"Elija que opción correr:\n" +
						"[0] Test File Scan\n" +
						"[1] Test Index Clustered\n" +
						"[2] Test Index Unclustered\n" +
						"[3] Test BNLJ\n" +
						"[4] Test BNLJ (Br < Bs)\n" +
						"[5] Test BNLJ (Br > Bs)\n" +
						"[6] Test Custom File\n" +
						"[7] "+(printHitRate ? "Desactivar" : "Activar")+" impresión del Hit-Rate\n" +
						"[8] "+(printBuffer ? "Desactivar" : "Activar")+" impresión del estado del Buffer\n" +
						"[9] Exit\n" +
						"> "
				);

		BufferedReader reader	= new BufferedReader(new InputStreamReader(System.in));
		String response			= null;
		try {
			response = reader.readLine().trim();
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
			case 1: 
				runFileTest("indexScanClustered.txt",4,4);
				runFileTest("indexScanClustered.txt",10,10);
				break;
			case 2: 
				//runFileTest("indexScanUnclustered.txt",4,4);
				//runFileTest("indexScanUnclustered.txt",10,10);
				runScanUnClusteredTest();
				break;
			case 3: 
				runFileTest("BNLJ-5R-5S-4B.txt",4,4);
				break;
			case 4: 
				demoBNLJ(20, 20, 50, 50, 1, 19, 40, 40);
				break;
			case 5: 
				demoBNLJ(50, 50, 20, 20, 1, 19, 40, 40);
				break;
			case 6:
				runCustomFile();
			case 7:
				printHitRate = !printHitRate;
				break;
			case 8:
				printBuffer = !printBuffer;
				break;
			case 9:
				System.out.println("Chaucito!");
				System.exit(0);
			default:
				System.out.println("La opción elegida no está disponible actualmente, por favor intente en unos minutos");
			}
		}
		else{
			System.out.println("Usted debe escribir una opción válida");
		}		

		execTest();
	}

	private void runScanUnClusteredTest() {
		List<PageReferenceTrace> traces = new ArrayList<PageReferenceTrace>();

		int bufferSize = 5;
		int indexHeight = 3;

		for (int pageCount = 2; pageCount < 10; pageCount++) {
			for (int referenceCount = 2; referenceCount < 10; referenceCount++) {
				PageReferenceTrace lrt = new PageReferenceTraceGenerator().generateIndexScanUnclustered("A", indexHeight, referenceCount, pageCount);
				lrt.setId("PC"+pageCount+"-RC"+referenceCount);
				traces.add(lrt);
			}
		}
		
		try{
			Map<PageReplacementStrategy, Double> hits = new HashMap<PageReplacementStrategy, Double>();
			for(PageReplacementStrategy strategy : STRATEGIES)
				hits.put(strategy, 0d);
			
			for (PageReferenceTrace trace : traces) 
			{
				for(PageReplacementStrategy strategy : STRATEGIES)
				{
					double d = testTrace(trace.getId(), trace, bufferSize, strategy);
					hits.put(strategy, hits.get(strategy)+d);
				}
			}
			
			for(PageReplacementStrategy strategy : STRATEGIES)
				System.out.println(strategy.getClass().getSimpleName() + " - " + hits.get(strategy)/(8*8));
		}catch(Exception e)
		{
			System.out.println("Ocurrió un error el ejecutar el test "+ e.getMessage());
		}
	}

	private void runCustomFile() {
		System.out.print("Ingrese <archivo a correr> <tamaño del buffer>\n" +
				"(El Archivo a corrrer debe encontrarse en /traces)\n" +
				">");
		try{
			BufferedReader reader	= new BufferedReader(new InputStreamReader(System.in));
			String[] response = reader.readLine().trim().split(" ");
			if(response.length == 2)
			{
				int bufferSize = Integer.valueOf(response[1]);
				runFileTest(response[0], bufferSize, bufferSize);
			}
			else
			{
				System.out.println("Debe ingresar <archivo a correr> <tamaño del buffer>\n" +
						"Ejemplo: archivo.txt 6");
			}
			
		}
		catch(Exception e)
		{
			System.out.println("Ocurrió un error el ejecutar el test "+ e.getMessage());
		}
	}

	/**
	 * Ejecuta los traces de la carpeta traces que correspondan con el filtro dado.
	 * Permite variar la cantidad de memoria disponible.
	 * 
	 * @param fileFilter filtro que debe coincidir con el fin del nombre de los archivos a correr
	 * @param minBSize minima cantidad de memoria
	 * @param maxBSize maxima cantidad de memoria
	 */
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


	/**
	 * Test parametrico de BNLJ. 
	 * 
	 * Permite calcular los hit-rates de cada estrategia de reemplazo para el algoritmo BNLJ. 
	 * Es posible variar el tamaño de R y de S, la cantidad de bloques asociados a R en el algoritmo
	 * y el tamalo del buffer.
	 * 
	 * @param minR minima cant de bloques de R
	 * @param maxR maximo cant de bloques de R
	 * @param minS minima cant de bloques de S
	 * @param maxS maxima cant de bloques de S
	 * @param minB minima cant de bloques para R en BNLJ
	 * @param maxB maxima cant de bloques para R en BNLJ
	 * @param maxBuffSize minima cant de bloques de memoria
	 * @param minBuffSize maxima cant de bloques de memoria
	 */
	private void demoBNLJ(int minR, int maxR, 
			int minS, int maxS,
			int minB, int maxB,
			int maxBuffSize, int minBuffSize) {

		try{

			List<PageReferenceTrace> traces = new ArrayList<PageReferenceTrace>();

			for (int b=minB; b<=maxB; b++){
				for (int rSize=minR; rSize<=maxR; rSize++){
					for (int sSize=minS; sSize<=maxS; sSize++)
					{
						PageReferenceTrace lrt = new PageReferenceTraceGenerator().generateBNLJ("R", rSize, "S", sSize, b);
						lrt.setId("R"+rSize+"-S"+sSize+"-b"+b);
						traces.add(lrt);
					}
				}
			}

			for (PageReferenceTrace trace : traces) 
			{
				for (int bufferSize=minBuffSize; bufferSize <=maxBuffSize; bufferSize++)
				{

					for(PageReplacementStrategy strategy : STRATEGIES)
					{
						testTrace(trace.getId()+"-BuffSize"+bufferSize, trace, bufferSize, strategy);
					}
				}
			}
		}catch(Exception e){
			System.out.println(e.toString());
			System.out.println(	"Ocurrió un error inesperado!");
		}
	}

	/**
	 * Testea un trace imprimiendo por la salida standard el hit-rate y el estado del buffer para cada request.
	 * 
	 * @param idTrace identificador del trace
	 * @param trace trace de pedidos de paginas
	 * @param maxBufferPoolSize tamaño del buffer
	 * @param pageReplacementStrategy estrategia de remplazo de paginas
	 * @throws InterruptedException en caso de no poder hacer el sleep entre requests.
	 * @throws BufferManagerException en caso de pedir mas paginas que las que entran en el buffer.
	 */
	private double testTrace(String idTrace, PageReferenceTrace trace, int maxBufferPoolSize, PageReplacementStrategy pageReplacementStrategy) 
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

		return hitRate;
	}

	/**
	 * Retorna el hit-rate en formato excel compatible.
	 * 
	 * @param hitRate hit-rate
	 * @return el hit-rate en formato excel compatible
	 */
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

	/**
	 * Calcula el hit-rate dado la cantidad de faults y requests.
	 * 
	 * @param faults fallas de paginas
	 * @param requests pedidos de paginas
	 * @return el hit-rate
	 */
	private static double calculateHitRate(int faults, int requests)
	{
		return (double)(requests - faults)/(double)requests;
	}
}
