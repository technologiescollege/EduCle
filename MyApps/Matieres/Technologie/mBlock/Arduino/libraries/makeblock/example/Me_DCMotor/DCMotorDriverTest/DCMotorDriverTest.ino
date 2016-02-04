/**
 * \par Copyright (C), 2012-2015, MakeBlock
 * @file    DCMotorDriverTest.ino
 * @author  MakeBlock
 * @version V1.0.0
 * @date    2015/09/09
 * @brief   Description: this file is sample code for Me DC motor device.
 *
 * Function List:
 *    1. void MeDCMotor::run(int16_t speed)
 *    2. void MeDCMotor::stop(void)
 *
 * \par History:
 * <pre>
 * <Author>     <Time>        <Version>      <Descr>
 * Mark Yan     2015/09/09    1.0.0          rebuild the old lib
 * </pre>
 */
#include "MeOrion.h"

MePort port(PORT_3);
Servo myservo1;  // create servo object to control a servo 
Servo myservo2;  // create servo object to control another servo
int16_t servo1pin =  port.pin1();//attaches the servo on PORT_3 SLOT1 to the servo object
int16_t servo2pin =  port.pin2();//attaches the servo on PORT_3 SLOT2 to the servo object


MeDCMotor motor1(PORT_1);

MeDCMotor motor2(PORT_2);

MeDCMotor motor3(M1);

MeDCMotor motor4(M2);

uint8_t motorSpeed = 100;

void setup()
{
  myservo1.attach(servo1pin);  // attaches the servo on servopin1
  myservo2.attach(servo2pin);  // attaches the servo on servopin2
}

void loop()
{
  motor1.run(motorSpeed); /* value: between -255 and 255. */
  motor2.run(motorSpeed); /* value: between -255 and 255. */
  motor3.run(motorSpeed);
  motor4.run(motorSpeed);
  myservo1.write(0);                  // sets the servo position according to the scaled value 
  myservo2.write(0);
  delay(2000);
  motor1.stop();
  motor2.stop();
  motor3.stop();
  motor4.stop();
  myservo1.write(180);
  myservo2.write(180);
  delay(100);
  motor1.run(-motorSpeed);
  motor2.run(-motorSpeed);
  motor3.run(-motorSpeed);
  motor4.run(-motorSpeed);
  delay(2000);
  motor1.stop();
  motor2.stop();
  motor3.stop();
  motor4.stop();
  delay(2000);
}

