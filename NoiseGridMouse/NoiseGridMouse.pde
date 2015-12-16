/**
Draws a grid of boxes, with an amount of noise added to their size based on proximity 
of the mouse to their position.
*/


/** if running on high-dpi display (eg retina mac), set this to true before running. */
boolean hdpi = false;

/** determines the frequency of noise by scaling the parameters that will be used to query it */
float noiseScale = 0.01;


//////////////////////////// mouse smoothing stuff.

/** these will be used for storing smoothed (exponential-lag) versions of mouse coorinates */
float sMouseX = 0, sMouseY = 0;
/** called once per frame to move the current 'smoothed' coordinates part of the way towards
the current real mouse coordinates.
*/
void smoothMouse() {
  sMouseX = lerp(sMouseX, mouseX, 0.1);
  sMouseY = lerp(sMouseY, mouseY, 0.1);
}
/**
* Draw a small sphere at the 'smoothed' mouse coordinates.
* Disables depth testing so that it will not be hidden by the boxes.
*/
void drawMouse() {
  hint(DISABLE_DEPTH_TEST);
  translate(sMouseX, sMouseY, 0);
  sphere(3);
  //I'd like to be able to 'pop' back to the previous depth test setting...
  //can't see how to do that with Processing (other than maybe by calling 
  //lower level glPush/PopAttribBits)... so I'm going to assume that re-enabling
  //depth test will be the right thing (I could use the convention that any code
  //which specifically cares about depth test etc. hints will set them explicitly
  //rather than assuming that they will be returned to a 'default state').
  hint(ENABLE_DEPTH_TEST);
}
/** calculate Euclidean distance from a coordinate x,y to our smoothed mouse coordinates */
float distanceToSMouse(int x, int y) {
  float dx = sMouseX - x;
  float dy = sMouseY - y;
  return sqrt((dx*dx)+(dy*dy));
}


///////////////////////// the main body of the sketch

void setup() {
  size(800, 800, P3D);
  if (hdpi) { //normally I would put a simple expression like this on one line,
  // but processing seems to get confused if I don't put the {} around this code block.
    pixelDensity(2); 
  }
}

void draw() {
  background(100);
  smoothMouse();
  //noiseScale = 0.1*mouseX/(float)width;
  //rather than translating by half-grid-size (40), I'm going to
  //start my iterration at that position, so that the x,y coordinates
  //I use for drawing boxes will correspond to the ones for mouse coords.
  //translate(40, 40, 0);
  for (int x=40; x<800; x+=80) {
    for (int y=40; y<800; y+=40) {
      pushMatrix();
      translate(x, y, 0);
      float s = 1. - min(distanceToSMouse(x, y)/300f, 1f);
      s *= 80;
      box(20 + s*noise(x*noiseScale, y*noiseScale, 0));
      popMatrix();
    }
  }
  drawMouse();
}


void mouseClicked() {
  noiseSeed(mouseX);
}