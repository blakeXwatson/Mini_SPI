# Mini_SPI

Basic mode 0 SPI implementation.  Does exactly what I need right now and no more - data in, data out, easy to modify.\
<br>

The point of this project is to provide a simple, reusable SPI module for use in other projects.  It's not a comprehensive implementation of SPI by any means, but it could
  be adapted to operate in other modes quite easily.\
<br>

I needed to test some operations that don't seem to be well suited to testbenching.  The first thought was to get the data into a computer somewhere and compare the input, output, and expected result of the operation on there.  That works pretty well; here's one way to do it.\
<br>

Sources/<br>
  * The main Verilog code is in here.  It is all synthesizable<br><br>
    - Main.v            - Driver for an actual device.  Operates on the data in to produce some output to return.  Also drives the LEDs
    - IO.v              - Contains the main SPI servant module.  Shifts data in and sends data out
    - Complementer.v    - Complements the data inbound to produce the sample output.
    - ShiftRegister.v   - Contains a generic ShiftRegister module built on that.  Used to hold data in from the SPI master
<br>
<br>


Simulation/<br>
  * Testbenches for the IO and ShiftRegister modules can be found here.<br><br>
    - IO_Sim.v
    - ShiftRegister_Sim.v
<br>
<br>


Constraints/<br>
  * The constraints file for my particular device, and Artix-7 on an Alchitry AU dev board<br><br>
    - Constraints.xdc<br>

<br>
<br>


Test_Driver/<br>
  * Arduino code for physically driving this and using it to perform a test of the ComplementerN module<br><br>
    - SPI_TestDriver.ino<br>
  <br>
<br>
