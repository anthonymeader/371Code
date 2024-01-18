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

	//Setup Timer B0

	TB0CTL |= TBCLR;        //Clear time to configure
	TB0CTL |= TBSSEL__ACLK; //Set Sourceto ACLK
	TB0CTL |= MC__UP;       //Set Mode Control to up
	TB0CCR0 = 32768;        //Set roll over value for PWM
	TB0CCR1 = 1638;         //Set Duty Cycle

	//Set up CCR IRQs

	TB0CCTL0 |= CCIE;     // Local Enable for CCR0 IRQ
	TB0CCTL0 &= ~CCIFG;     //clears CCR0 IRQ flag
	TB0CCTL1 |= CCIE;     // Local Enable for CCR1 IRQ
	TB0CCTL1 &= ~CCIFG;     //clears CCR1 IRQ flag
	__enable_interrupt();

	//main loop
	while(1){}


	return 0;
}

//-------------------------------------
//ISR Service Routines
//-------------------------------------
#pragma vector = TIMER0_B0_VECTOR
__interrupt void _ISR_TB0_CCR0(void)
{
    P1OUT |= BIT0;  //Set Led1 to 1
    TB0CCTL0 &= ~CCIFG; //Clear CCR0 Flag

}
#pragma vector = TIMER0_B1_VECTOR
__interrupt void _ISR_TB0_CCR1(void)
{
    P1OUT &= ~BIT0;  //Set Led1 to 1
    TB0CCTL1 &= ~CCIFG; //Clear CCR0 Flag

}
