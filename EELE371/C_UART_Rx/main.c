#include <msp430.h> 


/**
 * main.c
 */
int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	UCA1CTLW0 |= UCSWRST;

	UCA1CTLW0 |= UCSSEL__SMCLK;
	UCA1BRW = 8;
	UCA1MCTLW |= 0xD600;


	P4SEL1 &= ~BIT2;
	P4SEL0 |= BIT2;

	P1DIR |= BIT0;
	P1OUT &= ~BIT0;

	PM5CTL0 &= ~LOCKLPM5;

	UCA1CTLW0 &= ~UCSWRST;

	UCA1IE |= UCRXIE;
	__enable_interrupt();

	while(1){}
	return 0;
}

#pragma vector=EUSCI_A1_VECTOR
__interrupt void EUSCI_A1_Rx_ISR(void){
    if(UCA1RXBUF == 't'){
        P1OUT ^= BIT0;
    }
}
