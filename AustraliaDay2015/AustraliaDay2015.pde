import controlP5.*;  //<>// //<>//
import processing.serial.*;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.HttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.util.EntityUtils;
import org.apache.http.client.ClientProtocolException;

Serial myPort;        
int arrayLength = 1000;
String inData[] = new String[1];
int mode = 0;
int time0, time1, time2;
int sectorIndex = 0, lightIndex = 0, lightTimer, countDown, reactionTime, reactionTime0, reactionTime1, r;
boolean serialData = false;
boolean redON, greenON, blueON, yellowON, running, jumpStart, jumpEnable, lightsFinished, serial, yesReceived, pingFailed;
boolean serialSent = false;
int lightFlash;
String timeArray[] = new String[6];
String postData[] = new String[10];
boolean pNameSet = false;
String pName = "";
String pBarcode;
String barcode;
int currentPerson;
int count = 0;
String total;
String name;
float data[][] = new float[arrayLength][10];
float sortList[] = new float[arrayLength];
String names[] = new String[arrayLength];
String songs[] = new String[arrayLength];
String barcodes[] = new String[arrayLength];
float srData[][] = new float[arrayLength][2];
boolean nameSet = false;
boolean sect1min = false;
boolean sect2min = false;
boolean sect3min = false;
boolean sect4min = false;
boolean totalmin = false;
boolean flash = false;
float min[] = new float[9];
float max[] = new float[9];
int sortListPos[] = new int[arrayLength];
boolean firstClick = true;
String typing = "";
String player = "";
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
int toneTime = 300; //Time for the flashing of the tone and lights.

boolean salesForce = false;
String[] accessDetails = new String[2];

void setup() {
  size(1280, 700);
  frame.setTitle("Australia Day 2015");
  index = 0;

  loadFiles();

  //Start serial comms and initialise
  serial = startSerial();
  if (serial) {
    myPort.write("redOFF.greenOFF.blueOFF.yellowOFF.");
  }

  //Create fonts
  f1 = createFont("Calibri", 50);
  f2 = createFont("Calibri Bold", 20);
  f3 = createFont("Calibri Bold", 17);
  f4 = createFont("Arial Unicode MS", 15);
  f5 = createFont("Arial Unicode MS", 15);
  f6 = createFont("Arial Unicode MS", 12);

  //Set up listbox
  cp5 = new ControlP5(this);
  l = cp5.addListBox("myList")
    .setPosition(6, 21)
      .setSize(120, 200)
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

  for (int i=0; i< nameString.length; i++) {
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

  if (salesForce) {
    salesForceLogin();
  }
}



void draw() {

  create();

  switch(mode) {
  case 0:  //Set lights for initial position, no barcode set
    redOFF();
    greenOFF();
    blueOFF();
    yellowON();
    mode = 1;
    jumpStart = false;
    time2 = millis();
    break;
  case 1: //Check for barcode or name clicked, while waiting ping uC every 2 seconds to make sure its still alive.
  
    if (nameSet) {
      mode = 2;
      tone3ON();
      break;
    }
    
    if (millis() - time2 > 2000) {
      if(!ping()) {
        mode = 11;
      }
      time2 = millis();
    }
    break;
    
  case 2:  //Barcode set
    blueON();
    yellowOFF();
    mode = 10;
    countDown = millis();
    if (!pNameSet) {
      pName = name;
      pBarcode = barcode;
      pNameSet = true;
    }
    break;
  case 10: //Timer for run up
    if (millis() - countDown > 3000) {
      mode = 3;
    }
    if (serialData) {
      jumpStart = true;
      mode = 9;
      flash = true;
      serialData = true;
    }
    break;
  case 3: //Flash run up light and tones.
    if (serialData) {
      jumpStart = true;
      mode = 9;
      flash = true;
    }
    if (millis() - lightTimer > toneTime) {
      lightTimer = millis();
      lightFlash++;
    }
    if (lightFlash % 2 == 1) {
      blueON();
    } else {
      blueOFF();
    }
    if (millis() - countDown > 5400) {
      mode = 4;
      lightFlash = 0;
    }
    break;
  case 4:  //Set lights
    blueOFF();
    greenON();
    reactionTime0 = millis();
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
      } else {
        if (sectorIndex == 1) {
          String[] split = split(inData[0], " ");
          timeArray[sectorIndex] = str(time1);
          timeArray[0] = split[1];
          count = count+2;
        } else {
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
      sectorIndex = 0;
      pNameSet = false;
      running = false;
      formatPostData();
      fillData();
      redOFF();
      greenOFF();
      blueOFF();
      yellowON();
      index++;
      writeTextFile();
      count = 0;
      mode = 8;
    }
    if (jumpStart) {
      mode = 9;
      flash = true;
    }
    break;
  case 7:
    break;
  case 8:  //Send Data
    if (data[index -  1][8] <= min[8]) {
      play1upTone();
    }
    if (salesForce) {
      salesForceSendData();
    }
    mode = 0;
    break;
  case 9:  //Jump start
  
    nameSet = false;
    running = true;
    
    if (serialData) {
      if (sectorIndex == 0) {
        println("First");
        reactionTime = millis() - countDown - 5700;
        count++;
      } else {
        if (sectorIndex == 1) {
          String[] split = split(inData[0], " ");
          timeArray[sectorIndex] = str(time1);
          timeArray[0] = split[1];
          count = count+2;
        } else {
          timeArray[sectorIndex] = str(time1);
          count++;
        }
      }
      serialData = false;
      sectorIndex++;
      greenOFF();
      redON();
    }
    
    blueOFF();
    
    if (flash) {
      if (millis() - lightTimer > 100) {
        lightTimer = millis();
        lightFlash++;
      }
      if (lightFlash % 2 == 1) {
        redON();
      } else {
        redOFF();
      }
      if (lightFlash > 10) {
        flash = false;
        lightFlash = 0;
        redON();
      }
    }
    
    if (sectorIndex >= 5) {
      sectorIndex = 0;
      pNameSet = false;
      running = false;
      formatPostData();
      fillData();
      redOFF();
      greenOFF();
      blueOFF();
      yellowON();
      index++;
      writeTextFile();
      count = 0;
      mode = 8;
    }
    break;
    
    case 11:
      pingFailed = true;
      
      if (millis() - time2 > 1000) {
        if(ping()) {
          pingFailed = false;
          mode = 0;
        }
        time2 = millis();
      }
      
      stroke(255, 0, 0);
      fill(255, 0, 0);
      textSize(300);
      text("Ping \nFailed", 350, 250);
      break;
  }
  

  //  frame.setTitle(int(frameRate) + " fps");
  /*
  stroke(225);
   fill(225);
   rectMode(CORNER);
   rect(0, 0, 500, 20); 
   fill(0);
   textFont(f6);
   text(mouseX, 130, 20);
   text(mouseY, 160, 20);
   text(mouseX - valueX, 190, 20);
   text(mouseY - valueY, 220, 20);
   */
}

void keyPressed() {

  valueX = mouseX;
  valueY = mouseY;

  if (key == '\n' || keyCode == RETURN || keyCode == ENTER) {
    if(barcodeGood(typing)) {
      player = typing;
      typing = "";
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
  } else {
    typing = typing + key;
  }
  
  if (typing.length() > 2) {
    typing = typing.substring(1);
  }
}

boolean barcodeGood(String text) {
  text = trim(text);
  boolean good = false;
  for(int i = 0; i < barcodes.length; i++) {
    if(text.equals(barcodes[i])) {
      good = true;
      break;
    }
  }
  return good;
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
  int totalTime = et + abs(reactionTime);
  postData[0] = pBarcode;
  postData[1] = str(reactionTime + .0);
  postData[2] = str(speed);
  postData[3] = str(float(timeArray[1]));
  postData[4] = str(float(timeArray[2]));
  postData[5] = str(float(timeArray[3]));
  postData[6] = str(float(timeArray[4]));
  postData[7] = str(et + .0);
  postData[8] = str(totalTime + .0);
  postData[9] = str(jumpStart);
}

void fillData() {
  for (int i = 0; i < 9; i++) {
    data[index][i] = float(postData[i]);
  }
}

void mousePressed() {
  //Check if Mouse is over button and toggle on
  if (mouseX > boxX && mouseX < boxX+boxSize && mouseY >boxY && mouseY < boxY+boxSize) {
    //    if (sortFastest) {
    //      sortFastest = false;
    //      c3 = c2;
    //    } 
    //    else {
    //      sortFastest = true;
    //      c3 = c1;
    //    }
    time1 = millis() - time0;
    time0 = millis();
    serialData = true;
    inData[0] = "t 100";
  }
}

void delay(int delay)
{
  int time = millis();
  while (millis () - time <= delay);
}
