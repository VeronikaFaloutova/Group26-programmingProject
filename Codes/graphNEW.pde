class Graph { //<>//
  
  Frame frame;
  Bar[] barArray;
  Normaliser normaliser = new Normaliser();

  float scrollOffset = 0;
  float maxScroll = 0;

  float chartTop = 20;
  float chartBottom = SCREENY - 80;
  float chartHeight = chartBottom - chartTop;

  void setTitle(String title) {
    this.frame.title = title;
  }

  void setLabelX(String labelX) {
    this.frame.labelX = labelX;
  }

  void setLabelY(String labelY) {
    this.frame.labelY = labelY;
  }
  
  Graph(LinkedHashMap<String, Integer> values) {
    frame = new Frame();

    float barHeight = 20;
    float gap = 8;

    barArray = new Bar[values.size()];
    float ypos = chartTop;
    int i = 0;

    for (Map.Entry value : values.entrySet()) {
      barArray[i] = new Bar(ypos, barHeight, (int) value.getValue(), (String) value.getKey(), colourArray[i % 5]);
      ypos += barHeight + gap;
      i++;
    }

    i = 0;
    for (Map.Entry normalisedLength : normaliser.normalise(values).entrySet()) {
      int len = (int) normalisedLength.getValue();
      len = int(len * 1.12);

      if (len > SCREENX - 170) {
        len = SCREENX - 170;
      }

      barArray[i].setLength(len);
      i++;
    }

    float totalContentHeight = values.size() * (barHeight + gap);
    maxScroll = max(0, totalContentHeight - chartHeight);
  }
  
  void scroll(float amount) {
    scrollOffset += amount;
    if (scrollOffset < 0) scrollOffset = 0;
    if (scrollOffset > maxScroll) scrollOffset = maxScroll;
  }

  void draw() {
    frame.draw();

    for (Bar bar : barArray) {
      float visibleY = bar.ypos - scrollOffset;

      // 只画当前屏幕可见范围里的 bar
      if (visibleY + bar.width >= chartTop && visibleY <= chartBottom) {
        bar.drawAt(visibleY);
      }
    }
  }
}
