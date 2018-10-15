// Author: Lihong Zhan, 10/15/2018
// Please cite paper: "Proximal recolonization by self-renewing microglia 
// re-establishes microglial homeostasis in the adult mouse brain”, PloS Biology 2018
// Requires plugin adaptiveThr. To download: https://sites.google.com/site/qingzongtseng/adaptivethreshold
// Replace "/Users/lzhan/Desktop/Output/" to "/Your/Desired/Directory/"

start = getTime();
macro "Two channel marker count [a]" {
title = getTitle();
name1=getTitle();
run("Input/Output...", "jpeg=100 gif=-1 file=.csv copy_column save_column");
run("Set Scale...", "distance=0 known=0 pixel=1 unit=pixel global");
makeRectangle(435, 2821, 2000, 2000); //Crops a region for analysis, can be disabled.
run("Crop");
selectWindow(title);
run("Split Channels");
selectWindow(title + " (green)");

run("Duplicate...", " ");
run("Subtract Background...", "rolling=50");
run("adaptiveThr ", "using=Mean from=100 then=-10");
run("Options...", "iterations=1 count=3 black do=Dilate");
run("Options...", "iterations=5 count=3 black do=Close");

run("Convert to Mask");
run("Set Measurements...", "area area_fraction redirect=None decimal=3");
run("Analyze Particles...", "size=200-2000 show=Masks exclude add")
run("Convert to Mask");
run("Outline");
run("Green");
rename("GREENROI");
selectWindow(title + " (green)");
run("Grays");
setMinAndMax(20, 100);
rename("GREEN");
run("Merge Channels...", "c2=GREENROI c4=GREEN create keep");
saveAs("Jpeg", "/Users/lzhan/Desktop/Output/" + "IBA1_"+name1);

selectWindow(title + " (red)");

run("Duplicate...", " ");
run("adaptiveThr ", "using=Mean from=50 then=-20");
run("Analyze Particles...", "size=50-2000 show=Masks display exclude clear");
run("Convert to Mask");
rename("RED");
run("Set Measurements...", "area area_fraction redirect=None decimal=3");
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
     
for (i=1;i<roiManager("count");i++){ 
			array1 = Array.concat(array1,i); 
			Array.print(array1); 
}
roiManager("select", array1); 
roiManager("Measure");
saveAs("Results", "/Users/lzhan/Desktop/Output/" + name1 + ".csv");

selectWindow("RED");
run("Outline");
run("Red");
rename("REDROI");
selectWindow(title + " (red)");
setMinAndMax(10, 150);
run("Grays");
rename("RED");
run("Merge Channels...", "c4=RED c1=REDROI create keep");
saveAs("Jpeg", "/Users/lzhan/Desktop/Output/" + "RFP_" + name1);
close();

selectWindow("REDROI");
run("Fill Holes");
run("Convert to Mask");
selectWindow("GREENROI");
run("Fill Holes");
run("Green");
run("Convert to Mask");
run("Merge Channels...", "c1=REDROI c2=GREENROI create keep");
saveAs("Jpeg", "/Users/lzhan/Desktop/Output/" + "RG_" + name1);

list = getList("window.titles"); 
			for (i=0; i<list.length; i++){ 
			winame = list[i]; 
			selectWindow(winame); 
			run("Close"); 
			} 
run("Close All");
}};


