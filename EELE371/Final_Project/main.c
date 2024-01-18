#include <msp430.h> 

char message[] = "Rotating Right... ";
char message2[] = "Rotating Left... ";
int position;
int position2;
int i;
int cases;
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    UCA1CTLW0 |= UCSWRST;
    UCA1CTLW0 |= UCSSEL__SMCLK;
    UCA1BRW = 8;
    UCA1MCTLW |= 0xD600;
    P1DIR |= BIT0;
    P1OUT &= ~BIT0;

    P6DIR |= BIT6;
    P6OUT &= ~BIT6;

    P1DIR |= BIT4;
    P1OUT |= BIT4;
    P4DIR &= ~BIT1; // Make SW1=P4.1 an input
    P4REN |= BIT1;  // Enable pull up/down resistors
    P4OUT |= BIT1;  // Make resistor a pull up

    P2DIR &= ~BIT3; // Make SW1=P4.1 an input
    P2REN |= BIT3;  // Enable pull up/down resistors
    P2OUT |= BIT3;  // Make resistor a pull up
    P4IES |= BIT1;   //Set IRQ edge sensitivitiy
    P4IFG &= ~BIT1;
    P4IE  |= BIT1;    // turn on P4.w IRQ locaclly
    P2IES |= BIT3;   //Set IRQ edge sensitivitiy
    P2IFG &= ~BIT3;
    P2IE  |= BIT3;    // turn on P4.w IRQ locaclly

    TB0CTL |= TBCLR;        //Clear time to configure
    TB0CTL |= TBSSEL__SMCLK; //Set Sourceto ACLK
    TB0CTL |= MC__UP;       //Set Mode Control to up
    TB0CCR0 = 20000;        //Set roll over value for PWM
    TB0CCR1 = 1500;         //Set Duty Cycle


    TB0CCTL0 |= CCIE;     // Local Enable for CCR0 IRQ
    TB0CCTL0 &= ~CCIFG;     //clears CCR0 IRQ flag
    TB0CCTL1 |= CCIE;     // Local Enable for CCR1 IRQ
    TB0CCTL1 &= ~CCIFG;     //clears CCR1 IRQ flag

    P4SEL1 &= ~BIT3;
    P4SEL0 |= BIT3;

    PM5CTL0 &= ~LOCKLPM5;
    UCA1CTLW0 &= ~UCSWRST;
    __enable_interrupt();

    while(1){

    }

    return 0;
}

#pragma vector = PORT4_VECTOR
__interrupt void ISR_Port4_S1(void){
    position = 0;
    UCA1IE |= UCTXCPTIE;
    UCA1IFG &= ~UCTXCPTIFG;
    UCA1TXBUF = message[position];
    cases = 0;
    TB0CCR1 = TB0CCR1 + 100;
    if (TB0CCR1 >= 2000){
        TB0CCR1 = 2000;
        }

    P4IFG &= ~BIT1;
}

#pragma vector = PORT2_VECTOR
__interrupt void ISR_Port2_S3(void){
    position2 = 0;
    UCA1IE |= UCTXCPTIE;
    UCA1IFG &= ~UCTXCPTIFG;
    UCA1TXBUF = message2[position2];
    cases = 1;
    TB0CCR1 = TB0CCR1 - 100;
    if (TB0CCR1 <= 1000){
        TB0CCR1 = 1000;
    }

    P2IFG &= ~BIT3;
}
#pragma vector = TIMER0_B0_VECTOR
__interrupt void _ISR_TB0_CCR0(void){
    P1OUT |= BIT4;
    TB0CCTL0 &= ~CCIFG;

}
#pragma vector = TIMER0_B1_VECTOR
__interrupt void _ISR_TB0_CCR1(void){
    P1OUT &= ~BIT4;
    TB0CCTL1 &= ~CCIFG;

}
#pragma vector = EUSCI_A1_VECTOR
__interrupt void ISR_EUSCI_A1(void){
    switch(cases){
        case 0:
            if(position == sizeof(message)){
                P1OUT ^= BIT0;
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
                P6OUT ^= BIT6;
                UCA1IE &= ~UCTXCPTIE;
            }
            else{
                position2++;
                UCA1TXBUF = message2[position2];
            }
            UCA1IFG &= ~UCTXCPTIFG;
            break;
    }
}

