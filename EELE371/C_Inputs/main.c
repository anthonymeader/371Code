#include <msp430.h> 


/**
 * main.c
 */
int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	//-Setup ports
	P1DIR |= BIT0;  // Make LED1=P1.0 an output
	P1OUT &= ~BIT0; // Clear LED1 initially

	P4DIR &= ~BIT1; // Make SW1=P4.1 an input
	P4REN |= BIT1;  // Enable pull up/down resistors
	P4OUT |= BIT1;  // Make resistor a pull up

	PM5CTL0 &= ~LOCKLPM5;    // turns on I/O

	//-- Setup IRQs = Port IRQ on P4.1
	P4IES |= BIT1;   //Set IRQ edge sensitivitiy
	P4IFG &= ~BIT1;
	P4IE  |= BIT1;    // turn on P4.w IRQ locaclly
	__enable_interrupt();

	int SW1;

	while(1){

	}
	return 0;
}

//-----------------
//Interupt Service Routines
//-----------------
#pragma vector = PORT4_VECTOR
__interrupt void ISR_Port4_S1(void){
    P1OUT ^= BIT0;  // Toggle LED1 = P1.0
    P4IFG &= ~BIT1;
}




