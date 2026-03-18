void drawFeatureCards() {
  float y = 540;
  float gap = 12;
  float x0 = 50;
  float cardW = (width - 100 - gap * 3) / 4.0;
  float cardH = 100;

  drawFeatureCard(x0, y, cardW, cardH, "YUN-SEARCH", "Look up flights by route, airport, or flight code.");
  drawFeatureCard(x0 + (cardW + gap), y, cardW, cardH, "ROUTE MAP", "Explore domestic routes and airport connections.");
  drawFeatureCard(x0 + (cardW + gap) * 2, y, cardW, cardH, "STATISTICS", "Visualize status, timing, and route summaries.");
  drawFeatureCard(x0 + (cardW + gap) * 3, y, cardW, cardH, "UNFILTERED", "Project overview, system info, and module guidance.");
}

void drawFeatureCard(float x, float y, float w, float h, String title, String desc) {
  boolean hover = mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;

  noStroke();
  fill(hover ? color(30, 38, 52) : color(19, 24, 34), 245);
  rect(x, y, w, h, 14);

  fill(255, 190, 90);
  rect(x, y, 6, h, 14, 0, 0, 14);

  fill(235, 240, 245);
  textAlign(LEFT, TOP);
  textFont(createFont("Arial Bold", 22));
  text(title, x + 16, y + 12);

  fill(175, 185, 195);
  textFont(createFont("Arial", 16));
  textLeading(18);
  text(desc, x + 16, y + 40, w - 28, h - 12);
}

// ===== click helpers =====

boolean overButton(float x, float y, float w, float h) {
  return mouseX >= x && mouseX <= x + w &&
         mouseY >= y && mouseY <= y + h;
}

boolean clickSearchButton() {
  float y = 540;
  float gap = 12;
  float x0 = 50;
  float cardW = (width - 100 - gap * 3) / 4.0;
  float cardH = 100;

  return overButton(x0, y, cardW, cardH);
}

boolean clickRouteButton() {
  float y = 540;
  float gap = 12;
  float x0 = 50;
  float cardW = (width - 100 - gap * 3) / 4.0;
  float cardH = 100;

  return overButton(x0 + (cardW + gap), y, cardW, cardH);
}

boolean clickStatisticsButton() {
  float y = 540;
  float gap = 12;
  float x0 = 50;
  float cardW = (width - 100 - gap * 3) / 4.0;
  float cardH = 100;

  return overButton(x0 + (cardW + gap) * 2, y, cardW, cardH);
}

boolean clickUnfilteredButton() {
  float y = 540;
  float gap = 12;
  float x0 = 50;
  float cardW = (width - 100 - gap * 3) / 4.0;
  float cardH = 100;

  return overButton(x0 + (cardW + gap) * 3, y, cardW, cardH);
}

boolean clickBackButton() {
  float backX = 60;
  float backY = 620;
  float backW = 140;
  float backH = 42;

  return overButton(backX, backY, backW, backH);
}
