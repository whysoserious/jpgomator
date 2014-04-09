import java.io.*;
import java.util.*;
import java.util.regex.*;

class State {

  int framerate;
  String path;
  String fileRegex;
  color backgroundColor;
  boolean fullscreen;
  int sX;
  int sY;
  int fadeTime;
  
  long lastModified = 0;
  String newestFileName = null;
  PImage logo = null;
  int frames = 0;
  
  FileFilter imgFilter;

  State() {
    println("PWD is: [" + (new File(".").getAbsolutePath()) + "]");
    try {
      Properties p = new Properties();
      //InputStream is = new FileInputStream("/Users/jan/Dev/jpgomat/config.properties");
      InputStream is = new FileInputStream("config.properties");
      p.load(is);
      is.close();

      fullscreen = boolean(p.getProperty("fullscreen"));
      if (!fullscreen) {
        sX = int(p.getProperty("width"));
        sY = int(p.getProperty("height"));
      }
      framerate = int(p.getProperty("framerate"));
      path = p.getProperty("path");
      fileRegex = p.getProperty("filename-regex");
      backgroundColor = int(p.getProperty("background-color"));
      fadeTime = int(p.getProperty("fade-time"));
      
      imgFilter = new FileFilter() {
          private Pattern pattern = Pattern.compile(fileRegex);
          public boolean accept(File file) {           
              return pattern.matcher(file.getName().toLowerCase()).matches();            
          }
        };
      
    } catch (Exception e) {
      e.printStackTrace();
    }

  }

}

State state;

void setup() {
  state = new State();
  if (state.fullscreen) {
    size(displayWidth, displayHeight);
  } else {
    size(state.sX, state.sY);
  }
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
  File[] files = path.listFiles(state.imgFilter);
  if (files == null || files.length == 0) {
    return null;
  }
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
  // reset counter
  state.frames = 0;
}

void draw() {  
  String newestFileName = findNewestFile();
  if (newestFileName != null &&
      (state.newestFileName == null || !state.newestFileName.equals(newestFileName))) {
    state.newestFileName = newestFileName;
    showImage(state.newestFileName);
  }
  ++state.frames;
  if (state.frames > state.fadeTime) {
    background(state.backgroundColor);
  }
}

