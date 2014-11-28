import controlP5.*;  //<>//
import processing.serial.*;
////import http.requests.*;
//import org.apache.http.client.methods.HttpPost;
//import org.apache.http.client.methods.HttpGet;
//import org.apache.http.client.HttpClient;
//import org.apache.http.impl.client.HttpClientBuilder;
//import org.apache.http.HttpResponse;
//import org.apache.http.HttpStatus;
//import org.apache.http.util.EntityUtils;
//import org.apache.http.client.ClientProtocolException;

Serial myPort;        
String inData[] = new String[1];
int mode = 0;
int time0, time1;
int sectorIndex = 0, lightIndex = 0, lightTimer, countDown, reactionTime, reactionTime0, reactionTime1, r;
boolean serialData = false;
boolean redON, greenON, blueON, yellowON, recieveData, running, jumpStart, jumpEnable, lightsFinished, serial;
boolean serialSent = false;
int lightFlash;
String timeArray[] = new String[6];
String postData[] = new String[9];
boolean pNameSet = false;
String pName = "";
String pBarcode;
String barcode;
int currentPerson;
int count = 0;
String total;
String name;
float data[][] = new float[50][9];
float sortList[] = new float[50];
String names[] = new String[50];
String songs[] = new String[50];
String barcodes[] = new String[50];
float srData[][] = new float[150][2];
boolean nameSet = false;
boolean sect1min = false;
boolean sect2min = false;
boolean sect3min = false;
boolean sect4min = false;
boolean totalmin = false;
float min[] = new float[9];
float max[] = new float[9];
int sortListPos[] = new int[50];
boolean firstClick = true;
String typing = "";
String player = "";
boolean nameGood = false;
int srIndex;
int selection;
ControlP5 cp5;
ListBox l;

int cnt=0;

PFont f1, f2, f3, f4, f5, f6;
int index;
int valueX = 0;
int valueY = 0;
boolean sortFastest = true;
boolean justShoot = false;
color c2 = color(255, 220, 0), c1 = color(255, 50, 255), c3 = c1, c4 = c1;
int boxX = 1000, boxY = 20, boxSize = 15;
int box1X = 1000, box1Y = 230;

float[] list = new float[0];
float[] etlist = new float[0];
float rank;
float percentage;
int trapDistance = 1000;
int SgraphH = 38; //Speed graph scale
int ETgraphH = 1500000; //ET graph scale
int totalLength = 12000;
float averageSpeed;

void setup() {
  size(1280, 700);
  frame.setTitle("Australia Day 2015");
  index = 0;

  String loadlist[] = loadStrings("list.txt");
  for (int i = 0; i < loadlist.length; i++) {
    String[] split = split(loadlist[i], ',');
    for (int j = 0; j < 9; j++) {
      data[i][j] = float(split[j]);
    }
    index++;
  }

  String loadsrlist[] = loadStrings("srList.txt");
  for (int i = 0; i < loadsrlist.length; i++) {
    String[] split = split(loadsrlist[i], ',');
    for (int j = 0; j < 2; j++) {
      srData[i][j] = float(split[j]);
    }
    srIndex++;
  }

  // Import Names
  String nameString[] = loadStrings("names.txt");
  for (int i = 0; i < nameString.length; i++) {
    String[] split = split(nameString[i], ',');
    names[i] = split[0];
    barcodes[i] = split[1];
  }

  // Import barcodes
  //  String barcodeString[] = loadStrings("barcodes.txt");
  //  for (int i = 0; i < barcodeString.length; i++) {
  //    barcodes[i] = barcodeString[i];
  //  }

  //Create fonts
  f1 = createFont("Calibri", 50);
  f2 = createFont("Calibri Bold", 20);
  f3 = createFont("Calibri Bold", 17);
  f4 = createFont("Arial Unicode MS", 15);
  f5 = createFont("Arial Unicode MS", 15);
  f6 = createFont("Arial Unicode MS", 12);

  println(Serial.list());
  if (Serial.list().length > 0) {
    myPort = new Serial(this, Serial.list()[0], 9600);
    myPort.bufferUntil('\n');
    myPort.write("redOFF.greenOFF.blueOFF.");
    myPort.clear();
    serial = true;
  }


  cp5 = new ControlP5(this);
  l = cp5.addListBox("myList")
    .setPosition(6, 21)
      .setSize(120, 500)
        .setItemHeight(15)
          .setBarHeight(15)
            .setColorBackground(color(255, 255, 255))
              .setColorActive(color(50))
                .setColorForeground(color(255, 100, 100))
                  .setColorLabel(color(0));
  ;

  l.captionLabel().toUpperCase(true);
  l.captionLabel().set("Select a Name");
  l.captionLabel().setColor(#000000);
  l.captionLabel().style().marginTop = 3;
  l.valueLabel().style().marginTop = 3;

  for (int i=0;i< nameString.length ;i++) {
    ListBoxItem lbi = l.addItem(names[i], i);
    lbi.setColorBackground(#EAEAEA);
  }

  //Fill array for min times
  for (int i = 0; i < 9; i++) {
    min[i] = 2147483647;
  }  
  
  //Fill array for times times
  for (int i = 0; i < 6; i++) {
    timeArray[i] = "1";
  }
}

void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    String match[] = match(inString, "t");
    if (match != null) {
      time1 = millis() - time0;
      time0 = millis();
      print(inString);
      serialData = true;
      inString = trim(inString);
      String[] split = split(inString, ',');
      for (int i = 0; i < split.length; i++) {
        inData[i] = split[i];
      }
    }
  }
}


void draw() {
  create();

  switch(mode) {
  case 0:  //Set lights for initial position, no barcode set
    redON();
    greenOFF();
    blueOFF();
    yellowOFF();
    mode = 1;
    break;
  case 1: //Check for barcode or name clicked
    if (nameSet) {
      mode = 2;
    }
    break;
  case 2:  //Barcode set
    blueON();
    redOFF();
    mode = 3;
    countDown = millis();
    if (!pNameSet) {
      pName = name;
      pBarcode = barcode;
      pNameSet = true;
      //      data[index][0] = float(barcode);
    }
    break;
  case 3: //Flash run up light 
    if (serialData) {
      jumpStart = true;
      mode = 9;
    }
    if (millis() - lightTimer > 500) {
      lightTimer = millis();
      lightFlash++;
    }
    if (lightFlash % 2 == 1) {
      blueON();
    } 
    else {
      blueOFF();
    }
    if (millis() - countDown > 3000) {
      mode = 4;
      lightFlash = 0;
    }
    break;
  case 4:  //Set lights
    blueOFF();
    greenON();
    reactionTime0 = millis();
    recieveData = true;
    nameSet = false;
    running = true;
    mode = 6;
    break;
  case 5:
    break;
  case 6:  //Recieve Data
    if (serialData) {
      if (sectorIndex == 0) {
        reactionTime = millis() - reactionTime0;
        count++;
      } 
      else {
        if (sectorIndex == 1) {
          String[] split = split(inData[0], " ");
          timeArray[sectorIndex] = str(time1);
          timeArray[0] = split[1];
          count = count+2;
        }
        else {
          timeArray[sectorIndex] = str(time1);
          count++;
        }
      }
      serialData = false;
      sectorIndex++;
      greenOFF();
      yellowON();
    }
    if (sectorIndex >= 5) {
      recieveData = false;
      sectorIndex = 0;
      pNameSet = false;
      running = false;
      formatPostData();
      fillData();
      redON();
      greenOFF();
      blueOFF();
      yellowOFF();
      index++;
      count = 0;
      mode = 8;
    }
    if (jumpStart) {
      mode = 9;
    }
    break;
  case 7:
    break;
  case 8:  //Send Data
    //    int t = millis();
    //    PostRequest post = new PostRequest("https://mickwheelz2-developer-edition.ap1.force.com/straya");
    //    post.addData("rider", postData[0]);
    //    post.addData("reactionTime", postData[1]);
    //    post.addData("speed", postData[2]);
    //    post.addData("et", postData[3]);
    //    post.addData("sector1", postData[4]);
    //    post.addData("sector2", postData[5]);
    //    post.addData("sector3", postData[6]);
    //    post.addData("sector4", postData[7]);
    //    post.addData("totalTime", postData[8]);
    //    post.send();
    mode = 0;
    //    r = millis() - t;
    break;
  case 9:  //Jump start
    recieveData = false;
    sectorIndex = 0;
    nameSet = false;
    pNameSet = false;
    running = false;
    blueOFF();
    if (millis() - lightTimer > 100) {
      lightTimer = millis();
      lightFlash++;
    }
    if (lightFlash % 2 == 1) {
      redON();
    } 
    else {
      redOFF();
    }
    if (lightFlash > 30) {
      mode = 1;
      jumpStart = false;
      lightFlash = 0;
    }
    break;
  }

  //  frame.setTitle(int(frameRate) + " fps");
  //  stroke(225);
  //  fill(225);
  //  rectMode(CORNER);
  //  rect(0, 0, 500, 20);
  //  fill(0);
  //  textFont(f6);
  //  text(mouseX, 130, 20);
  //  text(mouseY, 160, 20);
  //  text(mouseX - valueX, 190, 20);
  //  text(mouseY - valueY, 220, 20);
}

void keyPressed() {

  valueX = mouseX;
  valueY = mouseY;

  if (typing.length() > 4) {
    if (typing.substring(typing.length() - 5).equals("name-")) {
      typing = "";
      nameGood = true;
    }
  }
  if (key == '.' && nameGood == true) {
    player = typing;
    typing = ""; 
    nameGood = false;
    for (int i = 0; i < barcodes.length; i++) {
      if (player.equals(barcodes[i])) {
        firstClick = false;
        int selection = i;
        println(names[selection]);
        l.captionLabel().set(names[selection]);
        data[index][0] = selection;
        name = names[int(data[index][0])];
        barcode = barcodes[selection];
        count = 0;
        nameSet = true;
      }
    }
  }
  else {
    typing = typing + key;
  }
}

void controlEvent(ControlEvent theEvent) {

  if (theEvent.isGroup() && theEvent.name().equals("myList")) {
    selection = (int)theEvent.group().value();
    updateName();
  }
}

void updateName() {
  firstClick = false;
  println(names[selection]);
  l.captionLabel().set(names[selection]);
  data[index][0] = selection;
  name = names[int(data[index][0])];
  barcode = barcodes[selection];
  nameSet = true;
}

void formatPostData() {
  float speed = trapDistance / int(timeArray[0]) * 360;
  int et = int(timeArray[1]) + int(timeArray[2]) + int(timeArray[3]) + int(timeArray[4]);
  int totalTime = et + reactionTime;
  postData[0] = pBarcode;
  postData[1] = str(reactionTime + .0);
  postData[2] = str(speed);
  postData[3] = str(float(timeArray[1]));
  postData[4] = str(float(timeArray[2]));
  postData[5] = str(float(timeArray[3]));
  postData[6] = str(float(timeArray[4]));
  postData[7] = str(et + .0);
  postData[8] = str(totalTime + .0);
}

void fillData() {
  for (int i = 0; i < 9; i++) {
    data[index][i] = float(postData[i]);
  }
}

void create() {

  //Clear screen
  background(0);

  //Text
  fill(255);
  textFont(f1);
  textAlign(CENTER);
  text("Current Session", width/2, 50);
  text("Ranking", width/2, 180);

  //Find Minimum sector time
  for (int j = 0; j < 9; j++) {
    for (int i = 0; i < index; i++) {
      if (data[i][j] < min[j]) {
        min[j] = data[i][j];
      }
    }
  }

  //Find Max sector time
  for (int j = 0; j < 9; j++) {
    for (int i = 0; i < index; i++) {
      if (data[i][j] > max[j]) {
        max[j] = data[i][j];
      }
    }
  }

  //Alternating Bars
  for (int i = 1; i < index + 1 && i < 25; i = i + 2) {
    fill(40);
    stroke(40);
    rectMode(CENTER);
    rect(width/2 - 25, (201 + (i * 20)), 690, 19, 7);
  }
  rect(width/2 - 25, 114, 690, 24, 7);

  //Text for Current Session
  fill(255);
  textFont(f2);
  textAlign(CENTER);
  text("Name", width/2 - (115 * 4) + 57, 96);
  text("Reaction Time", width/2 - (115 * 3) + 57, 96);
  text("Speed", width/2 - (115 * 2) + 57, 96);
  text("Sector 1", width/2 - (115 * 1) + 57, 96);
  text("Sector 2", width/2 - (115 * 0) + 57, 96);
  text("Sector 3", width/2 + (115 * 1) + 57, 96);
  text("Sector 4", width/2 + (115 * 2) + 57, 96);
  text("ET", width/2 + (115 * 3) + 57, 96);
  text("Total Time", width/2 + (115 * 4) + 57, 96);

  //Text for times and name of current session
  if (count == 7 && nameSet == false) {
    for (int i = 1; i < count + 2; i++) {
      //Check for minimum time 
      if (data[index -  1][i] <= min[i]) {
        rectMode(CORNERS);
        fill(c1);
        text(String.format("%.2f", data[index -  1][i]), width/2 - (115 * (4 - i)) + 57, 120);
      } 
      else if (data[index -  1][i] >= max[i]) {
        rectMode(CORNERS);
        fill(c2);
        text(String.format("%.2f", data[index -  1][i]), width/2 - (115 * (4 - i)) + 57, 120);
      } 
      else {
        fill(255);
        text(String.format("%.2f", data[index -  1][i]), width/2 - (115 * (4 - i)) + 57, 120);
      }
    }
    fill(255);
    text(names[int(data[index - 1][0])], width/2 - (115 * 4) + 57, 120);
  } 
  else {
    for (int i = 1; i < count + 1; i++) {
      //Check for minimum time 
      if (data[index][i] <= min[i]) {
        rectMode(CORNERS);
        fill(c1);
//        text(String.format("%.2f", data[index][i]), width/2 - (115 * (4 - i)) + 57, 120);
      } 
      else if (data[index][i] >= max[i]) {
        rectMode(CORNERS);
        fill(c2);
//        text(String.format("%.2f", data[index][i]), width/2 - (115 * (4 - i)) + 57, 120);
      } 
      else {
        fill(255);
//        text(String.format("%.2f", data[index][i]), width/2 - (115 * (4 - i)) + 57, 120);
      }
      text("Hit", width/2 - (115 * (4 - i)) + 57, 120);
    }
    fill(255);
    text(names[int(data[index][0])], width/2 - (115 * 4) + 57, 120);
  }

  //Sort the list for ranking based on total time
  for (int i = 0; i < index; i++) {
    sortList[i] = data[i][8];
  }
  sortList = sort(sortList);

  //Generate a list of the ranked positions
  for (int i = 0; i < index; i++) {
    for (int j = 0; j < index; j++) {
      if (data[j][8] == sortList[i]) {
        sortListPos[i] = j;
      }
    }
  }

  //text for times and names of Ranking
  if (sortFastest) { //For fastest first
    textFont(f3);
    for (int i = 0; i < index && i < 24; i++) {
      fill(255);
      textAlign(LEFT);
      text((i + 1) + ".", width/2 - (115 * 5) + 100, 226 + (20 * i));
      textAlign(CENTER);
      text(names[int(data[sortListPos[i]][0])], width/2 - (115 * 4) + 57, 226 + (20 * i));
      for (int j = 1; j < 8 + 1; j++) {
        //Check for minimum time 
        if (data[sortListPos[i]][j] <= min[j]) {
          rectMode(CORNERS);
          fill(c1);
          //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
          text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        }
        else if (data[sortListPos[i]][j] >= max[j]) {
          rectMode(CORNERS);
          fill(c2);
          //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
          text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        } 
        else {
          fill(255);
          text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        }
      }
    }
    //  println("Got here 5");
  } 
  else { //For slowest first
    textFont(f3);
    for (int i = 0; i < index && i < 24; i++) {
      fill(255);
      textAlign(LEFT);
      text((i + 1) + ".", width/2 - (115 * 5) + 100, 226 + (20 * i));
      textAlign(CENTER);
      text(names[int(data[sortListPos[index-i-1]][0])], width/2 - (115 * 4) + 57, 226 + (20 * i));
      for (int j = 1; j < 8 + 1; j++) {
        //Check for minimum time 
        if (data[sortListPos[index - 1-i]][j] <= min[j]) {
          rectMode(CORNERS);
          fill(c1);
          //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
          text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        }
        else if (data[sortListPos[index - 1-i]][j] >= max[j]) {
          rectMode(CORNERS);
          fill(c2);
          //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
          text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        } 
        else {
          fill(255);
          text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        }
      }
    }
  }


  //Draw box and text for sort selection
  rectMode(CORNER);
  textFont(f3);
  textAlign(LEFT);

  stroke(255);  
  fill(255);
  if (sortFastest) {
    text("Fastest", boxX+20, boxY+13);
  } 
  else {
    text("Slowest", boxX+20, boxY+13);
  }
  fill(c3);
  stroke(50);
  rect(boxX, boxY, boxSize, boxSize);

  //Draw text for Ready
  textFont(f1);
  textAlign(LEFT);
  if (count == 0 && nameSet == true) {
    fill(0, 255, 0);
    text("Ready", 20, 300);
  } 
  else {
    fill(255, 0, 0);
    text("Not Ready", 20, 300);
  }
  //Text for current mode for the swtich
  text(mode, 20, 350);
  //  text(r, 70, 350);
  //  text(pName, 50, 350);

  //Variable lights
  if (nameSet) {
    fill(255, 0, 0);
    //    ellipse(100, 320, 25, 25);
  }

  //Mimic lights
  ellipseMode(CORNER);
  if (redON) {
    fill(255, 0, 0);
  } 
  else { 
    fill(50, 0, 0);
  }
  ellipse(20, 360, 40, 40);
  if (blueON) {
    fill(0, 0, 255);
  }
  else {
    fill(0, 0, 50);
  }
  ellipse(20, 410, 40, 40);
  if (greenON) {
    fill(0, 255, 0);
  }
  else {
    fill(0, 50, 0);
  }
  ellipse(20, 460, 40, 40);
  if (yellowON) {
    fill(255);
  }
  else {
    fill(50);
  }
  ellipse(20, 510, 40, 40);
}

void mousePressed() {
  //Check if Mouse is over button and toggle on
  if (mouseX > boxX && mouseX < boxX+boxSize && mouseY >boxY && mouseY < boxY+boxSize) {
    if (sortFastest) {
      sortFastest = false;
      c3 = c2;
    } 
    else {
      sortFastest = true;
      c3 = c1;
    }
  }
  /*
  if (mouseX > box1X && mouseX < box1X+boxSize && mouseY >box1Y && mouseY < box1Y+boxSize) {
   if (justShoot) {
   justShoot = false;
   c4 = c1;
   } 
   else {
   justShoot = true;
   c4 = c2;
   }
   }
   */
}

void delay(int delay)
{
  int time = millis();
  while (millis () - time <= delay);
}

void greenON() {
  if (!greenON) {
    if (serial) {
      myPort.write("greenON.");
      myPort.clear();
    }
//    println("Green ON");
    greenON = true;
    serialData = false;
  }
}

void greenOFF() {
  if (greenON) {
    if (serial) {
      myPort.write("greenOFF.");
      myPort.clear();
    }
//    println("Green OFF");
    greenON = false;
    serialData = false;
  }
}
void blueON() {
  if (!blueON) {
    if (serial) {
      myPort.write("blueON.");
      myPort.clear();
    }
//    println("Blue ON");
    blueON = true;
    serialData = false;
  }
}

void blueOFF() {
  if (blueON) {
    if (serial) {
      myPort.write("blueOFF.");
      myPort.clear();
    }
//    println("Blue OFF");
    blueON = false;
    serialData = false;
  }
}

void redON() {
  if (!redON) {
    if (serial) {
      myPort.write("redON.");
      myPort.clear();
    }
//    println("Red ON");
    redON = true;
    serialData = false;
  }
}

void redOFF() {
  if (redON) {
    if (serial) {
      myPort.write("redOFF.");
      myPort.clear();
    }
//    println("Red OFF");
    redON = false;
    serialData = false;
  }
}

void yellowON() {
  if (!yellowON) {
    if (serial) {
      myPort.write("yellowON.");
      myPort.clear();
    }
//    println("Yellow ON");
    yellowON = true;
    serialData = false;
    myPort.clear();
  }
}

void yellowOFF() {
  if (yellowON) {
    if (serial) {
      myPort.write("yellowOFF.");
      myPort.clear();
    }
//    println("Yellow OFF");
    yellowON = false;
    serialData = false;
  }
}
