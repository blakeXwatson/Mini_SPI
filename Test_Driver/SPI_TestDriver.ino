//#define DEBUG
#include <SPI.h>

// Delay between iterations, in miliseconds
const int DEBUG_DELAY=10;

// Serial print the data we're sending out every XXX cycles, if in debug mode
const int PRINT_EVERY=1000;

const int MODE=1;
const int CSPIN=9;
const int SCLKPIN=13;
const int MISOPIN=12;
const int MOSIPIN=11;
const int LED_FAIL=17;

// This is the argument that I'm sending to the FPGA.  It increments every cycle
uint16_t opA = 0;


void setup() {

  pinMode(LED_FAIL, OUTPUT);
  pinMode(CSPIN, OUTPUT);
  digitalWrite(CSPIN, HIGH);

  SPI.setSCK(SCLKPIN);
  SPI.setMISO(MISOPIN);
  SPI.setMOSI(MOSIPIN);
  SPI.setDataMode(MODE);
  SPI.begin();

  Serial.begin(115200);
  Serial.println("Starting...");
  delay(1000);

}


uint16_t writeReadData(uint16_t output){

  digitalWrite(CSPIN, LOW);
  delayNanoseconds(250);

  SPI.transfer16(output);
  uint16_t result = SPI.transfer16(0);
  
  delayNanoseconds(250);
  digitalWrite(CSPIN, HIGH);

  return result;

}


// To be overridden/modified as needed.  This is where you look at everything and figure out if the data you received is what you expected
bool testResult( uint16_t dataOut, uint16_t dataIn ){
  
  int16_t dataOutI = ( int16_t ) dataOut;
  int16_t dataInI =  ( int16_t ) dataIn;
  int16_t expected = ( dataOutI * -1 );

  if( dataInI == expected )
    return true;

  // Else...
  Serial.printf( "mismatch.  result %d  does not match input  %d\n", dataOutI, dataInI );
  Serial.printf( "expected  %d\n\n", expected );
  return false;

}


void loop() {

  uint16_t result = 0;
  bool pass = false;

  #ifdef DEBUG
    if( opA % PRINT_EVERY == 0 )
      Serial.printf( "opA: %d\n", opA );
  #endif

  // Write data out and read the result in from the servant device
  result = writeReadData(opA);
  pass = testResult(opA, result);


  if( !pass )
    digitalWrite(LED_FAIL, HIGH);
  else
    digitalWrite(LED_FAIL, LOW);


  // Increment driver-counter, roll it over if necessary.  after that, a short delay and then back to the top
  opA = opA + 1;
  if(opA>32768)
    opA = 0;

  #ifdef DEBUG
    delay(DEBUG_DELAY);
  #else
    delayNanoseconds(50000);
  #endif

}
