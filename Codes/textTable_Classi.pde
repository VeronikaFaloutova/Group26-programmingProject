import java.util.ArrayList; //<>//

class TextTable {
  int xPos;
  int yPos;
  int tableWidth;
  int tableHeight;

  ArrayList<Flight> originalData;   
  ArrayList<Flight> flightData;    

  int rowHeight = 40;
  int headerHeight = 42;

  int currentPage = 0;
  int rowsPerPage;

  String originInput = "";
  String destInput = "";

  boolean typingOrigin = false;
  boolean typingDest = false;

  float originBoxX, originBoxY, originBoxW, originBoxH;
  float destBoxX, destBoxY, destBoxW, destBoxH;
  float searchBtnX, searchBtnY, searchBtnW, searchBtnH;
  float clearBtnX, clearBtnY, clearBtnW, clearBtnH;

  float prevBtnX, prevBtnY, prevBtnW, prevBtnH;
  float nextBtnX, nextBtnY, nextBtnW, nextBtnH;

  TextTable(int xPos, int yPos, int tableWidth, int tableHeight, ArrayList<Flight> inputData) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.tableWidth = tableWidth;
    this.tableHeight = tableHeight;

    this.originalData = new ArrayList<Flight>();
    this.flightData = new ArrayList<Flight>();

    for (Flight f : inputData) {
      originalData.add(f);
      flightData.add(f);
    }

    rowsPerPage = max(1, (tableHeight - 120) / rowHeight);
    updateLayout();
  }

  void updateLayout() {
    originBoxX = xPos + 10;
    originBoxY = yPos - 55;
    originBoxW = 120;
    originBoxH = 28;

    destBoxX = xPos + 160;
    destBoxY = yPos - 55;
    destBoxW = 120;
    destBoxH = 28;

    searchBtnX = xPos + 310;
    searchBtnY = yPos - 55;
    searchBtnW = 75;
    searchBtnH = 28;

    clearBtnX = xPos + 400;
    clearBtnY = yPos - 55;
    clearBtnW = 75;
    clearBtnH = 28;

    prevBtnW = 100;
    prevBtnH = 30;
    nextBtnW = 100;
    nextBtnH = 30;

    prevBtnX = xPos + tableWidth / 2 - 120;
    nextBtnX = xPos + tableWidth / 2 + 20;
    prevBtnY = yPos + tableHeight + 15;
    nextBtnY = yPos + tableHeight + 15;
  }

  void draw() {
    updateLayout();

    drawSearchUI();
    drawHeader();
    drawRows();
    drawPageButtons();
    drawPageInfo();
  }

  void drawSearchUI() {
    textAlign(LEFT, CENTER);

    fill(255);
    stroke(typingOrigin ? color(0, 120, 255) : color(120));
    strokeWeight(typingOrigin ? 2 : 1);
    rect(originBoxX, originBoxY, originBoxW, originBoxH, 6);
    fill(0);
    text(originInput, originBoxX + 8, originBoxY + originBoxH / 2);

    fill(220);
    noStroke();
    textSize(16);  
    text("Origin", originBoxX, originBoxY - 10);

    fill(255);
    stroke(typingDest ? color(0, 120, 255) : color(120));
    strokeWeight(typingDest ? 2 : 1);
    rect(destBoxX, destBoxY, destBoxW, destBoxH, 6);
    fill(0);
    text(destInput, destBoxX + 8, destBoxY + destBoxH / 2);

    fill(220);
    noStroke();
    text("Destination", destBoxX, destBoxY - 10);

    stroke(0);
    strokeWeight(1);

    fill(80, 120, 170);
    rect(searchBtnX, searchBtnY, searchBtnW, searchBtnH, 6);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Search", searchBtnX + searchBtnW / 2, searchBtnY + searchBtnH / 2);

    fill(140, 80, 80);
    rect(clearBtnX, clearBtnY, clearBtnW, clearBtnH, 6);
    fill(255);
    text("Clear", clearBtnX + clearBtnW / 2, clearBtnY + clearBtnH / 2);
  }

  void drawHeader() {
    fill(70, 95, 140);
    stroke(0);
    rect(xPos, yPos, tableWidth, headerHeight);

    fill(0);
    textAlign(LEFT, CENTER);
    textFont(subFont);
    textSize(16);

    text("Date",      xPos + 8,   yPos + headerHeight / 2);
    text("Flight",    xPos + 140, yPos + headerHeight / 2);
    text("From",      xPos + 200, yPos + headerHeight / 2);
    text("To",        xPos + 340, yPos + headerHeight / 2);
    text("Plan Dep",  xPos + 500, yPos + headerHeight / 2);
    text("Real Dep",  xPos + 590, yPos + headerHeight / 2);
    text("Plan Arr",  xPos + 680, yPos + headerHeight / 2);
    text("Real Arr",  xPos + 770, yPos + headerHeight / 2);
    text("Miles",     xPos + 860, yPos + headerHeight / 2);
    text("Status",    xPos + 930, yPos + headerHeight / 2);
  }

  void drawRows() {
    int startIndex = currentPage * rowsPerPage;
    int endIndex = min(startIndex + rowsPerPage, flightData.size());

    for (int i = startIndex; i < endIndex; i++) {
      int rowIndex = i - startIndex;
      int rowY = yPos + headerHeight + rowIndex * rowHeight;

      if (i % 2 == 0) {
          fill(235);
      } else {
          fill(245);
      }
      stroke(0);
      rect(xPos, rowY, tableWidth, rowHeight);

      Flight f = flightData.get(i);

      fill(0);
      textAlign(LEFT, CENTER);
      textSize(14);

      text(f.flightDate, xPos + 8, rowY + rowHeight / 2);
      text(f.IATACode + f.flightNumber, xPos + 140, rowY + rowHeight / 2);
      text(shortCityState(f.originCity, f.originState), xPos + 200, rowY + rowHeight / 2);
      text(shortCityState(f.destinationCity, f.destinationState), xPos + 340, rowY + rowHeight / 2);
      text(formatTime(f.scheduledDepartureTime), xPos + 500, rowY + rowHeight / 2);
      text(formatTime(f.actualDepartureTime), xPos + 590, rowY + rowHeight / 2);
      text(formatTime(f.scheduledArrivalTime), xPos + 680, rowY + rowHeight / 2);
      text(formatTime(f.actualArrivalTime), xPos + 770, rowY + rowHeight / 2);
      text(str(f.distanceBetweenAirports), xPos + 860, rowY + rowHeight / 2);
      text(getStatus(f), xPos + 930, rowY + rowHeight / 2);
    }

    if (flightData.size() == 0) {
      fill(255);
      stroke(0);
      rect(xPos, yPos + headerHeight, tableWidth, rowHeight);

      fill(80);
      textSize(16);
      textAlign(LEFT, CENTER);
      text("No matching flights found.", xPos + 15, yPos + headerHeight + rowHeight / 2);
    }
  }

  void drawPageButtons() {
    fill(90, 120, 170);
    rect(prevBtnX, prevBtnY, prevBtnW, prevBtnH, 6);
    rect(nextBtnX, nextBtnY, nextBtnW, nextBtnH, 6);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(15);
    text("Previous", prevBtnX + prevBtnW / 2, prevBtnY + prevBtnH / 2);
    text("Next", nextBtnX + nextBtnW / 2, nextBtnY + nextBtnH / 2);
  }

  void drawPageInfo() {
    int totalPages = max(1, (int)ceil(flightData.size() / float(rowsPerPage)));
    fill(255);
    textAlign(LEFT, CENTER);
    textSize(15);
    text("Page: " + (currentPage + 1) + " / " + totalPages, nextBtnX + 130, nextBtnY + prevBtnH / 2);

    if (flightData.size() > 0) {
      int startIndex = currentPage * rowsPerPage + 1;
      int endIndex = min((currentPage + 1) * rowsPerPage, flightData.size());
      text("Showing " + startIndex + " - " + endIndex + " of " + flightData.size(), xPos, prevBtnY + prevBtnH / 2);
    } else {
      text("Showing 0 flights", xPos, prevBtnY + prevBtnH / 2);
    }
  }

  void mousePressed() {
    if (mouseX >= originBoxX && mouseX <= originBoxX + originBoxW &&
        mouseY >= originBoxY && mouseY <= originBoxY + originBoxH) {
      typingOrigin = true;
      typingDest = false;
      return;
    }

    if (mouseX >= destBoxX && mouseX <= destBoxX + destBoxW &&
        mouseY >= destBoxY && mouseY <= destBoxY + destBoxH) {
      typingOrigin = false;
      typingDest = true;
      return;
    }

    if (mouseX >= searchBtnX && mouseX <= searchBtnX + searchBtnW &&
        mouseY >= searchBtnY && mouseY <= searchBtnY + searchBtnH) {
      searchFlights();
      return;
    }

    if (mouseX >= clearBtnX && mouseX <= clearBtnX + clearBtnW &&
        mouseY >= clearBtnY && mouseY <= clearBtnY + clearBtnH) {
      originInput = "";
      destInput = "";
      typingOrigin = false;
      typingDest = false;
      currentPage = 0;
      flightData.clear();
      for (Flight f : originalData) {
        flightData.add(f);
      }
      return;
    }

    if (mouseX >= prevBtnX && mouseX <= prevBtnX + prevBtnW &&
        mouseY >= prevBtnY && mouseY <= prevBtnY + prevBtnH) {
      if (currentPage > 0) currentPage--;
      return;
    }

    if (mouseX >= nextBtnX && mouseX <= nextBtnX + nextBtnW &&
        mouseY >= nextBtnY && mouseY <= nextBtnY + nextBtnH) {
      int lastPage = max(0, (flightData.size() - 1) / rowsPerPage);
      if (currentPage < lastPage) currentPage++;
      return;
    }

    typingOrigin = false;
    typingDest = false;
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
    } else if (typingDest) {
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
    flightData.clear();

    String originSearch = originInput.trim().toLowerCase();
    String destSearch = destInput.trim().toLowerCase();

    for (Flight f : originalData) {
      boolean originMatch =
        originSearch.equals("") ||
        f.originAirport.toLowerCase().contains(originSearch) ||
        f.originCity.toLowerCase().contains(originSearch) ||
        f.originState.toLowerCase().contains(originSearch);

      boolean destMatch =
        destSearch.equals("") ||
        f.destinationAirport.toLowerCase().contains(destSearch) ||
        f.destinationCity.toLowerCase().contains(destSearch) ||
        f.destinationState.toLowerCase().contains(destSearch);

      if (originMatch && destMatch) {
        flightData.add(f);
      }
    }
  }

  String formatTime(String t) {
    if (t == null) return "--:--";
    t = trim(t);
    if (t.equals("")) return "--:--";

    try {
      int time = Integer.parseInt(t);
      String s = nf(time, 4);
      return s.substring(0, 2) + ":" + s.substring(2, 4);
    } catch (Exception e) {
      return t;
    }
  }

  String getStatus(Flight f) {
    if (f.cancelled) return "Cancelled";
    if (f.diverted) return "Diverted";

    try {
      int sched = Integer.parseInt(trim(f.scheduledDepartureTime));
      int actual = Integer.parseInt(trim(f.actualDepartureTime));
      if (actual > sched) return "Delayed";
      if (actual == sched) return "On Time";
      if (actual < sched) return "Early";
    } catch (Exception e) {
    }

    return "Unknown";
  }

  String shortCityState(String city, String state) {
    String s = city + ", " + state;
    if (s.length() > 22) {
      return s.substring(0, 21) + "...";
    }
    return s;
  }
}
