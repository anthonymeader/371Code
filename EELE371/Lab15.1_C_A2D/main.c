#include <msp430.h> 


/**
 * main.c
 */
unsigned int ADC_Value;
int i;
int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	

	UCA1CTLW0 |= UCSWRST;
	UCA1CTLW0 |= UCSSEL__SMCLK;
	UCA1BRW = 8;
	UCA1MCTLW |= 0xD600;


	P1SEL1 |= BIT2;
	P1SEL0 |= BIT2;
	P4SEL1 &= ~BIT3;
	P4SEL0 |= BIT3;

	PM5CTL0 &= ~LOCKLPM5;
    UCA1CTLW0 &= ~UCSWRST;


	ADCCTL0 &= ~ADCSHT;
	ADCCTL0 |= ADCSHT_2;
	ADCCTL0 |= ADCON;

	ADCCTL1 |= ADCSSEL_2;
	ADCCTL1 |= ADCSHP;

	ADCCTL2 &= ~ADCRES;
	ADCCTL2 |= ADCRES_2;
	ADCMCTL0 |= ADCINCH_2;

	ADCIE |= ADCIE0;
	__enable_interrupt();
	while(1){
	    ADCCTL0 |= ADCENC | ADCSC;
	    while((ADCIFG & ADCIFG0) == 0);
	}

	return 0;
}

#pragma vector = ADC_VECTOR
__interrupt void ADC_ISR(void){
    ADC_Value = ADCMEM0;
    UCA1TXBUF = '+';
    if(ADC_Value > 4036){
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '3';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '.';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '4';
        for (i = 0; i < 300; i++){}

    }
    else if(ADC_Value > 3916 && ADC_Value <= 4036){
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '3';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '.';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '3';
        for (i = 0; i < 300; i++){}
    }
    else if(ADC_Value > 3796 && ADC_Value <= 3916){
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '3';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '.';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '2';
        for (i = 0; i < 300; i++){}
    }
    else if(ADC_Value > 3676 && ADC_Value <= 3796){
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '3';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '.';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '1';
        for (i = 0; i < 300; i++){}
    }
    else if(ADC_Value > 3556 && ADC_Value <= 3676){
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '3';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '.';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '3';
        for (i = 0; i < 300; i++){}
    }
    else if(ADC_Value > 3436 && ADC_Value <= 3556){
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '3';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '.';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '0';
        for (i = 0; i < 300; i++){}
    }
    else if(ADC_Value > 3316 && ADC_Value <= 3436){
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '2';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '.';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '9';
        for (i = 0; i < 300; i++){}
    }
    else if(ADC_Value > 3196 && ADC_Value <= 3316){
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '2';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '.';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '8';
        for (i = 0; i < 300; i++){}
    }
    else if(ADC_Value > 3076 && ADC_Value <= 3196){
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '2';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '.';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '7';
        for (i = 0; i < 300; i++){}
    }
    else if(ADC_Value > 2956 && ADC_Value <= 3076){
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '2';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '.';
        for (i = 0; i < 300; i++){}
        UCA1TXBUF = '6';
        for (i = 0; i < 300; i++){}
    }
    else if(ADC_Value > 2836 && ADC_Value <= 2956){
          for (i = 0; i < 300; i++){}
          UCA1TXBUF = '2';
          for (i = 0; i < 300; i++){}
          UCA1TXBUF = '.';
          for (i = 0; i < 300; i++){}
          UCA1TXBUF = '5';
          for (i = 0; i < 300; i++){}
      }
    else if(ADC_Value > 2716 && ADC_Value <= 2836){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '2';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '4';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 2596 && ADC_Value <= 2716){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '2';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '2';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 2476 && ADC_Value <= 2596){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '2';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 2356 && ADC_Value <= 2476){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '2';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 2236 && ADC_Value <= 2356){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '9';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 2116 && ADC_Value <= 2236){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '8';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 1996 && ADC_Value <= 2116){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '7';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 1876 && ADC_Value <= 1996){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '6';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 1756 && ADC_Value <= 1876){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '5';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 1636 && ADC_Value <= 1756){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '4';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 1516 && ADC_Value <= 1636){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '3';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 1396 && ADC_Value <= 1516){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '2';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 1276 && ADC_Value <= 1396){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 1156 && ADC_Value <= 1276){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 1036 && ADC_Value <= 1156){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '9';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 916 && ADC_Value <= 1036){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '8';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 796 && ADC_Value <= 916){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '7';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 676 && ADC_Value <= 796){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '6';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 556 && ADC_Value <= 676){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '5';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 436 && ADC_Value <= 556){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '4';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 316 && ADC_Value <= 436){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '3';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 196 && ADC_Value <= 316){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '2';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value > 76 && ADC_Value <= 196){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '1';
           for (i = 0; i < 300; i++){}
       }
    else if(ADC_Value >= 0 && ADC_Value <= 76){
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '.';
           for (i = 0; i < 300; i++){}
           UCA1TXBUF = '0';
           for (i = 0; i < 300; i++){}
       }
    else{
        P1OUT &= ~BIT0;
        P6OUT |= BIT6;
    }
    UCA1TXBUF = 'v';
    for (i = 0; i < 300; i++){}
    UCA1TXBUF = '\n';
    for (i = 0; i < 300; i++){}
    UCA1TXBUF = '\r';
    for (i = 0; i < 2000; i++){}
    for (i = 0; i < 10000; i++){}
}
