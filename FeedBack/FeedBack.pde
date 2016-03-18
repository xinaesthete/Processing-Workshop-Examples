/**
  Video feedback with kaleidoscope shader.
  Fiddling with the shaders can get different effects...
  
  At time of writing, very basic UI etc.

  Peter Todd 2016
 */

import controlP5.*;

ControlP5 cp5;
float leaves = 6, angle = 0, zoom = 5, inputImgScale = 1;
PVector centre = new PVector(0.5, 0.5);
Slider2D centreSlider, imgCSlider, inputImgOff;

PImage inputImg;
PGraphics frontBuf, backBuf;
int res = 3000;

boolean doSaveHD = false;

PShader kaleider, presenter;

void setup() {
  //size(1200, 800, P3D);
  fullScreen(P3D, 2);
  inputImg = loadImage("patchdesign2.png");
  frontBuf = createGraphics(res*3/2, res, P3D);
  backBuf = createGraphics(res*3/2, res, P3D);
  kaleider = loadShader("kaleid.glsl");
  presenter = loadShader("present.glsl");
  setupGUI();
}

void setupGUI() {
  cp5 = new ControlP5(this);
  int x = 10, y = 10, yInc = 20;
  cp5.addSlider("leaves").setPosition(x, y).setRange(3, 10).setNumberOfTickMarks(8);
  y += yInc;
  cp5.addSlider("angle").setPosition(x, y).setRange(-PI, PI);
  y += yInc;
  cp5.addSlider("zoom").setPosition(x,y).setRange(0.8, 2);
  y += yInc;
  centreSlider = cp5.addSlider2D("centre").setPosition(x,y)
    .setMinMax(0,0,1,1).setValue(0.5, 0.5);
  y += centreSlider.getHeight() + 3;
  imgCSlider = cp5.addSlider2D("imageCentre").setPosition(x,y).setMinMax(-0.5,-0.5,1.5,1.5);
  y += imgCSlider.getHeight() + 3;
  cp5.addSlider("inputImgScale").setPosition(x,y).setRange(0f, 1f);
  y+= yInc;
  inputImgOff = cp5.addSlider2D("inputImgOff").setPosition(x,y).setMinMax(0, 0, 1, 1);
}


void setShaderUniforms() {
  kaleider.set("segAng", PI*2f/leaves);
  kaleider.set("Angle", angle);
  kaleider.set("Zoom", zoom);
  centre.x = centreSlider.getArrayValue()[0];
  centre.y = centreSlider.getArrayValue()[1];
  kaleider.set("Centre", centre.x, centre.y);
  float x = imgCSlider.getArrayValue()[0];
  float y = imgCSlider.getArrayValue()[1];
  kaleider.set("ImageCentre", x, y);
  //kaleid.set("UVLimit", 1, imgAspect);
  //texture(img);
  //kaleid.set("texture", img); //should be automatic
  //edges.set("effectStrength", 1);
}


void draw() {
  if (doSaveHD) saveHD();
  setShaderUniforms();
  drawIntoFeedback();
  drawToScreen();
  swapBuffers();
}

void drawIntoFeedback(){
  PGraphics g = backBuf;
  g.beginDraw();
  g.background(0);
  g.textureMode(REPEAT);
  g.shader(kaleider);
  g.image(frontBuf, 0, 0, g.width, g.height);
  g.resetShader();
  float[] offset = inputImgOff.getArrayValue();
  float s = inputImgScale, w = g.width, h = g.height;
  //inputImg = cam;
  g.image(inputImg, offset[0]*w, offset[1]*h, s*w, s*w);
  //g.pushStyle();
  //g.noFill();
  //g.stroke(20, 255, 255, 255);
  //g.rect(0, 0, g.width, g.height);
  //g.popStyle();
  g.endDraw();
}

void swapBuffers() {
  PGraphics temp = frontBuf;
  frontBuf = backBuf;
  backBuf = temp;
}

void drawToScreen(){
  //fractaleid uses 50/50 blend of both buffers in shader, mostly to counteract
  //rapid flashing as colours are negated every frame.
  //could also potentially have variations to interpret colour differently
  //eg main shader increments, then 'presenter' shader references some other
  //function, lookup table etc.
  shader(presenter);
  presenter.set("textureB", frontBuf);
  image(backBuf, 0, 0, width, height);
  resetShader();
}

int frameCount = 0;
void saveHD() {
  backBuf.save("design_code"+ ++frameCount + ".png");
  println("saved screenshot");
  doSaveHD = false;
}

void keyPressed() {
  //space bar to save //TODO: number to save to slot...
  if (key == 32) doSaveHD = true;
}