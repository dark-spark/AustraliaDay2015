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
