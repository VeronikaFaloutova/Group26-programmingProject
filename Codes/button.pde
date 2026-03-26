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
    if (label.equals("Back")) {
      fill(50, 70, 100);
    } else {
      fill(hovered ? color(50, 70, 100) : buttonColor);
    }
    noStroke();
    rect(x, y, w, h);
    
    stroke(100, 120, 150);
    strokeWeight(1);
    if (!label.equals("Back")) {
      line(x + w, y, x + w, y + h); 
    }
    
    if (!label.equals("Back")) {
      pushMatrix();
      translate(x + w/2, y + h/2 - 30);
      
      if (label.equals("Graph")) {
        fill(100, 180, 250);
        rect(-40, -20, 20, 40);
        rect(-15, -10, 20, 30);
        rect(10, 0, 20, 20);
        rect(35, -30, 20, 50);
      } else if (label.equals("Table")) {
        stroke(200);
        strokeWeight(2);
        for (int i = -40; i <= 40; i+=27) {
          line(i, -40, i, 40);
          line(-40, i, 40, i);
        }
      } else if (label.equals("Heatmap")) {
        noStroke();
        fill(100, 200, 100);
        rect(-40, -40, 27, 27);
        fill(150, 200, 100);
        rect(-8, -40, 27, 27);
        fill(200, 200, 100);
        rect(24, -40, 27, 27);
        fill(100, 150, 200);
        rect(-40, -8, 27, 27);
        fill(200, 150, 100);
        rect(-8, -8, 27, 27);
        fill(250, 100, 100);
        rect(24, -8, 27, 27);
      } else if (label.equals("Pie Chart")) {
        fill(200, 100, 100);
        arc(0, 0, 80, 80, 0, PI/2);
        fill(100, 200, 100);
        arc(0, 0, 80, 80, PI/2, PI);
        fill(100, 100, 200);
        arc(0, 0, 80, 80, PI, PI*1.5);
        fill(200, 200, 100);
        arc(0, 0, 80, 80, PI*1.5, TWO_PI);
      }
      
      popMatrix();
    }
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(24);
    if (label.equals("Back")) {
      text(label, x + w/2, y + h/2);
    } else {
      text(label, x + w/2, y + h - 50);
    }
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
    
        if (currentScreen != homescreen) {
      for (Widget w : widgets) {
        w.isHovered();
        w.display();
      }
    }
  }

  Widget getEvent() {
    for (Widget w : widgets) {
      if (w.isClicked()) return w;
    }
    return null;
  }
}
       
