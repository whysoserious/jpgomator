import java.io.*;
import java.util.regex.*;

// running in fullscreen
// displaying a image
// command line args
// my directory
// State.toString
// center image

class State {
  int framerate = 1;
  // String path = ".";
  String path = "/Users/jan/Pictures";
  String fileRegex = "^.*\\.(jpg|jpeg|png|gif)$";
  color backgroundColor = 0;
  long lastModified = 0;
  String newestFileName = null;
  String logoFile = null;
  FileFilter imgFilter = new FileFilter() {
      private Pattern pattern = Pattern.compile(fileRegex);
      public boolean accept(File file) {
        return pattern.matcher(file.getName().toLowerCase()).matches();
      }
    };
  PImage logo = null;
}

State state;

void setup() {
  state = new State();
  size(200, 200);
  background(state.backgroundColor);
  frameRate(state.framerate);
}

String findNewestFile() {
  File path = new File(state.path);
  File[] files = path.listFiles(state.imgFilter);
  long lastModified = 0;
  String newestFileName = null;
  for (int i = 0; i < files.length; ++i) {
    long lm = files[i].lastModified();
    if (lm > lastModified) {
      lastModified = lm;
      newestFileName = files[i].getAbsolutePath();
    }
  }
  return newestFileName;
}

void showImage(String fileName) {
  PImage img = loadImage(fileName);
  background(state.backgroundColor);
  image(img, 0, 0);
}

void draw() {
  String newestFileName = findNewestFile();
  println("TICK: " + newestFileName);
  if (newestFileName != null) {
    if (state.newestFileName == null || !state.newestFileName.equals(newestFileName)) {
      state.newestFileName = newestFileName;
      showImage(state.newestFileName);
    }
  }
  
}


