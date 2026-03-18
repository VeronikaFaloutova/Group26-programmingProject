import java.util.ArrayList;

ArrayList<Flight> allFlights;
ArrayList<Flight> searchResults;

TextTable table;

String originInput = "";
String destInput = "";

boolean typingOrigin = true;
boolean typingDest = false;

int currentPage = 0;
int rowsPerPage = 8;

float margin = 20;
float topTitleY = 50;
float inputY = 100;
float infoY1 = 170;
float infoY2 = 200;
float infoY3 = 230;

float originBoxX, originBoxY, originBoxW, originBoxH;
float destBoxX, destBoxY, destBoxW, destBoxH;
float searchBtnX, searchBtnY, searchBtnW, searchBtnH;
float clearBtnX, clearBtnY, clearBtnW, clearBtnH;

float prevBtnX, prevBtnY, prevBtnW, prevBtnH;
float nextBtnX, nextBtnY, nextBtnW, nextBtnH;

void setup() {
  size(1280, 780);
  surface.setResizable(true);
  textFont(createFont("Arial", 16));

  allFlights = new ArrayList<Flight>();
  searchResults = new ArrayList<Flight>();

  loadFlightsFromCSV();
  updateLayout();
}

void draw() {
  background(240);

  updateLayout();

  drawTitle();
  drawInputBoxes();
  drawInstructions();

  if (table != null) {
    table.display(currentPage, rowsPerPage);
  }

  drawPageButtons();
}

void updateLayout() {
  originBoxX = 100;
  originBoxY = 80;
  originBoxW = 200;
  originBoxH = 45;

  destBoxX = 410;
  destBoxY = 80;
  destBoxW = 200;
  destBoxH = 45;

  searchBtnX = 650;
  searchBtnY = 80;
  searchBtnW = 120;
  searchBtnH = 45;

  clearBtnX = 790;
  clearBtnY = 80;
  clearBtnW = 120;
  clearBtnH = 45;

  float tableX = 20;
  float tableY = 270;
  float tableW = width - 40;
  float tableH = height - 270 - 130;

  table = new TextTable(int(tableX), int(tableY), int(tableW), int(tableH), searchResults);

  prevBtnW = 130;
  prevBtnH = 42;
  nextBtnW = 130;
  nextBtnH = 42;

  prevBtnY = height - 55;
  nextBtnY = height - 55;

  prevBtnX = width / 2.0 - 150;
  nextBtnX = width / 2.0 + 20;
}

void drawTitle() {
  fill(20);
  textSize(28);
  text("Flight Search Engine", margin, topTitleY);
}

void drawInputBoxes() {
  textSize(18);

  fill(20);
  text("Origin:", margin, inputY + 10);

  if (typingOrigin) {
    stroke(0, 100, 255);
    strokeWeight(3);
  } else {
    stroke(80);
    strokeWeight(1);
  }
  fill(255);
  rect(originBoxX, originBoxY, originBoxW, originBoxH);
  fill(0);
  text(originInput, originBoxX + 12, originBoxY + 29);

  fill(20);
  text("Destination:", 315, inputY + 10);

  if (typingDest) {
    stroke(0, 100, 255);
    strokeWeight(3);
  } else {
    stroke(80);
    strokeWeight(1);
  }
  fill(255);
  rect(destBoxX, destBoxY, destBoxW, destBoxH);
  fill(0);
  text(destInput, destBoxX + 12, destBoxY + 29);

  stroke(80);
  strokeWeight(1);

  fill(100, 170, 235);
  rect(searchBtnX, searchBtnY, searchBtnW, searchBtnH);
  fill(255);
  text("Search", searchBtnX + 28, searchBtnY + 29);

  fill(185, 85, 85);
  rect(clearBtnX, clearBtnY, clearBtnW, clearBtnH);
  fill(255);
  text("Clear", clearBtnX + 35, clearBtnY + 29);
}

void drawInstructions() {
  fill(60);
  textSize(15);
  text("Type airport codes like JFK, LAX, ORD, STL, CLT", margin, infoY1);
  text("Loaded flights: " + allFlights.size(), margin, infoY2);
  text("You can search by origin only, destination only, or both.", margin, infoY3);

  if (searchResults.size() > 0) {
    int startIndex = currentPage * rowsPerPage + 1;
    int endIndex = min((currentPage + 1) * rowsPerPage, searchResults.size());
    text("Showing " + startIndex + " - " + endIndex + " of " + searchResults.size() + " flights", width - 360, infoY2);
  } else {
    text("Showing 0 flights", width - 180, infoY2);
  }
}

void drawPageButtons() {
  prevBtnW = 130;
  prevBtnH = 42;
  nextBtnW = 130;
  nextBtnH = 42;

  prevBtnY = height - 60;
  nextBtnY = height - 60;

  prevBtnX = width / 2.0 - 170;
  nextBtnX = width / 2.0 - 10;

  fill(120, 180, 255);
  rect(prevBtnX, prevBtnY, prevBtnW, prevBtnH);
  fill(255);
  textSize(18);
  text("Previous", prevBtnX + 22, prevBtnY + 27);

  fill(120, 180, 255);
  rect(nextBtnX, nextBtnY, nextBtnW, nextBtnH);
  fill(255);
  text("Next", nextBtnX + 42, nextBtnY + 27);

  fill(0);
  int totalPages = 1;
  if (searchResults.size() > 0) {
    totalPages = (searchResults.size() - 1) / rowsPerPage + 1;
  }

  textSize(18);
  text("Page: " + (currentPage + 1) + " / " + totalPages, nextBtnX + 170, nextBtnY + 27);
}

void mousePressed() {
  if (mouseX >= originBoxX && mouseX <= originBoxX + originBoxW &&
      mouseY >= originBoxY && mouseY <= originBoxY + originBoxH) {
    typingOrigin = true;
    typingDest = false;
  }
  else if (mouseX >= destBoxX && mouseX <= destBoxX + destBoxW &&
           mouseY >= destBoxY && mouseY <= destBoxY + destBoxH) {
    typingOrigin = false;
    typingDest = true;
  }
  else if (mouseX >= searchBtnX && mouseX <= searchBtnX + searchBtnW &&
           mouseY >= searchBtnY && mouseY <= searchBtnY + searchBtnH) {
    searchFlights();
  }
  else if (mouseX >= clearBtnX && mouseX <= clearBtnX + clearBtnW &&
           mouseY >= clearBtnY && mouseY <= clearBtnY + clearBtnH) {
    originInput = "";
    destInput = "";
    currentPage = 0;
    searchResults.clear();
  }
  else if (mouseX >= prevBtnX && mouseX <= prevBtnX + prevBtnW &&
           mouseY >= prevBtnY && mouseY <= prevBtnY + prevBtnH) {
    if (currentPage > 0) {
      currentPage--;
    }
  }
  else if (mouseX >= nextBtnX && mouseX <= nextBtnX + nextBtnW &&
           mouseY >= nextBtnY && mouseY <= nextBtnY + nextBtnH) {
    int lastPage = 0;
    if (searchResults.size() > 0) {
      lastPage = (searchResults.size() - 1) / rowsPerPage;
    }
    if (currentPage < lastPage) {
      currentPage++;
    }
  }
}

void keyPressed() {
  if (typingOrigin) {
    if (key == BACKSPACE) {
      if (originInput.length() > 0) {
        originInput = originInput.substring(0, originInput.length() - 1);
      }
    } else if (key != CODED && key != ENTER && key != RETURN && key != TAB) {
      originInput += key;
    }
  }
  else if (typingDest) {
    if (key == BACKSPACE) {
      if (destInput.length() > 0) {
        destInput = destInput.substring(0, destInput.length() - 1);
      }
    } else if (key != CODED && key != ENTER && key != RETURN && key != TAB) {
      destInput += key;
    }
  }
}

void searchFlights() {
  currentPage = 0;
  searchResults.clear();

  String originSearch = originInput.trim().toLowerCase();
  String destSearch = destInput.trim().toLowerCase();

  for (int i = 0; i < allFlights.size(); i++) {
    Flight f = allFlights.get(i);

    boolean originMatch = originSearch.equals("") || f.origin.toLowerCase().contains(originSearch);
    boolean destMatch = destSearch.equals("") || f.dest.toLowerCase().contains(destSearch);

    if (originMatch && destMatch) {
      searchResults.add(f);
    }
  }
}

void loadFlightsFromCSV() {
  println("Trying to load flights.csv...");
  println(dataPath("flights.csv"));

  Table tableData = loadTable("flights.csv", "header");

  if (tableData == null) {
    println("File not found!");
    return;
  }

  for (TableRow row : tableData.rows()) {
    String flDate = row.getString("FL_DATE");
    String carrier = row.getString("MKT_CARRIER");
    String flightNum = str(row.getInt("MKT_CARRIER_FL_NUM"));
    String origin = row.getString("ORIGIN");
    String originCity = row.getString("ORIGIN_CITY_NAME");
    String dest = row.getString("DEST");
    String destCity = row.getString("DEST_CITY_NAME");

    int crsDepTime = row.getInt("CRS_DEP_TIME");
    float depTime = row.getFloat("DEP_TIME");
    int crsArrTime = row.getInt("CRS_ARR_TIME");
    float arrTime = row.getFloat("ARR_TIME");

    float cancelled = row.getFloat("CANCELLED");
    float diverted = row.getFloat("DIVERTED");
    float distance = row.getFloat("DISTANCE");

    Flight f = new Flight(
      flDate, carrier, flightNum,
      origin, originCity,
      dest, destCity,
      crsDepTime, depTime,
      crsArrTime, arrTime,
      cancelled, diverted, distance
    );

    allFlights.add(f);
  }

  println("Loaded flights: " + allFlights.size());
}
