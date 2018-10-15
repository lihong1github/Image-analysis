// Author: Lihong Zhan, 10/15/2018
// Please cite paper: "Proximal recolonization by self-renewing microglia 
// re-establishes microglial homeostasis in the adult mouse brain”, PloS Biology 2018
// Requires plugin adaptiveThr. To download: https://sites.google.com/site/qingzongtseng/adaptivethreshold
// Replace "/Users/lzhan/Desktop/Output/" to "/Your/Desired/Directory/"

start = getTime();
macro "Marker % area quantification [a]" {
title = getTitle();
name1=getTitle();
run("Input/Output...", "jpeg=100 gif=-1 file=.csv copy_column save_column");
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");

selectWindow(title);
run("Specify...", "width=2500 height=2000 x=2385 y=1692 centered"); //specify a smaller region for quantification, can be disabled
run("Crop");
run("Split Channels");

selectWindow(title + " (red)");
run("Duplicate...", " ");

run("adaptiveThr ", "using=Mean from=200 then=-30");
//this is the line for thresholding
run("Options...", "iterations=3 count=3 black do=Close");
run("Options...", "iterations=3 count=3 black do=Dilate");

run("Convert to Mask");
run("Set Measurements...", "area area_fraction redirect=None decimal=3");
run("Analyze Particles...", "size=200-3000 show=Masks exclude add")
//this needs to be changed according to image size

run("Outline");
run("Red");
run("Invert");
rename("REDROI");
selectWindow(title + " (red)");
run("Grays");

setMinAndMax(5, 180);
rename("RED");
selectWindow("REDROI");
run("Merge Channels...", "c1=REDROI c4=RED create keep");
saveAs("Jpeg", "/Users/lzhan/Desktop/Output/" + "ROI_IBA1_"+name1);

run("Set Measurements...", "area redirect=None decimal=3");
run("Clear Results");


array1 = newArray();
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
     
for (i=1;i<roiManager("count");i++){ 
			array1 = Array.concat(array1,i); 
			Array.print(array1); 
}
roiManager("select", array1); 
roiManager("Measure");
saveAs("Results", "/Users/lzhan/Desktop/Output/" + name1 + "_Iba1_count.csv");


run("Clear Results");

//Quantifies green channel percent positive area
selectWindow(title + " (green)");
run("Duplicate...", " ");
run("adaptiveThr ", "using=Mean from=500 then=-10");
run("Convert to Mask");
run("Select All");
run("Set Measurements...", "area_fraction redirect=None decimal=3");
run("Measure");
saveAs("Results", "/Users/lzhan/Desktop/Output/" + name1 + "_P2RY12_area.csv");

run("Outline");
run("Green");
rename("GREENROI");
selectWindow(title + " (green)");
run("Grays");
run("Enhance Contrast...", "saturated=0.01");
rename("GREEN");
selectWindow("GREENROI");
run("Merge Channels...", "c1=GREENROI c4=GREEN create keep");
saveAs("Jpeg", "/Users/lzhan/Desktop/Output/" + "ROI_P2Y12_"+name1);

list = getList("window.titles"); 
			for (i=0; i<list.length; i++){ 
			winame = list[i]; 
			selectWindow(winame); 
			run("Close"); 
			} 
run("Close All");
}};


