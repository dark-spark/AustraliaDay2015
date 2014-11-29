boolean startSerial() {
  //Setup serial communication
  println("Available Serial Ports: ");
  println(Serial.list());
  if (Serial.list().length > 0) {
    myPort = new Serial(this, Serial.list()[0], 9600);
    println("Port [0] selected for comms");
    myPort.bufferUntil('\n');
    myPort.clear();
    return true;
  } 
  else {
    return false;
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
