dir = getDirectory("/Users/pwth228/OneDrive - University of Kentucky/Desktop/Parker image analysis/Intermediates/Intermediate_GFAP");
list = getFileList(dir);

for (i=0; i<list.length; i++)
{
   if (endsWith(list[i], ".tif")) 
   {
        open(dir + list[i]);
        run("8-bit");
        run("Auto Threshold", "method=Moments white");
        setOption("BlackBackground", true);
        run("Convert to Mask");
        run("Create Selection");
        run("Measure");
        close();
    }
}