import java.util.ArrayList;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

class Reader {
  public ArrayList<Flight> readIn(int start, int end, String filter,String originFilter,String destFilter){
    ArrayList<Flight> result = new ArrayList<Flight>();
    
    BufferedReader br;
    try{
      br = new BufferedReader(new FileReader("flights10k.csv"));
    }catch (Exception e){
      return result;
    }
    
    String Line;
    int lineNum = 0;
    try{
    br.readLine();
    }catch(Exception e){}
   
    

    boolean applyFilter = !filter.equalsIgnoreCase("n/a");

    int columnIndex = -1;
    String filterValue = "";

    if (applyFilter){
      String[] parts = filter.split(",", 2);
      if (parts.length == 2) {
        String category = parts[0].trim().toLowerCase();
        filterValue = parts[1].trim().toLowerCase();

       if(category.equals("cancelled")) columnIndex = 17;
        else if(category.equals("diverted")) columnIndex = 18;
        else if(category.equals("origin airport")) columnIndex = 3;
        else if(category.equals("destination airport")) columnIndex = 8;
        else columnIndex = -1;

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
    
    try{
    while((Line = br.readLine()) != null){
        lineNum++;
        if(lineNum < start){
          continue;
        }
        if(end != 0 && lineNum>=end){
          break;
        }
       String[] row = Line.split(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)");

        for(int i = 0; i < row.length; i++){
            row[i] = cleanText(row[i]);
        }
        
        if (row.length < 20) {
          continue;
        }
      

     boolean matchMain = !applyFilter || row[columnIndex].trim().equalsIgnoreCase(filterValue);

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
      
      boolean cancelled = row[17].trim().equals("1");
      boolean diverted = row[18].trim().equals("1");

      int distance = safeInt(row[19]);

      Flight f = new Flight(
       row[0], row[1], row[2],row[3], row[4], row[6],row[7], row[8], row[9],row[11], row[12], row[13], row[14], row[15], row[16],diverted, cancelled, distance
      );
      result.add(f);
    }
    br.close();
    }catch(Exception e){}
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

  ArrayList<Flight> cancelled = reader.readIn(1, 20, "cancelled,0", "n/a", "n/a");
  println("Cancelled: " + cancelled.size());

  ArrayList<Flight> jfk = reader.readIn(1, 20, "cancelled, 1", "JFK", "n/a");
  println("Cancelled from JFK: " + jfk.size());

  ArrayList<Flight> lax = reader.readIn(1,20, "cancelled, 1", "n/a", "LAX");
  println("Cancelled to LAX: " + lax.size());

  ArrayList<Flight> both = reader.readIn(1, 20, "cancelled, 1", "JFK", "LAX");
  println("Cancelled from JFK to LAX: " + both.size());
  
}
