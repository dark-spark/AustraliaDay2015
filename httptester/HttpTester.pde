int x, y, z, v, u, r;
String postData[] = new String[9];

void setup() {
  size (400, 400);
  for (int i = 0; i > 10; i++) { 
    postData[i] = "100.0";
  }
}

void draw() {
  background(0);
  textSize(50);
  fill(255, 0, 0);
  text(r, 20, 50);
  text(z, 20, 100);
  text(x, 20, 150);
  text(y, 20, 200);
  text(u, 20, 250);
  text(v, 20, 300);
  
}

void mousePressed() {
  int t = millis();
  PostRequest post = new PostRequest("https://mickwheelz2-developer-edition.ap1.force.com/straya");
  post.addData("rider", postData[0]);
  post.addData("reactionTime", postData[1]);
  post.addData("speed", postData[2]);
  post.addData("et", postData[3]);
  post.addData("sector1", postData[4]);
  post.addData("sector2", postData[5]);
  post.addData("sector3", postData[6]);
  post.addData("sector4", postData[7]);
  post.addData("totalTime", postData[8]);
  post.send();
  r = millis() - t;
}
