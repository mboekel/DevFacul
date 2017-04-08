void main()
{
 TRISB.RB0 = 1;
 TRISD.RD0 = 0;
 
 while(1)
 {
   if (PORTB.RB0==0)
   {
     PORTD.RD0 = 1;
     Delay_ms(100);
     PORTD.RD0 = 0;

   }
 }
}