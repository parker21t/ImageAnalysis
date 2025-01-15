// Macro for GFAP on plaque analysis in Fiji
// Ensure the input is an 8-bit image with 2 channels

// User-defined parameters
setOption("ScaleConversions", true);
setOption("BlackBackground", true);

// Paths for saving results
basePath = "/Users/pwth228/OneDrive - University of Kentucky/Desktop/Parker image analysis/";
coreSelectionsPath = basePath + "Core Selections/";
intermediatePlaquePath = basePath + "Intermediates/intermediate_on_abeta_plaque/";
intermediateGFAPPath = basePath + "Intermediates/Intermediate_GFAP/";

// Ensure directories exist
File.makeDirectory(coreSelectionsPath);
File.makeDirectory(intermediatePlaquePath);
File.makeDirectory(intermediateGFAPPath);

// Get the title of the current window
originalTitle = getTitle();

// Extract mouse ID (first 4 digits after "projection")
genotypeStart = indexOf(originalTitle, "projection") + 10;  // Start after "projection"
genotypeEnd = genotypeStart + 4;  // Genotype is the next 4 digits
genotype = substring(originalTitle, genotypeStart, genotypeEnd);

// Extract image number (last two digits after the dash)
dashIndex = indexOf(originalTitle, "-");
imageNumber = substring(originalTitle, dashIndex + 1, dashIndex + 3);  // Next two digits after the last dash

// Function to process the image
function processChannels() {

    // Ensure we are processing the first channel (C=0)
    if (originalTitle.indexOf("C=0") == -1) {
        print("Error: Current image is not Channel 0. Please select the correct channel.");
        return;
    }

    // Save the original selection before enlarging
    saveAs("Tiff", coreSelectionsPath + genotype+"-"+imageNumber+" Core Selection.tif");

    // Enlarge the selection by 5 microns
    run("Enlarge...", "enlarge=5");
run("Measure");

    // Save the enlarged selection as intermediate plaque
    saveAs("Tiff", intermediatePlaquePath + genotype+"-"+imageNumber+" Plaque.tif");

    // Switch to second channel (C=1)
    secondChannelTitle = originalTitle.replace("C=0", "C=1");
    selectWindow(secondChannelTitle);

    // Restore selection on the second channel
    run("Restore Selection");

    // Save the intermediate GFAP signal with the selection applied
    run("8-bit");
    run("Clear Outside");
    saveAs("Tiff", intermediateGFAPPath + genotype+"-"+imageNumber+" GFAP.tif");

    // Smooth and despeckle
    run("Smooth");
    run("Despeckle");

    // Apply threshold
    setThreshold(8, 255, "raw");
    run("Convert to Mask");

    // Create selection and measure
    run("Create Selection");
    run("Measure");
}

// Start macro
processChannels();

// Notify user of completion
print("Processing completed.");
