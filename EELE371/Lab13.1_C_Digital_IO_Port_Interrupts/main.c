#include <msp430.h> 


/**
 * main.c
 *
 * Demo1
int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	P1DIR |= BIT0;  // Make LED1=P1.0 an output
	P1OUT &= ~BIT0; // Clear LED1 initially

	P6DIR |= BIT6;
	P6OUT &= ~BIT6;

	P4DIR &= ~BIT1; // Make SW1=P4.1 an input
	P4REN |= BIT1;  // Enable pull up/down resistors
	P4OUT |= BIT1;  // Make resistor a pull up

	P2DIR &= ~BIT3; // Make SW1=P4.1 an input
	P2REN |= BIT3;  // Enable pull up/down resistors
	P2OUT |= BIT3;  // Make resistor a pull up


	PM5CTL0 &= ~LOCKLPM5;    // turns on I/O


    //-- Setup IRQs = Port IRQ on P4.1
	int bit = 0;
    int i = 0;
    int SW1 = 0;
    int SW2 = 0;
	while(1){
	    SW1 = P4IN;
	    SW1 &= BIT1;

	    SW2 = P2IN;
	    SW2 &= BIT3;
	    if (SW1 == 0){
	        bit = bit + 1;
	    }
	    for(i = 0; i < 15000; i++){//delay loop

	    }
	    if (SW2 == 0){
	        bit = bit - 2;
	    }
	    for(i = 0; i < 15000; i++){//delay loop

	    }
	    switch(bit){

	    case 1: P1OUT &= ~BIT0;
                P6OUT |= BIT6;
                break;
	    case 2: P1OUT |= BIT0;
                P6OUT &= ~BIT6;
                break;
	    case 3: P1OUT |= BIT0;
	            P6OUT |= BIT6;
	            break;
	    default:P1OUT &= ~BIT0;
                P6OUT &= ~BIT6;
                break;
	    }

	}
	return 0;
}
  *Demo 2
  */
int bit = 0;
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    P1DIR |= BIT0;  // Make LED1=P1.0 an output
    P1OUT &= ~BIT0; // Clear LED1 initially

    P6DIR |= BIT6;
    P6OUT &= ~BIT6;

    P4DIR &= ~BIT1; // Make SW1=P4.1 an input
    P4REN |= BIT1;  // Enable pull up/down resistors
    P4OUT |= BIT1;  // Make resistor a pull up

    P2DIR &= ~BIT3; // Make SW1=P4.1 an input
    P2REN |= BIT3;  // Enable pull up/down resistors
    P2OUT |= BIT3;  // Make resistor a pull up

    PM5CTL0 &= ~LOCKLPM5;    // turns on I/O

    P4IES |= BIT1;   //Set IRQ edge sensitivitiy
    P4IFG &= ~BIT1;
    P4IE  |= BIT1;    // turn on P4.w IRQ locaclly

    P2IES |= BIT3;   //Set IRQ edge sensitivitiy
    P2IFG &= ~BIT3;
    P2IE  |= BIT3;    // turn on P4.w IRQ locaclly
    __enable_interrupt();

    while(1){
        switch(bit){
                case 1: P1OUT &= ~BIT0;
                        P6OUT |= BIT6;
                        break;
                case 2: P1OUT |= BIT0;
                        P6OUT &= ~BIT6;
                        break;
                case 3: P1OUT |= BIT0;
                        P6OUT |= BIT6;
                        break;
                default:P1OUT &= ~BIT0;
                        P6OUT &= ~BIT6;
                        break;
                }

    }

    return 0;
}

#pragma vector = PORT4_VECTOR
__interrupt void ISR_Port4_S1(void){
    bit = bit + 1;
    P4IFG &= ~BIT1;
}

#pragma vector = PORT2_VECTOR
__interrupt void ISR_Port2_S3(void){
    bit = bit - 2;
    P2IFG &= ~BIT3;
}






