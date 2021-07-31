// Happy Processing 20 years! 
// " Code and My Fingers"  by Tetsu Kondo (ITP 2002)
// "To me, the computer is just another tool. It's like a pen.
// You have to have a pen, and to know penmanship,
// but neither will write the book for you". (Red Burns)
// 2021.8.1


int Volume1 = 0;    // Volume1
int Volume2 = 0;   // Volume2
int Switch1 = 0;    // Switch
int inByte = 0;         // Incoming serial byte

const int VolumeNum1 = A0;
const int VolumeNum2 = A1;
const int SwitchNum1 = 13;

void setup() {
  Serial.begin(9600); // Serial Comminication

  pinMode(13, INPUT); //D13 for swicth
  establishContact();
}

void loop() {

  if (Serial.available() > 0 ) {
       
     inByte = Serial.read();
  // int Volume = analogRead(A0);
  
  Volume1 = analogRead(VolumeNum1);// A0 for Analog (right finger)
  int mappedVolume1 = map(Volume1, 0, 1023, 0, 255); // Mapping 0~255

  delay(10);

  Volume2 = analogRead(VolumeNum2);// A1 for Analog (left finger)
  int mappedVolume2 = map(Volume2, 0, 1023, 0, 255); // Mapping 0~255

  delay(10);

  Switch1 = map(digitalRead(SwitchNum1), 0, 1, 0, 1);

  //  Serial.println(mappedVolume);   // Debugging on serial print 
  
 Serial.write(mappedVolume1);
 Serial.write(mappedVolume2);
 Serial.write(Switch1);

 delay(1);
 
 
  }

 
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('T');   // Sending "T" to shake hands
    delay(300);
  }
}
