void main()
{
 TRISB.RB0 = 1;
 TRISD.RD0 = 0;
 
 while(1)
 {
   if (!PORTB.RB0)
   {
     PORTD.RD0 = 1;
     Delay_ms(1000);
   }
   else
       {
        PORTD.RD0 = 0;
        Delay_ms(1000);
        }
 }
}