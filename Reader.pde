Table flights;

void setup() {
  size(800,600);
  
  flights = loadTable("flights2k.csv", "header");
  
  println("Total rows: " + flights.getRowCount());
  
  for (TableRow row : flights.rows()) {
    
    String date = row.getString("FL_DATE");
    String carrier = row.getString("MKT_CARRIER");
    String origin = row.getString("ORIGIN");
    String dest = row.getString("DEST");
    int distance = row.getInt("DISTANCE");
    
    println(date + " " + carrier + " " + origin + " -> " + dest + " " + distance);
  }
}
