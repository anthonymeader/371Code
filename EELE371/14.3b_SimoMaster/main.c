#include <msp430.h> 


/**
 * main.c
 */
int Rx_Data;

int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    UCA0CTLW0 |= UCSWRST;

    UCA0CTLW0 |= UCSSEL__SMCLK;
    UCA0BRW = 10;

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

    P1SEL1 &= ~BIT5;
    P1SEL0 |= BIT5;

    P1SEL1 &= ~BIT7;
    P1SEL0 |= BIT7;

    P1SEL1 &= ~BIT6;
    P1SEL0 |= BIT6;


    PM5CTL0 &= ~LOCKLPM5;

    UCA0CTLW0 &= ~UCSWRST;

    P4IFG &= ~BIT1;
    P4IE |= BIT1;

    P2IFG &= ~BIT3;
    P2IE |= BIT3;

    UCA0IFG &= ~UCRXIFG;
    UCA0IE |= UCRXIE;

    __enable_interrupt();

    while(1){}

    return 0;
}

#pragma vector = PORT4_VECTOR
__interrupt void ISR_Port4_S1(void){
    UCA0TXBUF = 0xEE;
    P4IFG &= ~BIT1;
}

#pragma vector = PORT2_VECTOR
__interrupt void ISR_Port2_S2(void){
    UCA0TXBUF = 0x37;
    P2IFG &= ~BIT3;
}
#pragma vector = EUSCI_A0_VECTOR
__interrupt void ISR_EUSCI_A0(void){
    Rx_Data = UCA0RXBUF;

    if(Rx_Data == 0xEE){
        P1OUT ^= BIT0;
    }
    else if (Rx_Data == 0x37){
        P6OUT ^= BIT6;
    }
}









