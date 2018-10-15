// Author: Lihong Zhan, 10/15/2018
// Please cite paper: "Proximal recolonization by self-renewing microglia 
// re-establishes microglial homeostasis in the adult mouse brain”, PloS Biology 2018
// Requires plugin adaptiveThr. To download: https://sites.google.com/site/qingzongtseng/adaptivethreshold
// Replace "/Users/lzhan/Desktop/Output/" to "/Your/Desired/Directory/"

start = getTime();
macro "Iba1 count [a]" {
title = getTitle();
name1 = substring(title, 0, lastIndexOf(title, "."));
run("Input/Output...", "jpeg=100 gif=-1 file=.csv copy_column save_column");
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");
run("Colors...", "foreground=white background=black selection=yellow");
m = getWidth;
n = getHeight;

//make outline of the brain slice and exclude area outside of it
run("Duplicate...", " ");
setMinAndMax(0, 100);
run("Apply LUT");
run("8-bit");
setAutoThreshold("Huang dark");
run("Convert to Mask");
run("Fill Holes");

run("Analyze Particles...", "size=1000000-infinite circularity=0.00-1.00 show=Outlines add");
//Identifies the coronal slice
run("Convert to Mask");
rename("SliceROI");
run("Options...", "iterations=10 count=1 black do=Dilate");
selectWindow(title);
run("Duplicate...", " ");
roiManager("Select", 0);
setBackgroundColor(0, 0, 0);
roiManager("Set Color", "yellow");
roiManager("Set Line Width", 2);
run("Flatten");
saveAs("Jpeg", "/Users/lzhan/Desktop/Output/" + "Outline_" + name1); //Change to your directory

selectWindow(title);
roiManager("Select", 0);
setBackgroundColor(0, 0, 0);
run("Clear Outside");
run("Set Measurements...", "area display redirect=None decimal=3");
roiManager("Measure");
saveAs("Results", "/Users/lzhan/Desktop/Output/" + name1 + "_area.csv");

roiManager("Select", 0);
setBackgroundColor(0, 0, 0);
run("Clear Outside");
roiManager("Reset");

//If analyzing cropped images for specific regions; disable lines from 17 to 50.
selectWindow(title);
run("Split Channels");

selectWindow(title + " (red)"); //Change name if the splitted channel uses a different annotation. e.g., selectWindow("C1_" + title);
run("Duplicate...", " ");
//run("Subtract Background...", "rolling=50"); //Optional: to remove background, will take longer to run
run("Smooth");
setMinAndMax(10, 130); //adjust the contrast of the image for optimal thresholding
run("Apply LUT");
run("adaptiveThr ", "using=Mean from=100 then=-20"); //adjust these numbers to get the best result. Here MG is expected to be ~100 pixels with -20 threshold level
run("Convert to Mask");
run("Options...", "iterations=10 count=5 black do=Open");
run("Set Measurements...", "area redirect=None decimal=3");
run("Analyze Particles...", "size=30-500 show=Masks exclude add") //adjust these numbers to identify microglia. Here MG is spected to be at 30-500 pixels 


run("Clear Results");

array1 = newArray;

  if (roiManager("count")<1) { 
			
	list = getList("window.titles"); 
	for (i=0; i<list.length; i++){ 
			winame = list[i]; 
			selectWindow(winame); 
			run("Close"); 
			} 
run("Close All");
   } else {
run("Clear Results");  
		// to remove cells that are on the outline of the parenchyma
			for (i=0;i<roiManager("count");i++){ 
			run("Set Measurements...", "area_fraction redirect=None decimal=3");
			selectWindow("SliceROI");
			roiManager("Select",i);
			roiManager("Measure");
			Thr = getResult("%Area",i);
			if(Thr<1) {array1 = Array.concat(array1,i);}		
		
}		
		
}


run("Clear Results"); 
roiManager("select", array1); 
run("Set Measurements...", "area redirect=None decimal=3");
roiManager("Measure");
saveAs("Results", "/Users/lzhan/Desktop/Output/" + name1 + ".csv");

newImage("ROIOUTLINE", "8-bit black", m, n, 1);
run("Clear Results");
roiManager("Select", array1);
roiManager("Draw");
run("Fill Holes");
run("Options...", "iterations=1 count=3 black do=Dilate");
run("Outline");
run("Red");

selectWindow(title + " (red)");
run("Duplicate...", " ");
//run("Enhance Contrast...", "saturated=0.01");
setMinAndMax(10, 120);
run("Apply LUT");
rename("RAW");
run("Merge Channels...", "c1=ROIOUTLINE c4=RAW create keep");

saveAs("Jpeg", "/Users/lzhan/Desktop/Output/" + "ROI_IBA1_"+name1);

list = getList("window.titles"); 
			for (i=0; i<list.length; i++){ 
			winame = list[i]; 
			selectWindow(winame); 
			run("Close"); 
			} 
run("Close All");
}};


