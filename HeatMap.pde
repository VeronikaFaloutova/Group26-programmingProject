import java.util.HashMap;
import java.util.Map;

class HeatMap {

  Map<String, PImage> stateImages;
  HashMap<String, Integer> stateColors;
  HashMap<String, PVector> stateCoordinates = new HashMap<String, PVector>();

  HashMap<String, String> hoverShape = new HashMap<String, String>(); // "rect" or "ellipse"
  HashMap<String, float[]> hoverBounds = new HashMap<String, float[]>();
  String hoveredState = "";


  HeatMap(LinkedHashMap<String, Integer> lhm) {

    //-70 on y axis from previous code to fit the new dimensions

    stateCoordinates.put("AL", new PVector(506, 203));
    stateCoordinates.put("AK", new PVector(-10, 380));
    stateCoordinates.put("AZ", new PVector(74, 141));
    stateCoordinates.put("AR", new PVector(407, 194));
    stateCoordinates.put("CA", new PVector(-103, 101));
    stateCoordinates.put("CO", new PVector(187, 50));
    stateCoordinates.put("CT", new PVector(681, -42));
    stateCoordinates.put("DE", new PVector(655, 28));
    stateCoordinates.put("FL", new PVector(567, 278));
    stateCoordinates.put("GA", new PVector(560, 189));
    stateCoordinates.put("HI", new PVector(220, 410));
    stateCoordinates.put("ID", new PVector(57, -53));
    stateCoordinates.put("IL", new PVector(440, 65));
    stateCoordinates.put("IN", new PVector(489, 58));
    stateCoordinates.put("IA", new PVector(378, 19));
    stateCoordinates.put("KS", new PVector(215, 56));
    stateCoordinates.put("KY", new PVector(506, 97));
    stateCoordinates.put("LA", new PVector(421, 263));
    stateCoordinates.put("ME", new PVector(705, -120));
    stateCoordinates.put("MD", new PVector(627, 33));
    stateCoordinates.put("MA", new PVector(685, -45));
    stateCoordinates.put("MI", new PVector(467, 11));
    stateCoordinates.put("MN", new PVector(376, -17));
    stateCoordinates.put("MS", new PVector(455, 211));
    stateCoordinates.put("MO", new PVector(390, 174));
    stateCoordinates.put("MT", new PVector(134, -108));
    stateCoordinates.put("NE", new PVector(282, -24));
    stateCoordinates.put("NV", new PVector(-57, 166));
    stateCoordinates.put("NH", new PVector(683, -85));
    stateCoordinates.put("NJ", new PVector(660, 2));
    stateCoordinates.put("NM", new PVector(49, 163));
    stateCoordinates.put("NY", new PVector(633, -54));
    stateCoordinates.put("NC", new PVector(604, 111));
    stateCoordinates.put("ND", new PVector(333, 59));
    stateCoordinates.put("OH", new PVector(537, 33));
    stateCoordinates.put("OK", new PVector(242, 102));
    stateCoordinates.put("OR", new PVector(-26, 49));
    stateCoordinates.put("PA", new PVector(611, 5));
    stateCoordinates.put("RI", new PVector(695, -46));
    stateCoordinates.put("SC", new PVector(596, 162));
    stateCoordinates.put("SD", new PVector(390, 125));
    stateCoordinates.put("TN", new PVector(506, 134));
    stateCoordinates.put("TX", new PVector(282, 257));
    stateCoordinates.put("UT", new PVector(77, 75));
    stateCoordinates.put("VT", new PVector(662, -82));
    stateCoordinates.put("VA", new PVector(603, 71));
    stateCoordinates.put("WA", new PVector(-22, -82));
    stateCoordinates.put("WV", new PVector(585, 56));
    stateCoordinates.put("WI", new PVector(426, -38));
    stateCoordinates.put("WY", new PVector(173, 65));

    // Format: x, y, width, height, angle

    hoverShape.put("AL", "rect");
    hoverBounds.put("AL", new float[]{678, 350, 45, 80, 0});
    
    hoverShape.put("AK", "ellipse");
    hoverBounds.put("AK", new float[]{100, 520, 150, 150, 0});
    
    hoverShape.put("AZ", "rect");
    hoverBounds.put("AZ", new float[]{230, 310, 90, 135, 0});
    
    hoverShape.put("AR", "rect");
    hoverBounds.put("AR", new float[]{575, 340, 54, 65, 0});
    
    hoverShape.put("CA", "ellipse");
    hoverBounds.put("CA", new float[]{145, 185, 54, 235, radians (-30)});
    
    hoverShape.put("CO", "rect");
    hoverBounds.put("CO", new float[]{335, 260, 100, 70, 0});
    
    hoverShape.put("CT", "ellipse");
    hoverBounds.put("CT", new float[]{868, 150, 25, 15, radians (-15)});
    
    hoverShape.put("DE", "ellipse");
    hoverBounds.put("DE", new float[]{855, 222, 5, 20, radians (-15)});
    
    hoverShape.put("FL", "ellipse");
    hoverBounds.put("FL", new float[]{700, 432, 150, 80, radians (25)});
    
    hoverShape.put("GA", "ellipse");
    hoverBounds.put("GA", new float[]{720, 365, 90, 50, radians (40)});
    
    hoverShape.put("HI", "ellipse");
    hoverBounds.put("HI", new float[]{330, 602, 170, 70, radians (25)});
    
    hoverShape.put("ID", "ellipse");
    hoverBounds.put("ID", new float[]{225, 128, 60, 95, radians (-38)});
    
    hoverShape.put("IL", "ellipse");
    hoverBounds.put("IL", new float[]{620, 210, 50, 95, radians (-10)});
    
    hoverShape.put("IN", "ellipse");
    hoverBounds.put("IN", new float[]{670, 220, 35, 70, radians (-10)});

    hoverShape.put("IA", "rect");
    hoverBounds.put("IA", new float[]{538, 205, 65, 45});
    
    hoverShape.put("KS", "rect");
    hoverBounds.put("KS", new float[]{445, 275, 110, 55});
    
    hoverShape.put("KY", "ellipse");
    hoverBounds.put("KY", new float[]{660, 285, 95, 30, radians (-15)});
    
    hoverShape.put("LA", "rect");
    hoverBounds.put("LA", new float[]{585, 405, 45, 70});
    
    hoverShape.put("ME", "ellipse");
    hoverBounds.put("ME", new float[]{860, 43, 90, 65, radians (60)});
    
    hoverShape.put("MD", "ellipse");
    hoverBounds.put("MD", new float[]{827, 219, 25, 25, radians (-40)});
    
    hoverShape.put("MA", "ellipse");
    hoverBounds.put("MA", new float[]{870, 131, 50, 18, radians (-15)});
    
    hoverShape.put("MI", "rect");
    hoverBounds.put("MI", new float[]{653, 115, 80, 95});
    
    hoverShape.put("MN", "rect");
    hoverBounds.put("MN", new float[]{523, 100, 60, 95});
    
    hoverShape.put("MS", "rect");
    hoverBounds.put("MS", new float[]{625, 360, 55, 85});
    
    hoverShape.put("MO", "rect");
    hoverBounds.put("MO", new float[]{560, 260, 60, 80});
    
    hoverShape.put("MT", "rect");
    hoverBounds.put("MT", new float[]{278, 90, 130, 77, 0});
    
    hoverShape.put("NE", "rect");
    hoverBounds.put("NE", new float[]{417, 220, 110, 50, 0});
    
    hoverShape.put("NV", "ellipse");
    hoverBounds.put("NV", new float[]{175, 195, 75, 135, radians (-30)});
    
    hoverShape.put("NH", "ellipse");
    hoverBounds.put("NH", new float[]{870, 95, 20, 40, radians (-28)});
    
    hoverShape.put("NJ", "rect");
    hoverBounds.put("NJ", new float[]{850, 180, 15, 40, 0});
    
    hoverShape.put("NM", "rect");
    hoverBounds.put("NM", new float[]{325, 340, 104, 95, 0});
    
    hoverShape.put("NY", "ellipse");
    hoverBounds.put("NY", new float[]{780, 100, 65, 90, radians (60)});
    
    hoverShape.put("NC", "ellipse");
    hoverBounds.put("NC", new float[]{775, 283, 100, 50, radians (-10)});
    
    hoverShape.put("ND", "rect");
    hoverBounds.put("ND", new float[]{415, 95, 94, 65, 0});
    
    hoverShape.put("OH", "ellipse");
    hoverBounds.put("OH", new float[]{710, 207, 50, 65, radians (60)});
    
    hoverShape.put("OK", "rect");
    hoverBounds.put("OK", new float[]{475, 335, 90, 65, 0});
    
    hoverShape.put("OR", "rect");
    hoverBounds.put("OR", new float[]{105, 125, 114, 65, 0});
    
    hoverShape.put("PA", "rect");
    hoverBounds.put("PA", new float[]{765, 185, 70, 40, 0});
    
    hoverShape.put("RI", "rect");
    hoverBounds.put("RI", new float[]{890, 150, 7, 9, 0});
    
    hoverShape.put("SC", "ellipse");
    hoverBounds.put("SC", new float[]{755, 332, 70, 45, radians (30)});
    
    hoverShape.put("SD", "rect");
    hoverBounds.put("SD", new float[]{412, 155, 105, 60, 0});
    
    hoverShape.put("TN", "ellipse");
    hoverBounds.put("TN", new float[]{640, 320, 115, 30, radians (-15)});
    
    hoverShape.put("TX", "ellipse");
    hoverBounds.put("TX", new float[]{430, 405, 155, 155, radians (-15)});
    
    hoverShape.put("UT", "rect");
    hoverBounds.put("UT", new float[]{262, 235, 60, 75, 0});
    
    hoverShape.put("VT", "ellipse");
    hoverBounds.put("VT", new float[]{840, 110, 37, 16, radians (-120)});
        
    hoverShape.put("VA", "ellipse");
    hoverBounds.put("VA", new float[]{790, 243, 60, 35, radians (-40)});
    
    hoverShape.put("WA", "rect");
    hoverBounds.put("WA", new float[]{125, 65, 100, 55, 0});
    
    hoverShape.put("WV", "ellipse");
    hoverBounds.put("WV", new float[]{740, 250, 65, 30, radians (-50)});
    
    hoverShape.put("WI", "ellipse");
    hoverBounds.put("WI", new float[]{580, 150, 85, 55, radians (-110)});
    
    hoverShape.put("WY", "rect");
    hoverBounds.put("WY", new float[]{310, 175, 95, 70, 0});


    stateImages = new HashMap<String, PImage>();
    stateImages.put("AL", loadImage("Alabama.png"));
    stateImages.put("AK", loadImage("Alaska.png"));
    stateImages.put("AZ", loadImage("Arizona.png"));
    stateImages.put("AR", loadImage("Arkansas.png"));
    stateImages.put("CA", loadImage("California.png"));
    stateImages.put("CO", loadImage("Colorado.png"));
    stateImages.put("CT", loadImage("Connecticut.png"));
    stateImages.put("DE", loadImage("Delaware.png"));
    stateImages.put("FL", loadImage("Florida.png"));
    stateImages.put("GA", loadImage("Georgia.png"));
    stateImages.put("HI", loadImage("Hawaii.png"));
    stateImages.put("ID", loadImage("Idaho.png"));
    stateImages.put("IL", loadImage("Illinois.png"));
    stateImages.put("IN", loadImage("Indiana.png"));
    stateImages.put("IA", loadImage("Iowa.png"));
    stateImages.put("KS", loadImage("Kansas.png"));
    stateImages.put("KY", loadImage("Kentucky.png"));
    stateImages.put("LA", loadImage("Louisiana.png"));
    stateImages.put("ME", loadImage("Maine.png"));
    stateImages.put("MD", loadImage("Maryland.png"));
    stateImages.put("MA", loadImage("Massachusetts.png"));
    stateImages.put("MI", loadImage("Michigan.png"));
    stateImages.put("MN", loadImage("Minnesota.png"));
    stateImages.put("MS", loadImage("Missippi.png"));
    stateImages.put("MO", loadImage("Missouri.png"));
    stateImages.put("MT", loadImage("Montana.png"));
    stateImages.put("NE", loadImage("Nebraska.png"));
    stateImages.put("NV", loadImage("Nevada.png"));
    stateImages.put("NH", loadImage("NewHampshire.png"));
    stateImages.put("NJ", loadImage("NewJersey.png"));
    stateImages.put("NM", loadImage("NewMexico.png"));
    stateImages.put("NY", loadImage("NewYork.png"));
    stateImages.put("NC", loadImage("NorthCarolina.png"));
    stateImages.put("ND", loadImage("NorthDakota.png"));
    stateImages.put("OH", loadImage("Ohio.png"));
    stateImages.put("OK", loadImage("Oklahoma.png"));
    stateImages.put("OR", loadImage("Oregon.png"));
    stateImages.put("PA", loadImage("Pennsylvania.png"));
    stateImages.put("RI", loadImage("RhodeIsland.png"));
    stateImages.put("SC", loadImage("SouthCarolina.png"));
    stateImages.put("SD", loadImage("SouthDakota.png"));
    stateImages.put("TN", loadImage("Tennessee.png"));
    stateImages.put("TX", loadImage("Texas.png"));
    stateImages.put("UT", loadImage("Utah.png"));
    stateImages.put("VT", loadImage("Vermont.png"));
    stateImages.put("VA", loadImage("Virginia.png"));
    stateImages.put("WA", loadImage("Washington.png"));
    stateImages.put("WV", loadImage("WestVirginia.png"));
    stateImages.put("WI", loadImage("Wisconsin.png"));
    stateImages.put("WY", loadImage("Wyoming.png"));
    stateColors = heatmapNormaliser.normalise(lhm);
  }

  void drawFullHeatMap() {
    checkHover();
    drawHoverDebug();  //for checking box position
    fill(colourArray[0]);
    rect(SCREENX-MARGIN-10, SCREENY-MARGIN-40, 20, 20);
    fill(colourArray[2]);
    rect(SCREENX-MARGIN-10, SCREENY-MARGIN-10, 20, 20);
    textAlign(RIGHT);
    fill(255);
    text("Least Flights", SCREENX-MARGIN-15, SCREENY-MARGIN-25);
    text("Most Flights", SCREENX-MARGIN-15, SCREENY-MARGIN+5);
    for (String state : stateImages.keySet()) {

      PImage stateImage = stateImages.get(state);

      PVector position = stateCoordinates.get(state);

      if (position != null)
      {
        drawStateImage(stateImage, state, position.x, position.y);
      }
    }

    fill(255);
    textAlign(LEFT);
    textSize(16);

    if (!hoveredState.equals("")) {
      text(hoveredState, 20, 30);
    }
  }

  void drawStateImage(PImage stateImage, String stateName, float xPos, float yPos)
  {
    int value = 0;
    if (stateColors.containsKey(stateName)) {
      value = (int) stateColors.get(stateName);
    }
    //mapping value to a colour - blue -> magenta

    color stateColor = lerpColor(colourArray[0], colourArray[2], map(value, 0, 100, 0, 1)); // 5 = value input
    tint(stateColor); //apply colour to state img
    image(stateImage, xPos, yPos);
    noTint(); //reset tint
  }

  void drawHoverDebug() {  // delete after finished
  noFill();
  stroke(0, 0, 0);

  for (String state : hoverBounds.keySet()) {

    float[] b = hoverBounds.get(state);
    String shape = hoverShape.get(state);

    float x = b[0];
    float y = b[1];
    float w = b[2];
    float h = b[3];

    // default angle = 0 (no rotation)
    float angle = 0;
    if (b.length > 4) {
      angle = b[4];
    }

    if (shape.equals("rect")) {

      rect(x, y, w, h);

    } else if (shape.equals("ellipse")) {

      pushMatrix();
      translate(x + w/2, y + h/2); // move to center
      rotate(angle);               // rotate
      ellipse(0, 0, w, h);         // draw centered ellipse
      popMatrix();

    }
  }

  noStroke();
}

  void checkHover() {
    hoveredState = "";

    for (String state : hoverBounds.keySet()) {

      float[] b = hoverBounds.get(state);
      String shape = hoverShape.get(state);

      float x = b[0];
      float y = b[1];
      float w = b[2];
      float h = b[3];

      // default angle = 0 (no rotation)
      float angle = 0;
      if (b.length > 4) {
        angle = b[4];
      }

      if (shape.equals("rect")) {

        if (mouseX >= x && mouseX <= x + w &&
          mouseY >= y && mouseY <= y + h) {
          hoveredState = state;
        }
      } else if (shape.equals("ellipse")) {

        // center of ellipse
        float cx = x + w/2;
        float cy = y + h/2;

        // translate mouse into ellipse space
        float dx = mouseX - cx;
        float dy = mouseY - cy;

        // rotate mouse BACK (inverse rotation)
        float rotatedX = dx * cos(-angle) - dy * sin(-angle);
        float rotatedY = dx * sin(-angle) + dy * cos(-angle);

        // ellipse hit test
        if ((rotatedX * rotatedX) / (w*w/4) +
          (rotatedY * rotatedY) / (h*h/4) <= 1) {
          hoveredState = state;
        }
      }
    }
  }
}
