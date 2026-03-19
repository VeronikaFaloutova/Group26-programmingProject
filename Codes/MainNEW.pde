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

Screen homescreen, graphScreen, currentScreen;
Screen modeSelectScreen, tableScreen, heatmapScreen, piechartScreen;
ArrayList<Flight> currentFilteredFlights;
String currentTitle = "";
TextTable table1;
funLines funlines;
Reader r = new Reader();

LinkedHashMap<String, Integer> dataMap;

int flightLen = 4;
int routeLen  = 3;
int timeLen   = 5;
int statusLen = 12;

int rows = 6;
String charset = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789:-";

String[] flightPool = {"AA20", "DL44", "UA11", "WN55", "B674", "AS32", "NK78", "F921", "QF12", "BA98", "LH43", "AF76"};
String[] routePool  = {"LAX", "ORD", "SEA", "DEN", "MCO", "PHX", "ATL", "BOS", "JFK", "DFW", "LAS", "SFO"};
String[] timePool   = {"08:30", "09:10", "09:45", "10:05", "09:30", "11:15", "12:40", "12:15", "12:30", "12:05"};
String[] statusPool = {"ON TIME", "DELAYED", "BOARDING", "CANCELLED"};

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
String scroll = "WELCOME TO AERO VISION   |   FLIGHT QUERY & VISUALIZATION SYSTEM   |   DESIGNED FOR PROJECT PROGRAMMING 2025/2026   |   ";

void setup() {
  size(1200, 700);

  funlines = new funLines();

  welcomeFont = createFont("Arial", 50);
  titleFont = createFont("Arial Bold", 50);
  subFont   = createFont("Arial Bold", 16);
  labelFont = createFont("Arial Bold", 20);
  flipFont  = createFont("Arial Bold", 22);
  smallFont = createFont("Arial", 16);
  bodyFont  = createFont("Arial", 20);

  textFont(welcomeFont);

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

  homescreen = new Screen(color(7, 11, 18));

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
    updateBoard();
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
      currentTitle = "Cancelled Flights";
      setupModeSelectScreen();
      currentScreen = modeSelectScreen;

    } else if (clicked.label.equalsIgnoreCase("Unfiltered")) {
      currentFilteredFlights = new Reader().readIn(1, 0, "n/a");
      currentTitle = "All Flights";
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
      currentTitle = "Delayed Flights";
      setupModeSelectScreen();
      currentScreen = modeSelectScreen;

    } else if (clicked.label.equalsIgnoreCase("Diverted")) {
      currentFilteredFlights = new Reader().readIn(1, 0, "diverted, 1");
      currentTitle = "Diverted Flights";
      setupModeSelectScreen();
      currentScreen = modeSelectScreen;

    } else if (clicked.label.equalsIgnoreCase("Graph")) {
      dataMap = countBy(currentFilteredFlights);
      graphScreen = new Screen(color(7,11,18));
      graphScreen.graph = new Graph(dataMap);
      graphScreen.graph.setTitle(currentTitle + " by Origin State");
      graphScreen.addWidget(new Widget(1000, 620, 140, 42, "Back", colourArray[0]));
      currentScreen = graphScreen;

    } else if (clicked.label.equalsIgnoreCase("Table")) {
      tableScreen = new Screen(color(7,11,18));
      tableScreen.addWidget(new Widget(1000, 620, 140, 42, "Back", colourArray[0]));
      table1 = new TextTable(10, currentFilteredFlights, 130, 250, 25, 130);
      currentScreen = tableScreen;

    } else if (clicked.label.equalsIgnoreCase("Pie Chart")) {
      dataMap = countBy(currentFilteredFlights);
      piechartScreen = new Screen(color(7,11,18));
      piechartScreen.addWidget(new Widget(1000, 620, 140, 42, "Back", colourArray[0]));
      piechartScreen.chart = new PieChart(dataMap);
      currentScreen = piechartScreen;

    } else if (clicked.label.equalsIgnoreCase("Heatmap")) {
      heatmapScreen = new Screen(color(7,11,18));
      dataMap = countBy(currentFilteredFlights);
      heatmapScreen.heatmap = new HeatMap(dataMap);
      heatmapScreen.addWidget(new Widget(1000, 620, 140, 42, "Back", colourArray[0]));
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
    String key = f.originState;
    if (!map.containsKey(key)) {
      map.put(key, 1);
    } else {
      map.put(key, map.get(key) + 1);
    }
  }
  return map;
}

void setupModeSelectScreen() {
  modeSelectScreen = new Screen(color(7,11,18));

  modeSelectScreen.addWidget(new Widget(180, 260, 180, 70, "Graph", colourArray[1]));
  modeSelectScreen.addWidget(new Widget(390, 260, 180, 70, "Table", colourArray[2]));
  modeSelectScreen.addWidget(new Widget(600, 260, 180, 70, "Heatmap", colourArray[0]));
  modeSelectScreen.addWidget(new Widget(810, 260, 180, 70, "Pie Chart", colourArray[3]));
  modeSelectScreen.addWidget(new Widget(1000, 620, 140, 42, "Back", colourArray[4]));
}

void updateBoard() {
  if (!flipping) {
    holdFrames--;
    if (holdFrames <= 0) {
      startRandomRowFlip();
    }
    return;
  }

  boolean allDone = true;
  int offset = 0;

  allDone &= updateField(flightChars[flippingRow], flightDone[flippingRow], targetFlight[flippingRow], offset);
  offset += flightLen;

  allDone &= updateField(routeChars[flippingRow], routeDone[flippingRow], targetRoute[flippingRow], offset);
  offset += routeLen;

  allDone &= updateField(timeChars[flippingRow], timeDone[flippingRow], targetTime[flippingRow], offset);
  offset += timeLen;

  allDone &= updateField(statusChars[flippingRow], statusDone[flippingRow], targetStatus[flippingRow], offset);

  if (allDone) {
    flipping = false;
    flippingRow = -1;
    holdFrames = holdDuration;
  }
}

boolean updateField(char[] arr, boolean[] done, String target, int globalOffset) {
  boolean fieldDone = true;

  for (int i = 0; i < arr.length; i++) {
    int tileStart = baseStartFrame + (globalOffset + i) * delayPerTile;

    if (frameCount < tileStart) {
      fieldDone = false;
      continue;
    }

    char targetChar = target.charAt(i);

    if (arr[i] != targetChar) {
      fieldDone = false;
      done[i] = false;

      for (int s = 0; s < flipSpeed; s++) {
        arr[i] = nextChar(arr[i]);
        if (arr[i] == targetChar) {
          done[i] = true;
          break;
        }
      }
    } else {
      done[i] = true;
    }
  }

  return fieldDone;
}

void startRandomRowFlip() {
  flippingRow = int(random(rows));

  rowFlight[flippingRow] = randomFrom(flightPool);
  rowRoute[flippingRow]  = randomFrom(routePool);
  rowTime[flippingRow]   = randomFrom(timePool);
  rowStatus[flippingRow] = randomFrom(statusPool);

  targetFlight[flippingRow] = padToLen(rowFlight[flippingRow], flightLen);
  targetRoute[flippingRow]  = padToLen(rowRoute[flippingRow], routeLen);
  targetTime[flippingRow]   = padToLen(rowTime[flippingRow], timeLen);
  targetStatus[flippingRow] = padToLen(rowStatus[flippingRow], statusLen);

  markAllUnsettled(flightDone[flippingRow]);
  markAllUnsettled(routeDone[flippingRow]);
  markAllUnsettled(timeDone[flippingRow]);
  markAllUnsettled(statusDone[flippingRow]);

  flipping = true;
  baseStartFrame = frameCount;
}

void markAllUnsettled(boolean[] arr) {
  for (int i = 0; i < arr.length; i++) {
    arr[i] = false;
  }
}

void initRow(char[] arr, boolean[] done, String target) {
  for (int i = 0; i < arr.length; i++) {
    arr[i] = target.charAt(i);
    done[i] = true;
  }
}

String padToLen(String s, int len) {
  if (s.length() > len) return s.substring(0, len);
  while (s.length() < len) s += " ";
  return s;
}

char nextChar(char c) {
  int idx = charset.indexOf(c);
  if (idx < 0) idx = 0;
  idx++;
  if (idx >= charset.length()) idx = 0;
  return charset.charAt(idx);
}

String randomFrom(String[] arr) {
  return arr[int(random(arr.length))];
}

String charsToString(char[] arr) {
  String s = "";
  for (int i = 0; i < arr.length; i++) {
    s += arr[i];
  }
  return trim(s);
}

boolean allDone(boolean[] arr) {
  for (int i = 0; i < arr.length; i++) {
    if (!arr[i]) return false;
  }
  return true;
}

int currentStatusColor(boolean[] doneArr, char[] chars) {
  if (!allDone(doneArr)) {
    return color(248, 208, 118);
  }
  return getStatusColor(charsToString(chars));
}

int getStatusColor(String status) {
  String s = trim(status);

  if (s.equals("DELAYED")) {
    return color(204, 187, 68);
  } else if (s.equals("BOARDING")) {
    return color(102, 204, 238);
  } else if (s.equals("CANCELLED")) {
    return color(238, 102, 119);
  } else {
    return color(255);
  }
}

void mouseWheel(processing.event.MouseEvent event) {
  float e = event.getCount();

  if (currentScreen == graphScreen && graphScreen.graph != null) {
    graphScreen.graph.scroll(e * 20);
  }
}
