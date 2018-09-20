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

selectWindow(title);
run("Split Channels");

selectWindow(title + " (red)");
run("Duplicate...", " ");
//run("Subtract Background...", "rolling=50");
run("Smooth");
setMinAndMax(10, 100);
run("Apply LUT");
run("adaptiveThr ", "using=Mean from=100 then=-20");
//setAutoThreshold("MaxEntropy dark");
run("Convert to Mask");
//run("Options...", "iterations=1 count=2 black do=[Fill Holes]");
//run("Options...", "iterations=3 count=3 black do=Dilate");
run("Options...", "iterations=10 count=5 black do=Open");
run("Set Measurements...", "area redirect=None decimal=3");
run("Analyze Particles...", "size=40-800 show=Masks exclude add")

//run("Analyze Particles...", "size=50-1000 show=Masks display exclude");
run("Clear Results");


array1 = newArray("0");
  if (roiManager("count")<1) {
      saveAs("Results", "/Users/lzhan/Desktop/Output/" + name1 + ".csv");
      list = getList("window.titles"); 
			for (i=0; i<list.length; i++){ 
			winame = list[i]; 
			selectWindow(winame); 
			run("Close"); 
			} 
run("Close All");
   } else {
     
for (i=0;i<roiManager("count");i++){ 
			array1 = Array.concat(array1,i);
		
}
roiManager("select", array1); 
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


