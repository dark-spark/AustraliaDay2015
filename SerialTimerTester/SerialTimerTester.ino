int out = 22;
int in = 8;
int count = 5;
int led = 11;
boolean triggered = false;

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
      delay(1000);
      digitalWrite(out, LOW);    
      digitalWrite(led, LOW);
      delay(1000);
    }
    triggered = false;
  }
}





