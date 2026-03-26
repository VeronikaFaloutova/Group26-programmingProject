ArrayList<Bar> bars = new ArrayList<Bar>();
ArrayList<Float> originalY = new ArrayList<Float>();

float scrollOffset = 0;
float maxScroll = 0;

float chartTop = 80;
float chartBottomMargin = 60;

float scrollBarX;
float scrollBarY;
float scrollBarW = 14;
float scrollBarH;
float scrollThumbY;
float scrollThumbH = 80;

boolean draggingScroll = false;
float dragOffsetY = 0;

class Bar {
  float value;
  float length;
  float width;
  color barColour;
  float xpos = MARGIN;
  float ypos;
  String shortLabel;
  String fullLabel;
  float multiplier;

  float totalValue = -1;
  float hoverOffset = 0;
  float hoverTarget = 0;
  float jellyPhase;
  float displayLength = 0;
  float glowAlpha = 0;

  Bar(float ypos, float width, int value, String shortLabel, String fullLabel, color barColour) {
    this.ypos = ypos;
    this.width = width;
    this.value = value;
    this.shortLabel = shortLabel;
    this.fullLabel = fullLabel;
    this.barColour = barColour;
    this.jellyPhase = random(TWO_PI);
  }

  void setLength(int length) {
    this.length = length;
    if (displayLength == 0) {
      displayLength = length;
    }
  }

  void setTotalValue(float totalValue) {
    this.totalValue = totalValue;
  }

  void setMultiplier(float multiplier) {
    this.multiplier = multiplier;
  }

  boolean isMouseOver() {
    return mouseX >= xpos &&
      mouseX <= xpos + displayLength &&
      mouseY >= ypos &&
      mouseY <= ypos + width;
  }

  void draw() {
    boolean hovering = isMouseOver();

    hoverTarget = hovering ? min(16, SCREENX * 0.012) : 0;
    hoverOffset += (hoverTarget - hoverOffset) * 0.22;

    displayLength += (length - displayLength) * 0.18;

    float targetGlow = hovering ? 90 : 0;
    glowAlpha += (targetGlow - glowAlpha) * 0.18;

    float jelly = 0;
    if (hovering) {
      jelly = sin(frameCount * 0.18 + jellyPhase) * 2.0;
    }

    float drawX = xpos;
    float drawY = ypos - jelly * 0.15;
    float drawW = displayLength + hoverOffset * 0.35;
    float drawH = width + abs(jelly) * 0.3;
    
    fill(255);                     
    textAlign(RIGHT, CENTER);
    textSize(14);
    text(shortLabel, drawX - 10, drawY + drawH / 2);

    noStroke();
    fill(0, 25);
    rectMode(CORNER);
    rect(drawX + 4, drawY + 4, drawW, drawH, 10);
    
    fill(barColour);
    rect(drawX, drawY, drawW, drawH, 10);

    if (glowAlpha > 1) {
      fill(255, glowAlpha);
      rect(drawX, drawY, drawW, drawH * 0.45, 10);
    }

      if (hovering) {
      String percentText = "";
      if (totalValue > 0) {
        float percent = value / totalValue * 100.0;
        percentText = nf(percent, 0, 1) + "%";
      }

      String info;
      if (percentText.equals("")) {
        info = fullLabel + ": " + (int)value;
      } else {
        info = fullLabel + ": " + (int)value + "  (" + percentText + ")";
      }

      drawTooltip(info, drawX + drawW, drawY + drawH/2);
    }
  }

  void drawAt(float y) {
    float originalY = this.ypos;
    this.ypos = y;
    draw();
    this.ypos = originalY;
  }

  void drawTooltip(String info, float anchorX, float anchorY) {
    textSize(16);
    float paddingX = 12;
    float tw = textWidth(info);
    float boxW = tw + paddingX * 2;
    float boxH = 28;

    float tx = anchorX + 18;
    float ty = anchorY - boxH/2;

    if (tx + boxW > SCREENX - 10) {
      tx = anchorX - boxW - 18;
    }

    if (ty < 10) {
      ty = 10;
    }

    if (ty + boxH > SCREENY - 10) {
      ty = SCREENY - boxH - 10;
    }

    stroke(80, 120);
    strokeWeight(1.5);
    line(anchorX + 5, anchorY, tx, ty + boxH/2);

    noStroke();
    fill(255, 245);
    rect(tx, ty, boxW, boxH, 8);

    fill(30);
    textAlign(LEFT, CENTER);
    text(info, tx + paddingX, ty + boxH/2 - 1);
  }
}
