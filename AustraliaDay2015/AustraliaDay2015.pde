import controlP5.*;  //<>//
import processing.serial.*;
import http.requests.*;

Serial myPort;        
String inData[] = new String[1];
int mode = 0;
int time0, time1;
int sectorIndex = 0, lightIndex = 0, lightTimer, countDown, reactionTime, reactionTime0, reactionTime1;
boolean serialData = false;
boolean redON, redOFF, greenON, greenOFF, blueON, blueOFF, recieveData, running, jumpStart, lightsFinished, serial;
boolean serialSent = false;
int lightFlash;
String sectorTime[] = new String[6];
String postData[] = new String[9];
boolean pNameSet = false;
String pName;
int currentPerson;
int count = 0;
String total;
String name;
float data[][] = new float[50][6];
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
float min[] = new float[6];
float max[] = new float[6];
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
int boxX = 1000, boxY = 210, boxSize = 15;
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
    for (int j = 0; j < 6; j++) {
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
  for (int i = 0; i< 6; i++) {
    min[i] = 1000;
  }
}

void serialEvent (Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    String js[] = match(inString, "jump");
    String match[] = match(inString, "t");
    if (running && js != null) {
      jumpStart = true;
    }
    if (match != null) {
      time1 = millis() - time0;
      time0 = millis();
      println(inString);
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
  case 0:  //Barcode not set
    redON();
    greenOFF();
    blueOFF();
    mode = 1;
    break;
  case 1: 
    break;
  case 2:  //Barcode set
    blueON();
    redOFF();
    mode = 3;
    countDown = millis();
    break;
  case 3:
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
    if (serialData == true) {
      if (sectorIndex == 0) {
        reactionTime1 = millis() - reactionTime0;
        String[] split = split(inData[0], " ");
        sectorTime[sectorIndex] = split[1];
        reactionTime = reactionTime1 - int(sectorTime[0]);
      } 
      else {
        sectorTime[sectorIndex] = str(time1);
      }
      serialData = false;
      sectorIndex++;
      greenOFF();
      redON();
      if (!pNameSet) {
        pName = name;
        pNameSet = true;
      }
    }
    if (sectorIndex >= 4) {
      recieveData = false;
      sectorIndex = 0;
      pNameSet = false;
      formatPostData();
      running = false;
      mode = 8;
    }
    break;
  case 7:
    break;
  case 8:  //Send Data
    PostRequest post = new PostRequest("https://mickwheelz2-developer-edition.ap1.force.com/straya/services/apexrest/SlideRun");
    post.addData("id", postData[0]);
    post.addData("reactionTime", postData[1]);
    post.addData("speed", postData[2]);
    post.addData("et", postData[3]);
    post.addData("sector1", postData[4]);
    post.addData("sector2", postData[5]);
    post.addData("sector3", postData[6]);
    post.addData("totalTime", postData[7]);
    post.addData("jumpStart", postData[8]);
    post.send();
    mode = 0;
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

void greenON() {
  if (!greenON) {
    if (serial) {
      myPort.write("greenON.");
      myPort.clear();
    }
    println("Green ON");
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
    println("Green OFF");
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
    println("Blue ON");
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
    println("Blue OFF");
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
    println("Red ON");
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
    println("Red OFF");
    redON = false;
    serialData = false;
  }
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
        count = 0;
        if (firstClick == false) {
          if (nameSet == false) {
            //            index++;
          }
        }
        nameSet = true;
        serialSent = false;
        mode = 1;
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
  if (firstClick == false) {
    if (nameSet == false) {
      //      index++;
    }
  }
  firstClick = false;
  println(names[selection]);
  l.captionLabel().set(names[selection]);
  data[index][0] = selection;
  name = names[int(data[index][0])];
  count = 0;
  nameSet = true;
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

void formatPostData() {
  float speed = trapDistance / int(sectorTime[0]) * 360;
  int et = int(sectorTime[0]) + int(sectorTime[1]) + int(sectorTime[2]) + int(sectorTime[3]);
  int firstSector = int(sectorTime[0]) + int(sectorTime[1]);
  int totalTime = et + reactionTime;
  postData[0] = pName;
  postData[1] = str(reactionTime);
  postData[2] = str(speed);
  postData[3] = str(et);
  postData[4] = str(firstSector);
  postData[5] = sectorTime[2];
  postData[6] = sectorTime[3];
  postData[7] = str(totalTime);
  if (jumpStart) {
    postData[8] = "1";
  }
  else {
    postData[8] = "0";
  }
}

void setLight(String light, boolean state) {

  myPort.write(light);
  if (state) {
    myPort.write("ON.");
  } 
  else {
    myPort.write("OFF.");
  }

  if (light == "red") {
    if (state) {
      redON = true;
    } 
    else { 
      redON = false;
    }
  } 
  else if (light == "blue") {
    if (state) {
      blueON = true;
    } 
    else { 
      blueON = false;
    }
  } 
  else if (light == "green") {
    if (state) {
      greenON = true;
    } 
    else { 
      greenON = false;
    }
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
  for (int j = 0; j <6; j++) {
    for (int i = 0; i < index; i++) {
      if (data[i][j] < min[j]) {
        min[j] = data[i][j];
      }
    }
  }

  //Find Max sector time
  for (int j = 0; j <6; j++) {
    for (int i = 0; i < index; i++) {
      if (data[i][j] > max[j]) {
        max[j] = data[i][j];
      }
    }
  }

  if (!justShoot) { //////////////////////////////////////////////Normal Stuff//////////////////////////////////////////////////////////
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
    text("Name", width/2 - (115 * 3) + 57, 96);
    text("Sector 1", width/2 - (115 * 2) + 57, 96);
    text("Sector 2", width/2 - (115 * 1) + 57, 96);

    text("Sector 3", width/2 - (115 * 0) + 57, 96);
    text("Sector 4", width/2 + (115 * 1) + 57, 96);
    text("Total Time", width/2 + (115 * 2) + 57, 96);

    //Text for times and name of current session
    if (count == 5 && nameSet == false) {
      for (int i = 1; i < count + 1; i++) {
        //Check for minimum time 
        if (data[index -  1][i] <= min[i]) {
          rectMode(CORNERS);
          fill(c1);
          text(String.format("%.2f", data[index -  1][i]), width/2 - (115 * (3 - i)) + 57, 120);
        } 
        else if (data[index -  1][i] >= max[i]) {
          rectMode(CORNERS);
          fill(c2);
          text(String.format("%.2f", data[index -  1][i]), width/2 - (115 * (3 - i)) + 57, 120);
        } 
        else {
          fill(255);
          text(String.format("%.2f", data[index -  1][i]), width/2 - (115 * (3 - i)) + 57, 120);
        }
      }
      fill(255);
      text(names[int(data[index - 1][0])], width/2 - (115 * 3) + 57, 120);
    } 
    else {
      for (int i = 1; i < count + 1; i++) {
        //Check for minimum time 
        if (data[index][i] <= min[i]) {
          rectMode(CORNERS);
          fill(c1);
          text(String.format("%.2f", data[index][i]), width/2 - (115 * (3 - i)) + 57, 120);
        } 
        else if (data[index][i] >= max[i]) {
          rectMode(CORNERS);
          fill(c2);
          text(String.format("%.2f", data[index][i]), width/2 - (115 * (3 - i)) + 57, 120);
        } 
        else {
          fill(255);
          text(String.format("%.2f", data[index][i]), width/2 - (115 * (3 - i)) + 57, 120);
        }
      }
      fill(255);
      text(names[int(data[index][0])], width/2 - (115 * 3) + 57, 120);
    }

    //Text for name of current session

    //Sort the list for ranking based on total time
    for (int i = 0; i < index; i++) {
      sortList[i] = data[i][5];
    }
    sortList = sort(sortList);

    //Generate a list of the ranked positions
    for (int i = 0; i < index; i++) {
      for (int j = 0; j < index; j++) {
        if (data[j][5] == sortList[i]) {
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
        text((i + 1) + ".", width/2 - (115 * 4) + 100, 226 + (20 * i));
        textAlign(CENTER);
        text(names[int(data[sortListPos[i]][0])], width/2 - (115 * 3) + 57, 226 + (20 * i));
        for (int j = 1; j < 5 + 1; j++) {
          //Check for minimum time 
          if (data[sortListPos[i]][j] <= min[j]) {
            rectMode(CORNERS);
            fill(c1);
            //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
            text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (3 - j)) + 57, 226 + (20 * i));
          }
          else if (data[sortListPos[i]][j] >= max[j]) {
            rectMode(CORNERS);
            fill(c2);
            //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
            text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (3 - j)) + 57, 226 + (20 * i));
          } 
          else {
            fill(255);
            text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (3 - j)) + 57, 226 + (20 * i));
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
        text((i + 1) + ".", width/2 - (115 * 4) + 100, 226 + (20 * i));
        textAlign(CENTER);
        text(names[int(data[sortListPos[index-i-1]][0])], width/2 - (115 * 3) + 57, 226 + (20 * i));
        for (int j = 1; j < 5 + 1; j++) {
          //Check for minimum time 
          if (data[sortListPos[index - 1-i]][j] <= min[j]) {
            rectMode(CORNERS);
            fill(c1);
            //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
            text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (3 - j)) + 57, 226 + (20 * i));
          }
          else if (data[sortListPos[index - 1-i]][j] >= max[j]) {
            rectMode(CORNERS);
            fill(c2);
            //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
            text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (3 - j)) + 57, 226 + (20 * i));
          } 
          else {
            fill(255);
            text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (3 - j)) + 57, 226 + (20 * i));
          }
        }
      }
    }
  } 
  else {   ///////////////////////////////////////////Shooting Range Stuff////////////////////////////////////////////////
    //Alternating Bars
    for (int i = 1; i < index; i = i + 2) {
      fill(40);
      stroke(40);
      rectMode(CENTER);
      rect(width/2, (height - 259 - (i * 20)), 230, 19, 7);
    }
    rect(width/2, 114, 220, 24, 7);

    //Text for Current Session
    fill(255);
    textFont(f2);
    textAlign(CENTER);
    text("Name", width/2 - (115 * 1) + 57, 96);
    text("Time", width/2 - (115 * 0) + 57, 96);
    //    text("Sector 2", width/2 - (115 * 1) + 57, 96);
    //    text("Sector 3", width/2 - (115 * 0) + 57, 96);
    //    text("Sector 4", width/2 + (115 * 1) + 57, 96);
    //    text("Total Time", width/2 + (115 * 2) + 57, 96);

    //Text for time of current session
    for (int i = 1; i < 2; i++) {
      //Check for minimum time 
      if (data[index][i] <= min[i]) {
        fill(c1);
        text(String.format("%.2f", data[index][i]), width/2 - (115 * (i-1)) + 57, 120);
      } 
      else if (data[index][i] >= max[i]) {
        fill(c2);
        text(String.format("%.2f", data[index][i]), width/2 - (115 * (i-1)) + 57, 120);
      } 
      else {
        fill(255);
        text(String.format("%.2f", data[index][i]), width/2 - (115 * (i-1)) + 57, 120);
      }
    }

    //Text for name of current session
    fill(255);
    text(names[int(data[index][0])], width/2 - (115 * 1) + 57, 120);

    //Sort the list for ranking based on total time
    for (int i = 0; i < index; i++) {
      sortList[i] = data[i][5];
    }
    sortList = sort(sortList);

    //Generate a list of the ranked positions
    for (int i = 0; i < index; i++) {
      for (int j = 0; j < index; j++) {
        if (data[j][5] == sortList[i]) {
          sortListPos[i] = j;
        }
      }
    }

    //text for times and names of Ranking
    if (sortFastest) { //For fastest first
      textFont(f3);
      for (int i = 0; i < index ; i++) {
        fill(255);
        textAlign(LEFT);
        text((i + 1) + ".", width/2 - (115 * 2) + 128, 226 + (20 * i));
        textAlign(CENTER);
        text(names[int(data[sortListPos[i]][0])], width/2 - (115 * 1) + 57 + 28, 226 + (20 * i));
        for (int j = 1; j < 1 + 1; j++) {
          //Check for minimum time 
          if (data[sortListPos[i]][j] <= min[j]) {
            rectMode(CORNERS);
            fill(c1);
            //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
            text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (1 - j)) + 57 + 28, 226 + (20 * i));
          }
          else if (data[sortListPos[i]][j] >= max[j]) {
            rectMode(CORNERS);
            fill(c2);
            //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
            text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (1 - j)) + 57 + 28, 226 + (20 * i));
          } 
          else {
            fill(255);
            text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (1 - j)) + 57 + 28, 226 + (20 * i));
          }
        }
      }
    } 
    else { //For slowest first
      textFont(f3);
      for (int i = 0; i < index ; i++) {
        fill(255);
        textAlign(LEFT);
        text((i + 1) + ".", width/2 - (115 * 4) + 100, 226 + (20 * i));
        textAlign(CENTER);
        text(names[int(data[sortListPos[index-i-1]][0])], width/2 - (115 * 3) + 57, 226 + (20 * i));
        for (int j = 1; j < 5 + 1; j++) {
          //Check for minimum time 
          if (data[sortListPos[index - 1-i]][j] <= min[j]) {
            rectMode(CORNERS);
            fill(c1);
            //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
            text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (3 - j)) + 57, 226 + (20 * i));
          }
          else if (data[sortListPos[index - 1-i]][j] >= max[j]) {
            rectMode(CORNERS);
            fill(c2);
            //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
            text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (3 - j)) + 57, 226 + (20 * i));
          } 
          else {
            fill(255);
            text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (3 - j)) + 57, 226 + (20 * i));
          }
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
    if (mode < 3) {
      mode = 2;
    }
  } 
  else {
    fill(255, 0, 0);
    text("Not Ready", 20, 300);
  }
  //Text for current mode for the swtich
  text(mode, 20, 350);

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
}
