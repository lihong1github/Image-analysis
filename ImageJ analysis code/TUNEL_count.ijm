// Author: Lihong Zhan, 10/15/2018
// Please cite paper: "Proximal recolonization by self-renewing microglia 
// re-establishes microglial homeostasis in the adult mouse brain”, PloS Biology 2018
// Requires plugin adaptiveThr. To download: https://sites.google.com/site/qingzongtseng/adaptivethreshold
// Replace "/Users/lzhan/Desktop/Output/" to "/Your/Desired/Directory/"

start = getTime();
macro "TUNEL count [a]" {
title = getTitle();
name1=getTitle();
run("Input/Output...", "jpeg=100 gif=-1 file=.csv copy_column save_column");
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");
selectWindow(title);
W = getWidth();
H = getHeight();
//make outline of the brain slice and exclude area outside of it
run("Duplicate...", " ");
setMinAndMax(0, 70);
run("Apply LUT");
run("8-bit");
setAutoThreshold("Huang dark");
run("Convert to Mask");
run("Fill Holes");
//run("Options...", "iterations=20 count=1 black do=close");


run("Analyze Particles...", "size=1000000-infinite circularity=0.00-1.00 show=Outlines add");
run("Convert to Mask");
rename("Slice_outline");
selectWindow(title);
run("Duplicate...", " ");
setMinAndMax(0, 150);
run("Apply LUT");
run("Duplicate...", " ");
roiManager("Select", 0);
setBackgroundColor(0, 0, 0);
roiManager("Set Color", "yellow");
roiManager("Set Line Width", 2);
run("Flatten");
saveAs("Jpeg", "/Users/lzhan/Desktop/Output/" + "area_" + name1);

selectWindow(title);
roiManager("Select", 0);
setBackgroundColor(0, 0, 0);
run("Clear Outside");
run("Set Measurements...", "area display greenirect=None decimal=3");
roiManager("Measure");
saveAs("Results", "/Users/lzhan/Desktop/Output/" + name1 + "_area.csv");

roiManager("reset");


selectWindow(title);
run("Split Channels");

selectWindow(title + " (green)");
run("Duplicate...", " ");
run("adaptiveThr ", "using=Mean from=20 then=-20");
run("Convert to Mask");
run("Set Measurements...", "area area_fraction greenirect=None decimal=3");
run("Analyze Particles...", "size=10-100 circularity=0.5-1 show=Masks exclude add");

selectWindow("Slice_outline");
run("Options...", "iterations=20 count=2 black do=Dilate");


run("Clear Results");


  if (roiManager("count")<1) {
  	  run("Clear Results");
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
	run("Set Measurements...", "area_fraction greenirect=None decimal=3");
	selectWindow("Slice_outline");
	roiManager("select", i);
	roiManager("measure");
	thr=getResult("%Area", i);
	if(thr<1) {array1 = Array.concat(array1,i);};			 
		
}

run("Clear Results");
run("Set Measurements...", "area greenirect=None decimal=3");
roiManager("select", array1); 
roiManager("Measure");
saveAs("Results", "/Users/lzhan/Desktop/Output/" + name1 + ".csv");

//
newImage("roi", "8-bit black", W, H, 1);
roiManager("select", array1);
roiManager("Fill");
run("Convert to Mask");
run("Options...", "iterations=3 count=3 black do=Dilate");
run("Convert to Mask");
run("Outline");
run("Green");
rename("greenROI");
selectWindow(title + " (green)");
run("Grays");
setMinAndMax(00, 150);
rename("green");
selectWindow("greenROI");
run("Merge Channels...", "c1=greenROI c4=green create keep");
saveAs("Jpeg", "/Users/lzhan/Desktop/Output/" + "ROI_TUNEL_"+name1);
//
list = getList("window.titles"); 
			for (i=0; i<list.length; i++){ 
			winame = list[i]; 
			selectWindow(winame); 
			run("Close"); 
			} 
run("Close All");
}};


