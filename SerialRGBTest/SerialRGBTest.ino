boolean red, green, blue;
boolean falling_edge_trigger = false;
boolean stringComplete = false;
String inputString = "";

void setup() {
  Serial.begin(9600);

  pinMode(14, OUTPUT);
  pinMode(15, OUTPUT);
  pinMode(16, OUTPUT);
  pinMode(17, INPUT_PULLUP);
  digitalWrite(16, true);
  delay(1000);
}

void loop() {

  if (stringComplete) {
    Serial.println(inputString);
    if (inputString == "redON") {
      //      Serial.println("Red ON");
      red = true;
    } 
    else if (inputString == "redOFF") {
      //      Serial.println("Red OFF");
      red = false;
    } 
    else if (inputString == "greenON") {
      //      Serial.println("Green ON");
      green = true;
    } 
    else if (inputString == "greenOFF") {
      //      Serial.println("Green OFF");
      green = false;
    } 
    else if (inputString == "blueON") {
      //      Serial.println("Blue ON");
      blue = true;
    } 
    else if (inputString == "blueOFF") {
      //      Serial.println("Blue OFF");
      blue = false;

    }
    stringComplete = false;
    inputString = "";
  }
  digitalWrite(14, red);
  digitalWrite(15, green);
  digitalWrite(16, blue);

  if (digitalRead(17) == LOW) {
    if (falling_edge_trigger == false) {
      Serial.println("t 100");
      falling_edge_trigger = true;
      delay(10);
    }
  }
  if (digitalRead(17) == HIGH) {
    falling_edge_trigger = false;
    delay(10);
  }
  while (Serial.available()) {
    char inChar = (char)Serial.read(); 
    if (inChar == '.') {
      stringComplete = true;
      break;
    } 
    inputString += inChar;
  }
}



