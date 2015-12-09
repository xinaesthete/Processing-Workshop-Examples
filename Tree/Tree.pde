/**
 * Recursive Tree
 * by Daniel Shiffman.  
 * Slightly modified by Peter Todd.
 * 
 * Renders a simple tree-like structure via recursion. 
 * The branching angle is calculated as a function of 
 * the horizontal mouse location. Move the mouse left
 * and right to change the angle.
 *
 * Move the mouse up and down to change the "growth factor". 
 * Click to print out some stats about how many leaves are 
 * drawn as a function of the growth factor. 
 */
 
float theta;   
int leafCount = 0;
boolean printStats = false;

void setup() {
  size(640, 360);
}

void draw() {
  leafCount = 0;
  background(0);
  frameRate(30);
  stroke(255);
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  float a = (mouseX / (float) width) * 90f;
  // Convert it to radians
  theta = radians(a);
  // Start the tree from the bottom of the screen
  translate(width/2,height);
  // Draw a line 120 pixels
  line(0,0,0,-120);
  // Move to the end of that line
  translate(0,-120);
  // Start the recursive branching!
  branch(120);
  
  if (printStats) {
    println("growth factor: " + getGrowthFactor() + ", leaves: " + leafCount);
    printStats = false;
  }
}

void branch(float h) {
  // Each branch will be at most 3/4s the size of the previous one...
  h *= getGrowthFactor();
  
  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 2) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state
    
    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
  } else {
    leafCount++;
    pushStyle();
    fill(100, 255, 150);
    noStroke();
    h = 2*h;
    ellipse(h, h, h, h);
    popStyle();
  }
}

void mouseClicked() {
  printStats = true;
}

float getGrowthFactor() {
  return Math.min(1.-(mouseY/(float)height), 0.75);//0.66
}