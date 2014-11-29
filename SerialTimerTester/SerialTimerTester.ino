int out = 22;
int in = 8;
int count = 5;
int led = 11;
boolean triggered = false;
long timeBetweenRisingEdge = 1000;
int pulseTime = 100;

void setup() {                
  pinMode(in, INPUT_PULLUP);
  pinMode(out, OUTPUT);     
  pinMode(led, OUTPUT);
}

void loop() {
  if(digitalRead(in) == HIGH) {
    triggered = true;
  } 
  if(triggered == true) {
    for(int i = 0; i < count; i++) {
      timeBetweenRisingEdge = random(500,1500);
      digitalWrite(out, HIGH);
      digitalWrite(led, HIGH);
      delay(pulseTime);
      digitalWrite(out, LOW);    
      digitalWrite(led, LOW);
      delay(timeBetweenRisingEdge-pulseTime);
    }
    triggered = false;
  }
}
