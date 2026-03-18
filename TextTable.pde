import java.util.ArrayList;

class TextTable {
  int xPos;
  int yPos;
  int tableWidth;
  int tableHeight;

  ArrayList<Flight> flightData;

  int rowHeight = 38;
  int headerHeight = 42;

  TextTable(int xPos, int yPos, int tableWidth, int tableHeight, ArrayList<Flight> flightData) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.tableWidth = tableWidth;
    this.tableHeight = tableHeight;
    this.flightData = flightData;
  }

  void display(int currentPage, int rowsPerPage) {
    drawHeader();

    int startIndex = currentPage * rowsPerPage;
    int endIndex = min(startIndex + rowsPerPage, flightData.size());

    int rowIndex = 0;

    for (int i = startIndex; i < endIndex; i++) {
      int rowY = yPos + headerHeight + rowIndex * rowHeight;

      fill(255);
      stroke(0);
      rect(xPos, rowY, tableWidth, rowHeight);

      Flight f = flightData.get(i);

      fill(0);
      textSize(12);

      text(f.flDate, xPos + 10, rowY + 24);
      text(f.getFlightCode(), xPos + 165, rowY + 24);
      text(f.origin, xPos + 260, rowY + 24);
      text(f.dest, xPos + 360, rowY + 24);
      text(f.formatTime(f.crsDepTime), xPos + 450, rowY + 24);
      text(f.formatTime(f.depTime), xPos + 560, rowY + 24);
      text(f.formatTime(f.crsArrTime), xPos + 670, rowY + 24);
      text(f.formatTime(f.arrTime), xPos + 780, rowY + 24);
      text(str(int(f.distance)), xPos + 890, rowY + 24);
      text(f.getStatus(), xPos + 1010, rowY + 24);
      text(f.getShortCities(), xPos + 1110, rowY + 24);

      rowIndex++;
    }

    if (flightData.size() == 0) {
      fill(80);
      textSize(18);
      text("No matching flights found.", xPos + 20, yPos + headerHeight + 35);
    }
  }

  void drawHeader() {
    fill(126, 162, 255);
    stroke(0);
    rect(xPos, yPos, tableWidth, headerHeight);

    fill(0);
    textSize(13);
    text("Date", xPos + 10, yPos + 25);
    text("Flight", xPos + 165, yPos + 25);
    text("Origin", xPos + 260, yPos + 25);
    text("Dest", xPos + 360, yPos + 25);
    text("Plan Dep", xPos + 450, yPos + 25);
    text("Real Dep", xPos + 560, yPos + 25);
    text("Plan Arr", xPos + 670, yPos + 25);
    text("Real Arr", xPos + 780, yPos + 25);
    text("Distance", xPos + 890, yPos + 25);
    text("Status", xPos + 1010, yPos + 25);
    text("Cities", xPos + 1110, yPos + 25);
  }
}
