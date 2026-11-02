#include <SoftwareSerial.h>
#include <Servo.h> 

char CommandByte;
int SerialCommu = 0;

SoftwareSerial rfid = SoftwareSerial(2, 3);
int resetpin = 5;
String msg;

Servo Gate1; 
Servo Gate2;
int servoPin1 = 8;
int servoPin2 = 9;
int closeposition = 5;
// box1: 5, box2: 5, box3: 5, box4: 5, box5: 5, box6: 5


void setup() {
  Serial.begin(9600);
  rfid.begin(9600);
  Gate1.attach(servoPin1);
  Gate2.attach(servoPin2);
  Gate1.write(closeposition);
  Gate2.write(closeposition);
  delay(100);

  pinMode(resetpin, OUTPUT);
  digitalWrite(resetpin, LOW);
  digitalWrite(resetpin, HIGH);
}

void loop(){
  if (SerialCommu == 1) {
     RFIDSerial();
  }

  if (Serial.available() > 0) {
      CommandByte = Serial.read();
      switch (CommandByte) {
         case '1':
            OpenGate(Gate1);
         break;
         case '2':
            CloseGate(Gate1);
         break;
         case '3':
            OpenGate(Gate2);
         break;
         case '4':
            CloseGate(Gate2);
         break;
         case 'E':
            ResetPosition();
         break;
         case 'A':
            OpenAllGate();
         break;
         case 'O':   //Channel 'O'pen
            SerialCommu = 1;
            while(rfid.available() >0){
              // make sure buffer is empty
              rfid.read();
              delay(1);
            }
         break;
         case 'C':   //Chaneel 'C'losed
            SerialCommu = 0;
         break;
      }
   }
}

void RFIDSerial() {
  // RFID
  msg = "";
  
  while(rfid.available()>0) {
    msg += char(rfid.read());
    delay(1); 
  }
  
  if(msg.length() >= 12) {
     msg = msg.substring(1, 13);
     Serial.println(msg);
     digitalWrite(resetpin, LOW);
     digitalWrite(resetpin, HIGH);
     delay(50);
  }
}

void OpenGate(Servo servoMotor) {
   servoMotor.write(90);
   delay(15);
}

void CloseGate(Servo servoMotor) {
   servoMotor.write(30);
   delay(300);
//   servoMotor.write(closeposition + 10);
//   delay(1000);
   servoMotor.write(closeposition);
   delay(15);
}

void CloseGate_habituation(Servo servoMotor) {
   servoMotor.write(30);
   delay(300);
   servoMotor.write(closeposition + 10);
   delay(2000);
   servoMotor.write(closeposition);
   delay(15);
}

void ResetPosition() {
   OpenGate(Gate1);
   OpenGate(Gate2);
   delay(500);
   CloseGate(Gate1);
   CloseGate(Gate2);
}

void OpenAllGate() {
   OpenGate(Gate1);
   OpenGate(Gate2);
   delay(100);
}
