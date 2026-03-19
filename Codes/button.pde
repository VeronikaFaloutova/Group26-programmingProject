class Button {
  int x, y, width, height;
  String label;
  int event;
  color widgetColor, labelColor, strokeColor;
  final int BUTTON_GAP = 5;

  Button(int x, int y, int width, int height, String label, color widgetColor, color strokeColor, int event) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.label = label;
    this.event = event;
    this.widgetColor = widgetColor;
    this.strokeColor = strokeColor;
    this.labelColor = color(0, 0, 0);
  }

  void draw() {
    stroke(strokeColor);
    fill(widgetColor);
    rect(x, y, width, height, 8);
    fill(labelColor);
    textAlign(LEFT, BOTTOM);
    textSize(12);
    text(label, x + BUTTON_GAP, y + height - BUTTON_GAP);
  }

  int getEvent(int mX, int mY) {
    if (mX > x && mX < x + width && mY > y && mY < y + height) {
      return event;
    }
    return 0;
  }
}

class Widget {
  int x, y, w, h;
  String label;
  boolean hovered;
  color buttonColor;

  Widget(int x, int y, int w, int h, String label, color buttonColor) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
    this.buttonColor = buttonColor;
  }

  void display() {
    stroke(hovered ? color(255) : color(0));
    fill(buttonColor);
    rect(x, y, w, h, 10);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(22);
    text(label, x + w / 2, y + h / 2);
  }

  void isHovered() {
    hovered = mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }

  boolean isClicked() {
    return hovered;
  }
}

class Screen {
  ArrayList<Widget> widgets;
  int bgColor;

  Graph graph;
  HeatMap heatmap;
  PieChart chart;

  Screen(int bgColor) {
    this.bgColor = bgColor;
    widgets = new ArrayList<Widget>();
  }

  void addWidget(Widget w) {
    widgets.add(w);
  }

  void draw() {
    background(bgColor);

    if (currentScreen != homescreen) {
      for (Widget w : widgets) {
        w.isHovered();
        w.display();
      }
    }

    if (currentScreen == graphScreen && graph != null) {
      graph.draw();

    } else if (currentScreen == heatmapScreen && heatmap != null) {
      heatmap.drawFullHeatMap();

    } else if (currentScreen == piechartScreen && chart != null) {
      chart.draw();

    } else if (currentScreen == tableScreen && table1 != null) {
      table1.draw();

    } else if (currentScreen == modeSelectScreen) {
      fill(235, 240, 245);
      textAlign(CENTER, TOP);
      textFont(titleFont);
      text(currentTitle, width / 2, 120);
    }
  }

  Widget getEvent() {
    for (Widget w : widgets) {
      if (w.isClicked()) return w;
    }
    return null;
  }
}
       
