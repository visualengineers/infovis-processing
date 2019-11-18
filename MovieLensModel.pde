public class MovieLensModel {
  boolean isReady = false;
  Table movieTable, ratingTable;
  int startYear = 2019;
  int endYear = 0;
  List<Movie> movies = new ArrayList<Movie>();  
  int maxMoviesPerYear = 0;
  Map<Integer, Integer> moviesPerYear = new HashMap<Integer, Integer>();

  public void init() {
    movieTable = loadTable("data/movies.csv", "header");
    ratingTable = loadTable("data/ratings.csv", "header");  

    for (TableRow row : movieTable.rows()) {
      String title = row.getString("title").trim().replace("\\", "");
      String genres = row.getString("genres");
      int id = Integer.parseInt(row.getString("movieId"));
      int year;
      try {
        year = Integer.parseInt(title.substring(title.length()-5, title.length()-1));
        Movie mv = new Movie(id, title, year, genres);
        movies.add(mv);
        if (startYear > mv.year) startYear = mv.year;
        if (endYear < mv.year) endYear = mv.year;
        Integer val = moviesPerYear.get(year);
        val = val == null ? val = 1 : val+1;
        moviesPerYear.put(year, val);
        if (maxMoviesPerYear < val) maxMoviesPerYear = val; 
      } catch (NumberFormatException e) { }
    }
    for (TableRow row : ratingTable.rows()) {
      int id = Integer.parseInt(row.getString("movieId"));
      Movie movie = null;
      for (Movie mv : movies) {
        if (mv.id == id) {
          movie = mv;
          break;
        }
      }
      if (movie != null) {
        movie.rating += Float.parseFloat(row.getString("rating"));
        movie.ratingCount++;
      }
    }
    Collections.sort(movies, new SortByRating());  
    this.isReady = true;
  }
  
  public int getStartYear() { return this.startYear; }
  public int getEndYear() { return this.endYear; }
  public int getMaxMoviesPerYear() { return this.maxMoviesPerYear; }
  public List<Movie> getMovies() { return this.movies; }
  public int getMoviesPerYear(Integer year) {
    Integer result = this.moviesPerYear.get(year);
    if (result == null) result = 0;
    return result; 
  }
  
  public void debugOutput() {
    for (Movie mv : movies) {
      println("Year: " + mv.year + " --> " + mv.getRating() + " : " + mv.title);
    }
    for (Integer year : moviesPerYear.keySet()) {
      println(year + ": " + moviesPerYear.get(year));
    }
  }
}
