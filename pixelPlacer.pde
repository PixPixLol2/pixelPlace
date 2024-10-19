float W_W = 1000;
float W_H = 1000;

float gridW = W_W;
float gridH = W_H;

color[] pixelColors = {
  color(255, 255, 255),
  color(0, 0, 0)
};

String[] pixelData = {
  ". . . . . . . . . . . . . . . .",
  ". . . . . . . . . . . . . . . .",
  ". . f f f f f . f f f f f . . .",
  ". . . . . . . . . . . . . . . .",
  ". . . . f . . . . . f . . . . .",
  ". . . . . . . . . . . . . . . .",
  ". . . . . . . . . . . . . . . .",
  ". . f . . . . . . . . . f . . .",
  ". . f f f f f f f f f f f . . .",
  ". . f . . . . . . . . . f . . .",
  ". . . . . . f f f . . . . . . .",
  ". . . . . . . . . . . . . . . .",
  ". . . . . . . . . . . . . . . .",
  ". . . . . . . . . . . . . . . .",
  ". . . . . . . . . . . . . . . .",
  ". . . . . . . . . . . . . . . ."
};

float camRadius = 800; // Adjusted for zoom
float camAngle = 0;
float camSpeed = 0.02;

PImage bg;

int cols, rows;
float[][] startX, startY, endX, endY, progress;

void settings() {
  size(1000, 1000, P3D);
}

void setup() {
  bg = loadImage("bg.png");

  rows = pixelData.length;
  cols = pixelData[0].length() / 2;

  startX = new float[rows][cols];
  startY = new float[rows][cols];
  endX = new float[rows][cols];
  endY = new float[rows][cols];
  progress = new float[rows][cols];

  float boxSize = min(gridW / rows, gridH / cols);

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      startX[i][j] = random(-W_W, W_W);
      startY[i][j] = random(-W_H, W_H);
      endX[i][j] = j * boxSize - gridW / 2;
      endY[i][j] = i * boxSize - gridH / 2;
      progress[i][j] = 0;
    }
  }
}

void draw() {
  background(bg);
  lights();
  
  float camX = cos(camAngle) * camRadius;
  float camZ = sin(camAngle) * camRadius;
  camera(camX, -600, camZ, 0, 0, 0, 0, 1, 0); // Adjusted for zoom
  camAngle += camSpeed;
  
  drawGrid();
}

void drawGrid() {
  float boxSize = min(gridW / rows, gridH / cols);

  for (int i = 0; i < rows; i++) {
    String[] row = split(pixelData[i], ' ');
    for (int j = 0; j < cols; j++) {
      char pixelChar = row[j].charAt(0);
      color pixelColor = (pixelChar == 'f') ? pixelColors[1] : pixelColors[0];

      float t = (1 - cos(progress[i][j] * PI)) / 2; 
      float x = lerp(startX[i][j], endX[i][j], t);
      float y = lerp(startY[i][j], endY[i][j], t);

      pushMatrix();
      translate(x, y, 0);
      fill(pixelColor);
      noStroke();
      box(boxSize * 0.9);
      popMatrix();

      progress[i][j] = min(1, progress[i][j] + 0.002); 
    }
  }
}
