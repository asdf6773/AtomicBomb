int val;
void setup() {
  val = 0;
  Serial.begin(9600);
  pinMode(13, OUTPUT);
}
void loop() {
  val = digitalRead(13);
  Serial.write(val);
  delay(50);
}
