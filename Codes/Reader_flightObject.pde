import java.util.ArrayList;

class Reader {
  
  public ArrayList<Flight> readIn(int start, int end, String filter) {
  return readIn(start, end, filter, "n/a", "n/a");
}
  
  public ArrayList<Flight> readIn(int start, int end, String filter, String originFilter, String destFilter) {
    String[] data = loadStrings("flights10k.csv");
    
    boolean isFiltered = true;
    if (filter.toLowerCase().equals("n/a")) { 
      isFiltered = false;
    }
    
    int categoryNumber = 1;
    String filterBy = "";
    
    if (isFiltered) {
      String[] filterHalves = filter.split(",", 2);  
      
      if (filterHalves.length == 2) {
        String category = filterHalves[0].trim();
        filterBy = filterHalves[1].trim();
      
        String[] categories = {
          "flight date", "iata code", "flight number", "origin airport", "origin city", "placeholder", 
          "origin state", "origin wac", "destination airport", "destination city", "placeholder", 
          "destination state", "destination wac", "scheduled departure time",
          "actual departure time", "scheduled arrival time", "actual arrival time", 
          "cancelled", "diverted", "distance between airports"
        };
        
        categoryNumber = 100;
      
        for (int i = 0; i < categories.length; i++) {
          if (category.toLowerCase().equals(categories[i])) {
            categoryNumber = i;
            break;
          }
        }
        
        if (categoryNumber == 100) {
          isFiltered = false;
        }
      } else {
        isFiltered = false;
      }
    }
    
    if (start < 1) {
      start = 1;
    }
    
    if (end == 0 || end > data.length) { 
      end = data.length;
    }

    String[] parts = new String[25];
    ArrayList<Flight> flights = new ArrayList<Flight>();
    boolean cancelled;
    boolean diverted;
    int distance;
    boolean useThis = true;
    
    String originUpper = originFilter.toUpperCase();
    String destUpper = destFilter.toUpperCase();
    
    for (int i = start; i < end; i++) {
      parts = data[i].split(",");
      
      if (parts.length < 20) {
        continue;
      }

      parts[4] = parts[4].replace("\"", "").trim();
      parts[9] = parts[9].replace("\"", "").trim();
      
      useThis = true;
      
      if (isFiltered) {
        if (!parts[categoryNumber].toLowerCase().equals(filterBy.toLowerCase())) {
          useThis = false;
        }
      }
      
      if (!originUpper.equals("N/A")) {
        if (!parts[3].toUpperCase().equals(originUpper)) {
          useThis = false;
        }
      }

      if (!destUpper.equals("N/A")) {
        if (!parts[8].toUpperCase().equals(destUpper)) {
          useThis = false;
        }
      }
      
      if (useThis) {
        if (parts[17].equals("1")) {
          cancelled = true;
        } else {
          cancelled = false;
        }
        
        if (parts[18].equals("1")) {
          diverted = true;
        } else {
          diverted = false;
        }
        
        distance = safeInt(parts[19]);
   
        flights.add(new Flight(
          parts[0], parts[1], parts[2], 
          parts[3], parts[4], parts[6], parts[7], 
          parts[8], parts[9], parts[11], parts[12], 
          parts[13], parts[14], parts[15], parts[16], 
          cancelled, diverted, distance
        ));
      }
    }
    
    return flights;
  }

  int safeInt(String s) {
    try {
      return Integer.parseInt(s.trim());
    } catch (Exception e) {
      return 0;
    }
  }
}

class Flight{
  
  String flightDate;
  String IATACode;
  String flightNumber;
  String originAirport;
  String originCity;
  String originState;
  String originWAC;
  String destinationAirport;
  String destinationCity;
  String destinationState;
  String destinationWAC;
  String scheduledDepartureTime;
  String actualDepartureTime;
  String scheduledArrivalTime;
  String actualArrivalTime;
  boolean cancelled;
  boolean diverted;
  int distanceBetweenAirports;
  
  Flight(String tFlightDate, String tIATACode, String tFlightNumber, String tOriginAirport, 
         String tOriginCity, String tOriginState, String tOriginWAC, String tDestinationAirport, 
         String tDestinationCity, String tDestinationState, String tDestinationWAC, 
         String tScheduledDepartureTime, String tActualDepartureTime, String tScheduledArrivalTime, 
         String tActualArrivalTime, boolean tCancelled, boolean tDiverted, int tDistance){
            
    this.flightDate = tFlightDate;
    this.IATACode = tIATACode;
    this.flightNumber = tFlightNumber;
    this.originAirport = tOriginAirport;
    this.originCity = tOriginCity;
    this.originState = tOriginState;
    this.originWAC = tOriginWAC;
    this.destinationAirport = tDestinationAirport;
    this.destinationCity = tDestinationCity;
    this.destinationState = tDestinationState;
    this.destinationWAC = tDestinationWAC;
    this.scheduledDepartureTime = tScheduledDepartureTime;
    this.actualDepartureTime = tActualDepartureTime;
    this.scheduledArrivalTime = tScheduledArrivalTime;
    this.actualArrivalTime = tActualArrivalTime;
    this.cancelled = tCancelled;
    this.diverted = tDiverted;
    this.distanceBetweenAirports = tDistance;    
  }
}
