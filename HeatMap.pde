import java.util.HashMap;
import java.util.Map;

class HeatMap {

  Map<String, PImage> stateImages;
  HashMap<String, Integer> stateColors;
  HashMap<String, PVector> stateCoordinates = new HashMap<String, PVector>();

  HeatMap(LinkedHashMap<String, Integer> lhm) {
    
    //-70 on y axis from previous code

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
    fill(colourArray[0]);
    rect(SCREENX-MARGIN-10, SCREENY-MARGIN-40,20,20);
    fill(colourArray[2]);
    rect(SCREENX-MARGIN-10, SCREENY-MARGIN-10,20,20);
    textAlign(RIGHT);
    fill(0);
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
  }

  void drawStateImage(PImage stateImage, String stateName, float xPos, float yPos)
  {
    int value = 0;
    if (stateColors.containsKey(stateName)) {
      value = (int) stateColors.get(stateName);
    }
    //mapping value to a colour - green -> red
 
    color stateColor = lerpColor(colourArray[0], colourArray[2], map(value, 0, 100, 0, 1)); // 5 = value input
    tint(stateColor); //apply colour to state img
    image(stateImage, xPos, yPos);
    noTint(); //reset tint
  }
}
