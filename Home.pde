PFont titleFont;
PFont subFont;
PFont labelFont;
PFont flipFont;
PFont smallFont;
PFont bodyFont;

int flightLen = 4;
int routeLen  = 3;
int timeLen   = 5;
int statusLen = 12;         

final int HOME       = 0;
final int SEARCH     = 1;
final int ROUTE_MAP  = 2;
final int STATISTICS = 3;
final int UNFILTERED = 4;

int page = HOME;

int rows = 6;
String charset = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789:-";

String[] flightPool = {"AA20", "DL44", "UA11", "WN55", "B674", "AS32", "NK78", "F921", "QF12", "BA98", "LH430", "AF76"};
String[] routePool  = {"LAX", "ORD", "SEA", "DEN", "MCO", "PHX", "ATL", "BOS", "JFK", "DFW", "LAS", "SFO"};
String[] timePool   = {"08:30", "09:10", "09:45", "10:05", "09:30", "11:15", "12:40", "12:15", "12:30", "12:05"};
String[] statusPool = {"ON TIME", "DELAYED", "BOARDING", "FINAL CALL", "GATE OPEN", "DEPARTED", "CANCELLED"};

String[] rowFlight = new String[rows];
String[] rowRoute  = new String[rows];
String[] rowTime   = new String[rows];
String[] rowStatus = new String[rows];

char[][] flightChars = new char[rows][flightLen];
char[][] routeChars  = new char[rows][routeLen];
char[][] timeChars   = new char[rows][timeLen];
char[][] statusChars = new char[rows][statusLen];

boolean[][] flightDone = new boolean[rows][flightLen];
boolean[][] routeDone  = new boolean[rows][routeLen];
boolean[][] timeDone   = new boolean[rows][timeLen];
boolean[][] statusDone = new boolean[rows][statusLen];

String[] targetFlight = new String[rows];
String[] targetRoute  = new String[rows];
String[] targetTime   = new String[rows];
String[] targetStatus = new String[rows];

int flippingRow = -1;
boolean flipping = false;
int holdFrames = 0;
int holdDuration = 300;
int baseStartFrame = 0;
int delayPerTile = 5;
int flipSpeed = 1;

float scrollX;
String scroll = "WELCOME TO AERO VISION   |   FLIGHT QUERY & VISUALIZATION SYSTEM   |   DESIGN BY CHICKEN DOGS   |   ";

void setup() {
  size(1200, 700);

  titleFont = createFont("Arial Bold", 50);
  subFont   = createFont("Arial Bold", 16);
  labelFont = createFont("Arial Bold", 20);
  flipFont  = createFont("Arial Bold", 22);
  smallFont = createFont("Georgina", 16);
  bodyFont  = createFont("Arial", 20);

  for (int r = 0; r < rows; r++) {
    rowFlight[r] = randomFrom(flightPool);
    rowRoute[r]  = randomFrom(routePool);
    rowTime[r]   = randomFrom(timePool);
    rowStatus[r] = randomFrom(statusPool);

    targetFlight[r] = padToLen(rowFlight[r], flightLen);
    targetRoute[r]  = padToLen(rowRoute[r], routeLen);
    targetTime[r]   = padToLen(rowTime[r], timeLen);
    targetStatus[r] = padToLen(rowStatus[r], statusLen);

    initRow(flightChars[r], flightDone[r], targetFlight[r]);
    initRow(routeChars[r],  routeDone[r],  targetRoute[r]);
    initRow(timeChars[r],   timeDone[r],   targetTime[r]);
    initRow(statusChars[r], statusDone[r], targetStatus[r]);
  }

  holdFrames = holdDuration;
  scrollX = width;
}

void draw() {
  if (page == HOME) {
    drawHome();
    updateBoard();
    updateTicker();
  } 
  else if (page == SEARCH) {
    drawSearchPage();
  } 
  else if (page == ROUTE_MAP) {
    drawRoutePage();
  } 
  else if (page == STATISTICS) {
    drawStatisticsPage();
  } 
  else if (page == UNFILTERED) {
    drawUnfilteredPage();
  }
}

void drawHome() {
  background(7, 11, 18);
  drawBackground();
  drawHeader();
  drawMainBoard();
  drawFeatureCards();
  drawBottomTicker();
}

void drawSearchPage() {
  drawSubPage("YUN-SEARCH", "Search page placeholder", "SEARCH TABLE WILL BE ADDED HERE",
              "This page can later hold a table, filter bar, and search results.");
}

void drawRoutePage() {
  drawSubPage("VERONIKA-ROUTE MAP", "Route map placeholder", "ROUTE NETWORK WILL BE ADDED HERE",
              "This page can later show airport connections, routes, and visual map data.");
}

void drawStatisticsPage() {
  drawSubPage("YIWEI-STATISTICS", "Statistics placeholder", "DATA VISUALIZATION WILL BE ADDED HERE",
              "This page can later hold bar charts, pie charts, and timing summaries.");
}

void drawUnfilteredPage() {
  drawSubPage("ALL-UNFILTERED", "Overview placeholder", "PROJECT OVERVIEW WILL BE ADDED HERE",
              "This page can later hold system notes, project intro, or unfiltered raw output.");
}

void drawSubPage(String title, String subtitle, String boxTitle, String desc) {
  background(10, 14, 22);

  stroke(255, 255, 255, 10);
  for (int x = 0; x < width; x += 40) {
    line(x, 0, x, height);
  }
  for (int y = 0; y < height; y += 40) {
    line(0, y, width, y);
  }

  noStroke();
  fill(235, 240, 245);
  textAlign(LEFT, TOP);
  textFont(titleFont);
  text(title, 60, 50);

  fill(255, 190, 90);
  textFont(subFont);
  text(subtitle, 60, 95);

  stroke(255, 190, 90, 90);
  line(60, 132, width - 60, 132);
  noStroke();

  float boxX = 90;
  float boxY = 180;
  float boxW = width - 180;
  float boxH = 360;

  fill(18, 20, 24, 245);
  rect(boxX, boxY, boxW, boxH, 18);

  fill(255, 205, 110);
  textFont(labelFont);
  textAlign(LEFT, TOP);
  text(boxTitle, boxX + 30, boxY + 30);

  fill(180, 190, 200);
  textFont(bodyFont);
  text(desc, boxX + 30, boxY + 85, boxW - 60, boxH - 120);

  drawBackButton();
}

void drawBackButton() {
  float backX = 60;
  float backY = 620;
  float backW = 140;
  float backH = 42;

  fill(30, 38, 52);
  rect(backX, backY, backW, backH, 10);

  fill(255, 190, 90);
  textAlign(CENTER, CENTER);
  textFont(createFont("Arial Bold", 20));
  text("← BACK", backX + backW/2, backY + backH/2);
}

void mousePressed() {
  if (page == HOME) {
    if (clickSearchButton()) {
      page = SEARCH;
    } 
    else if (clickRouteButton()) {
      page = ROUTE_MAP;
    } 
    else if (clickStatisticsButton()) {
      page = STATISTICS;
    } 
    else if (clickUnfilteredButton()) {
      page = UNFILTERED;
    }
  } 
  else {
    if (clickBackButton()) {
      page = HOME;
    }
  }
}

void drawBackground() {
  noStroke();

  for (int i = 0; i < 180; i++) {
    fill(20, 35, 60, 5);
    rect(0, i * 2, width, 2);
  }

  stroke(255, 255, 255, 10);
  for (int x = 0; x < width; x += 40) {
    line(x, 0, x, height);
  }
  for (int y = 0; y < height; y += 40) {
    line(0, y, width, y);
  }

  noStroke();
  for (int i = 40; i < width; i += 36) {
    fill(255, 180, 90, 110);
    ellipse(i, height - 18, 4, 4);
  }

  noFill();
  stroke(100, 170, 255, 35);
  strokeWeight(2);
  arc(width * 0.72, height * 0.26, 520, 240, PI + 0.25, TWO_PI - 0.25);
  arc(width * 0.77, height * 0.32, 440, 180, PI + 0.35, TWO_PI - 0.35);
  strokeWeight(1);
}

void drawHeader() {
  fill(235, 240, 245);
  textAlign(LEFT, TOP);
  textFont(titleFont);
  text("AERO VISION", 60, 50);

  fill(255, 190, 90);
  textFont(subFont);
  text("Graphs  •  Route Analysis  •  Data Visualization", 60, 92);

  textAlign(RIGHT, TOP);
  fill(220, 225, 230);
  textFont(createFont("Consolas", 20));
  String currentTime = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
  text(currentTime, width - 60, 40);

  textFont(subFont);
  fill(170, 180, 190);
  text("LOCAL TIME  |  SYSTEM ONLINE", width - 60, 88);

  stroke(255, 190, 90, 90);
  line(60, 132, width - 60, 132);
  noStroke();
}
