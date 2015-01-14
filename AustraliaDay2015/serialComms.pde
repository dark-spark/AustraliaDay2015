boolean startSerial() {
  //Setup serial communication
  println(Serial.list());
  if (Serial.list().length > 0) {
    myPort = new Serial(this, Serial.list()[0], 9600);
    println("Port [0] selected for comms");
    myPort.bufferUntil('\n');
    myPort.clear();
    return true;
  } else {
    return false;
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

void tone1ON() {
  if (serial) {
    myPort.write("tone1ON.");
    myPort.clear();
  }
}

void tone1OFF() {
  if (serial) {
    myPort.write("tone1OFF.");
    myPort.clear();
  }
}

void tone2ON() {
  if (serial) {
    myPort.write("tone2ON.");
    myPort.clear();
  }
}

void tone2OFF() {
  if (serial) {
    myPort.write("tone2OFF.");
    myPort.clear();
  }
}

void tone3ON() {
  if (serial) {
    myPort.write("tone3ON.");
    myPort.clear();
  }
}

void tone3OFF() {
  if (serial) {
    myPort.write("tone3OFF.");
    myPort.clear();
  }
}
