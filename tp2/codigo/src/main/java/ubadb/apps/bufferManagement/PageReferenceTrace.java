package ubadb.apps.bufferManagement;

import java.util.ArrayList;
import java.util.List;

public class PageReferenceTrace
{
	private List<PageReference> pageReferences;
	private String id;

	public PageReferenceTrace()
	{
		pageReferences = new ArrayList<PageReference>();
	}

	public void addPageReference(PageReference pageReference)
	{
		pageReferences.add(pageReference);
	}
	
	public List<PageReference> getPageReferences()
	{
		return pageReferences;
	}
	
	public PageReferenceTrace concatenate(PageReferenceTrace otherTrace)
	{
		pageReferences.addAll(otherTrace.pageReferences);
		return this;
	}
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	@Override
	public String toString()
	{
		StringBuilder builder = new StringBuilder();
		
		for(PageReference reference : pageReferences)
		{
			builder.append(reference.toString());
			builder.append('\n');
		}
		
		return builder.toString();
			
	}
}
