#include <msp430.h> 


/**
 * main.c
 */
int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer

	//-- Setup Ports = LED1 = P1.0
	P1DIR |= BIT0;
	P1OUT |= BIT0;

	PM5CTL0 &= ~LOCKLPM5;

	P4DIR &= ~BIT1; // Make SW1=P4.1 an input
	P4REN |= BIT1;  // Enable pull up/down resistors
	P4OUT |= BIT1;  // Make resistor a pull up

	P2DIR &= ~BIT3; // Make SW1=P4.1 an input
    P2REN |= BIT3;  // Enable pull up/down resistors
    P2OUT |= BIT3;  // Make resistor a pull up

	//Setup Timer B0

	TB0CTL |= TBCLR;        //Clear time to configure
	TB0CTL |= TBSSEL__SMCLK; //Set Sourceto ACLK
	TB0CTL |= MC__UP;       //Set Mode Control to up
	TB0CCR0 = 1000;        //Set roll over value for PWM
	TB0CCR1 = 250;         //Set Duty Cycle

	//Set up CCR IRQs

	TB0CCTL0 |= CCIE;     // Local Enable for CCR0 IRQ
	TB0CCTL0 &= ~CCIFG;     //clears CCR0 IRQ flag
	TB0CCTL1 |= CCIE;     // Local Enable for CCR1 IRQ
	TB0CCTL1 &= ~CCIFG;     //clears CCR1 IRQ flag

	P4IES |= BIT1;   //Set IRQ edge sensitivitiy
	P4IFG &= ~BIT1;
	P4IE  |= BIT1;    // turn on P4.w IRQ locaclly

	P2IES |= BIT3;   //Set IRQ edge sensitivitiy
	P2IFG &= ~BIT3;
	P2IE  |= BIT3;    // turn on P4.w IRQ locaclly
	__enable_interrupt();
	while(1){

	}
	
	return 0;
}
#pragma vector = PORT4_VECTOR
__interrupt void ISR_Port4_S1(void){
    TB0CCR1 = TB0CCR1 + 25;
    if (TB0CCR1 >= 500){
        TB0CCR1 = 500;
        }
    P4IFG &= ~BIT1;
}

#pragma vector = PORT2_VECTOR
__interrupt void ISR_Port2_S3(void){
    TB0CCR1 = TB0CCR1 - 25;
    if (TB0CCR1 <= 25){
        TB0CCR1 = 250;
    }
    P2IFG &= ~BIT3;
}
#pragma vector = TIMER0_B0_VECTOR
__interrupt void _ISR_TB0_CCR0(void){
    P1OUT |= BIT0;
    TB0CCTL0 &= ~CCIFG;

}
#pragma vector = TIMER0_B1_VECTOR
__interrupt void _ISR_TB0_CCR1(void){
    P1OUT &= ~BIT0;
    TB0CCTL1 &= ~CCIFG;

}




