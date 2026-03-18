import java.util.ArrayList;

class Reader {
  public ArrayList<Flight> readIn(int start, int end, String filter,String originFilter,String destFilter) {
    String[] data = loadStrings("flights10k.csv");
    ArrayList<Flight> result = new ArrayList<Flight>();

    boolean applyFilter = !filter.equalsIgnoreCase("n/a");

    int columnIndex = -1;
    String filterValue = "";

    if (applyFilter){
      String[] parts = filter.split(",", 2);
      if (parts.length == 2) {
        String category = parts[0].trim().toLowerCase();
        filterValue = parts[1].trim().toLowerCase();

        String[] headers={
          "flight date", "iata code", "flight number", "origin airport","origin city", "x", "origin state", "origin wac","destination airport", "destination city", "x",
          "destination state", "destination wac","scheduled departure time", "actual departure time","scheduled arrival time", "actual arrival time",
          "cancelled", "diverted", "distance between airports"
        };

        for(int i = 0; i < headers.length; i++){
          if (headers[i].equals(category)){
            columnIndex = i;
            break;
          }
        }

        if(columnIndex == -1){
          applyFilter = false;
        }
      }else{
        applyFilter = false;
      }
    }

    if(start < 1){
      start = 1;
    }
    if(end == 0 || end > data.length){
      end = data.length;
    }

    for(int i = start; i < end; i++){
      String[] row = split(data[i], ',');
      if (row.length < 20) {
        continue;
      }
      
      row[4] = cleanText(row[4]);
      row[9] = cleanText(row[9]);

      boolean matchMain = !applyFilter || row[columnIndex].toLowerCase().equals(filterValue);

      if(!matchMain){
        continue;
      }
      
      boolean matchOrigin = true;
      boolean matchDest = true;
      if(!originFilter.equalsIgnoreCase("n/a")){
        matchOrigin = row[3].equalsIgnoreCase(originFilter);
      }
      
      if(!destFilter.equalsIgnoreCase("n/a")){
        matchDest = row[8].equalsIgnoreCase(destFilter);
      }
      
      if(!(matchOrigin && matchDest)){
        continue;
      }
      
      boolean cancelled = row[17].equals("1");
      boolean diverted = row[18].equals("1");

      int distance = safeInt(row[19]);

      Flight f = new Flight(
        row[0], row[1], row[2],row[3], row[4], row[6],row[7], row[8], row[9],row[11], row[12], row[13],
        row[14], row[15], row[16],diverted, cancelled, distance
      );
      result.add(f);
    }

    return result;
  }

  String cleanText(String s){
    return s.replace("\"", "").trim();
  }

  int safeInt(String s){
    try {
      return Integer.parseInt(s);
    } catch (Exception e){
      return 0;
    }
  }
}


Reader reader = new Reader();

void setup(){
  size(800, 600);

  ArrayList<Flight> cancelled = reader.readIn(1, 20, "cancelled, 1", "n/a", "n/a");
  println("Cancelled: " + cancelled.size());

  ArrayList<Flight> jfk = reader.readIn(1, 20, "cancelled, 1", "JFK", "n/a");
  println("Cancelled from JFK: " + jfk.size());

  ArrayList<Flight> lax = reader.readIn(1, 20, "cancelled, 1", "n/a", "LAX");
  println("Cancelled to LAX: " + lax.size());

  ArrayList<Flight> both = reader.readIn(1, 20, "cancelled, 1", "JFK", "LAX");
  println("Cancelled from JFK to LAX: " + both.size());
}
