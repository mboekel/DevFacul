//      TESTE COM LCD

ADCON1 = 0x6;

// LCD module connections
sbit LCD_RS at RE0_bit;
sbit LCD_EN at RE1_bit;
sbit LCD_D4 at RC4_bit;
sbit LCD_D5 at RC5_bit;
sbit LCD_D6 at RC6_bit;
sbit LCD_D7 at RC7_bit;
sbit LCD_RS_Direction at TRISE0_bit;
sbit LCD_EN_Direction at TRISE1_bit;
sbit LCD_D4_Direction at TRISC4_bit;
sbit LCD_D5_Direction at TRISC5_bit;
sbit LCD_D6_Direction at TRISC6_bit;
sbit LCD_D7_Direction at TRISC7_bit;


char txt1[] = "mikroElektronika";
char txt2[] = "EasyPIC6";
char txt3[] = "Lcd4bit";
char txt4[] = "example";

char i;                              // Loop variable

void Move_Delay()
  {                  // Function used for text moving
  Delay_ms(500);                     // You can change the moving speed here
  }

void main(){
  //ANSEL  = 0;                        // Configure AN pins as digital I/O
  ANSELH = 0;
  C1ON_bit = 0;                      // Disable comparators
  C2ON_bit = 0;

  Lcd_Init();                        // Initialize LCD

  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
  Lcd_Out(1,6,txt3);                 // Write text in first row

  Lcd_Out(2,6,txt4);                 // Write text in second row
  Delay_ms(2000);
  Lcd_Cmd(_LCD_CLEAR);               // Clear display

  Lcd_Out(1,1,txt1);                 // Write text in first row
  Lcd_Out(2,5,txt2);                 // Write text in second row

  Delay_ms(2000);

  // Moving text
  for(i=0; i<4; i++) {               // Move text to the right 4 times
    Lcd_Cmd(_LCD_SHIFT_RIGHT);
    Move_Delay();
  }

  while(1) {                         // Endless loop
    for(i=0; i<8; i++) {             // Move text to the left 7 times
      Lcd_Cmd(_LCD_SHIFT_LEFT);
      Move_Delay();
    }

    for(i=0; i<8; i++) {             // Move text to the right 7 times
      Lcd_Cmd(_LCD_SHIFT_RIGHT);
      Move_Delay();
    }
  }
}