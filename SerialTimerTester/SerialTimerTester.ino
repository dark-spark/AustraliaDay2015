int out = 13;
int in = 17;
int count = 5;
int led = 11;
boolean triggered = false;

void setup() {                
  pinMode(in, INPUT_PULLUP);
  pinMode(out, OUTPUT);     
}

void loop() {
  if(!in) {
    triggered = true;
  }
  if(triggered) {
    digitalWrite(led, HIGH);
    for(int i = 0; i <= count; i++) {
      digitalWrite(out, HIGH);
      delay(1000);
      digitalWrite(out, LOW);    
      delay(1000);
      if(i = count -1) {
        triggered = false;
        digitalWrite(led, false);
      }
    }  
  }
}



