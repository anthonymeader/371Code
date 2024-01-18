#include <msp430.h> 


/*
  main.c
*/
int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
  /*SetupPorts
   * Configure P1.0 (LED1) as output
   * Turn on GPIO
   * Turn off LED1
   */
	P1DIR |= BIT0;
	PM5CTL0 &= ~LOCKLPM5;  //GPIO stuff, to clear a bit (AND IT WITH ITS INVERSION)
	P1OUT &= ~BIT0;
	int i = 0;
	while(1){
	    P1OUT ^= BIT0;        //Toggle LED1
	    for (i = 0; i < 10000; i++){

	    }
	}
	
	return 0;
}
