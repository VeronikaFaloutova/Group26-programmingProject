class funLines {

  void drawLinesOnly() {
    int xpos = 0;
    int ypos = 0;

    strokeWeight(20);
    for (int i = 0; i < 10; i++) {
      xpos += width / 10;
      ypos += width / 30;
      if (existsColourArray()) {
        stroke(colourArray[i % 5], 200 - i * 20);
      } else {
        stroke(100 + i * 10, 150, 220, 200 - i * 20);
      }
      line(-10, width - ypos, xpos, height + 10);
    }

    strokeWeight(3);
    if (existsColourArray()) {
      stroke(colourArray[0], 100);
    } else {
      stroke(150, 180, 255, 100);
    }
    line(-10, 300 - ypos, xpos, 810);

    if (existsColourArray()) {
      stroke(colourArray[2], 100);
    } else {
      stroke(255, 180, 150, 100);
    }
    line(-10, 450, 1000, 0);

    strokeWeight(width / 2.0);
    if (existsColourArray()) {
      stroke(colourArray[4], 50);
    } else {
      stroke(255, 220, 120, 50);
    }


    strokeWeight(1);
    stroke(150);
  }


  boolean existsColourArray() {
    return true;
  }
}

void drawHomeScreenV2Style() {
  background(7, 11, 18);
  drawHeader();
  drawMainBoard();
  drawFeatureCardsV1Widgets();
  drawBottomTicker();
}

void drawBackground() {
  noStroke();

  for (int i = 0; i < 180; i++) {
    fill(20, 35, 60, 5);
    rect(0, i * 2, width, 2);
  }
}

void drawHeader() {
  fill(235, 240, 245);
  textAlign(LEFT, TOP);
  textFont(titleFont);
  text("AERO VISION", 60, 50);

  fill(255, 190, 90);
  textFont(subFont);
  text("Graphs  •  Route Analysis  •  Data Visualization", 60, 92);

  stroke(255, 190, 90, 90);
  line(60, 132, width - 60, 132);
  noStroke();
}

void drawMainBoard() {
  float boardW = 900;
  float boardH = 340;
  float bx = width / 2 - boardW / 2;
  float by = 180;

  noStroke();
  fill(18, 20, 24, 245);
  rect(bx, by, boardW, boardH, 18);

  fill(36, 38, 44);
  rect(bx, by, boardW, 54, 18, 18, 0, 0);

  fill(255, 205, 110);
  textAlign(LEFT, CENTER);
  textFont(labelFont);

  float xFlight = bx + 26;
  float xRoute  = bx + 200;
  float xTime   = bx + 400;
  float xStatus = bx + 600;

  text("FLIGHT", xFlight, by + 27);
  text("DES",    xRoute,  by + 27);
  text("TIME",   xTime,   by + 27);
  text("STATUS", xStatus, by + 27);

  stroke(255, 255, 255, 18);
  line(bx + 25, by + 54, bx + boardW - 25, by + 54);

  for (int i = 0; i < rows; i++) {
    float rowY = by + 78 + i * 40;

    drawField(flightChars[i], flightDone[i], xFlight, rowY, color(248, 208, 118));
    drawField(routeChars[i],  routeDone[i],  xRoute,  rowY, color(248, 208, 118));
    drawField(timeChars[i],   timeDone[i],   xTime,   rowY, color(248, 208, 118));
    drawField(statusChars[i], statusDone[i], xStatus, rowY, currentStatusColor(statusDone[i], statusChars[i]));
  }
}

void drawField(char[] chars, boolean[] done, float startX, float y, int txtColor) {
  
  float tileW = 20;
  float tileH = 32;

  textFont(flipFont);
  textAlign(CENTER, CENTER);

  for (int i = 0; i < chars.length; i++) {
    float x = startX + i * tileW;
    drawTile(x, y, tileW, tileH, chars[i], done[i], txtColor);
  }
}

void drawTile(float x, float y, float w, float h, char ch, boolean isDone, int txtColor) {
  stroke(85, 85, 90, 110);
  fill(20, 20, 22);
  rect(x, y, w, h, 4);

  noStroke();
  fill(26, 26, 28);
  rect(x + 1, y + 1, w - 2, h / 2 - 1, 3, 3, 0, 0);

  fill(16, 16, 18);
  rect(x + 1, y + h / 2, w - 2, h / 2 - 1, 0, 0, 3, 3);

  stroke(90, 90, 95, 100);
  line(x + 2, y + h / 2, x + w - 2, y + h / 2);

  if (!isDone) {
    noStroke();
    fill(255, 210, 120, 12);
    rect(x + 2, y + 2, w - 4, h - 4, 3);
  }

  fill(txtColor);
  text(ch, x + w / 2, y + h / 2 + 1);
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
  fill(hover ? color(30, 38, 52) : color(19, 24, 34), 245);
  rect(x, y, w, h, 14);

  fill(255, 190, 90);
  rect(x, y, 6, h, 14, 0, 0, 14);

  fill(235, 240, 245);
  textAlign(LEFT, TOP);
  textFont(labelFont);
  text(title.toUpperCase(), x + 16, y + 12);

  fill(175, 185, 195);
  textFont(bodyFont);
  textSize(16);
  textLeading(18);
  text(desc, x + 16, y + 40, w - 28, h - 12);
}

void drawBottomTicker() {
  float y = height - 42;

  noStroke();
  fill(14, 16, 20, 248);
  rect(0, y, width, 42);

  stroke(255, 190, 90, 80);
  line(0, y, width, y);

  fill(220, 225, 230);
  textAlign(LEFT, CENTER);
  textFont(smallFont);
  text(scroll, scrollX, y + 21);
}

void updateTicker() {
  scrollX -= 2.0;
  float tw = textWidth(scroll);
  if (scrollX < -tw - 40) {
    scrollX = width;
  }
}
