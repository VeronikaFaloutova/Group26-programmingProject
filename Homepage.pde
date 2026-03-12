PShape plane;

String[] names = {
  "Back",
  "Unfiltered",
  "Cancelled",
  "Delayed",
  "Diverted",
};

float t = 0;
float cloudOffset = 0;
float cameraZ = 0;

int starCount = 180;
float[] starX = new float[starCount];
float[] starY = new float[starCount];
float[] starBrightness = new float[starCount];

float offsetX = 0;
float offsetY = 0;

void settings(){
  size(600, 400, P3D);
  pixelDensity(displayDensity());  
}

void setup(){
  plane = loadShape("11803_Airplane_v1_l1.obj"); 
  frameRate(60);

  for(int i = 0; i < starCount; i++){
    starX[i] = random(width);
    starY[i] = random(height);

    float r = random(1);
    if(r < 0.1){
      starBrightness[i] = random(400, 600);
    } 
    else if(r < 0.3){
      starBrightness[i] = random(150, 200);
    } 
    else{
      starBrightness[i] = random(50, 100);
    }
  }
}

void draw(){

  background(5, 8, 20);
  ambientLight(25, 25, 40);
  directionalLight(100, 100, 140, -1, -1, -0.3);

  offsetX += 2.0; //sky move
  offsetY += 1.8;

  hint(DISABLE_DEPTH_TEST);
  strokeWeight(1);

  for(int i = 0; i < starCount; i++){
    float x = (starX[i] + offsetX) % width;
    float y = (starY[i] + offsetY) % height;
    stroke(starBrightness[i]);
    point(x, y);
  }

  hint(ENABLE_DEPTH_TEST);

  cameraZ = lerp(cameraZ, -300, 0.01);

  t = frameCount * 0.08;  // fly far away
  float swayX = sin(t) * radians(4.0);
  float swayZ = sin(t * 0.6) * radians(2.0);
  float floatY = sin(t) * 5;

  pushMatrix();
  translate(width/2, height/2 + floatY, cameraZ);
  scale(0.15);
  rotateX(radians(95) + swayX);
  rotateZ(radians(130) + swayZ);
  rotateY(radians(-25));
  rotateX(radians(-12));

  shape(plane);

  float cycle = frameCount % 30;
  float flash = (cycle < 5 || (cycle > 10 && cycle < 15)) ? 1 : 0;

  pushMatrix();
  translate(0, 0, -140);
  emissive(255,255,255);
  fill(255,255,255);
  sphere(14);

  if(flash == 1){

    hint(DISABLE_DEPTH_MASK);   

    noStroke();
    fill(10,255,100);
    sphere(20);
    int layers = 22;
    float maxLength = -1300;   
    float maxRadius = 140;

    for(int i = 1; i <= layers; i++){
      float tt = i / float(layers);
      float z = maxLength * tt;
      float radius = maxRadius * tt;

      fill(255,255,255, 5 * (1 - tt));

      beginShape(TRIANGLE_FAN);
      vertex(0, 0, 0);

      int steps = 160;
      for(int a = 0; a <= steps; a++){
        float angle = TWO_PI * a / steps;
        float x = cos(angle) * radius;
        float y = sin(angle) * radius;
        vertex(x, y, z);
      }
      endShape();
    }

    hint(ENABLE_DEPTH_MASK);
  }

  popMatrix();
  emissive(0,0,0);
  popMatrix();

  cloudOffset += 0.002;

  hint(DISABLE_DEPTH_TEST);
  loadPixels();

  int d = displayDensity(); 

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {

      float base = noise(x * 0.0025, y * 0.0025 + cloudOffset);
      float detail = noise(x * 0.01, y * 0.01 + cloudOffset * 2.0);
      float cloudValue = base * 0.75 + detail * 0.25;

      float density = pow(cloudValue, 3.0);
      float alpha = density * 70;

      color cloudColor = color(210, 225, 255);

      for(int dy = 0; dy < d; dy++){
        for(int dx = 0; dx < d; dx++){

          int index = (x*d + dx) + (y*d + dy) * width * d;
          pixels[index] = lerpColor(pixels[index], cloudColor, alpha / 255.0);
        }
      }
    }
  }

  updatePixels();
  hint(ENABLE_DEPTH_TEST);
  drawUI();
}

void drawUI(){

  blendMode(BLEND);
  noLights();
  hint(DISABLE_DEPTH_TEST);
  rectMode(CENTER);
  noStroke();

  float boxWidth = width * 0.85;
  float boxHeight = 380;
  float x = width/2;
  float y = height - boxHeight/2 - 10;

  fill(255, 255, 255, 40);
  rect(x, y, boxWidth, boxHeight, 30);

  fill(255,255,255,20);
  rect(x, y - boxHeight/3, boxWidth*0.95, boxHeight*0.2, 20);

  hint(ENABLE_DEPTH_TEST);
}
