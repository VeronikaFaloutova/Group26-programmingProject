class Bar {
  float value;
  float length;
  float width;
  color barColour;
  float xpos = 58;
  float ypos;
  String label;
  float multiplier; 
  
  Bar(float ypos, float width, int value, String label, color barColour) {
    this.ypos = ypos;
    this.width = width;
    this.value = value;
    this.label = label;
    this.barColour = barColour;
  }

  void setLength(int length) {
    this.length = length;
  }

  void drawAt(float drawY) {
    noStroke();
    fill(barColour);
    rectMode(CORNER);
    rect(xpos, drawY, length, width, 2);

    int labelSize = int(width * 0.92);
    if (labelSize > 20) labelSize = 20;
    if (labelSize < 10) labelSize = 10;

    int valueSize = int(width * 0.95);
    if (valueSize > 20) valueSize = 20;
    if (valueSize < 10) valueSize = 10;

    fill(235, 240, 245);

    // 左边州名
    textAlign(LEFT, CENTER);
    textSize(labelSize);
    text(label, 10, drawY + width / 2);

    // 右边数值
    textAlign(LEFT, CENTER);
    textSize(valueSize);
    text((int) value, xpos + length + 8, drawY + width / 2);
  }
}
