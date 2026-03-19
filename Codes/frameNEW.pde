class Frame {
  
  String title = "Default title";
  String labelX = "X-axis";
  String labelY = "Y-axis";
  
  Frame() {
  }
  
  void draw() {
    // 只保留底部一句
    textAlign(CENTER, CENTER);
    fill(170, 180, 190);
    textSize(26);
    text("Flight numbers from origin state", SCREENX / 2, SCREENY - 34);
  }
  
  void setTitle(String title) {
    this.title = title;
  }
  
  void setLabelX(String labelX) {
    this.labelX = labelX;
  }
  
  void setLabelY(String labelY) {
    this.labelY = labelY;
  }
}
