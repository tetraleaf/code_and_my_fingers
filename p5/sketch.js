// Happy Processing 20 years!
// " Code and My Fingers"  by Tetsu Kondo (ITP 2002)
// "To me, the computer is just another tool. It's like a pen.
// You have to have a pen, and to know penmanship,
// but neither will write the book for you". (Red Burns)
// 2021.8.1

//  Physical Computing Lab for more serial communication
//  https://itp.nyu.edu/physcomp/

let serial;
let portName = "/dev/tty.usbmodem146101";
let inData;

let Volume1, Volume2;
let Switch1 = 255;

let hand = [];
let hand2 = [];
let numFrames = 100;
let nowFrames = 0;
let nowFrames2 = 0;

let options = { baudrate: 9600 };

function preload() {
  for (let i = 0; i < numFrames; i++) {
    let imageName = "tetsu-left-" + nf(i, 3) + ".jpg"; // My left fingers
    hand[i] = loadImage("data/" + imageName);
  }

  for (let i = 0; i < numFrames; i++) {
    let imageName = "tetsu-right-" + nf(i, 3) + ".jpg"; // My right fingers
    hand2[i] = loadImage("data/" + imageName);
  }
}

function setup() {
  createCanvas(1200, 954);
  serial = new p5.SerialPort();

  serial.on("data", serialEvent);
  serial.on("error", serialError);
  serial.on("close", portClose);

  serial.list();
  serial.open(portName);
}

function serverConnected() {
  console.log("connected to server.");
}

function portOpen() {
  console.log("the serial port opened.");
}

function serialError(err) {
  console.log("Something went wrong with the serial port. " + err);
}

function portClose() {
  console.log("The serial port closed.");
}

function serialEvent() {
  let inString = serial.readStringUntil("\r\n");

  if (inString.length > 0) {
    if (inString !== "hello") {
      let sensors = split(inString, ",");

      if (sensors.length > 2) {
        Volume1 = sensors[0];
        Volume2 = sensors[1];
        Switch1 = sensors[2];
      }
    }
    serial.write("x"); // shake hands
  }
}

function printList(portList) {
  for (let i = 0; i < portList.length; i++) {
    console.log(i + portList[i]);
  }
}

function draw() {
  if (Switch1 == 1) {
    image(hand[10], 0, 0); // Showing left mother finger
    image(hand2[15], 600, 0); // Showing right mother finger
  } else {
    nowFrames = int(map(Volume1, 0, 255, 0, 99)); // maping to 100
    image(hand[nowFrames], 0, 0);

    nowFrames2 = int(map(Volume2, 0, 255, 0, 99)); // maping to 100
    image(hand2[nowFrames2], 600, 0);
  }

/* just for debugging 
text("Volume1 : " + Volume1, 30, 30);
text("Volume2 : " + Volume2, 30, 60);
text("Switch1 : " + Switch1, 30, 90);
*/

  console.log(Volume1, Volume2, Switch1);
}
