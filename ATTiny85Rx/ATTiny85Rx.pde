
#include <SoftwareServo.h>
/*
  SparkFun Electronics 2010
  Playing with IR remote control
  
  IR Receiver TSOP382: Supply voltage of 2.5V to 5.5V
  With the curved front facing you, pin 1 is on the left.
  Attach
    Pin 1: To pin 2 on Arduino
    Pin 2: GND
    Pin 3: 5V
  
  This is based on pmalmsten's code found on the Arduino forum from 2007:
  http://www.arduino.cc/cgi-bin/yabb2/YaBB.pl?num=1176098434/0

  This code works with super cheapo remotes. If you want to look at the individual timing
  of the bits, use this code:
  http://www.arduino.cc/playground/Code/InfraredReceivers
  
  This code clips a lot of the incoming IR blips, but what is left is identifiable as key codes.

*/

int irPin = 1; //Sensor pin 1 wired to Arduino's pin 2
int statLED = 2; //Toggle the status LED every time Power is pressed
int start_bit = 2200; //Start bit threshold (Microseconds)
int bin_1 = 1000; //Binary 1 threshold (Microseconds)
int bin_0 = 400; //Binary 0 threshold (Microseconds)

//int start_bit = 275; //Start bit threshold (Microseconds)
//int bin_1 = 120; //Binary 1 threshold (Microseconds)
//int bin_0 = 50; //Binary 0 threshold (Microseconds)

//int start_bit = 137; //Start bit threshold (Microseconds)
//int bin_1 = 62; //Binary 1 threshold (Microseconds)
//int bin_0 = 25; //Binary 0 threshold (Microseconds)

SoftwareServo myservo;

void turnWithEnoughTime(int angle) {
  myservo.write(angle);
      
    for (int i = 0; i < 10; i++) {
    delay(50);
    SoftwareServo::refresh();
    }
}

void setup() {
  
//  pwm_init();
  
  pinMode(statLED, OUTPUT);
  digitalWrite(statLED, LOW);

  pinMode(irPin, INPUT);

  myservo.attach(0);
  turnWithEnoughTime(75);

  //Serial.begin(9600);
  //Serial.println("Waiting: ");
}



void loop() {


  int key = getIRKey();		    //Fetch the key
  
  if (key == 144) {
    digitalWrite(statLED, HIGH);
    turnWithEnoughTime(180);
  delay(500);
  
  turnWithEnoughTime(75);
    

    
  } else if (key == 145) {
    digitalWrite(statLED, LOW);
turnWithEnoughTime(0);
  delay(500);
  
  turnWithEnoughTime(75);
  
  }


}

int getIRKey() {
  int data[12];
  int i;


  while(pulseIn(irPin, LOW) < start_bit); //Wait for a start bit

  for(i = 0 ; i < 11 ; i++)
    data[i] = pulseIn(irPin, LOW); //Start measuring bits, I only want low pulses


//if (data[0] > 90) {
//}
  for(i = 0 ; i < 11 ; i++) //Parse them
  {	    


    if(data[i] > bin_1) { //is it a 1?
      data[i] = 1;
    }
    else if(data[i] > bin_0) { //is it a 0?
      data[i] = 0;
    }
    else {
 
      return -1; //Flag the data as invalid; I don't know what it is! Return -1 on invalid data
    }
  }

  int result = 0;
  for(i = 0 ; i < 11 ; i++) //Convert data bits to integer
    if(data[i] == 1) result |= (1<<i);

  return result; //Return key number
} 

