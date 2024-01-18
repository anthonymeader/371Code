#include <msp430.h> 


/**
 * main.c
 */
//char Data_In;
int position;
int position2;
char message[] = " Seconds = ";
char Received[] = " Seconds = ";
int i;
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    //1. Put eUSCI B0 into SW Reset
    UCB0CTLW0 |= UCSWRST;
    UCA1CTLW0 |= UCSWRST;

    UCA1CTLW0 |= UCSSEL__SMCLK;
    UCA1BRW = 8;
    UCA1MCTLW |= 0xD600;

    //2. Set up eUSCI B0
    UCB0CTLW0 |= UCSSEL__SMCLK;
    UCB0BRW = 10; //divide by 10 to get 100khz SCK
    UCB0CTLW0 |= UCMODE_3; // puts B0 into I2C mode
    UCB0CTLW0 |= UCMST;    // make I2C master
    UCB0CTLW0 &= ~UCTR;      // recieve mode
    UCB0I2CSA = 0x0068;        //slave address for rtc
    UCB0CTLW1 |= UCASTP_2;  // auto stop when UCB0TBCNT reached
    UCB0TBCNT = 1; //send 1 byte of data


    //3. Set up Ports
    P1SEL1 &= ~BIT3;     //P1.3 - SCL(01)
    P1SEL0 |= BIT3;
    P1SEL1 &= ~BIT2;     //P1.2 - SDA(01)
    P1SEL0 |= BIT2;

    P1DIR |= BIT0;
    P1OUT &= ~BIT0;
    P6DIR |= BIT6;
    P6OUT &= ~BIT6;

    P4DIR &= ~BIT1;
    P4REN |= BIT1;
    P4OUT |= BIT1;
    P4IES |= BIT1;

    P4SEL1 &= ~BIT3;
    P4SEL0 |= BIT3;

    PM5CTL0 &= ~LOCKLPM5;   // turn on io

    //4. Take out of reset
    UCB0CTLW0 &= ~UCSWRST;
    UCA1CTLW0 &= ~UCSWRST;

    //-- 5. Enable interrupt
    UCB0IE |= UCTXIE0;      // enable I2C IRQ fpr Tx ready..
    UCB0IE |= UCRXIE0;

    P4IFG &= ~BIT1;
    P4IE |= BIT1;

    __enable_interrupt();

    while(1){
        //SEND
        UCB0TBCNT = 1;
        UCB0CTLW0 |= UCTR;
        UCB0CTLW0 |= UCTXSTT; //Generate Start!
        while ((UCB0IFG & UCSTPIFG) == 0);
            UCB0IFG &= ~UCSTPIFG;
        //READ
        UCB0TBCNT = 1;
        UCB0CTLW0 &= ~UCTR;
        UCB0CTLW0 |= UCTXSTT;
        while ((UCB0IFG & UCSTPIFG) == 0);
        UCB0IFG &= ~UCSTPIFG;

    }
    return 0;
}
// ISR ---------------------------
#pragma vector=EUSCI_B0_VECTOR
__interrupt void EUSCI_B0_I2C_ISR(void){
    switch(UCB0IV){
        case 0x16:
            Received[position] = UCB0RXBUF;
            if (position == sizeof(Received) - 1){
                position = 0;
            }
            else{
                position++;
            }
            break;
        case 0x18:
            UCB0TXBUF = 0x03;
            break;
        default:
            break;
    }
}
#pragma vector = PORT4_VECTOR
__interrupt void ISR_PORT4_S1(void){
    position = 0;
    UCA1IE |= UCTXCPTIE;
    UCA1IFG &= ~UCTXCPTIFG;
    UCA1TXBUF = Received[position];
    //UCA1TXBUF = ((Received[position] & 0xF0)>>4)+ '0';
    //for (i =0; i<100; i++){}
    //UCA1TXBUF = (Received[position] & 0x0F) + '0';
    //for (i = 0; i < 100; i++){}

    UCA1TXBUF = '\n';
    for (i = 0; i<100; i++){}
    UCA1TXBUF = '\r';
    for (i = 0; i<100; i++){}
    P4IFG &= ~BIT1;
}
#pragma vector = EUSCI_A1_VECTOR
__interrupt void ISR_EUSCI_A1(void){

    if(position == sizeof(Received)){
        UCA1IE &= ~UCTXCPTIE;
    }
    else{
        position++;
        UCA1TXBUF = Received[position];

    }
    UCA1TXBUF &= ~UCTXCPTIFG;
}






