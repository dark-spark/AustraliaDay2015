int out = 22;
int in = 8;
int count = 5;
int led = 11;
boolean triggered = false;
int timeBetweenRisingEdge = 1000;

void setup() {                
  pinMode(in, INPUT_PULLUP);
  pinMode(out, OUTPUT);     
  pinMode(led, OUTPUT);
}

void loop() {
  if(digitalRead(in) == LOW) {
    triggered = true;
  } 
  if(triggered == true) {
    for(int i = 0; i < count; i++) {
      digitalWrite(out, HIGH);
      digitalWrite(led, HIGH);
      delay(timeBetweenRisingEdge/2);
      digitalWrite(out, LOW);    
      digitalWrite(led, LOW);
      delay(timeBetweenRisingEdge/2);
    }
    triggered = false;
  }
}





