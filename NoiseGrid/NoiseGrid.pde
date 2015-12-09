float noiseScale = 0.01;

void setup() {
  size(800, 800, P3D);
  noiseDetail(8, 0.5);
}

void draw() {
  background(100);
  translate(40, 40, 0);
  for (int x=0; x<800; x+=80) {
    for (int y=0; y<800; y+=80) {
      pushMatrix();
      translate(x, y, 0);
      box(80*noise(x*noiseScale, y*noiseScale, frameCount*noiseScale));
      popMatrix();
    }
  }
}