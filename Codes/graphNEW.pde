import java.util.Collections; //<>//
import java.util.Comparator;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.LinkedHashMap;
import java.util.HashMap;

class Graph {
  
  Frame frame;
  Bar[] barArray;
  Normaliser normaliser = new Normaliser();
  int maxValue = 0;
  HashMap<String, String> airportToCity = new HashMap<String, String>();

  float scrollOffset = 0;
  float maxScroll = 0;

  float chartTop = 15;
  float chartBottom = SCREENY - 100;
  float chartHeight = chartBottom - chartTop;

  float chartLeft = MARGIN;
  float chartRight = SCREENX - 170;
  float graphWidth = chartRight - chartLeft;

  void setTitle(String title) {
    this.frame.title = title;
  }

  void setLabelX(String labelX) {
    this.frame.labelX = labelX;
  }

  void setLabelY(String labelY) {
    this.frame.labelY = labelY;
  }
  
  Graph(LinkedHashMap<String, Integer> values, ArrayList<Flight> flights) {
    frame = new Frame();

    for (Flight f : flights) {
      airportToCity.put(f.originAirport, f.originCity);
    }

    List<Map.Entry<String, Integer>> list = new ArrayList<Map.Entry<String, Integer>>(values.entrySet());

    Collections.sort(list, new Comparator<Map.Entry<String, Integer>>() {
      public int compare(Map.Entry<String, Integer> o1, Map.Entry<String, Integer> o2) {
        return o2.getValue().compareTo(o1.getValue());
      }
    });

    LinkedHashMap<String, Integer> sortedValues = new LinkedHashMap<String, Integer>();
    for (Map.Entry<String, Integer> entry : list) {
      sortedValues.put(entry.getKey(), entry.getValue());
    }

    maxValue = 0;
    for (Map.Entry<String, Integer> entry : sortedValues.entrySet()) {
      int val = entry.getValue();
      if (val > maxValue) {
        maxValue = val;
      }
    }

    float barHeight = 28;
    float gap = 12;

    barArray = new Bar[sortedValues.size()];
    float ypos = chartTop;
    int i = 0;

    for (Map.Entry<String, Integer> entry : sortedValues.entrySet()) {
      String shortLabel = entry.getKey();
      String fullLabel = airportToCity.get(shortLabel);
      if (fullLabel == null) {
        fullLabel = shortLabel;
      }

      barArray[i] = new Bar(
        ypos,
        barHeight,
        entry.getValue(),
        shortLabel,
        fullLabel,
        colourArray[i % 5]
      );

      ypos += barHeight + gap;
      i++;
    }

    i = 0;
    for (Map.Entry<String, Integer> entry : sortedValues.entrySet()) {
      int value = entry.getValue();
      float len = map(value, 0, maxValue, 0, graphWidth);
      barArray[i].setLength((int)len);
      i++;
    }

    float totalContentHeight = sortedValues.size() * (barHeight + gap);
    maxScroll = max(0, totalContentHeight - chartHeight);
  }

  void scroll(float amount) {
    scrollOffset += amount;

    if (scrollOffset < 0) {
      scrollOffset = 0;
    }
    if (scrollOffset > maxScroll) {
      scrollOffset = maxScroll;
    }
  }

  void draw() {
    frame.draw();

    stroke(100, 120, 150, 60);
    strokeWeight(1);

    int currentMax = 0;
    for (Bar bar : barArray) {
      if (bar.value > currentMax) {
        currentMax = (int) bar.value;
      }
    }

    if (currentMax == 0) {
      currentMax = 1;
    }

    int numVLines;
    if (currentMax <= 10) {
      numVLines = currentMax;
    } else {
      numVLines = 5;
    }

    if (numVLines < 1) {
      numVLines = 1;
    }

    for (int i = 0; i <= numVLines; i++) {
      float x = chartLeft + (graphWidth / numVLines) * i;
      line(x, chartTop, x, chartBottom);

      fill(150, 170, 200, 180);
      textAlign(CENTER, TOP);
      textSize(12);

      if (currentMax <= 10) {
        text(i, x, chartBottom + 30);
      } else {
        float value = currentMax * i / (float) numVLines;
        text(round(value), x, chartBottom + 30);
      }
    }

    for (Bar bar : barArray) {
      float visibleY = bar.ypos - scrollOffset;

      if (visibleY + bar.width >= chartTop && visibleY <= chartBottom) {
        bar.drawAt(visibleY);
      }
    }
  }
}
