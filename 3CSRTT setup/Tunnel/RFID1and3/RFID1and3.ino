#include <SoftwareSerial.h>

SoftwareSerial rfid = SoftwareSerial(2, 3); //coonect pin to 2
int resetpin = 5;
String msg;

char CommandByte;
int SerialCommu = 0;

void setup()  
{
  Serial.begin(9600);
  rfid.begin(9600);

  pinMode(resetpin, OUTPUT);
  digitalWrite(resetpin, HIGH);
//  Serial.println("Ready");
}

void loop(){
  CommandByte = Serial.read();
  switch (CommandByte) {
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
  
  if (SerialCommu == 1) {
    RFIDSerial();
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
