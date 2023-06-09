// Convert LSM to TIFF and Split Color Channels Macro Set the 
// input directory containing LSM files
path = "input";



// Get a list of all files in the folder
list = getFileList(path);



// Loop through each file in the list
for (i = 0; i < list.length; i++) {
  filename = list[i];

  // Check if the file is an .tif file
  if (endsWith(filename, ".tif")) {

    // Open the .tiff file
    open(path + "/" + filename);

    // Convert active image to 8-bit
    run("8-bit"); 


    out_dir = "output/";
    run("Stack Splitter", "split_directory=" + out_dir);
    
    // Get the list of image titles
    list = getList("image.titles");

    // Check if there are any open image windows
    if (list.length == 0) {

    } else {


    // Loop through each image title in the list
    for (i = 1; i < list.length; i++) {


        


        // Select Channel 
        selectWindow(list[i]);
        
        // Generate a unique file name for the TIFF file
        outFile = "output/" + i + "_" + list[i];
        print(outFile);
        
        // Save the image as a TIFF file
        saveAs("Tiff", outFile);
    }
    }



    // Close all windows
    close("*");
  }
}

// Display a message after conversion is complete
showMessage("Tif channel splitting and selection completed.");