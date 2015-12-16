/**
* Example showing a nested foor loop, with perlin noise used to
* modulate some of the parameters as a function of loop indices.
* 
* Each "shape" that is drawn is itself a nested foor loop with some
* "spikes" made from scaled spheres.
*/

float sMouseX = 0;
float sMouseY = 0;

void smoothMouse() {
  sMouseX = lerp(sMouseX, mouseX, 0.1);
  sMouseY = lerp(sMouseY, mouseY, 0.1);
}


void setup() {
  size(1200, 720, P3D);
  //we'll make use of HSB colouring later on, to change the hue & saturation
  //as a function of 'branch' and 'rib' index, respectively.
  colorMode(HSB, 1); 
  //pixelDensity(2);
  noiseSeed(0);
}

void draw() {
  smoothMouse();
  background(0.3, 0.3, 0.2);
  pushMatrix();
  lights();
  translate(width/2, height/2, 0);
  //rotateY(frameCount * 0.01);
  noStroke();
  
  //scale(10);
  //spikeyThing();
  alienThing();
  
  popMatrix();
}

void alienThing() {
  float n = 6;
  // the rotation at each iteration inside the nested loop will be scaled
  // by this overal base rotation which depends on the mouse
  float baseR = (sMouseX / (float) width) - 0.5;
  //outer loop over 'i' where 'n' is the number of 'branches'
  for (int i=0; i<n; i++) {
    pushMatrix();
    rotateZ(i*2*PI/n);
    //inner loop over 'j' where 20 is the number of 'ribs'
    for (int j=0; j<20; j++) {
      fill(i/n, j/20.f, 1);
      translate(20, 0, 0);
      //noiseSeed(i);
      //rotateZ(0.1 * noise(frameCount*0.01f));
      
      rotateZ(baseR * noise(i, j, frameCount*0.01));
      shininess(j);
      // vary the Y scale between 0.2 & 1.2 as a function of mouseY.
      scale(1, 1.2 - (sMouseY/(float)height), 1);
      pushMatrix();
      //scale(5*noise(i, j, frameCount*0.01));
      scale(5*noise(modelX(0,0,0), modelY(0,0,0), frameCount*0.01));
      spikeyThing();
      popMatrix();
    }
    popMatrix();
  }
}


void spikeyThing() {
  pushMatrix();
  sphereDetail(5);
  sphere(4);
  for (int i=0; i<4; i++) {
    pushMatrix();
    rotateZ(i*2.*PI/4.);
    for (int j=0; j<4; j++) {
      rotate(2.*PI/4., 0.707, 0.707, 0);
      pushMatrix();
      scale(0.1, 1, 0.1);
      sphere(10);
      popMatrix();
    }
    popMatrix();
  }
  popMatrix();
}