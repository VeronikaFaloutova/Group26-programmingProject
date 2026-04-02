import java.util.*;
static float multiplier;

class PieChart {
  int diameter = min(SCREENX, SCREENY) - 250;
  LinkedHashMap<String, Float> angles;

  float pieCenterX = SCREENX * 0.25;
  float pieCenterY = SCREENY * 0.5;

  float hoverExplode = 22;
  float jellyAmount = 4;
  float hoverScale = 12;
  int hoveredIndex = -1;
  int hoveredLegendIndex = -1;

  float shadowOffsetX = 7;
  float shadowOffsetY = 9;

  float legendStartX = SCREENX * 0.58;
  float legendStartY = SCREENY * 0.2;
  float legendColumnGap = 170;
  float legendRowGap = 20;
  float legendBoxSize = 10;

  PieChart(LinkedHashMap<String, Integer> values) {
    this.angles = normalise(values);
  }

  void draw() {
    noStroke();
    hoveredIndex = -1;

    int n = angles.size();
    if (n == 0) return;

    String[] keys = new String[n];
    float[] startAngles = new float[n];
    float[] currentAngles = new float[n];
    float[] midAngles = new float[n];

    int i = 0;
    float lastAngle = 0;

    for (Map.Entry element : angles.entrySet()) {
      keys[i] = (String) element.getKey();
      currentAngles[i] = radians((float) element.getValue());
      startAngles[i] = lastAngle;
      midAngles[i] = lastAngle + currentAngles[i] / 2.0;

      if (isMouseOverSector(startAngles[i], startAngles[i] + currentAngles[i])) {
        hoveredIndex = i;
      }

      lastAngle += currentAngles[i];
      i++;
    }

    hoveredLegendIndex = getHoveredLegendIndex(keys, currentAngles);
    if (hoveredIndex == -1 && hoveredLegendIndex != -1) {
      hoveredIndex = hoveredLegendIndex;
    }

    for (i = 0; i < n; i++) {
      boolean isHovered = (i == hoveredIndex);

      float explodeX = 0;
      float explodeY = 0;
      float drawDiameter = diameter;

      if (isHovered) {
        explodeX = cos(midAngles[i]) * hoverExplode;
        explodeY = sin(midAngles[i]) * hoverExplode;
        drawDiameter = diameter + hoverScale + sin(frameCount * 0.18 + i) * jellyAmount;
      }

      fill(colourArray[i % 5]);
      if ((i == n - 1) && (i % 5 == 0)) {
        fill(colourArray[2]);
      }

      arc(
        pieCenterX + explodeX,
        pieCenterY + explodeY,
        drawDiameter,
        drawDiameter,
        startAngles[i],
        startAngles[i] + currentAngles[i]
      );
    }

    drawLegend(keys, currentAngles);
  }


  LinkedHashMap<String, Float> normalise(LinkedHashMap<String, Integer> lhm) {
    LinkedHashMap<String, Float> normalised_lhm = new LinkedHashMap<String, Float>();

    int totalValue = 0;
    for (Map.Entry element : lhm.entrySet()) {
      totalValue += (int) element.getValue();
    }

    multiplier = (360 / (float) totalValue);
    int currentValue;
    for (Map.Entry element : lhm.entrySet()) {
      currentValue = (int) element.getValue();
      normalised_lhm.put((String) element.getKey(), (float) currentValue * multiplier);
    }

    return normalised_lhm;
  }

  boolean isMouseOverSector(float startAngle, float endAngle) {
    float dx = mouseX - pieCenterX;
    float dy = mouseY - pieCenterY;
    float distanceToCenter = dist(mouseX, mouseY, pieCenterX, pieCenterY);

    if (distanceToCenter > diameter / 2.0) {
      return false;
    }

    float mouseAngle = atan2(dy, dx);
    if (mouseAngle < 0) {
      mouseAngle += TWO_PI;
    }

    float s = startAngle;
    float e = endAngle;

    if (s < 0) s += TWO_PI;
    if (e < 0) e += TWO_PI;

    if (e >= TWO_PI) {
      return mouseAngle >= s || mouseAngle <= (e - TWO_PI);
    } else {
      return mouseAngle >= s && mouseAngle <= e;
    }
  }

  void drawLegend(String[] keys, float[] currentAngles) {
    int n = keys.length;

    fill(255);
    textAlign(LEFT, CENTER);
    textSize(21);
    text("Legend", legendStartX, legendStartY - 35);

    int rowsPerColumn = ceil(n / 2.0);

    for (int i = 0; i < n; i++) {
      int col = i / rowsPerColumn;
      int row = i % rowsPerColumn;

      float x = legendStartX + col * legendColumnGap;
      float y = legendStartY + row * legendRowGap;

      float percentage = degrees(currentAngles[i]) / 360.0 * 100.0;
      boolean isHovered = (i == hoveredIndex);

      if (isHovered) {
        noStroke();
       fill(245, 245, 245, 220);
        rectMode(CORNER);
        rect(x - 10, y - 13, 180, 26, 8);
      }

      fill(colourArray[i % 5]);
      if ((i == n - 1) && (i % 5 == 0)) {
        fill(colourArray[2]);
      }
      rectMode(CORNER);
      rect(x, y - legendBoxSize / 2, legendBoxSize, legendBoxSize, 4);

      if (isHovered) {
        fill(255);
        textSize(17);
      } else {
        fill(255);
        textSize(16);
      }

      textAlign(LEFT, CENTER);
      text(trimLabel(keys[i], 14), x + 24, y);

      textAlign(RIGHT, CENTER);
      text(nf(percentage, 0, 1) + "%", x + 150, y);
    }

    if (hoveredIndex != -1) {
      float infoX = legendStartX;
      float infoY = legendStartY + rowsPerColumn * legendRowGap + 28;
      float percentage = degrees(currentAngles[hoveredIndex]) / 360.0 * 100.0;

      noStroke();
      fill(250, 245);
      rectMode(CORNER);
      rect(infoX - 8, infoY - 16, 260, 56, 10);

      fill(20);
      textAlign(LEFT, CENTER);
      textSize(17);
      text(keys[hoveredIndex], infoX, infoY);

      fill(70);
      textSize(15);
      text("Share: " + nf(percentage, 0, 1) + "%", infoX, infoY + 21);
    }
  }

  int getHoveredLegendIndex(String[] keys, float[] currentAngles) {
    int n = keys.length;
    int rowsPerColumn = ceil(n / 2.0);

    for (int i = 0; i < n; i++) {
      int col = i / rowsPerColumn;
      int row = i % rowsPerColumn;

      float x = legendStartX + col * legendColumnGap;
      float y = legendStartY + row * legendRowGap;

      float boxX = x - 10;
      float boxY = y - 13;
      float boxW = 180;
      float boxH = 26;

      if (mouseX >= boxX && mouseX <= boxX + boxW &&
          mouseY >= boxY && mouseY <= boxY + boxH) {
        return i;
      }
    }
    return -1;
  }

  String trimLabel(String s, int maxLen) {
    if (s.length() <= maxLen) return s;
    return s.substring(0, maxLen - 3) + "...";
  }
}
