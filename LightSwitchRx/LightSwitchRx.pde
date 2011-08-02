//include <IRremoteInt.h>
#include <IRremote.h>
#include <Servo.h>

Servo myservo;


int RECV_PIN = 3;
IRrecv irrecv(RECV_PIN);
decode_results results;


long lastRun;

void setup() {
    Serial.begin(9600);
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
        irrecv.resume(); // Receive the next value
      
      
      /*
      int i;
      for (i = 0; i <= 180; i++) {
       myservo.write(i);
       delay(5);
      }
      
      for (i = 180; i >= 0; i--) {
       myservo.write(i);
       delay(5);
      }
      */
      
    lastRun = millis();

//    Serial.println(results.value, HEX);
    }

  }
}
  
  /*
  int pos;
  myservo.write(90);
  delay(1000);
  */
  /*
  for (pos = 0; pos < 180; pos++) {
    myservo.write(pos);
    delay(15);
  }
  
  for (pos = 180; pos >= 1; pos--) {
    myservo.write(pos);
    delay(15);
  }
*/
//}
