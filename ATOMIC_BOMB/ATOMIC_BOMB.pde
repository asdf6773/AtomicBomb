//include library
import processing.video.*;
import processing.sound.*;
import processing.serial.*;

//define Serial port
Serial myPort; 

//define sound and video resources
Movie atomBomb;   // video when button triggered
SoundFile bg;     // background music
SoundFile atom;   // sound of explosion
SoundFile bomb;   // sound of firing
PImage wait;      // static image of before firing

//define some variables
int val;         //value received from Arduino Serial writing
int lastVal;     // val value of last frame 
boolean status;  //status of whether bomb is fired 
float n;         //define parameter of a noise() function
float wiggle;    //define value of a noise() function 
String s, m, h;  //define current timing (hour, minute, second)
void setup() {
  //initialize program
  frameRate(30);   //set frameRate at 30 frame per second
  size(800, 600);  //set window to 800x600

  //initialize varibles
  n=0;
  status = false;
  val = 0;
  lastVal =0;

  //load media resources
  wait = loadImage("static.png");
  bg = new SoundFile(this, "bg.mp3");
  bomb = new SoundFile(this, "bomb.wav");
  atom = new SoundFile(this, "BMM.wav");
  atomBomb = new Movie(this, "atom_bomb_2.mp4");

  //play the background music from 0'10"(to avoid low sound at begining)
  bg.jump(10);  //set time to 0'10"
  bg.loop();    //play the music in loop

  //set 1st Serial port from Serial list as reading port
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);

  //set text font
  PFont font = createFont("黑体", 20, true);
  textFont(font);
}

void draw() {
  //println(atomBomb.time());
  n+=0.03;             //set increment of noise parameter as 0.03 
  wiggle = noise(n);   // get the value of noise

  //read value from the Serial Port
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.read();          // read it and store it in val
  }



  //-----Conditional Statement
  // three "AND" conditions trigger the bomb firing:
  //1. (!status) if bomb has not fired yet
  //2. current val is not equal to the val of last frame(which means button changed status)
  //3. current val is higher than the val of last frame(only when the (current)val==1 and lastVal==0 )
  //if those 3 conditions are all true, bomb will be fired(video will be played)
  if ((!status)&&val!=lastVal&&val>lastVal) {
    status = true;    //set bomb status to "fired"
    atomBomb.play();  //play the video
    atom.play();      //play the firing sound
  }
  //show video
  if (status) {       //while the status become true
    image(atomBomb, 0, 0, 800, 600);  //show video
  } else { 
    //static image before cannon firing
    image(wait, 0, 0, 800, 600);
    image(wait, 5*wiggle, 5*wiggle, 795+5*wiggle, 595+5*wiggle);
  }

  //after 10 second of firing, play the sound of big explosion
  if (floor(atomBomb.time())==10) {
    bomb.play();
  }

  //run time
  time();

  //write some text on the top layer of the canvas
  textSize(50);
  text("LIVE直播", 50, 80);
  textSize(27);
  text("新疆核试验基地", 50, height-80);
  textSize(20);
  text("北京时间 2017年6月18日  "+h+":"+m+":"+s, 50, height-50);

  //save the value of current val as lastVal
  lastVal = val;
}

//I don't know; if need play video, must have this.
void movieEvent(Movie m) {
  m.read();
}


//set current time
void time() {
  if (second()<10)          //if second value is less than 10, add a '0' in front of it 
    s = '0'+str(second());  //and transform it into String value. 
  else                      //(e.g. 15:20:07 instead of 15:20:7)
    s=str(second());        //if second value is bigger than 10, transform it into Srting directly


  if (minute()<10)
    m = '0'+str(minute());
  else
    m = str(minute());

  if (hour()<10)
    h= '0'+str(hour());
  else
    h= str(hour());
}