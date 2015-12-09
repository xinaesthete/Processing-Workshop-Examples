void setup() {
  size(1200, 720, P3D);
  colorMode(HSB, 1);
  pixelDensity(2);
}

void draw() {
  background(0.3, 0.3, 0.2);
  pushMatrix();
  translate(width/2, height/2, 0);
  noStroke();
  float n = 20;
  for (int i=0; i<n; i++) {
    rotateZ(2*PI/n);
    pushMatrix();
    for (int j=0; j<20; j++) {
      fill(i/n, j/20.f, 1);
      translate(20, 0, 0);
      rotateZ(0.1 * sin(frameCount*0.1f));
      scale(0.9, 1.1, 1);
      sphere(10);
    }
    popMatrix();
  }
  popMatrix();
}