/*Avril 2021
 * Erwan Grandgirard
 * grandgie@igbmc.fr
 * 
 * 1-Open .czi serie, run 8 bits, duplicate chanel 2"greenonly", correct the illumination and save as .tiff
 * 
 * 
*/



// INITIALISE MACRO
print("\\Clear");
               
run("Bio-Formats Macro Extensions");	//enable macro functions for Bio-formats Plugin
print("select folder with your Data")
dir1 = getDirectory("Choose a Directory");
print("Select the Save Folder")
dir2 = getDirectory("Choose a Directory");
list = getFileList(dir1);
setBatchMode(false);
// PROCESS LIF FILES
for (i = 0; i < list.length; i++) {
		processFile(list[i]);
}

/// Requires run("Bio-Formats Macro Extensions");
function processFile(fileToProcess){
	path=dir1+fileToProcess;
	Ext.setId(path);
	Ext.getCurrentFile(fileToProcess);
	Ext.getSeriesCount(seriesCount); // this gets the number of series
	print("Processing the file = " + fileToProcess);
	// see http://imagej.1557.x6.nabble.com/multiple-series-with-bioformats-importer-td5003491.html
	for (j=0; j<seriesCount; j++) {
        Ext.setSeries(j);
        Ext.getSeriesName(seriesName);
		run("Bio-Formats Importer", "open=&path color_mode=Default view=Hyperstack stack_order=XYCZT series_"+j+1); 
		image= getTitle();
		run("8-bit");
		run("Duplicate...", "duplicate channels=2");
		slices=nSlices;
		print(slices);
		for (i = 1; i <= nSlices; i++) {
    		setSlice(i); 
			run("Bandpass Filter...", "filter_large=10 filter_small=1 suppress=None tolerance=5 autoscale saturate");
		}
		saveAs(".tiff", dir2+image);
		run("Close All");
	}
}	