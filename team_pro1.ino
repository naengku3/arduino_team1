void setup() {

  pinMode(13, OUTPUT);
  pinMode(7, INPUT_PULLUP);
  Serial.begin(9600);
  
}

void loop() {

  int sw = digitalRead(7);
    Serial.println(sw);
    delay(1000);

  String m = Serial.readStringUntil('\n');
  if(m == "on") digitalWrite(13, HIGH);
  if(m == "off") digitalWrite(13, LOW);
  
  if(m == "song") { 
    tone(4, 261, 500); // 도
    delay(500);
    tone(4, 261, 500); // 도
    delay(500);
    tone(4, 392, 500); // 솔
    delay(500);
    tone(4, 392, 500); // 솔
    delay(500);
    tone(4, 440, 500); // 라
    delay(500);
    tone(4, 440, 500); // 라
    delay(500);
    tone(4, 392, 500); // 솔
    delay(500);
  }
}
