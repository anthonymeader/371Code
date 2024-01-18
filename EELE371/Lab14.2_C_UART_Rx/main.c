#include <msp430.h> 


/**
 * main.c
 */
int Rx_Data;
char message[] = "S1 was pressed ";
char message2[] = "S2 was pressed ";
int position;
int position2;
int i;
int j;
int cases;
int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	UCA0CTLW0 |= UCSWRST;

	UCA0CTLW0 |= UCSSEL__SMCLK;
	UCA0BRW = 10;

    UCA1CTLW0 |= UCSWRST;
    UCA1CTLW0 |= UCSSEL__SMCLK;
    UCA1BRW = 8;
    UCA1MCTLW |= 0xD600;


	UCA0CTLW0 |= UCSYNC;
	UCA0CTLW0 |= UCMST;

	P1DIR |= BIT0;
	P1OUT &= ~BIT0;

	P6DIR |= BIT6;
	P6OUT &= ~BIT6;

	P4DIR &= ~BIT1;
	P4REN |= BIT1;
	P4OUT |= BIT1;
	P4IES |= BIT1;

	P2DIR &= ~BIT3;
	P2REN |= BIT3;
	P2OUT |= BIT3;
	P2IES |= BIT3;

	P4SEL1 &= ~BIT2;
	P4SEL0 |= BIT2;

    P4SEL1 &= ~BIT3;
    P4SEL0 |= BIT3;

	P1SEL1 &= ~BIT5;
	P1SEL0 |= BIT5;

	P1SEL1 &= ~BIT7;
	P1SEL0 |= BIT7;

	P1SEL1 &= ~BIT6;
	P1SEL0 |= BIT6;

	PM5CTL0 &= ~LOCKLPM5;

	UCA0CTLW0 &= ~UCSWRST;
    UCA1CTLW0 &= ~UCSWRST;


	P4IE |= BIT1;
	P4IFG &= ~BIT1;

    P2IE |= BIT3;
	P2IFG &= ~BIT3;

	UCA0IE |= UCRXIE;
    UCA0IFG &= ~UCRXIFG;
    UCA1IE |= UCRXIE;

	__enable_interrupt();

	while(1){}

	return 0;
}
#pragma vector = PORT4_VECTOR
__interrupt void ISR_Port4_S1(void){
    position = 0;
    UCA1IE |= UCTXCPTIE;
    UCA1IFG &= ~UCTXCPTIFG;
    UCA1TXBUF = message[position];
    cases = 0;


   // if (UCA1RXBUF == '1'){
   //     UCA0TXBUF = 0x31;
   //     }
    P4IFG &= ~BIT1;
}
#pragma vector =  PORT2_VECTOR
__interrupt void ISR_Port2_S2(void){
    position2 = 0;
    UCA1IE |= UCTXCPTIE;
    UCA1IFG &= ~UCTXCPTIFG;
    UCA1TXBUF = message2[position2];
    cases = 1;
   // if (UCA1RXBUF == '2'){
   // UCA0TXBUF = 0x32;
   // }
    P2IFG &= ~BIT3;
}

/*#pragma vector = EUSCI_A0_VECTOR
__interrupt void ISR_EUSCI_A0(void){
    Rx_Data = UCA0RXBUF;
    if (Rx_Data == 0x31){
        P1OUT ^= BIT0;
    }
    else if (Rx_Data == 0x32){
        P6OUT ^= BIT6;
    }

}*/
#pragma vector = EUSCI_A1_VECTOR
__interrupt void ISR_EUSCI_A1(void){





    switch(cases){
        case 0:
            if(position == sizeof(message)){
                UCA1IE &= ~UCTXCPTIE;
            }
            else{
                position++;
                UCA1TXBUF = message[position];
            }
            UCA1IFG &= ~UCTXCPTIFG;
            break;
        case 1:
            if(position2 == sizeof(message2)){
                UCA1IE &= ~UCTXCPTIE;
            }
            else{
                position2++;
                UCA1TXBUF = message2[position2];
            }
            UCA1IFG &= ~UCTXCPTIFG;
            break;
    }

    if (UCA1RXBUF == '1'){
        P1OUT ^= BIT0;
    }
    else if(UCA1RXBUF == '2'){
        P6OUT ^= BIT6;
    }
}
