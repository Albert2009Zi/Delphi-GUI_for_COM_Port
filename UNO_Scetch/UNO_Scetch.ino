/*******************************************************************************
 * Project   : Arduino LED Control via COM Port
 * Author    : Albert Ziatdinov
 * Created   : 27.06.2025
 * Board     : Arduino UNO R3
 * Purpose   : Demonstrates communication between Arduino and a Delphi-based GUI
 * Description:
 *   - This sketch interacts with a GUI application written in Delphi,
 *     which communicates with the Arduino over a serial COM port.
 *   - Digital pins 2, 3, 4, and 5 are connected to blue, white, yellow,
 *     and green LEDs respectively, via 220 Ohm resistors.
 *   - Upon receiving commands via the COM port, the sketch can:
 *       * Turn LEDs ON or OFF
 *       * Send the UNO R3 CH340 board version
 *   - This example is intended for testing serial communication and
 *     remote control using a simple graphical user interface.
 *
 * Notes:
 *   - All communication uses ASCII commands terminated by newline or carriage return.
 *   - Designed for educational and testing purposes.
 *******************************************************************************/

#define BLUE_LED   2
#define WHITE_LED  3
#define YELLOW_LED 4
#define GREEN_LED  5

enum cmdStr {
  ledOn = 1,
  ledOff,
  allLedsOn,
  allLedsOff,
  Version,
  RandomText
  };

void setup() {
  Serial.begin(115200);
  Serial.print("Please enter command or random text:");
}

void loop() {

   if (Serial.available()) {
    String testStr = Serial.readStringUntil('\n');
    testStr.trim();

    int smbSpace = testStr.indexOf(' ');
  
    String cmdStr = testStr.substring(0, smbSpace);
    int symAfterSpace = numFromColor(testStr.substring(smbSpace + 1));

switch (cmd(cmdStr)) {
  case ledOn:
    // Turn on the specified LED
    digitalWrite(symAfterSpace, HIGH);
      switch(symAfterSpace){
          case BLUE_LED:
          Serial.println("Blue LED is ON");
          break;

          case WHITE_LED:
          Serial.println("White LED is ON");
          break;

          case YELLOW_LED:
          Serial.println("Yellow LED is ON");
          break;

          case GREEN_LED:
          Serial.println("Green LED is ON");
          break;

          default:
          Serial.println("Wrong LED number...");
          Serial.println("ECHO: " + testStr); 
          break;
        }
    break;

  case ledOff:
    // Turn off the specified LED
    digitalWrite(symAfterSpace, LOW);
      switch(symAfterSpace){
          case BLUE_LED:
          Serial.println("Blue LED is OFF");
          break;

          case WHITE_LED:
          Serial.println("White LED is OFF");
          break;

          case YELLOW_LED:
          Serial.println("Yellow LED is OFF");
          break;

          case GREEN_LED:
          Serial.println("Green LED is OFF");
          break;

          default:
          Serial.println("Wrong LED number...");
          Serial.println("ECHO: " + testStr); 
          break;
        }    
    break;

  case allLedsOn:
    // Turn on all LEDs
        for(int i = 2; i < 6; i++){
        digitalWrite(i, HIGH);
        }
      Serial.println("All LEDs are on"); 
    break;

  case allLedsOff:
    // Turn off all LEDs
        for(int i = 2; i < 6; i++){
        digitalWrite(i, LOW);
          }
      Serial.println("All LEDs are off");
    break;

  case Version:
    // Send firmware or board version information
    Serial.println("UNO R3 CH340 ver.1.0");
    break;

  case RandomText:
    // Handle unrecognized text (not a command)
    Serial.println("It is not a command...");
    Serial.println("ECHO: " + testStr);  
    break;

  default:
    // Unknown command
    break;
}

Serial.print("Please repeat command or random text:");   
   }  
}

int cmd(String cmdStr){
  if (cmdStr == "ledOn")           return ledOn;
  else if (cmdStr == "ledOff")     return ledOff;
  else if (cmdStr == "allLedsOn")  return allLedsOn;
  else if (cmdStr == "allLedsOff") return allLedsOff;
  else if (cmdStr == "Version")    return Version;
  else                             return RandomText;
  }

int numFromColor(String ledColor) {
  if (ledColor == "Blue")        return BLUE_LED;
  else if (ledColor == "White")  return WHITE_LED;
  else if (ledColor == "Yellow") return YELLOW_LED;
  else if (ledColor == "Green")  return GREEN_LED;
  else                           return -1; // Unknown color
}
