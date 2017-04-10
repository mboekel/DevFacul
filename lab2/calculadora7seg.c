#define SUM 10
#define SUB 11
#define MUL 12
#define DIV 13
#define IGU 14
#define CLR 15


unsigned int display (int number);
int convertTecla (int tecla, KeyType* type);


int acumulador = 0;
int ultValor = 0;
int operador = -1;
int lastRead = 0xFF;


typedef enum keyType
{
        IGUAL, SOMA, SUB, MULT, DIVI, ON_CLEAR, NUM, EMPTY
}KeyType;

  char edge = 1; //tratar mudanca de nivel

  int operando1 = 0;
  int operando2 = 0;
  char text[40];
  KeyType operation = EMPTY;

// High priority interrupt function
  volatile char xx;
  
  unsigned int display (int number)
{
        switch(number)
        {
                case 0: return 0x3F ;
                case 1: return 0x06;
                case 2: return 0x5B;
                case 3: return 0x4F;
                case 4: return 0x66;
                case 5: return 0x6D;
                case 6: return 0x7D;
                case 7: return 0x07;
                case 8: return 0x7F;
                case 9: return 0x67;
        }
}



int convertTecla (int tecla, KeyType* type)
{
    int result = -1;
    switch(tecla)
    {
     case 231:
     *type = ON_CLEAR;
     break;

     case 215:
     *type = NUM;
     result = 0;
     break;

     case 183:
     *type = IGUAL;
     break;

     case 119:
     *type = SOMA;
     break;

     case 235:
     *type = NUM;
     result = 1;
     break;

     case 219:
     *type = NUM;
     result = 2;
     break;

     case 187:
     *type = NUM;
     result = 3;
     break;

     case 123:
     *type = SUB;
     break;

     case 237:
     *type = NUM;
     result = 4;
     break;

     case 221:
     *type = NUM;
     result = 5;
     break;

     case 189:
     *type = NUM;
     result = 6;
     break;

     case 125:
     *type = MULT;
     break;

     case 238:
     *type = NUM;
     result = 7;
     break;

     case 222:
     *type = NUM;
     result = 8;
     break;

     case 190:
     *type = NUM;
     result = 9;
     break;

     case 126:
     *type = DIVI;
     break;
    }

    return result;
}


  void interrupt(void){
   if(INTCON.RBIF)
   {
        char i;
        KeyType type;
        int result;

        for(i = 0, xx = 0x0f; (i < 4) && (xx==0x0f); i++)
        {
           PORTB.RB0 = 1; // digital output
           PORTB.RB1 = 1;
           PORTB.RB2 = 1;
           PORTB.RB3 = 1;
           if(i==0)PORTB.RB0 = 0; // digital output
           if(i==1)PORTB.RB1 = 0;
           if(i==2)PORTB.RB2 = 0;
           if(i==3)PORTB.RB3 = 0;
           xx = PORTB >> 4;
        }
        result = convertTecla(PORTB, &type);
        PORTB.RB0 = 0; // digital output
        PORTB.RB1 = 0;
        PORTB.RB2 = 0;
        PORTB.RB3 = 0;

        if(edge == 1)
        {
         Lcd_Cmd(_LCD_CLEAR);

          if(type == NUM && operation == EMPTY)
          {
           operando1 *= 10;
           operando1 += result;
           IntToStr(operando1, text);
          }
          if(type != NUM && type != ON_CLEAR && type != IGUAL)
          {
           operation = type;
          }
          if(type == NUM && operation != EMPTY)
          {
           operando2 *= 10;
           operando2 += result;
           IntToStr(operando2, text);
          }
          if(type == IGUAL)
          {
           if(operation == SOMA)
                   IntToStr(operando1 + operando2, text);

           if(operation == SUB)
                   IntToStr(operando1 - operando2, text);

           if(operation == MULT)
                   IntToStr(operando1 * operando2, text);

           if(operation == DIVI)
                   IntToStr(operando1 / operando2, text);
          }
          if(type == ON_CLEAR)
          {
           operando1 = 0;
           operando2 = 0;
           operation = EMPTY;
           IntToStr(0, text);
          }
    }

    edge = !edge;
    INTCON.RBIF = 0;
   }
 }


void main()
{
     //Pins as digital I/O
    ADCON1 = 0x6;

    // Global Interrupt Enable
    INTCON.GIE = 1;

    // Int0/PORTB0 interrupt config
    TRISB.RB4 = 1; // digital input
    TRISB.RB5 = 1; // digital input
    TRISB.RB6 = 1; // digital input
    TRISB.RB7 = 1; // digital input

    TRISB.RB0 = 0; // digital output
    TRISB.RB1 = 0; // digital output
    TRISB.RB2 = 0; // digital output
    TRISB.RB3 = 0; // digital output

    PORTB.RB0 = 0; // digital output
    PORTB.RB1 = 0; // digital output
    PORTB.RB2 = 0; // digital output
    PORTB.RB3 = 0; // digital output

    INTCON.RBIE = 1;
    INTCON.RBIF = 0;

        while(1)
        {
                tecla = nextKey();

                if (tecla != 0xFF)
                {
                        processaTecla(tecla);
                }

                show7seg(acumulador);
        }
}