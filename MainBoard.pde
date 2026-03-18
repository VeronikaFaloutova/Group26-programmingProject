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

  stroke(255, 255, 255, 12);
  line(bx + 385, by + 64, bx + 385, by + boardH - 40);

  for (int i = 0; i < rows; i++) {
    float rowY = by + 78 + i * 40;

    if (i < rows - 1) {
      stroke(255, 255, 255, 10);
      line(bx + 25, rowY + 42, bx + boardW - 25, rowY + 42);
    }

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
  scrollX -= 1.8;
  float tw = textWidth(scroll);
  if (scrollX < -tw - 40) {
    scrollX = width;
  }
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
    return color(255, 140, 0);
  } else if (s.equals("BOARDING")) {
    return color(255, 210, 90);
  } else if (s.equals("CANCELLED")) {
    return color(255, 80, 80);
  } else if (s.equals("GATE OPEN")) {
    return color(90, 170, 255);
  } else {
    return color(255);
  }
}
