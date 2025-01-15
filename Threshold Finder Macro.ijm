// GFAP Thresholding Macro for Fiji
// Ensure consistent thresholding and ROI analysis across multiple images

// Prompt user for input folder and output folder
inputDir = getDirectory("C:/Users/pwth228/Intermediate_GFAP/");
outputDir = getDirectory("C:/Users/pwth228/OneDrive - University of Kentucky/Desktop/");

// Threshold value (set based on initial exploration)
threshValue = 10; // Replace with the determined threshold value

// File handling
fileList = getFileList(inputDir);
setBatchMode(true); // Run in batch mode for efficiency

// Create a Results file
outputFile = outputDir + "Results.csv";
File.open(outputFile);
File.append("Image Name,Area,Mean,Min,Max\n", outputFile);

// Process each image in the folder
for (i = 0; i < fileList.length; i++) {
    if (endsWith(fileList[i], ".tif")) {
        open(inputDir + fileList[i]);
        run("8-bit"); // Ensure the image is 8-bit

        // Check if the image is open successfully
        if (isOpen(fileList[i])) {
            // Apply threshold
            setThreshold(threshValue, 255);
            run("Make Binary");

            // Analyze particles
            run("Analyze Particles...", "size=10-Infinity display summarize");

            // Append results to file
            results = File.openAsString();
            File.append(fileList[i] + "," + replace(results, "\t", ",") + "\n", outputFile);

            // Save thresholded image
            saveAs("Tiff", outputDir + fileList[i]);
            close();
            run("Clear Results");
        } else {
            print("Failed to open: " + fileList[i]);
        }
    }
}

File.close(outputFile);
setBatchMode(false); // Restore normal mode
print("Processing complete. Results saved to: " + outputFile);