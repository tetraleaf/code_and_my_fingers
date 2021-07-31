// Happy Processing 20 years! 
// " Code and My Fingers"  by Tetsu Kondo (ITP 2002)
// "To me, the computer is just another tool. It's like a pen.
// You have to have a pen, and to know penmanship,
// but neither will write the book for you". (Red Burns)
// 2021.8.1


import processing.serial.*;

Serial myPort;

int numFrames = 100; // Number of images

PImage[] hand = new PImage[numFrames];
PImage[] hand2 = new PImage[numFrames];

int nowFrames = 0;
int nowFrames2 = 0;


int Switch1;           // 0 or 1
int Volume1, Volume2;     // 0 to 255

int[] serialInArray = new int[3];    // From Arduino nano 33
int serialCount = 0;                 // How many bites

boolean firstContact = false;        // Check serial connection

void setup() {
  size(1200, 954);
  frameRate(60);

  String portName = Serial.list()[0]; // Pring out your serial ports 
  myPort = new Serial(this, "/dev/cu.usbmodem146101", 9600); // my MacbookPro 16 was left second port


  for (int i = 0; i < numFrames; i++) {
    String imageName = "tetsu-left-" + nf(i, 3) + ".jpg"; // My left fingers
    hand[i] = loadImage(imageName);
  }


  for (int i = 0; i < numFrames; i++) {
    String imageName = "tetsu-right-" + nf(i, 3) + ".jpg"; // My right fingers
    hand2[i] = loadImage(imageName);
  }
}

void draw() {

  // println(nowFrames, nowFrames2);


  // Serial in  debugging 
  //fill(0, 255, 255);
  //text(Switch1, 20, 20);
  //fill(255, 0, 0, 100);
  //text(Volume1, 200, height/2);
  //ellipse(200, height/2, Volume1, Volume1);
  //fill(0, 255, 0, 100);
  //text(Volume2, 400, height/2);
  //ellipse(400, height/2, Volume2, Volume2);
  

  if (Switch1 == 1 ) {
    image(hand[10], 0, 0); // Showing left mother finger
    image(hand2[15], 600, 0); // Showing right mother finger
  } else {
    

    nowFrames = int(map(Volume1, 0, 255, 0, 99)); // maping to 100
    image(hand[nowFrames], 0, 0);

    nowFrames2 = int(map(Volume2, 0, 255, 0, 99)); // maping to 100
    image(hand2[nowFrames2], 600, 0);
  }
}


//  Down here are codes from Tom @ ITP
//  Physical Computing Lab
//  https://itp.nyu.edu/physcomp/

void serialEvent(Serial myPort) {

  int inByte = myPort.read();

  if (firstContact == false) {

    if (inByte == 'T') {
      myPort.clear();
      firstContact = true;
      myPort.write('T');       // send "T"
    }
  } else {

    serialInArray[serialCount] = inByte;
    serialCount++;

    // Checking 3 Bytes
    if (serialCount > 2 ) {
      Volume1 = serialInArray[0];
      Volume2 = serialInArray[1];
      Switch1 = serialInArray[2];


      // for debugging 
      println(Volume1 + "\t" + Volume2 + "\t" + Switch1);

      // Send a capital T to request new sensor readings:
      myPort.write('T');
      // Reset serialCount:
      serialCount = 0;
    }
  }
}
