import java.io.*;
import java.util.*;
import java.util.regex.*;

// running in fullscreen
// command line args
// my directory
// State.toString
// center image
// logo
// flagi:
//  -fullscreen
//  -size
//  -background-color
//  -help
//  -logo-file
//  -file-extensions
//  -file-name-regex
//  -path
//  -framerate
//  -logo-position

class State {
  int framerate = 1;
  //  String path = ".";
String path = "/Users/jan/Pictures";
  String fileRegex = "^.*\\.(jpg|jpeg|png|gif)$";
  color backgroundColor = 0;
  long lastModified = 0;
  String newestFileName = null;
  File logo = new File("/Users/jan/Pictures/sasha.png");
  FileFilter imgFilter = new FileFilter() {
      private Pattern pattern = Pattern.compile(fileRegex);
      public boolean accept(File file) {
        println(file.getAbsolutePath());
        if (logo != null && logo.getAbsolutePath().equals(file.getAbsolutePath())) {
          return false;
        } else {
          return pattern.matcher(file.getName().toLowerCase()).matches();
        }
      }
    };
  PImage logoImg = null;


}

State state;

void setup() {
  state = new State();
  size(70, 50);
  background(state.backgroundColor);
  frameRate(state.framerate);
}

Properties loadCommandLine () {
  Properties props = new Properties();
  for (String arg : args) {
    String[] parsed = arg.split("=", 2);
    if (parsed.length == 2)
      props.setProperty(parsed[0], parsed[1]);
  }
  return props;
}

String findNewestFile() {
  File path = new File(state.path);
  println ("PATH: " + path.getAbsolutePath());
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
  println("WIDTH: " + img.width + " HEIGHT: " + img.height);
  // calculate new size of the image
  int w = img.width;
  int h = img.height;
  if      (w > width && h > height && w > h) { h = h * width  / w; w = width;  }
  else if (w > width && h > height)          { w = w * height / h; h = height; }
  else if (w > width)                        { h = h * width  / w; w = width;  }
  else if (h > height)                       { w = w * height / h; h = height; }
  else if (w < width && h < height && w > h) { h = h * width  / w; w = width;  }
  else if (w < width && h < height)          { w = w * height / h; h = height; }
  else if (w < width)                        { h = h * width  / w; w = width;  }
  else if (h < height)                       { w = w * height / h; h = height; }
  // resize image
  img.resize(w, h);
  // center image
  int pw = max(0, (width  - w) / 2);
  int ph = max(0, (height - h) / 2);
  // paint the base
  background(state.backgroundColor);
  // draw image
  image(img, pw, ph);
}

void draw() {
  String newestFileName = findNewestFile();
  println("TICK: " + newestFileName);
  if (newestFileName != null &&
      (state.newestFileName == null || !state.newestFileName.equals(newestFileName))) {
    state.newestFileName = newestFileName;
    showImage(state.newestFileName);
  }
}


