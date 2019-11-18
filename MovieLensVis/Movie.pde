public class Movie {
  String title;
  int year;
  int id;
  Vector<String> genres = new Vector<String>();
  float rating;
  int ratingCount;
  
  public float getRating() { return rating / ratingCount; }
  
  public Movie(int id, String title, int year, String genres) {
    this.id = id;
    this.title = title;
    this.year = year;
    String[] geArray = genres.split("|");
    for (String a : geArray) 
      this.genres.add(a);      
  }
}

class SortByRating implements Comparator<Movie> 
{ 
    public int compare(Movie a, Movie b) 
    { 
//      if (a == null || b == null) println("NULL");
//      println(a.getRating() + "::" + b.getRating() + "-->" + ((int) (a.getRating() - b.getRating())));
      return Float.compare(a.getRating(), b.getRating());
    } 
}
