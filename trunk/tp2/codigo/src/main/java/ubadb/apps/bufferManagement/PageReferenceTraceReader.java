package ubadb.apps.bufferManagement;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.StringTokenizer;

import ubadb.common.PageId;
import ubadb.common.TableId;

public class PageReferenceTraceReader 
{
	
	public PageReferenceTrace read(File file) throws IOException
	{
		PageReferenceTrace trace = new PageReferenceTrace();
		
		String line = null;
		BufferedReader reader = new BufferedReader(new FileReader(file));
		while( (line = reader.readLine()) != null )
		{
			StringTokenizer st = new StringTokenizer(line, "([, ])");
			PageReferenceType refType = PageReferenceType.valueOf(st.nextToken().toUpperCase());
			TableId tableId = new TableId(st.nextToken());
			int number = Integer.valueOf(st.nextToken());
			PageId pageId = new PageId(number, tableId);
			PageReference pageRef = new PageReference(pageId, refType);
			
			trace.addPageReference(pageRef);
		}
		return trace;
	}

}
