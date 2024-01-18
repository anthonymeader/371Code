#include <msp430.h> 


/**
 * main.c
 */
char Data_In;
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    //1. Put eUSCI B0 into SW Reset
    UCB0CTLW0 |= UCSWRST;

    //2. Set up eUSCI B0
    UCB0CTLW0 |= UCSSEL__SMCLK;
    UCB0BRW = 10; //divide by 10 to get 100khz SCK

    UCB0CTLW0 |= UCMODE_3; // puts B0 into I2C mode
    UCB0CTLW0 |= UCMST;    // make I2C master
    UCB0CTLW0 &= ~UCTR;      // recieve mode
    UCB0I2CSA = 0x68;        //slave address for rtc
    UCB0CTLW1 |= UCASTP_2;  // auto stop when UCB0TBCNT reached
    UCB0TBCNT = sizeof(Packet); //send 1 byte of data

    //3. Set up Ports
    P1SEL1 &= ~BIT3;     //P1.3 - SCL(01)
    P1SEL0 |= BIT3;

    P1SEL1 &= ~BIT2;     //P1.2 - SDA(01)
    P1SEL0 |= BIT2;

    PM5CTL0 &= ~LOCKLPM5;   // turn on io

    //4. Take out of reset
    UCB0CTLW0 &= ~UCSWRST;

    //-- 5. Enable interrupt
    UCB0IE |= UCRXIE0;      // enable I2C IRQ fpr RX ready..
    __enable_interrupt();
    int i;
    while(1){
        UCB0CTLW0 |= UCTXSTT; //Generate Start!
        for(i = 0; i < 100; i++){

        }
    }

    return 0;
}
// ISR ---------------------------
#pragma vecotr = EUSCI_B0_VECTOR
__interrupt void B0_I2C_Tx(void){

    Data_In = UCB0RXBUF;

}









