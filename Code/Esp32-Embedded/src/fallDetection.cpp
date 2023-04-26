#include <Arduino.h>
#include <fallDetection.h>

boolean fall = false; 
boolean trigger1=false; 
boolean trigger2=false; 
boolean trigger3=false; 

byte trigger1count=0; 
byte trigger2count=0; 
byte trigger3count=0; 
int angleChange=0;

bool fallDetection(float &ax, float &ay, float &az, int &gx, int &gy, int &gz) {
  float raw_am = sqrt(pow(ax, 2) + pow(ay, 2) + pow(az, 2));
  int am = raw_am * 10;
  Serial.println(am);

  if (trigger3) {
    trigger3count++;
    if (trigger3count >= 10) {
      float angleChange = sqrt(pow(gx, 2) + pow(gy, 2) + pow(gz, 2));
      Serial.println(angleChange);
      if (angleChange >= 0 && angleChange <= 10) {
        fall = true;
        trigger3 = false;
        trigger3count = 0;
        Serial.println(angleChange);
      } else {
        trigger3 = false;
        trigger3count = 0;
        Serial.println("TRIGGER 3 DEACTIVATED");
      }
    }
  }

  if (fall) {
    Serial.println("FALL DETECTED");
    fall = false;
    return true;
  }

  if (trigger2count >= 6) {
    trigger2 = false;
    trigger2count = 0;
    Serial.println("TRIGGER 2 DECACTIVATED");
  }

  if (trigger1count >= 6) {
    trigger1 = false;
    trigger1count = 0;
    Serial.println("TRIGGER 1 DECACTIVATED");
  }

  if (trigger2) {
    trigger2count++;
    float angleChange = sqrt(pow(gx, 2) + pow(gy, 2) + pow(gz, 2));
    Serial.println(angleChange);
    if (angleChange >= 30 && angleChange <= 400) {
      trigger3 = true;
      trigger2 = false;
      trigger2count = 0;
      Serial.println(angleChange);
      Serial.println("TRIGGER 3 ACTIVATED");
    }
  }

  if (trigger1) {
    trigger1count++;
    if (am >= 12) {
      trigger2 = true;
      Serial.println("TRIGGER 2 ACTIVATED");
      trigger1 = false;
      trigger1count = 0;
    }
  }

  if (am <= 2 && !trigger2) {
    trigger1 = true;
    Serial.println("TRIGGER 1 ACTIVATED");
  }

  return false;
}