import java.util.*;

MovieLensModel model; 
PImage bgImage;
PFont mediumFont; PFont lightFont;
int appWidth = 1024;
int appHeight = (int) (1024 / 1.5);
int currentYear;
int startTime = millis();   // use for animation purposes
color c = color(255, 255, 255);
boolean pause = false;

void settings() { size(appWidth, appHeight); }

void setup() {
  mediumFont = createFont("data/Roboto-Medium.ttf", 18);
  lightFont = createFont("data/Roboto-Light.ttf", 18);
  bgImage = 
    loadImage("data/erik-witsoe-GF8VvBgcJ4o-unsplash.jpg");
  bgImage.resize(appWidth, appHeight);
  bgImage.filter(BLUR, 6);
  model = new MovieLensModel();
}


void layoutMovies() {
  // print out the current movies
  strokeWeight(1);
  stroke(c);
  fill(c);
  textFont(mediumFont);
  text("YEAR", 12, 60);
  line(12, 66, 212, 66);

  text("BEST MOVIES", 230, 60);
  line(230, 66, appWidth - 12, 66);
  textFont(lightFont);
  text(currentYear, 12, 94);
  int ypos = 94;

  for (Movie mv : model.getMovies()) {
    if (mv.year == currentYear) {
      text(mv.title, 230, ypos);
      ypos += 28;
      if (ypos > 240) break;
    }
  }
}

void layoutGraph() {
  // calculate positioning
  int bottom = appHeight - 64;
  int maxWidth = appWidth - 24;
  float maxHeight = 200;
  int yearsCount = 
    model.getEndYear() - model.getStartYear() + 1;
  float barWidth = maxWidth / (float) yearsCount;
  float max = (float) model.getMaxMoviesPerYear();

  // print small info about current year
  textFont(mediumFont);
  text("MOVIES PER YEAR", 12, 320);
  line(12,bottom, appWidth - 12, bottom);

  // create bar charts up to the current year
  for (int y = model.getStartYear(); y <= currentYear; y++)
  {    
    float currYearCount = y - model.getStartYear();
    float val = model.getMoviesPerYear(y) / max;
    float x1 = 12 + currYearCount * barWidth;
    float y1 = bottom - maxHeight * val;
    rect(x1, y1, barWidth, maxHeight * val);
  }
  textFont(lightFont);
  text(model.getMoviesPerYear(currentYear) 
       + " movies in " + currentYear, 12, bottom + 22);
}

void mouseClicked() {
  // pause time animation
  pause = !pause;
  c = pause 
      ? color(170, 170, 170) 
      : color(255, 255, 255);
}

void draw() {
  background(bgImage);
  if (model.isReady) {    
    layoutMovies();
    layoutGraph();
    int m = millis();
    if (!pause && currentYear < model.getEndYear() && 
       (m - startTime > 1000)) {
      currentYear++;
      startTime = m;
    } else if (pause) {
      startTime = m;
    }
  } else {
    model.init(); // lazy initialization of model
    currentYear = model.getStartYear();
    startTime = millis();
  }
}
