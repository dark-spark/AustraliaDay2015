int imageWidth = 23;
int imageHeight = 19;
int mode = 1;
int timer;

void setup() {
  size(500, 500);
}

void draw() {

  frame.setTitle("FPS = " + int(frameRate));

  background(255);

  color black = color(255,0,0);
  
  if (millis() - timer >= 2000) {
    mode += 1;
    timer = millis();
  }
  if (mode > 3) {mode = 1;};

  if(mode == 1) {
  drawPixelArray(brokenHeart, black, 200, 200, 2);
  } else if(mode == 2) {
  drawPixelArray(smallHeart, black, 200, 200, 2);
  } else if(mode == 3) {
  drawPixelArray(bigHeart, black, 200, 200, 2);
  }
}

void drawPixelArray(int[][] image, color color1, int posx, int posy, int multiplier) {

  fill(color1);
  stroke(color1);
  
  for (int i = 0; i < brokenHeart[0].length; i++) {
    for (int j = 0; j < brokenHeart.length; j++) {
      if (image[j][i] > 0) {
        rect((i*multiplier) + posx, (j*multiplier) + posy, multiplier, multiplier);
      }
    }
  }
}


void delay(int delay)
{
  int time = millis();
  while (millis () - time <= delay);
}
