# Delphi-GUI_for_COM_Port
A Delphi GUI project to control LEDs via COM port using an Arduino UNO R3 board (CH340). Includes basic command protocol, serial communication, and visual feedback.
# LED Control via COM Port and Delphi GUI

## Project Description

This project was developed for educational purposes to demonstrate how a graphical user interface (GUI) written in **Delphi** can interact with external hardware via a **COM port**.

As the external device, an **UNO R3 board with CH340 USB-UART converter** is used. The board is connected via its built-in **USB-COM interface**, which appears as a regular COM port in **Windows Device Manager**.

Four LEDs are connected to the board's digital pins (2–5) through current-limiting resistors of **220 Ohms** each. The pin configuration is as follows:

- **Pin 2** — blue LED  
- **Pin 3** — green LED  
- **Pin 4** — yellow LED  
- **Pin 5** — red LED

The Delphi GUI application allows turning each LED on and off by sending appropriate commands via the COM port. The UNO R3 board receives the commands over UART and changes the state of the pins accordingly.

---

## GUI Interaction and Communication Protocol

Feedback from the device is provided via text messages sent back through the COM port. These messages are received and displayed in the Delphi GUI.

When a valid command is received, the board performs the corresponding action and responds with a confirmation message, for example:

- `WHITE LED is ON` — white LED turned on  
- `BLUE LED is OFF` — blue LED turned off

If the message sent from the GUI doesn't match any known command, the board treats it as arbitrary text and responds with an error message along with an echo:

- `It is not a command...
   ECHO: <your input>`

---

## Available Commands

| Command                 | Description                                 |
|-------------------------|---------------------------------------------|
| `ledOn <color>`         | Turns on the LED of the specified color     |
| `ledOff <color>`        | Turns off the LED of the specified color    |
| `allLedsOn`             | Turns on all LEDs simultaneously            |
| `allLedsOff`            | Turns off all LEDs                          |
| `Version`               | Returns device information                  |

### Examples:

- `ledOn Blue`  
- `ledOff Green`  
- `allLedsOn`  
- `Version`

### Supported LED colors (case-sensitive):

- `Blue`  
- `White`  
- `Yellow`  
- `Green`

---

## How to Run the Project

1. **Compile the GUI application**  
   Open the project in **Embarcadero RAD Studio** and build it. You will get an executable with the graphical interface.

2. **Connect LEDs to the board**  
   Use an **UNO R3 (CH340)** board and connect four LEDs to digital pins **2–5** through **220 Ohm** resistors.  
   Pin layout:

   - `Pin 2` — blue LED  
   - `Pin 3` — green LED  
   - `Pin 4` — yellow LED  
   - `Pin 5` — red LED

3. **Upload the firmware to the board**  
   Use the **Arduino IDE** or another compatible tool to upload the sketch from this repository to the UNO R3 board.

4. **Configure the connection in the GUI**  
   - Launch the compiled GUI application.  
   - From the dropdown list, select the **COM port** assigned to your board (check in Windows Device Manager).  
   - Click the **Open** button in the **Actions** section to establish the connection.

5. **Control the board using the GUI**  
   - In the **Send Command** field, enter one of the control commands (e.g., `ledOn Blue`, `allLedsOff`, `Version`) or any arbitrary text.  
   - The board's response will appear in the receive window.

6. **Additional actions:**
   - To **close the connection**, click the **Close** button.  
   - To **clear the receive area**, click the **Clear receive** button.

---

**Good luck using the project!** 😊
