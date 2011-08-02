#include <IRremote.h>
#include <Servo.h>

Servo myservo;


int RECV_PIN = 3;
IRrecv irrecv(RECV_PIN);
decode_results results;


long lastRun;

void setup() {
    // Serial.begin(9600);
  irrecv.enableIRIn(); // Start the receiver
  
   myservo.attach(9);
    lastRun = millis();

    myservo.write(75);
    delay(500);
}

void loop() {
      myservo.detach();

   
   if (millis() - lastRun > 500) {
    if (irrecv.decode(&results)) {
      //Serial.println(results.value, HEX);
      
      myservo.attach(9);
      
      if (results.value == 0x1D00D926) {
        myservo.write(180);
        //Serial.println("up");
         
      } else if (results.value == 0x1D0059A6) {
          myservo.write(0);
        //Serial.println("down");
      }
      
      delay(500);
    myservo.write(75);
      delay(500);
      myservo.detach();
        irrecv.resume(); 
      
    lastRun = millis();

    }

  }
}

