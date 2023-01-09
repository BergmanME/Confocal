openPath = getDirectory("Choose Source Directory");
files = getFileList(openPath);
savePath = getDirectory("Choose Destination Directory");

for (fileCount = 0; fileCount < (files.length); fileCount++)
{
	filename = files[fileCount];
	
	if (indexOf(filename, ".czi") >=0) //Screens file names for variable
	{
		print("opening " + filename + "...");
		//tempName = getTitle();
		open(openPath + filename);
		print("This can take a while to load the stack...");
		// virtual stack is much faster if no need to scan through the file manually and RAM is limited
		//run(...
		
		//originalPath="Z:/Users/Matthew/LSM800/221220_TPS3/";
		
		originalPath=savePath;
		originalTitle=getTitle();
		originalFile=getInfo("image.filename");
		originalPrefix = originalPath + originalTitle;
		//rename("Original");
		//selectWindow("Original");
		run("Duplicate...", "duplicate");
		rename("Temp_image");
		
		run("Z Project...");
		run("Set Scale...");
		run("Scale Bar...", "width=50 height=15 thickness=15 font=30 color=White background=None location=[Lower Right] horizontal bold overlay");
		run("Split Channels");
		//Channel 1 = Chlorophyll autofluorescence, Channel 2 = eGFP, Channel 3 = Brightfield
		selectWindow("C3-AVG_Temp_image");
		thisChannel = "Brightfield";
		run("Despeckle");
		wait(1000); //Waits for 1 seconds (sometimes the command does not finish before next one starts)
		run("Enhance Contrast...", "saturated=0.01");
		wait(1000); //Waits for 1 seconds (sometimes the command does not finish before next one starts)
		run("Flatten"); //Makes this into a static image with all layers including channel, labels, and scale
		wait(1000); //Waits for 1 seconds (sometimes the command does not finish before next one starts)
		thisExtension = ".tif";
		thisFile= originalPrefix + "_" + thisChannel + thisExtension;
		print(thisFile);
		saveAs("Tiff", thisFile);
		close();
		
		selectWindow("C2-AVG_Temp_image");
		thisChannel = "eGFP";
		run("Despeckle");
		wait(1000); //Waits for 1 seconds
		run("Enhance Contrast...", "saturated=0.01");
		wait(1000); //Waits for 1 seconds
		run("Flatten");
		wait(1000); //Waits for 1 seconds
		thisExtension = ".tif";
		thisFile= originalPrefix + "_" + thisChannel + thisExtension;
		print(thisFile);
		saveAs("Tiff", thisFile);
		close();
		
		selectWindow("C1-AVG_Temp_image");
		thisChannel = "Chlorophyll";
		run("Despeckle");
		wait(1000); //Waits for 1 seconds
		run("Enhance Contrast...", "saturated=0.01");
		wait(1000); //Waits for 1 seconds
		run("Flatten");
		wait(1000); //Waits for 1 seconds
		thisExtension = ".tif";
		thisFile= originalPrefix + "_" + thisChannel + thisExtension;
		print(thisFile);
		saveAs("Tiff", thisFile);
		close();
		
		run("Merge Channels...", "c1=[C1-AVG_Temp_image] c2=[C2-AVG_Temp_image] c3=[C3-AVG_Temp_image] create");
		thisChannel = "Merged";
		run("Scale Bar...", "width=50 height=15 thickness=15 font=30 color=White background=None location=[Lower Right] horizontal bold overlay");
		run("Flatten");
		thisExtension = ".tif";
		thisFile= originalPrefix + "_" + thisChannel + thisExtension;
		print(thisFile);
		saveAs("Tiff", thisFile);
		print("Macro complete");
		close();
		selectWindow("Temp_image");
		close(); // close the duplicate sample for working on
	}
}
