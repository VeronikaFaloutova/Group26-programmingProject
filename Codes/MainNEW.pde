import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.HashMap;
import java.util.Map;

ArrayList<Widget> widgets;
PFont welcomeFont;
PFont titleFont;
PFont subFont;
PFont labelFont;
PFont flipFont;
PFont smallFont;
PFont bodyFont;

int totalFlightsCount = 0;
int totalDelayedCount = 0;
int totalCancelledCount = 0;

SmoothScrollTable smoothTable;

Screen homescreen, graphScreen, currentScreen;
Screen modeSelectScreen, tableScreen, heatmapScreen, piechartScreen;
ArrayList<Flight> currentFilteredFlights;
String currentTitle = "";
TextTable table1;
Reader r = new Reader();

float scrollX;

LinkedHashMap<String, Integer> dataMap;

void setup() {
  size(1200, 700);

  welcomeFont = createFont("Arial", 50);
  titleFont = createFont("Arial", 50);
  subFont   = createFont("Arial Bold", 16);
  labelFont = createFont("Arial Bold", 20);
  flipFont  = createFont("Arial Bold", 22);
  smallFont = createFont("Arial Bold", 16);
  bodyFont  = createFont("Arial", 20);
  textFont(welcomeFont);
  
  smoothTable = new SmoothScrollTable();
  ArrayList<Flight> allFlights = r.readIn(1, 0, "n/a");
  totalFlightsCount = allFlights.size();
  
  for (Flight f : allFlights) {
    if (f.cancelled) totalCancelledCount++;
    try {
      int sched = Integer.parseInt(f.scheduledDepartureTime.trim());
      int actual = Integer.parseInt(f.actualDepartureTime.trim());
      if (actual > sched) totalDelayedCount++;
    } catch (Exception e) {
      
    }
  }
 
  homescreen = new Screen(color(30, 40, 60));

  float y = 540;
  float gap = 12;
  float x0 = 50;
  float cardW = (width - 100 - gap * 3) / 4.0;
  float cardH = 100;

  homescreen.addWidget(new Widget((int)x0, (int)y, (int)cardW, (int)cardH, "Unfiltered", color(126, 162, 255)));
  homescreen.addWidget(new Widget((int)(x0 + (cardW + gap)), (int)y, (int)cardW, (int)cardH, "Cancelled", color(120, 94, 240)));
  homescreen.addWidget(new Widget((int)(x0 + (cardW + gap) * 2), (int)y, (int)cardW, (int)cardH, "Delayed", color(220, 38, 127)));
  homescreen.addWidget(new Widget((int)(x0 + (cardW + gap) * 3), (int)y, (int)cardW, (int)cardH, "Diverted", color(255, 176, 0)));

  currentScreen = homescreen;
}

void draw() {
  if (currentScreen == homescreen) {
    drawHomeScreenV2Style();
    updateTicker();
  } else {
    currentScreen.draw();
  }
}

void mousePressed() {
  Widget clicked = currentScreen.getEvent();

  if (clicked != null) {

    if (clicked.label.equalsIgnoreCase("Cancelled")) {
      currentFilteredFlights = new Reader().readIn(1, 0, "cancelled, 1");
      setupModeSelectScreen();
      currentScreen = modeSelectScreen;

    } else if (clicked.label.equalsIgnoreCase("Unfiltered")) {
      currentFilteredFlights = new Reader().readIn(1, 0, "n/a");
      setupModeSelectScreen();
      currentScreen = modeSelectScreen;

    } else if (clicked.label.equalsIgnoreCase("Delayed")) {
      ArrayList<Flight> all = new Reader().readIn(1, 0, "n/a");
      ArrayList<Flight> delayed = new ArrayList<Flight>();

      for (Flight f : all) {
        try {
          int sched = Integer.parseInt(f.scheduledDepartureTime.trim());
          int actual = Integer.parseInt(f.actualDepartureTime.trim());
          if (actual > sched) {
            delayed.add(f);
          }
        } catch (Exception e) {
        }
      }

      currentFilteredFlights = delayed;
      setupModeSelectScreen();
      currentScreen = modeSelectScreen;

    } else if (clicked.label.equalsIgnoreCase("Diverted")) {
      currentFilteredFlights = new Reader().readIn(1, 0, "diverted, 1");
      setupModeSelectScreen();
      currentScreen = modeSelectScreen;

    } else if (clicked.label.equalsIgnoreCase("Graph")) {
      dataMap = countBy(currentFilteredFlights);
      graphScreen = new Screen(color(7,11,18));
      graphScreen.graph = new Graph(dataMap, currentFilteredFlights);
      graphScreen.graph.setTitle(currentTitle + " by Origin State");
      graphScreen.addWidget(new Widget(1010, 660, 140, 35, "Back", color(255, 140, 50)));
      currentScreen = graphScreen;
    } else if (clicked.label.equalsIgnoreCase("Table")) {
      tableScreen = new Screen(color(7,11,18));
      tableScreen.addWidget(new Widget(1010, 660, 140, 35, "Back", colourArray[0]));
      table1 = new TextTable(10, currentFilteredFlights, 130, 250, 25, 130);
      currentScreen = tableScreen;

    } else if (clicked.label.equalsIgnoreCase("Pie Chart")) {
      dataMap = countBy(currentFilteredFlights);
      piechartScreen = new Screen(color(7,11,18));
      piechartScreen.addWidget(new Widget(1010, 660, 140,35, "Back", colourArray[0]));
      piechartScreen.chart = new PieChart(dataMap);
      currentScreen = piechartScreen;

    } else if (clicked.label.equalsIgnoreCase("Heatmap")) {
      heatmapScreen = new Screen(color(7,11,18));
      dataMap = countBy(currentFilteredFlights);
      heatmapScreen.heatmap = new HeatMap(dataMap);
      heatmapScreen.addWidget(new Widget(1010, 660, 140, 35, "Back", colourArray[0]));
      currentScreen = heatmapScreen;

    } else if (clicked.label.equalsIgnoreCase("Back")) {
      currentScreen = homescreen;
    }
  }

  if (currentScreen == tableScreen && table1 != null) {
    table1.mousePressed();
  }
}


void keyPressed() {
  if (currentScreen == tableScreen && table1 != null) {
    table1.keyPressed();
  }
}

void mouseMoved() {
  redraw();
}

LinkedHashMap<String, Integer> countBy(ArrayList<Flight> flights) {
  LinkedHashMap<String, Integer> map = new LinkedHashMap<String, Integer>();
  for (Flight f : flights) {
    String key = f.originAirport;
    if (!map.containsKey(key)) {
      map.put(key, 1);
    } else {
      map.put(key, map.get(key) + 1);
    }
  }
  return map;
}

void setupModeSelectScreen() {
  modeSelectScreen = new Screen(color(7, 11, 18));
  
  int cols = 4;
  int backH = 80;
  int cardH = height - backH; 
  
  float cardW = width / cols;  
  
  modeSelectScreen.addWidget(new Widget(0, 0, (int)cardW, cardH, "Graph", color(30, 40, 60)));
  modeSelectScreen.addWidget(new Widget((int)cardW, 0, (int)cardW, cardH, "Table", color(30, 40, 60)));
  modeSelectScreen.addWidget(new Widget((int)cardW * 2, 0, (int)cardW, cardH, "Heatmap", color(30, 40, 60)));
  modeSelectScreen.addWidget(new Widget((int)cardW * 3, 0, (int)cardW, cardH, "Pie Chart", color(30, 40, 60)));
  
  modeSelectScreen.addWidget(new Widget(0, height - backH, width, backH, "Back", color(80, 120, 180)));
}

class SmoothScrollTable {
  ArrayList<Flight> allFlights;
  int totalFlightsCount = 0;
  float yOffset = 0;
  float scrollSpeed = 0.4;
  int visibleRows = 8;
  int rowHeight = 38;
  
  SmoothScrollTable() {
    allFlights = new ArrayList<Flight>();
    loadDataFromCSV();
  }
  
  void loadDataFromCSV() {
    ArrayList<Flight> fullData = r.readIn(1, 0, "n/a");
    totalFlightsCount = fullData.size();
    println("Total flights in CSV: " + totalFlightsCount);
    
    allFlights = r.readIn(1, 200, "n/a");
    println("Loaded " + allFlights.size() + " flights for scrolling");
  }
  
  int getTotalCount() {
    return totalFlightsCount;
  }
  
  void update() {
    yOffset -= scrollSpeed;
    
    if (yOffset <= -rowHeight) {
      yOffset += rowHeight;
      Flight first = allFlights.get(0);
      allFlights.remove(0);
      allFlights.add(first);
    }
  }
  
  void draw(float bx, float by, float boardH) {
    for (int i = -1; i < visibleRows + 1; i++) {
      if (i >= 0 && i < allFlights.size()) {
        Flight f = allFlights.get(i);
        float rowY = by + 70 + i * rowHeight + yOffset;
        
        if (rowY > by + 54 && rowY < by + boardH - 10) {
          float alpha = 255;
          float fadeStart = 30;
          
          float distToTop = rowY - (by + 60);
          if (distToTop < fadeStart) {
            alpha = (distToTop / fadeStart) * 255;
            alpha = constrain(alpha, 0, 255);
          }
          
          float distToBottom = (by + boardH - 10) - rowY;
          if (distToBottom < fadeStart) {
            float bottomAlpha = (distToBottom / fadeStart) * 255;
            alpha = min(alpha, bottomAlpha);
            alpha = constrain(alpha, 0, 255);
          }
          
          drawFlightRow(f, bx, rowY, alpha);
        }
      }
    }
  }
  
  void drawFlightRow(Flight f, float bx, float rowY, float alpha) {
    float xFlight = bx + 30;
    float xRoute  = bx + 180;
    float xTime   = bx + 380;
    float xMiles  = bx + 520;
    float xStatus = bx + 650;
    float xCities = bx + 800;
    
    textAlign(LEFT, CENTER);
    textFont(flipFont);
    textSize(16);
    
    fill(255, alpha); 
    text(f.IATACode + f.flightNumber, xFlight, rowY);
    
    fill(255, alpha); 
    text(f.originAirport + " → " + f.destinationAirport, xRoute, rowY);
    
    fill(255, alpha); 
    String formattedTime = formatTime(f.scheduledDepartureTime);
    text(formattedTime, xTime, rowY);
    
    fill(255, alpha); 
    text(f.distanceBetweenAirports + " mi", xMiles, rowY);
    
    String status = getFlightStatus(f);
    text(status, xStatus, rowY);
    
    fill(255, alpha);  
    textSize(16);
    String cities = f.originCity + " → " + f.destinationCity;
    if (cities.length() > 38) cities = cities.substring(0, 35) + "...";
    text(cities, xCities, rowY);
  }
  
  String formatTime(String time) {
    if (time == null || time.length() == 0) return "--:--";
    time = time.trim();
    
    if (time.length() == 4) {
      return time.substring(0, 2) + ":" + time.substring(2, 4);
    }
    if (time.length() == 3) {
      return "0" + time.substring(0, 1) + ":" + time.substring(1, 3);
    }
    if (time.length() == 2) {
      return "0" + time + ":00";
    }
    if (time.contains(":")) {
      return time;
    }
    return time;
  }
  
  String getFlightStatus(Flight f) {
  if (f.cancelled) return "CANCELLED";
  if (f.diverted) return "DIVERTED";
  
  try {
    int sched = Integer.parseInt(f.scheduledDepartureTime.trim());
    int actual = Integer.parseInt(f.actualDepartureTime.trim());
    if (actual > sched) return "DELAYED";
    if (actual < sched && actual > 0) return "EARLY";
  } catch (Exception e) {}
  
  return "ON TIME";
}
}

void mouseWheel(processing.event.MouseEvent event) {
  float e = event.getCount();

  if (currentScreen == graphScreen && graphScreen.graph != null) {
    graphScreen.graph.scroll(e * 20);
  }
}
