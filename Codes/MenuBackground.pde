
void drawHomeScreenV2Style() {
  background(30, 40, 60);
  smoothTable.update();
  drawHeader();
  drawMainBoardNew();
  drawFeatureCardsV1Widgets();
  drawBottomTicker();
}

void drawBackground() {
  noStroke();

  for (int i = 0; i < 180; i++) {
    fill(30, 40, 60);
    rect(0, i * 2, width, 2);
  }
}

void drawHeader() {
  fill(100, 180, 250);
  textAlign(LEFT, TOP);
  textFont(titleFont);
  text("AERO VISION", 60, 50);

  fill(255);
  textFont(subFont);
  text("Graphs • Route Analysis • Data Visualization", 60, 92);

  stroke(100, 180, 250, 90);
  line(60, 132, width - 60, 132);
  noStroke();
  
}

void drawFeatureCardsV1Widgets() {
  for (int i = 0; i < homescreen.widgets.size(); i++) {
    Widget w = homescreen.widgets.get(i);
    w.isHovered();

    String desc = "";

  if (w.label.equals("Cancelled")) {
    desc = "Show all cancelled flights.";
  } else if (w.label.equals("Delayed")) {
    desc = "Flights delayed beyond scheduled time.";
  } else if (w.label.equals("Diverted")) {
    desc = "Flights diverted to another airport.";
  } else if (w.label.equals("Unfiltered")) {
    desc = "View all flights without filtering.";
  }

    drawFeatureCardStyled(w.x, w.y, w.w, w.h, w.label.toUpperCase(), desc, w.hovered);
  }
}

void drawFeatureCardStyled(float x, float y, float w, float h, String title, String desc, boolean hover) {
  noStroke();
  fill(hover ? color(50,70,100) : color(30,40,60), 240);
  rect(x, y, w, h, 14);

  fill(100, 180, 250);
  rect(x, y, 6, h, 14, 0, 0, 14);

  fill(255);
  textAlign(LEFT, TOP);
  textFont(labelFont);
  text(title.toUpperCase(), x + 16, y + 12);

  fill(200, 210, 230);
  textFont(bodyFont);
  textSize(16);
  textLeading(18);
  text(desc, x + 16, y + 40, w - 28, h - 12);
}

void drawMainBoardNew() {
  float boardW = 1080; 
  float boardH = 360;
  float bx = width / 2 - boardW / 2;
  float by = 165;
  
  noStroke();
  fill(45, 55, 75, 230);
  rect(bx, by, boardW, boardH, 12);
  
  fill(35, 45, 65, 240);
  rect(bx, by, boardW, 54, 12, 12, 0, 0);
  
  fill(100, 180, 250);
  textAlign(LEFT, CENTER);
  textFont(labelFont);
  textSize(18);
  
  text("FLIGHT", bx + 30, by + 27);
  text("ROUTE",  bx + 180, by + 27);
  text("TIME",   bx + 380, by + 27);
  text("MILES",   bx + 520, by + 27);
  text("STATUS", bx + 650, by + 27);
  text("CITIES (FROM-TO-)", bx + 800, by + 27);
  
  stroke(100, 180, 250, 60);
  line(bx + 20, by + 54, bx + boardW - 20, by + 54);

  smoothTable.draw(bx, by, boardH);
}

String scrollText = ""; 

void drawBottomTicker() {
  float y = height - 42;

  noStroke();
  fill(30, 40, 60, 248);
  rect(0, y, width, 42);

  stroke(100, 180, 250, 80);
  line(0, y, width, y);

  fill(255);
  textAlign(LEFT, CENTER);
  textFont(smallFont);
  
  float delayedRate = (totalDelayedCount * 100.0) / totalFlightsCount;
  float cancelledRate = (totalCancelledCount * 100.0) / totalFlightsCount;
  scrollText = " TOTAL FLIGHTS: " + totalFlightsCount + "   |   DELAYED RATE: " + nf(delayedRate, 0, 2) + "%   |  CANCELLED RATE: " + nf(cancelledRate, 0, 2) + "% ";
  
  text(scrollText, scrollX, y + 21);
}

void updateTicker() {
  scrollX -= 1.0;
  float tw = textWidth(scrollText);
  if (scrollX < -tw - 40) {
    scrollX = width;
  }
}
