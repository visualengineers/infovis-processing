import java.util.*;
import java.util.stream.Stream;

MovieLensModel model;
PImage bgImage;
PFont mediumFont;
PFont lightFont;
int appWidth = 1024;
int appHeight = (int) (1024 / 1.5);
int currentYear;

void settings() {
  size(appWidth, appHeight);
}

void setup() {
  mediumFont = createFont("data/Roboto-Medium.ttf", 18);
  lightFont = createFont("data/Roboto-Light.ttf", 18);
  bgImage = loadImage("data/erik-witsoe-GF8VvBgcJ4o-unsplash.jpg");
  bgImage.resize(appWidth, appHeight);
  bgImage.filter(BLUR, 6);
  model = new MovieLensModel();
}

void layoutMovies() {
  strokeWeight(1);
  stroke(255,255,255);
  textFont(mediumFont);
  text("YEAR", 12, 60);
  line(12,66,212,66);
  text("BEST MOVIES", 230, 60);
  line(230,66,appWidth - 12,66);
  textFont(lightFont);
  text(currentYear, 12, 94);
  int ypos = 94;
  boolean noMovie = true;
  for (Movie mv : model.getMovies()) {
    if (mv.year == currentYear) {
      text(mv.title, 230, ypos);
      ypos += 28;
      noMovie = false;
      if (ypos > 240) break;
    }
  }
  if (noMovie) text("-- no movie --", 230, ypos); 
}

void layoutGraph() {
  println(model.getMoviesPerYear(currentYear));
  line(12,appHeight - 24, appWidth - 12, appHeight - 24);
  int maxWidth = appWidth - 24;
  int yearsCount = model.getEndYear() - model.getStartYear();
  int barWidth = maxWidth / yearsCount;
  int val = model.getMoviesPerYear(currentYear);
  int max = model.getMaxMoviesPerYear();
  rect(12,)
}

void draw() {
  background(bgImage);
  if (model.isReady) {
    layoutMovies();
    layoutGraph();
    if (currentYear < model.getEndYear()) currentYear++;
    delay(500);
  } else {
    model.init();
    currentYear = model.getStartYear();
  }  
}
