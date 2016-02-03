
; *****************************************************************************
; *                                                                           *
; * PICAXE Connect Program                                              029   *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * Author  : Revolution Education Ltd                                        *
; *                                                                           *
; * Email   : support@picaxe.com                                              *
; * Website : www.picaxe.com                                                  *
; * Forum   : www.picaxeforum.co.uk                                           *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; *                                                                           *
; *                                                                           *
; *                                                                           *
; *                                                                           *
; *                                                                           *
; *                                                                           *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * Version History                                                           *
; *                                                                           *
; *     0.X     JB  Beta development versions                                 *
; *                                                                           *
; *     0.1     JB  Modified ADC                                              *
; *     0.2     JB  Modified ADC                                              *
; *     0.3     JB  Added PICAXE type prefix to all replies                   *
; *     0.4     JB  Remove PE5 support                                        *
; *     0.5     CPS Added sensor configurations                               *
; *     0.6     JB  Updated sensor configuration (unfinished)                 *
; *     0.7     JB  Steamlined ADC masking                                    *
; *     0.8     JB  Changed to single bit adcSetup setting and clearing       *
; *     0.9     JB                                                            *
; *     0.10    JB  Correct ADC mask / polling                                *
; *     0.11    JB  Improved motor control                                    *
; *     0.12    JB  Corrected pin reporting bug                               *
; *     0.13    JB  Simplified motor control as per S2P_095_CPS and onwards   *
; *     0.14    JB  Support for Motor C and D added for 40X2                  *
; *     0.15    JB  X2 Touch pins on ADC channels                             *
; *     0.16    JB  Reorganised reset command                                 *
; *     0.17    JB  Added extra I2C commands (nunchuck)                       *
; *     0.18    JB  I2C returns "READI2C" packet / I2C setup args swapped     *
; *     0.19    JB  I2C setup speed setting adjusted                          *
; *     0.20    JB  I2C READI2C 6-byte return. Fixed bug in testing code      *
; *     0.21    JB  I2C READI2C compile bug fixed                             *
; *     0.22    CPS Added RESETOUTPUTS outputs reset                          *
; *     0.23    JB  Added ReadEeprom and WriteEeprom                          *
; *     0.24    JB  Added Infrared+1 sensor - No actual code change           *
; *     0.25    JB  Added D for Display On LCD                                *
; *     0.26    JB  Fixed baudrate for LCD output                             *
; *     0.27    JB  Added INFRAIN+1                                           *
; *     0.28    JB  Removed INFRAIN+1                                         *
; *     0.29    JB  Fixed ULTRA frequency                                     *
; *                                                                           *
; *****************************************************************************

  Symbol VERSION_MAJOR = 0
  Symbol VERSION_MINOR = 29

; .---------------------------------------------------------------------------.
; | Define the PICAXE type during testing                                     |
; |---------------------------------------------------------------------------|
; |                                                                           |
; | Note that there should be no #Picaxe type in the program code which is to |
; | be downloaded into any chip by PE6 or S2P or it will not compile for the  |
; | chip actually selected.                                                   |
; |                                                                           |
; `---------------------------------------------------------------------------'

; #Picaxe 08M2

; .---------------------------------------------------------------------------.
; | Select output format                                                      |
; |---------------------------------------------------------------------------|
; |                                                                           |
; | The default output format is as compact as possible, designed to be sent  |
; | quickly from the PICAXE to the PC. In that respect it is not useful when  |
; | trying to immediately comprehend the data sent.                           |
; |                                                                           |
; | When the VERBOSE definition is included the data will be sent in a more   |
; | human readble format.                                                     |
; |                                                                           |
; | Either include the "#Define VERBOSE" line or comment it out. Anything     |
; | which recives the data should be able to handle the data in either of the |
; | two formats.                                                              |
; |                                                                           |
; | It may be possible to make this a programmable option but is currently a  |
; | compile time option.                                                      |
; |                                                                           |
; `---------------------------------------------------------------------------'

; #Define VERBOSE

; *****************************************************************************
; *                                                                           *
; * Check this code can be compiled for the PICAXE selected                   *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * Currently the code is only written for M2 and X2 chips. If more are added *
; * this section and other parts of the code must be updated to enable full   *
; * support for those chips.                                                  *
; *                                                                           *
; *****************************************************************************

  #IfDef _08M2
    #Define _isM2
    #Define _isOK
  #EndIf

  #IfDef _14M2
    #Define _isM2
    #Define _isOK
  #EndIf

  #IfDef _18M2
    #Define _isM2
    #Define _isOK
  #EndIf

  #IfDef _20M2
    #Define _isM2
    #Define _isOK
  #EndIf

  #IfDef _20X2
    #Define _isX2
    #Define _isOK
  #EndIf

  #IfDef _28X2
    #Define _isX2
    #Define _isOK
  #EndIf

  #IfDef _40X2
    #Define _isX2
    #Define _isOK
  #EndIf

  #IfDef _isOK
    #Undefine _isOK
  #Else
    #Error This code is not suitable for currently selected PICAXE type
  #EndIf

; *****************************************************************************
; *                                                                           *
; * Specify baud rate of SERTXD and SERRXD used                               *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * This is mostly an infortive entry but does ensure the Programming Editor  *
; * Terminal switches to the correct baud rate if the code is explicitly      *
; * downloaded for testing purposes rather than automatically downloaded by   *
; * Programming Editor or Scraxe.                                             *
; *                                                                           *
; *****************************************************************************

  #Terminal 19200

; *****************************************************************************
; *                                                                           *
; * Define the operational speed of this program                              *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * We want to run quite fast to make this program as responsive as possible  *
; * and to keep SERTXD and SERRXD baud rates high to minimise transmission    *
; * times.                                                                    *
; *                                                                           *
; * Baud rates of 19200 are reasonbly fast and supported by a physical serial *
; * cables, AXE027 and many PICAXE chips.                                     *
; *                                                                           *
; * The FREQ setting is the speed required to run the chip at to obtain the   *
; * desired baud rate, FREQ_DEFAULT is the normal operating speed of the chip *
; * and FREQ_MULTIPLIER is how many times faster the chip is running over its *
; * default speed. This is used to adjust time constants when running at the  *
; * operational speed.                                                        *
; *                                                                           *
; * FREQ_DEFAULT is simply informative and for reference. It is not easy to   *
; * mathematically calculate the actual FREQ_MULTIPLIER so it is easier to    *
; * have FREQ_MULTIPLIER set by hand. Having FREQ and FREQ_DEFAULT makes it   *
; * easier to spot any errors.                                                *
; *                                                                           *
; *****************************************************************************

  #IfDef _isM2 Then
    Symbol FREQ            = M16
    Symbol FREQ_DEFAULT    = M4
    Symbol FREQ_MULTIPLIER = 4
    Symbol FREQ_N2400      = N2400_16
    #Define _isOK
  #EndIf

  #IfDef _isX2 Then
    Symbol FREQ            = M16
    Symbol FREQ_DEFAULT    = M8
    Symbol FREQ_MULTIPLIER = 2
    Symbol FREQ_N2400      = N2400_16
    #Define _isOK
  #EndIf

  #IfDef _isOK
    #Undefine _isOK
  #Else
    #Error No FREQ / FREQ_MULTIPLIER set for PICAXE type
  #EndIf

; *****************************************************************************
; *                                                                           *
; * Constants                                                                 *
; *                                                                           *
; *****************************************************************************

; .---------------------------------------------------------------------------.
; | Time constants                                                            |
; |---------------------------------------------------------------------------|
; |                                                                           |
; | Because the chip operates at different speeds above its default depending |
; | on type we have to adjust time constants accordingly. We specify all time |
; | constants in milliseconds and adjust according to the FREQ_MULTIPLIER     |
; | in use.                                                                   |
; |                                                                           |
; | If a new time period is added into the code it should be specified as an  |
; | MS_XXX constant then added here.                                          |
; |                                                                           |
; `---------------------------------------------------------------------------'

  Symbol MS_10       = 10   * FREQ_MULTIPLIER   ; 10ms
  Symbol MS_20       = 20   * FREQ_MULTIPLIER   ; 20ms
  Symbol MS_100      = 100  * FREQ_MULTIPLIER   ; 100ms
  Symbol MS_500      = 500  * FREQ_MULTIPLIER   ; 500ms
  Symbol MS_1000     = 1000 * FREQ_MULTIPLIER   ; 1000ms = 1 second

; .---------------------------------------------------------------------------.
; | Timeout constants                                                         |
; |---------------------------------------------------------------------------|
; |                                                                           |
; |                                                                           |
; |                                                                           |
; |                                                                           |
; |                                                                           |
; |                                                                           |
; `---------------------------------------------------------------------------'

  Symbol MAX_TIMEOUT = MS_1000          ; 1000ms = 1 second
  Symbol MIN_TIMEOUT = MS_500           ; 500ms  = 1/2th second
  Symbol DEC_TIMEOUT = MS_20

; .---------------------------------------------------------------------------.
; | Useful character constants to make the program code more readable         |
; `---------------------------------------------------------------------------'

  Symbol SPACE       = " "              ; The space character
  Symbol COMMA       = ","              ; The comma character

; .---------------------------------------------------------------------------.
; | Analogue inputs available                                                 |
; `---------------------------------------------------------------------------'

   #IfDef _08M2
     ;                  CCCCCCCCBBBBBBBB
     ;                  7654321076543210
     Symbol MASK_CB  = %0001011000000000
   #EndIf

   #IfDef _14M2
     ;                  CCCCCCCCBBBBBBBB
     ;                  7654321076543210
     Symbol MASK_CB  = %0011111000010001
   #EndIf

   #IfDef _18M2
     ;                  CCCCCCCCBBBBBBBB
     ;                  7654321076543210
     Symbol MASK_CB  = %0000011111111110
   #EndIf

   #IfDef _20M2
     ;                  CCCCCCCCBBBBBBBB
     ;                  7654321076543210
     Symbol MASK_CB  = %1000111001111111
   #EndIf

   #IfDef _20X2
     ;                  CCCCCCCCBBBBBBBB                      DDDDDDDDAAAAAAAA
     ;                  7654321076543210                      7654321076543210
     Symbol MASK_CB  = %1000011101111111 : Symbol MASK_DA  = %0000000000000000
   #EndIf

   #IfDef _28X2
     ;                  CCCCCCCCBBBBBBBB                      DDDDDDDDAAAAAAAA
     ;                  7654321076543210                      7654321076543210
     Symbol MASK_CB  = %1111110000111111 : Symbol MASK_DA  = %0000000000001111
   #EndIf

   #IfDef _40X2
     ;                  CCCCCCCCBBBBBBBB                      DDDDDDDDAAAAAAAA
     ;                  7654321076543210                      7654321076543210
     Symbol MASK_CB  = %1111110000111111 : Symbol MASK_DA  = %1111111111101111
   #EndIf

; *****************************************************************************
; *                                                                           *
; * Variables                                                                 *
; *                                                                           *
; *****************************************************************************

; .---------------------------------------------------------------------------.
; | Define the basic variables used and their component parts                 |
; `---------------------------------------------------------------------------'

  Symbol reserveW0   = w0 ; b1:b0       ; Command value / General purpose
  Symbol reserveW1   = w1 ; b3:b2       ; Command parameter
  Symbol reserveW2   = w2 ; b5:b4       ; Command paramater / Return result

  Symbol w0.lsb      = b0
  Symbol w0.msb      = b1

  Symbol w1.lsb      = b2
  Symbol w1.msb      = b3

  Symbol w2.lsb      = b4
  Symbol w2.msb      = b5

; .---------------------------------------------------------------------------.
; | Define additional variables and their component parts                     |
; `---------------------------------------------------------------------------'

  Symbol timeout     = w3 ; b7:b6       ; Command timeout period

  Symbol adcMaskCB   = w4 ; b9:b8       ; Mask of ADC pins enabled (C:B)

  Symbol adcMaskB    = b8
  Symbol adcMaskC    = b9

  #IfDef _isX2

    Symbol adcMaskDA = w5 ; b11:b10     ; Mask of ADC pins enabled (D:A)

    Symbol adcMaskA  = b10
    Symbol adcMaskD  = b11

  #EndIf

; .---------------------------------------------------------------------------.
; | Bits when adcMaskCB for C (msb) and B (lsb) loaded into w0                |
; `---------------------------------------------------------------------------'

  Symbol bitB.0      = bit0
  Symbol bitB.1      = bit1
  Symbol bitB.2      = bit2
  Symbol bitB.3      = bit3
  Symbol bitB.4      = bit4
  Symbol bitB.5      = bit5
  Symbol bitB.6      = bit6
  Symbol bitB.7      = bit7

  Symbol bitC.0      = bit8
  Symbol bitC.1      = bit9
  Symbol bitC.2      = bit10
  Symbol bitC.3      = bit11
  Symbol bitC.4      = bit12
  Symbol bitC.5      = bit13
  Symbol bitC.6      = bit14
  Symbol bitC.7      = bit15

; .---------------------------------------------------------------------------.
; | Bits when adcMaskCB for D (msb) and A (lsb) loaded into w0                |
; `---------------------------------------------------------------------------'

  #IfDef _isX2

    Symbol bitA.0    = bit0
    Symbol bitA.1    = bit1
    Symbol bitA.2    = bit2
    Symbol bitA.3    = bit3
    Symbol bitA.4    = bit4
    Symbol bitA.5    = bit5
    Symbol bitA.6    = bit6
    Symbol bitA.7    = bit7

    Symbol bitD.0    = bit8
    Symbol bitD.1    = bit9
    Symbol bitD.2    = bit10
    Symbol bitD.3    = bit11
    Symbol bitD.4    = bit12
    Symbol bitD.5    = bit13
    Symbol bitD.6    = bit14
    Symbol bitD.7    = bit15

  #EndIf

; .---------------------------------------------------------------------------.
; | Bits for w1 - Makes it easier to know which bit is being referenced       |
; `---------------------------------------------------------------------------'

  Symbol w1.bit0     = bit16
  Symbol w1.bit1     = bit17
  Symbol w1.bit2     = bit18
  Symbol w1.bit3     = bit19
  Symbol w1.bit4     = bit20
  Symbol w1.bit5     = bit21
  Symbol w1.bit6     = bit22
  Symbol w1.bit7     = bit23

  Symbol w1.bit8     = bit24
  Symbol w1.bit9     = bit25
  Symbol w1.bit10    = bit26
  Symbol w1.bit11    = bit27
  Symbol w1.bit12    = bit28
  Symbol w1.bit13    = bit29
  Symbol w1.bit14    = bit30
  Symbol w1.bit15    = bit31

; *****************************************************************************
; *                                                                           *
; * Power on reset                                                            *
; *                                                                           *
; *****************************************************************************

PowerOnReset:

; .---------------------------------------------------------------------------.
; | Set the operating frequency of the chip                                   |
; `---------------------------------------------------------------------------'

  SetFreq FREQ

; .---------------------------------------------------------------------------.
; | Delay and send some ignored characters to clear any corruption            |
; `---------------------------------------------------------------------------'

  For b0 = 1 To 10
    Pause MS_10
    SerTxd( "+" )
  Next

; *****************************************************************************
; *                                                                           *
; * Fake a power on reset                                                     *
; *                                                                           *
; *****************************************************************************

FakeReset:

; .---------------------------------------------------------------------------.
; | Set the operating frequency of the chip                                   |
; `---------------------------------------------------------------------------'

  SetFreq FREQ

; .---------------------------------------------------------------------------.
; | All pins inputs, outputs low
; `---------------------------------------------------------------------------'

  #IfDef _isM2

    pinsB = 0
    pinsC = 0

    dirsB = 0
    dirsC = 0

  #Else

    pinsB = 0
    pinsC = 0
    pinsA = 0
    pinsD = 0

    dirsB = 0
    dirsC = 0
    dirsA = 0
    dirsD = 0

  #EndIf

; .---------------------------------------------------------------------------.
; | All ADC off
; `---------------------------------------------------------------------------'

  adcMaskCB = $0000

  #IfDef _isX2
    adcMaskDA = $0000
  #EndIf

  adcSetup = $0000

  #IfDef _28X2
    adcSetup2 = $0000
  #EndIf

  #IfDef _40X2
    adcSetup2 = $0000
  #EndIf

; .---------------------------------------------------------------------------.
; | Send a Reset packet                                                       |
; |---------------------------------------------------------------------------|
; |                                                                           |
; | This packet will have the format of -                                     |
; |                                                                           |
; |     [RESET <type>,<version>]                                              |
; |                                                                           |
; | Where -                                                                   |
; |                                                                           |
; |     <type>     PICAXE type code is running on, eg "08M2"                  |
; |                                                                           |
; |     <version>  Version of the code running, eg "1.23"                     |
; |                                                                           |
; `---------------------------------------------------------------------------'

  #IfDef _08M2
    SerTxd( "[08M2", SPACE, "RESET" )
    #Define _isOK
  #EndIf

  #IfDef _14M2
    SerTxd( "[14M2", SPACE, "RESET" )
    #Define _isOK
  #EndIf

  #IfDef _18M2
    SerTxd( "[18M2", SPACE, "RESET" )
    #Define _isOK
  #EndIf

  #IfDef _20M2
    SerTxd( "[20M2", SPACE, "RESET" )
    #Define _isOK
  #EndIf

  #IfDef _20X2
    SerTxd( "[20X2", SPACE, "RESET" )
    #Define _isOK
  #EndIf

  #IfDef _28X2
    SerTxd( "[28X2", SPACE, "RESET" )
    #Define _isOK
  #EndIf

  #IfDef _40X2
    SerTxd( "[40X2", SPACE, "RESET" )
    #Define _isOK
  #EndIf

  #IfDef _isOK
    #Undefine _isOK
  #Else
    #Error No RESET report for PICAXE type
  #EndIf

; .---------------------------------------------------------------------------.
; | Display the code's version number                                         |
; `---------------------------------------------------------------------------'

  SerTxd( SPACE, #VERSION_MAJOR, ".", #VERSION_MINOR )

; .---------------------------------------------------------------------------.
; | Initialise the timeout                                                    |
; `---------------------------------------------------------------------------'

  timeout = MAX_TIMEOUT

; *****************************************************************************
; *                                                                           *
; * Wait for a command to be received                                         *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; *
; *
; *
; *
; *
; *
; *
; *
; *                                                                           *
; *****************************************************************************

WaitForCommand:

  SerTxd( "]" )

  SerRxd [timeout,TimedOut], (">"), b0, #w1, #w2

  ; .-------------------------------------------------------------------------.
  ; | All replies are prefixed with PICAXE type                               |
  ; `-------------------------------------------------------------------------'

  #IfDef _08M2
    SerTxd( "[08M2", SPACE )
    #Define _isOK
  #EndIf

  #IfDef _14M2
    SerTxd( "[14M2", SPACE )
    #Define _isOK
  #EndIf

  #IfDef _18M2
    SerTxd( "[18M2", SPACE )
    #Define _isOK
  #EndIf

  #IfDef _20M2
    SerTxd( "[20M2", SPACE )
    #Define _isOK
  #EndIf

  #IfDef _20X2
    SerTxd( "[20X2", SPACE )
    #Define _isOK
  #EndIf

  #IfDef _28X2
    SerTxd( "[28X2", SPACE )
    #Define _isOK
  #EndIf

  #IfDef _40X2
    SerTxd( "[40X2", SPACE )
    #Define _isOK
  #EndIf

  #IfDef _isOK
    #Undefine _isOK
  #Else
    #Error No reply type report for PICAXE type
  #EndIf

  ; b0
  ; b0, w1
  ; b0, w1, w2
  ; b0, w1, w2.lsb, w2.msb
  ; b0, w1.lsb, w1.msb, w2.lsb, w2.msb

  Select Case b0

    Case "?" ; Polling Query

    Case "C" : Goto    CountCommand
    Case "D" : Goto    DisplayOnLcdCommand
    Case "G" : Goto    GetPinCommand
    Case "H" : High    w1
    Case "I" : IrOut   w1, w2.msb, w2.lsb
    Case "L" : Low     w1
    Case "M" : Goto    MotorCommand
    Case "P" : PulsOut w1, w2
    Case "R" : Goto    FakeReset
    Case "S" : Sound   w1, ( w2.msb, w2.lsb )
    Case "T" : Toggle  w1
    Case "V" : Servo   w1, w2
    Case "W" : PwmOut  w2.msb, w2.lsb, w1 ; Note order is reversed
    Case "X" : Goto    ResetOutputs

    Case "a" : Goto    SetPinAs
    Case "b" : Goto    I2cBlockCommand
    Case "g" : Goto    ReadEeprom         ; "get eeprom"
    Case "h" : Goto    ReadTempCommand
    Case "i" : Goto    IrInCommand
    Case "p" : Goto    WriteEeprom        ; "put eeprom"
    Case "r" : Goto    I2cEepromRead
    Case "s" : Goto    I2cEepromSetup
    Case "t" : Goto    TouchCommand
    Case "u" : Goto    UltraCommand
    Case "w" : Goto    I2cEepromWrite

    Else     : Goto    UnknownCommand

  End Select

    ;Below! Goto Polling

; *****************************************************************************
; *                                                                           *
; *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; *
; *
; *
; *
; *
; *
; *
; *
; *
; *
; *                                                                           *
; *****************************************************************************

Polling:

  ; Returned results are in the form of -

  ; A=nnn/nnn  = pinsA/dirsA
  ; B=nnn/nnn  = pinsB/dirsB
  ; C=nnn/nnn  = pinsC/dirsC
  ; D=nnn/nnn  = pinsD/dirsD

  ; Ax=nnn     = ADC Channel A.x
  ; Bx=nnn     = ADC Channel B.x
  ; Cx=nnn     = ADC Channel C.x
  ; Dx=nnn     = ADC Channel D.x

  ; .-------------------------------------------------------------------------.
  ; | 08M2                                                                    |
  ; `-------------------------------------------------------------------------'

  #IfDef _08M2

    #IfDef VERBOSE
      w2 = "C" : Gosub PollInit
    #Else
      SerTxd( "POLL", SPACE, "C=", #pinsC, "/", #dirsC )
    #EndIf

    w0.msb = adcMaskC &/ dirsC ; Adc on pins C

    If w0.msb = 0 Then WaitForCommand

    If bitC.1 = 1 Then : ReadAdc10 C.1, w2 : SerTxd( COMMA, "C1=", #w2 ) : End If
    If bitC.2 = 1 Then : ReadAdc10 C.2, w2 : SerTxd( COMMA, "C2=", #w2 ) : End If
    If bitC.4 = 1 Then : ReadAdc10 C.4, w2 : SerTxd( COMMA, "C4=", #w2 ) : End If

    #Define _isOK

  #EndIf

  ; .-------------------------------------------------------------------------.
  ; | 14M2                                                                    |
  ; `-------------------------------------------------------------------------'

  #IfDef _14M2

    #IfDef VERBOSE
      w2 = "B" : Gosub PollInit : Gosub PollNext
    #Else
      SerTxd( "POLL", SPACE, "B=", #pinsB, "/", #dirsB, _
                      COMMA, "C=", #pinsC, "/", #dirsC  )
    #EndIf

    w0.lsb = adcMaskB &/ dirsB ; Adc on pins B
    w0.msb = adcMaskC &/ dirsC ; Adc on pins C

    If w0 = 0 Then WaitForCommand

    If bitB.1 = 1 Then : ReadAdc10 B.1, w2 : SerTxd( COMMA, "B1=", #w2 ) : End If
    If bitB.2 = 1 Then : ReadAdc10 B.2, w2 : SerTxd( COMMA, "B2=", #w2 ) : End If
    If bitB.3 = 1 Then : ReadAdc10 B.3, w2 : SerTxd( COMMA, "B3=", #w2 ) : End If
    If bitB.4 = 1 Then : ReadAdc10 B.4, w2 : SerTxd( COMMA, "B4=", #w2 ) : End If
    If bitB.5 = 1 Then : ReadAdc10 B.5, w2 : SerTxd( COMMA, "B5=", #w2 ) : End If

    If bitC.0 = 1 Then : ReadAdc10 C.0, w2 : SerTxd( COMMA, "C0=", #w2 ) : End If
    If bitC.4 = 1 Then : ReadAdc10 C.4, w2 : SerTxd( COMMA, "C4=", #w2 ) : End If

    #Define _isOK

  #EndIf

  ; .-------------------------------------------------------------------------.
  ; | 18M2                                                                    |
  ; `-------------------------------------------------------------------------'

  #IfDef _18M2

    #IfDef VERBOSE
      w2 = "B" : Gosub PollInit : Gosub PollNext
    #Else
    SerTxd( "POLL", SPACE, "B=", #pinsB, "/", #dirsB, _
                    COMMA, "C=", #pinsC, "/", #dirsC  )
    #EndIf

    w0.lsb = adcMaskB &/ dirsB ; Adc on pins B
    w0.msb = adcMaskC &/ dirsC ; Adc on pins C

    If w0 = 0 Then WaitForCommand

    If bitB.1 = 1 Then : ReadAdc10 B.1, w2 : SerTxd( COMMA, "B1=", #w2 ) : End If
    If bitB.2 = 1 Then : ReadAdc10 B.2, w2 : SerTxd( COMMA, "B2=", #w2 ) : End If
    If bitB.3 = 1 Then : ReadAdc10 B.3, w2 : SerTxd( COMMA, "B3=", #w2 ) : End If
    If bitB.4 = 1 Then : ReadAdc10 B.4, w2 : SerTxd( COMMA, "B4=", #w2 ) : End If
    If bitB.5 = 1 Then : ReadAdc10 B.5, w2 : SerTxd( COMMA, "B5=", #w2 ) : End If
    If bitB.6 = 1 Then : ReadAdc10 B.6, w2 : SerTxd( COMMA, "B6=", #w2 ) : End If
    If bitB.7 = 1 Then : ReadAdc10 B.7, w2 : SerTxd( COMMA, "B7=", #w2 ) : End If

    If bitC.0 = 1 Then : ReadAdc10 C.0, w2 : SerTxd( COMMA, "C0=", #w2 ) : End If
    If bitC.1 = 1 Then : ReadAdc10 C.1, w2 : SerTxd( COMMA, "C1=", #w2 ) : End If
    If bitC.2 = 1 Then : ReadAdc10 C.2, w2 : SerTxd( COMMA, "C2=", #w2 ) : End If

    #Define _isOK

  #EndIf

  ; .-------------------------------------------------------------------------.
  ; | 20M2                                                                    |
  ; `-------------------------------------------------------------------------'

  #IfDef _20M2

    #IfDef VERBOSE
      w2 = "B" : Gosub PollInit : Gosub PollNext
    #Else
      SerTxd( "POLL", SPACE, "B=", #pinsB, "/", #dirsB, _
                      COMMA, "C=", #pinsC, "/", #dirsC  )
    #EndIf

    w0.lsb = adcMaskB &/ dirsB ; Adc on pins B
    w0.msb = adcMaskC &/ dirsC ; Adc on pins C

    If w0 = 0 Then WaitForCommand

    If bitB.0 = 1 Then : ReadAdc10 B.0, w2 : SerTxd( COMMA, "B0=", #w2 ) : End If
    If bitB.1 = 1 Then : ReadAdc10 B.1, w2 : SerTxd( COMMA, "B1=", #w2 ) : End If
    If bitB.2 = 1 Then : ReadAdc10 B.2, w2 : SerTxd( COMMA, "B2=", #w2 ) : End If
    If bitB.3 = 1 Then : ReadAdc10 B.3, w2 : SerTxd( COMMA, "B3=", #w2 ) : End If
    If bitB.4 = 1 Then : ReadAdc10 B.4, w2 : SerTxd( COMMA, "B4=", #w2 ) : End If
    If bitB.5 = 1 Then : ReadAdc10 B.5, w2 : SerTxd( COMMA, "B5=", #w2 ) : End If
    If bitB.6 = 1 Then : ReadAdc10 B.6, w2 : SerTxd( COMMA, "B6=", #w2 ) : End If

    If bitC.1 = 1 Then : ReadAdc10 C.1, w2 : SerTxd( COMMA, "C1=", #w2 ) : End If
    If bitC.2 = 1 Then : ReadAdc10 C.2, w2 : SerTxd( COMMA, "C2=", #w2 ) : End If
    If bitC.3 = 1 Then : ReadAdc10 C.3, w2 : SerTxd( COMMA, "C3=", #w2 ) : End If
    If bitC.7 = 1 Then : ReadAdc10 C.7, w2 : SerTxd( COMMA, "C7=", #w2 ) : End If

    #Define _isOK

  #EndIf

  ; .-------------------------------------------------------------------------.
  ; | 20X2                                                                    |
  ; `-------------------------------------------------------------------------'

  #IfDef _20X2

    #IfDef VERBOSE
      w2 = "B" : Gosub PollInit : Gosub PollNext
    #Else
      SerTxd( "POLL", SPACE, "B=", #pinsB, "/", #dirsB, _
                      COMMA, "C=", #pinsC, "/", #dirsC  )
    #EndIf

    w0.lsb = adcMaskB &/ dirsB ; Adc on pins B
    w0.msb = adcMaskC &/ dirsC ; Adc on pins C

    If w0 = 0 Then WaitForCommand

    If bitB.0 = 1 Then : ReadAdc10 B.0, w2 : SerTxd( COMMA, "B0=", #w2 ) : End If
    If bitB.1 = 1 Then : ReadAdc10 B.1, w2 : SerTxd( COMMA, "B1=", #w2 ) : End If
    If bitB.2 = 1 Then : ReadAdc10 B.2, w2 : SerTxd( COMMA, "B2=", #w2 ) : End If
    If bitB.3 = 1 Then : ReadAdc10 B.3, w2 : SerTxd( COMMA, "B3=", #w2 ) : End If
    If bitB.4 = 1 Then : ReadAdc10 B.4, w2 : SerTxd( COMMA, "B4=", #w2 ) : End If
    If bitB.5 = 1 Then : ReadAdc10 B.5, w2 : SerTxd( COMMA, "B5=", #w2 ) : End If
    If bitB.6 = 1 Then : ReadAdc10 B.6, w2 : SerTxd( COMMA, "B6=", #w2 ) : End If

    If bitC.1 = 1 Then : ReadAdc10 C.1, w2 : SerTxd( COMMA, "C1=", #w2 ) : End If
    If bitC.2 = 1 Then : ReadAdc10 C.2, w2 : SerTxd( COMMA, "C2=", #w2 ) : End If
    If bitC.3 = 1 Then : ReadAdc10 C.3, w2 : SerTxd( COMMA, "C3=", #w2 ) : End If
    If bitC.7 = 1 Then : ReadAdc10 C.7, w2 : SerTxd( COMMA, "C7=", #w2 ) : End If

    #Define _isOK

  #EndIf

  ; .-------------------------------------------------------------------------.
  ; | 28X2                                                                    |
  ; `-------------------------------------------------------------------------'

  #IfDef _28X2

    #IfDef VERBOSE
      w2 = "A" : Gosub PollInit : Gosub PollNext
                 Gosub PollNext : Gosub PollNext
    #Else
      SerTxd( "POLL", SPACE, "A=", #pinsA, "/", #dirsA, _
                      COMMA, "B=", #pinsB, "/", #dirsB, _
                      COMMA, "C=", #pinsC, "/", #dirsC, _
                      COMMA, "D=", #pinsD, "/", #dirsD  )
    #EndIf

    w0.lsb = adcMaskA &/ dirsA ; Adc on pins A

    If w0.lsb <> 0 Then

    If bitA.0 = 1 Then : ReadAdc10 A.0, w2 : SerTxd( COMMA, "A0=", #w2 ) : End If
    If bitA.1 = 1 Then : ReadAdc10 A.1, w2 : SerTxd( COMMA, "A1=", #w2 ) : End If
    If bitA.2 = 1 Then : ReadAdc10 A.2, w2 : SerTxd( COMMA, "A2=", #w2 ) : End If
    If bitA.3 = 1 Then : ReadAdc10 A.3, w2 : SerTxd( COMMA, "A3=", #w2 ) : End If

    End If

    w0.lsb = adcMaskB &/ dirsB ; Adc on pins B
    w0.msb = adcMaskC &/ dirsC ; Adc on pins C

    If w0 = 0 Then WaitForCommand

    If bitB.0 = 1 Then : ReadAdc10 B.0, w2 : SerTxd( COMMA, "B0=", #w2 ) : End If
    If bitB.1 = 1 Then : ReadAdc10 B.1, w2 : SerTxd( COMMA, "B1=", #w2 ) : End If
    If bitB.2 = 1 Then : ReadAdc10 B.2, w2 : SerTxd( COMMA, "B2=", #w2 ) : End If
    If bitB.3 = 1 Then : ReadAdc10 B.3, w2 : SerTxd( COMMA, "B3=", #w2 ) : End If
    If bitB.4 = 1 Then : ReadAdc10 B.4, w2 : SerTxd( COMMA, "B4=", #w2 ) : End If
    If bitB.5 = 1 Then : ReadAdc10 B.5, w2 : SerTxd( COMMA, "B5=", #w2 ) : End If

    If bitC.2 = 1 Then : ReadAdc10 C.2, w2 : SerTxd( COMMA, "C2=", #w2 ) : End If
    If bitC.3 = 1 Then : ReadAdc10 C.3, w2 : SerTxd( COMMA, "C3=", #w2 ) : End If
    If bitC.4 = 1 Then : ReadAdc10 C.4, w2 : SerTxd( COMMA, "C4=", #w2 ) : End If
    If bitC.5 = 1 Then : ReadAdc10 C.5, w2 : SerTxd( COMMA, "C5=", #w2 ) : End If
    If bitC.6 = 1 Then : ReadAdc10 C.6, w2 : SerTxd( COMMA, "C6=", #w2 ) : End If
    If bitC.7 = 1 Then : ReadAdc10 C.7, w2 : SerTxd( COMMA, "C7=", #w2 ) : End If

    #Define _isOK

  #EndIf

  ; .-------------------------------------------------------------------------.
  ; | 40X2                                                                    |
  ; `-------------------------------------------------------------------------'

  #IfDef _40X2

    #IfDef VERBOSE
      w2 = "A" : Gosub PollInit : Gosub PollNext
                 Gosub PollNext : Gosub PollNext
    #Else
      SerTxd( "POLL", SPACE, "A=", #pinsA, "/", #dirsA, _
                      COMMA, "B=", #pinsB, "/", #dirsB, _
                      COMMA, "C=", #pinsC, "/", #dirsC, _
                      COMMA, "D=", #pinsD, "/", #dirsD  )
    #EndIf

    w0.lsb = adcMaskA &/ dirsA ; Adc on pins A
    w0.msb = adcMaskD &/ dirsD ; Adc on pins D

    If w0 <> 0 Then

    If bitA.0 = 1 Then : ReadAdc10 A.0, w2 : SerTxd( COMMA, "A0=", #w2 ) : End If
    If bitA.1 = 1 Then : ReadAdc10 A.1, w2 : SerTxd( COMMA, "A1=", #w2 ) : End If
    If bitA.2 = 1 Then : ReadAdc10 A.2, w2 : SerTxd( COMMA, "A2=", #w2 ) : End If
    If bitA.3 = 1 Then : ReadAdc10 A.3, w2 : SerTxd( COMMA, "A3=", #w2 ) : End If
    If bitA.5 = 1 Then : ReadAdc10 A.5, w2 : SerTxd( COMMA, "A5=", #w2 ) : End If
    If bitA.6 = 1 Then : ReadAdc10 A.6, w2 : SerTxd( COMMA, "A6=", #w2 ) : End If
    If bitA.7 = 1 Then : ReadAdc10 A.7, w2 : SerTxd( COMMA, "A7=", #w2 ) : End If

    If bitD.0 = 1 Then : ReadAdc10 D.0, w2 : SerTxd( COMMA, "D0=", #w2 ) : End If
    If bitD.1 = 1 Then : ReadAdc10 D.1, w2 : SerTxd( COMMA, "D1=", #w2 ) : End If
    If bitD.2 = 1 Then : ReadAdc10 D.2, w2 : SerTxd( COMMA, "D2=", #w2 ) : End If
    If bitD.3 = 1 Then : ReadAdc10 D.3, w2 : SerTxd( COMMA, "D3=", #w2 ) : End If
    If bitD.4 = 1 Then : ReadAdc10 D.4, w2 : SerTxd( COMMA, "D4=", #w2 ) : End If
    If bitD.5 = 1 Then : ReadAdc10 D.5, w2 : SerTxd( COMMA, "D5=", #w2 ) : End If
    If bitD.6 = 1 Then : ReadAdc10 D.6, w2 : SerTxd( COMMA, "D6=", #w2 ) : End If
    If bitD.7 = 1 Then : ReadAdc10 D.7, w2 : SerTxd( COMMA, "D7=", #w2 ) : End If

    End If

    w0.lsb = adcMaskB &/ dirsB ; Adc on pins B
    w0.msb = adcMaskC &/ dirsC ; Adc on pins C

    If w0 = 0 Then WaitForCommand

    If bitB.0 = 1 Then : ReadAdc10 B.0, w2 : SerTxd( COMMA, "B0=", #w2 ) : End If
    If bitB.1 = 1 Then : ReadAdc10 B.1, w2 : SerTxd( COMMA, "B1=", #w2 ) : End If
    If bitB.2 = 1 Then : ReadAdc10 B.2, w2 : SerTxd( COMMA, "B2=", #w2 ) : End If
    If bitB.3 = 1 Then : ReadAdc10 B.3, w2 : SerTxd( COMMA, "B3=", #w2 ) : End If
    If bitB.4 = 1 Then : ReadAdc10 B.4, w2 : SerTxd( COMMA, "B4=", #w2 ) : End If
    If bitB.5 = 1 Then : ReadAdc10 B.5, w2 : SerTxd( COMMA, "B5=", #w2 ) : End If

    If bitC.2 = 1 Then : ReadAdc10 C.2, w2 : SerTxd( COMMA, "C2=", #w2 ) : End If
    If bitC.3 = 1 Then : ReadAdc10 C.3, w2 : SerTxd( COMMA, "C3=", #w2 ) : End If
    If bitC.4 = 1 Then : ReadAdc10 C.4, w2 : SerTxd( COMMA, "C4=", #w2 ) : End If
    If bitC.5 = 1 Then : ReadAdc10 C.5, w2 : SerTxd( COMMA, "C5=", #w2 ) : End If
    If bitC.6 = 1 Then : ReadAdc10 C.6, w2 : SerTxd( COMMA, "C6=", #w2 ) : End If
    If bitC.7 = 1 Then : ReadAdc10 C.7, w2 : SerTxd( COMMA, "C7=", #w2 ) : End If

    #Define _isOK

  #EndIf

  ; .-------------------------------------------------------------------------.
  ; | Template code for adding polling for another chip                       |
  ; `-------------------------------------------------------------------------'

  #IfDef _XXXX

    #IfDef VERBOSE
      w2 = "A" : Gosub PollInit : Gosub PollNext
                 Gosub PollNext : Gosub PollNext
    #Else
      SerTxd( "POLL", SPACE, "A=", #pinsA, "/", #dirsA, _
                      COMMA, "B=", #pinsB, "/", #dirsB, _
                      COMMA, "C=", #pinsC, "/", #dirsC, _
                      COMMA, "D=", #pinsD, "/", #dirsD  )
    #EndIf

    w0.lsb = adcMaskA &/ dirsA ; Adc on pins A
    w0.msb = adcMaskD &/ dirsD ; Adc on pins D

    If w0 <> 0 Then

    If bitA.0 = 1 Then : ReadAdc10 A.0, w2 : SerTxd( COMMA, "A0=", #w2 ) : End If
    If bitA.1 = 1 Then : ReadAdc10 A.1, w2 : SerTxd( COMMA, "A1=", #w2 ) : End If
    If bitA.2 = 1 Then : ReadAdc10 A.2, w2 : SerTxd( COMMA, "A2=", #w2 ) : End If
    If bitA.3 = 1 Then : ReadAdc10 A.3, w2 : SerTxd( COMMA, "A3=", #w2 ) : End If
    If bitA.5 = 1 Then : ReadAdc10 A.5, w2 : SerTxd( COMMA, "A5=", #w2 ) : End If
    If bitA.6 = 1 Then : ReadAdc10 A.6, w2 : SerTxd( COMMA, "A6=", #w2 ) : End If
    If bitA.7 = 1 Then : ReadAdc10 A.7, w2 : SerTxd( COMMA, "A7=", #w2 ) : End If

    If bitD.0 = 1 Then : ReadAdc10 D.0, w2 : SerTxd( COMMA, "D0=", #w2 ) : End If
    If bitD.1 = 1 Then : ReadAdc10 D.1, w2 : SerTxd( COMMA, "D1=", #w2 ) : End If
    If bitD.2 = 1 Then : ReadAdc10 D.2, w2 : SerTxd( COMMA, "D2=", #w2 ) : End If
    If bitD.3 = 1 Then : ReadAdc10 D.3, w2 : SerTxd( COMMA, "D3=", #w2 ) : End If
    If bitD.4 = 1 Then : ReadAdc10 D.4, w2 : SerTxd( COMMA, "D4=", #w2 ) : End If
    If bitD.5 = 1 Then : ReadAdc10 D.5, w2 : SerTxd( COMMA, "D5=", #w2 ) : End If
    If bitD.6 = 1 Then : ReadAdc10 D.6, w2 : SerTxd( COMMA, "D6=", #w2 ) : End If
    If bitD.7 = 1 Then : ReadAdc10 D.7, w2 : SerTxd( COMMA, "D7=", #w2 ) : End If

    End If

    w0.lsb = adcMaskB &/ dirsB ; Adc on pins B
    w0.msb = adcMaskC &/ dirsC ; Adc on pins C

    If w0 = 0 Then WaitForCommand

    If bitB.0 = 1 Then : ReadAdc10 B.0, w2 : SerTxd( COMMA, "B0=", #w2 ) : End If
    If bitB.1 = 1 Then : ReadAdc10 B.1, w2 : SerTxd( COMMA, "B1=", #w2 ) : End If
    If bitB.2 = 1 Then : ReadAdc10 B.2, w2 : SerTxd( COMMA, "B2=", #w2 ) : End If
    If bitB.3 = 1 Then : ReadAdc10 B.3, w2 : SerTxd( COMMA, "B3=", #w2 ) : End If
    If bitB.4 = 1 Then : ReadAdc10 B.4, w2 : SerTxd( COMMA, "B4=", #w2 ) : End If
    If bitB.5 = 1 Then : ReadAdc10 B.5, w2 : SerTxd( COMMA, "B5=", #w2 ) : End If

    If bitC.2 = 1 Then : ReadAdc10 C.2, w2 : SerTxd( COMMA, "C2=", #w2 ) : End If
    If bitC.3 = 1 Then : ReadAdc10 C.3, w2 : SerTxd( COMMA, "C3=", #w2 ) : End If
    If bitC.4 = 1 Then : ReadAdc10 C.4, w2 : SerTxd( COMMA, "C4=", #w2 ) : End If
    If bitC.5 = 1 Then : ReadAdc10 C.5, w2 : SerTxd( COMMA, "C5=", #w2 ) : End If
    If bitC.6 = 1 Then : ReadAdc10 C.6, w2 : SerTxd( COMMA, "C6=", #w2 ) : End If
    If bitC.7 = 1 Then : ReadAdc10 C.7, w2 : SerTxd( COMMA, "C7=", #w2 ) : End If

    #Define _isOK

  #EndIf

  #IfDef _isOK
    #Undefine _isOK
  #Else
    #Error No Polling routine for PICAXE type
  #EndIf

  Goto WaitForCommand

; *****************************************************************************
; *                                                                           *
; * Timedout - No command received                                            *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * The reply packet will have the format of -                                *
; *                                                                           *
; *     [TIMEOUT]                                                             *
; *                                                                           *
; * Note that we have a period of time during the timeout where we re-enable  *
; * downloads. This allows new code to be downloaded even if the PICAXE is    *
; * running this code, that is, it never blocks entirely under normal usage.  *
; *                                                                           *
; * We also slowly decrease the timeout period to give a better chance of any *
; * download attempt working.                                                 *
; *                                                                           *
; *****************************************************************************

TimedOut:

  timeout = timeout - DEC_TIMEOUT Min MIN_TIMEOUT

  #IfDef _08M2
    SerTxd( "[08M2", SPACE, "TIMEOUT" )
    #Define _isOK
  #EndIf

  #IfDef _14M2
    SerTxd( "[14M2", SPACE, "TIMEOUT" )
    #Define _isOK
  #EndIf

  #IfDef _18M2
    SerTxd( "[18M2", SPACE, "TIMEOUT" )
    #Define _isOK
  #EndIf

  #IfDef _20M2
    SerTxd( "[20M2", SPACE, "TIMEOUT" )
    #Define _isOK
  #EndIf

  #IfDef _20X2
    SerTxd( "[20X2", SPACE, "TIMEOUT" )
    #Define _isOK
  #EndIf

  #IfDef _28X2
    SerTxd( "[28X2", SPACE, "TIMEOUT" )
    #Define _isOK
  #EndIf

  #IfDef _40X2
    SerTxd( "[40X2", SPACE, "TIMEOUT" )
    #Define _isOK
  #EndIf

  #IfDef _isOK
    #Undefine _isOK
  #Else
    #Error No timeout report for PICAXE type
  #EndIf

  Reconnect

  Pause MS_100

  Disconnect

  Goto WaitForCommand

; *****************************************************************************
; *                                                                           *
; * Handle unknown and invalid commands                                       *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * The reply packet will have the format of -                                *
; *                                                                           *
; *     [UNKNOWN <b0>,<w1>,<w2>]                                              *
; *                                                                           *
; * or -                                                                      *
; *                                                                           *
; *     [INVALID <b0>,<w1>,<w2>]                                              *
; *                                                                           *
; *****************************************************************************

UnknownCommand:

  SerTxd( "UNKNOWN" )
  Goto EchoBackCommand

InvalidCommand:

  SerTxd( "INVALID" )

EchoBackCommand:

  SerTxd( SPACE, b0, COMMA, #w1, COMMA, #w2 )
  Goto WaitForCommand

; *****************************************************************************
; *                                                                           *
; *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; *
; *
; *
; *
; *
; *
; *
; *
; *                                                                           *
; *****************************************************************************

; .---------------------------------------------------------------------------.
; |                                                                           |
; |---------------------------------------------------------------------------|
; |                                                                           |
      ' 0------- = not configured
      ' 1------- = configured
      ' -0------ = input
      ' -1------ = output
      ' --0----- = digital
      ' --1----- = analogue
      ' ----nnnn = type

      ' 00000000 = unconfigured
      ' 11000001 = output
      ' 10000010 = switch
      ' 10100011 = analogue
      ' 10000100 = temperature
      ' 10000101 = unltrasonic
      ' 10000110 = infrared
      ' 10000111 = touch
      ' 10001000 = infrared+1
; |                                                                           |
; `---------------------------------------------------------------------------'

SetPinAs:
  b0 = w2
  If bit7 = 0 Then              ; 0------- Unconfigured
    Input w1
    Gosub ClradcMaskBitSub
  Else
    If bit6 = 1 Then            ; 11------ Output
      Output w1
      Gosub ClradcMaskBitSub
    Else
      Input w1
      If bit5 = 0 Then          ; 100----- Input - Digital
        Gosub ClradcMaskBitSub
      Else
        Gosub SetadcMaskBitSub  ; 101----- Input - Analogue
      End If
    End If
  End If
  Goto Polling

; *****************************************************************************
; *                                                                           *
; * Count pulses seen on a digital input pin                                  *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * The reply packet will have the format of -                                *
; *                                                                           *
; *     [COUNT <pin>=<count>]                                                 *
; *                                                                           *
; * Where -                                                                   *
; *                                                                           *
; *     <pin>         Is the pin read                                         *
; *                                                                           *
; *     <count>       Is the number of pulses seen on the pin read            *
; *                                                                           *
; *****************************************************************************

CountCommand:

  SetFreq M4
  Count w1, w2, w2
  SetFreq FREQ

  SerTxd( "COUNT" )
  Goto ShowPinPlusResult

; *****************************************************************************
; *                                                                           *
; * Output to an LCD attached to a pin                                        *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; *  Parameter w1 is pin, w2.msb/w2.lsb are the bytes to send -               *
; *                                                                           *
; *  128 xxx - Set position then send character byte to LCD                   *
; *    0 xxx - Sent as a character byte to the LCD                            *
; *                                                                           *
; *****************************************************************************

DisplayOnLcdCommand:

  If w2.msb <> 0 Then
    SerOut w1, FREQ_N2400, ( 254, w2.msb )
  End If
  SerOut w1, FREQ_N2400, ( w2.lsb )
  Goto Polling

; *****************************************************************************
; *                                                                           *
; * Read a digital input pin and return its input level                       *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * The reply packet will have the format of -                                *
; *                                                                           *
; *     [PIN <pin>=<level>]                                                   *
; *                                                                           *
; * Where -                                                                   *
; *                                                                           *
; *     <pin>         Is the pin read                                         *
; *                                                                           *
; *     <level>       Is the "0" or "1" leve read on the pin                  *
; *                                                                           *
; *****************************************************************************

GetPinCommand:

; .---------------------------------------------------------------------------.
; | Determine which port and pin we are looking at if an M2                   |
; `---------------------------------------------------------------------------'

  #IfDef _isM2
    #IfDef _08M2
      w2 = pinsC
    #Else
      Lookup w1.bit3, ( pinsB, pinsC ), w2
    #EndIf
    b0 = w1 & 7
    Read b0, b0
    w2 = w2 & b0 Max 1
  #EndIf

; .---------------------------------------------------------------------------.
; | Determine which port and pin we are looking at if an X2                   |
; `---------------------------------------------------------------------------'

  #IfDef _isX2
    b0 = w1 >> 3 & 3
    LookUp b0, ( pinsB, pinsC, pinsA, pinsD ), w2
    b0 = w1 & 7
    w2 = 1 << b0 & w2 Max 1
  #EndIf

; .---------------------------------------------------------------------------.
; | Return the result                                                         |
; `---------------------------------------------------------------------------'

  SerTxd( "PIN" )
  Goto ShowPinPlusResult

; *****************************************************************************
; *                                                                           *
; * Read an IR command on a pin ( with or without timeout )                   *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * The reply packet will have the format of -                                *
; *                                                                           *
; *     [IRIN <pin>=<code>]                                                   *
; *                                                                           *
; * Where -                                                                   *
; *                                                                           *
; *     <pin>         Is the pin read                                         *
; *                                                                           *
; *     <code>        Is button code read ( $80/128=timout )                  *
; *                                                                           *
; *****************************************************************************

IrInCommand:

  If w2 = 0 Then
    IrIn w1, w2
  Else
    b0 = 128
    IrIn [w2], w1, b0
    w2 = b0
  End If

  SerTxd( "IRIN" )
  Goto ShowPinPlusResult

; *****************************************************************************
; *                                                                           *
; *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; *
; *
; *
; *                                                                           *
; *****************************************************************************

MotorCommand:

  #IfDef _08M2
    Goto InvalidCommand
    #Define _isOK
  #EndIf

  #IfDef _14M2
    Select Case w1
      Case $A0 : Halt     A
      Case $A1 : Forward  A
      Case $A2 : Backward A
      Else     : Goto InvalidCommand
    End Select
    #Define _isOK
  #EndIf

  #IfDef _18M2
    Select Case w1
      Case $A0 : Halt     A
      Case $A1 : Forward  A
      Case $A2 : Backward A
      Case $B0 : Halt     B
      Case $B1 : Forward  B
      Case $B2 : Backward B
      Else     : Goto InvalidCommand
    End Select
    #Define _isOK
  #EndIf

  #IfDef _20M2
    Select Case w1
      Case $A0 : Halt     A
      Case $A1 : Forward  A
      Case $A2 : Backward A
      Case $B0 : Halt     B
      Case $B1 : Forward  B
      Case $B2 : Backward B
      Else     : Goto InvalidCommand
    End Select
    #Define _isOK
  #EndIf

  #IfDef _20X2
    Select Case w1
      Case $A0 : Halt     A
      Case $A1 : Forward  A
      Case $A2 : Backward A
      Case $B0 : Halt     B
      Case $B1 : Forward  B
      Case $B2 : Backward B
      Else     : Goto InvalidCommand
    End Select
    #Define _isOK
  #EndIf

  #IfDef _28X2
    Select Case w1
      Case $A0 : Halt     A
      Case $A1 : Forward  A
      Case $A2 : Backward A
      Case $B0 : Halt     B
      Case $B1 : Forward  B
      Case $B2 : Backward B
      Else     : Goto InvalidCommand
    End Select
    #Define _isOK
  #EndIf

  #IfDef _40X2
    Select Case w1
      Case $A0 : Halt     A
      Case $A1 : Forward  A
      Case $A2 : Backward A
      Case $B0 : Halt     B
      Case $B1 : Forward  B
      Case $B2 : Backward B
      Case $C0 : Halt     C
      Case $C1 : Forward  C
      Case $C2 : Backward C
      Case $D0 : Halt     D
      Case $D1 : Forward  D
      Case $D2 : Backward D
      Else     : Goto InvalidCommand
    End Select
    #Define _isOK
  #EndIf

  #IfDef _XXXX
    Select Case w1
      Case $A0 : Halt     A
      Case $A1 : Forward  A
      Case $A2 : Backward A
      Case $B0 : Halt     B
      Case $B1 : Forward  B
      Case $B2 : Backward B
      Case $C0 : Halt     C
      Case $C1 : Forward  C
      Case $C2 : Backward C
      Case $D0 : Halt     D
      Case $D1 : Forward  D
      Case $D2 : Backward D
      Else     : Goto InvalidCommand
    End Select
    #Define _isOK
  #EndIf

  #IfDef _isOK
    #Undefine _isOK
  #Else
    #Error No MotorCommand routine for PICAXE type
  #EndIf

  Goto Polling

; *****************************************************************************
; *                                                                           *
; * Read a pulse length on a pin in 10us units                                *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * The reply packet will have the format of -                                *
; *                                                                           *
; *     [PULSIN <pin>=<length>]                                               *
; *                                                                           *
; * Where -                                                                   *
; *                                                                           *
; *     <pin>         Is the pin number the pulse was read on                 *
; *                                                                           *
; *     <length>      Is the length of the pulse read in 10us units           *
; *                                                                           *
; *****************************************************************************

PulsInCommand:

  SetFreq M4
  PulsIn w1, w2, w2
  SetFreq FREQ

  SerTxd( "PULSIN" )
  Goto ShowPinPlusResult

; *****************************************************************************
; *                                                                           *
; * Read a DS18B20 temperature sensor attached to a pin                       *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * The reply packet will have the format of -                                *
; *                                                                           *
; *     [READTEMP <pin>=<temperature>]                                        *
; *                                                                           *
; * Where -                                                                   *
; *                                                                           *
; *     <pin>         Is the pin number of the temperature sensor read        *
; *                                                                           *
; *     <temperature> Is the temperature read in dereees C x 16               *
; *                                                                           *
; *****************************************************************************

ReadTempCommand:

  ReadTemp12 w1, w2

  SerTxd( "READTEMP" )
  Goto ShowPinPlusResult

; *****************************************************************************
; *                                                                           *
; * Read an ultrasonic sensor attached to a pin                               *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * The reply packet will have the format of -                                *
; *                                                                           *
; *     [TOUCH <pin>=<touched>]                                               *
; *                                                                           *
; * Where -                                                                   *
; *                                                                           *
; *     <pin>         Is the pin number of the touch sensor read              *
; *                                                                           *
; *     <touched>     Is the touch value read                                 *
; *                                                                           *
; *****************************************************************************

TouchCommand:

  #IfDef _20X2

    Goto InvalidCommand

  #Else

    #IfDef _isX2
      Gosub GetAdcChannelNumber
      If bit7 <> 0 Then InvalidCommand
      Touch b0, w2
    #Else
      Touch w1, w2
    #EndIf

    SerTxd( "TOUCH" )
    Goto ShowPinPlusResult

  #EndIf

; *****************************************************************************
; *                                                                           *
; * Read an ultrasonic sensor attached to a pin                               *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * The reply packet will have the format of -                                *
; *                                                                           *
; *     [ULTRA <pin>=<distance>]                                              *
; *                                                                           *
; * Where -                                                                   *
; *                                                                           *
; *     <pin>         Is the pin number of the ultrasonic sensor read         *
; *                                                                           *
; *     <distance>    Is the raw distance read                                *
; *                                                                           *
; *****************************************************************************

UltraCommand:

  SetFreq FREQ_DEFAULT
  Ultra w1, w2
  SetFreq FREQ

  SerTxd( "ULTRA" )
  Goto ShowPinPlusResult

; *****************************************************************************
; *                                                                           *
; * Read internal Eeprom                                                      *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * The reply packet will have the format of -                                *
; *                                                                           *
; *     [EEPROM <addess>=<value>]                                             *
; *                                                                           *
; * Where *                                                                   *
; *                                                                           *
; *     <address>     Is the address of the Eeprom read                       *
; *                                                                           *
; *     <value>       Is the byte value read from the address                 *
; *                                                                           *
; *****************************************************************************

ReadEeprom:

  Read w1, w2

  SerTxd( "EEPROM", SPACE, #w1 )
  Goto ShowResult

; *****************************************************************************
; *                                                                           *
; * Write internal Eeprom                                                     *
; *                                                                           *
; *****************************************************************************

WriteEeprom:

  Write w1, w2
  Goto Polling

; *****************************************************************************
; *                                                                           *
; * Reset all outputs to 0                                                    *
; *                                                                           *
; *****************************************************************************

; .---------------------------------------------------------------------------.
; | Reset Outputs                                                             |
; |---------------------------------------------------------------------------|
; |                                                                           |
; | The reply packet will be the standard polling packet -                    |
; |                                                                           |
; |     [POLL ... ]                                                           |
; |                                                                           |
; `---------------------------------------------------------------------------'

ResetOutputs:

  #IfDef _isM2

    pinsB = 0
    pinsC = 0

  #Else

    pinsB = 0
    pinsC = 0
    pinsA = 0
    pinsD = 0

  #EndIf

  Goto Polling

; *****************************************************************************
; *                                                                           *
; * I2C Interfacing Commands                                                  *
; *                                                                           *
; *****************************************************************************

; .---------------------------------------------------------------------------.
; | I2C bus configuration                                                     |
; |---------------------------------------------------------------------------|
; |                                                                           |
; | The reply packet will be the standard polling packet -                    |
; |                                                                           |
; |     [POLL ... ]                                                           |
; |                                                                           |
; `---------------------------------------------------------------------------'

I2cEepromSetup:

  If w1 <> 0 Then
    If w2.msb = 0 Then
      w2.msb = I2CSLOW
    Else
      w2.msb = I2CFAST
    End If
    HI2cSetup I2CMASTER, w1, w2.msb, w2.lsb
  Else
    HI2cSetup OFF
  End If
  Goto Polling

; .---------------------------------------------------------------------------.
; | Write a byte to an I2C Eeprom and verify data written                     |
; |---------------------------------------------------------------------------|
; |                                                                           |
; | The reply packet will have the format of -                                |
; |                                                                           |
; |     [I2C <addess>=<value>]                                                |
; |                                                                           |
; | Where -                                                                   |
; |                                                                           |
; |     <address>     Is the address of the I2C Eeprom written                |
; |                                                                           |
; |     <value>       Is the byte value read from the address                 |
; |                                                                           |
; `---------------------------------------------------------------------------'

I2cEepromWrite:

  SetFreq M4
  HI2cOut w1, ( w2 )
  SetFreq FREQ

  Pause MS_20

; .---------------------------------------------------------------------------.
; | Read a byte from an I2C Eeprom                                            |
; |---------------------------------------------------------------------------|
; |                                                                           |
; | The reply packet will have the format of -                                |
; |                                                                           |
; |     [I2C <addess>=<value>]                                                |
; |                                                                           |
; | Where -                                                                   |
; |                                                                           |
; |     <address>     Is the address of the I2C Eeprom read                   |
; |                                                                           |
; |     <value>       Is the byte value read from the address                 |
; |                                                                           |
; `---------------------------------------------------------------------------'

I2cEepromRead:

  SetFreq M4
  HI2cIn w1, ( w2 )
  SetFreq FREQ

  SerTxd( "I2C", SPACE, #w1 )
  Goto ShowResult

; .---------------------------------------------------------------------------.
; | I2C Block Commands                                                        |
; |---------------------------------------------------------------------------|
; |                                                                           |
; | This allows bytes to be written and read from an I2C device               |
; |                                                                           |
; | SendToPicaxe( "b", rxCount, txCount, tx1data, tx2data )                   |
; |                                                                           |
; |                b0  w1.msb   w1.lsb   w2.msb   w2.lsb                      |
; |                                                                           |
; | Send 1 byte, no read : SendToPicaxe( "b", 0, 1, $t1, 0   )                |
; | Send 2 byte, no read : SendToPicaxe( "b", 0, 2, $t1, $t2 )                |
; |                                                                           |
; | Send 0 byte, read N  : SendToPicaxe( "b", N, 0, 0,   0   )                |
; | Send 1 byte, read N  : SendToPicaxe( "b", N, 1, $t1, 0   )                |
; | Send 2 byte, read N  : SendToPicaxe( "b", N, 2, $t1, $t2 )                |
; |                                                                           |
; | The reply packet will have the format of -                                |
; |                                                                           |
; |     [READI2C <w0>,<w1>,<w2>]                                              |
; |                                                                           |
; | Where -                                                                   |
; |                                                                           |
; |     w0.lsb = 1st data byte    w0.msb = 4th data byte                      |
; |     w1.lsb = 2nd data byte    w1.msb = 5th data byte                      |
; |     w2.lsb = 3rd data byte    w2.msb = 6th data byte                      |
; |                                                                           |
; `---------------------------------------------------------------------------'

I2cBlockCommand:

; #### Faked block read

#rem
      If w1.msb = 0 Then
        SerTxd( "SENTI2C" )
      Else
        b6 = w1.msb
        w0 = 1
        w1 = 0
        w2 = 0
        If b21 >= 2 Then : b1 = 2 : End If
        If b21 >= 3 Then : b2 = 3 : End If
        If b21 >= 4 Then : b3 = 4 : End If
        If b21 >= 5 Then : b4 = 5 : End If
        If b21 >= 6 Then : b5 = 6 : End If
        b27 = b27 + 1
        b0  = b27
        b1  = b27 + 1
        b2  = b27 + 2
        b3  = b27 + 3
        b4  = b27 + 4
        b5  = b27 + 5
        SerTxd( "READI2C", SPACE, #b0, COMMA, #b1, COMMA, #b2, _
                           COMMA, #b3, COMMA, #b4, COMMA, #b5 )
      End If
      Goto WaitForCommand
#endrem

  SetFreq M4
  Select Case w1.lsb
    Case 1 : HI2cOut( w2.msb )
    Case 2 : HI2cOut( w2.msb, w2.lsb )
  End Select
  SetFreq FREQ

  If w1.msb = 0 Then
    SerTxd( "SENTI2C" )
  Else

    w0 = w1.msb
    w1 = 0
    w2 = 0

    SetFreq M4
    Select Case w0
      Case 1 : HI2cIn( b0                     )
      Case 2 : HI2cIn( b0, b1                 )
      Case 3 : HI2cIn( b0, b1, b2             )
      Case 4 : HI2cIn( b0, b1, b2, b3         )
      Case 5 : HI2cIn( b0, b1, b2, b3, b4     )
      Case 6 : HI2cIn( b0, b1, b2, b3, b4, b5 )
    End Select
    SetFreq FREQ

    SerTxd( "READI2C", SPACE, #b0, COMMA, #b1, COMMA, #b2, _
                       COMMA, #b3, COMMA, #b4, COMMA, #b5 )

  End If
  Goto WaitForCommand

; *****************************************************************************
; *                                                                           *
; * Send a pin and value reply                                                *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * The pin will be in the form <letter><number> without the familiar dot     *
; * separator to minimise transmission time.                                  *
; *                                                                           *
; * The output format will be as folows, where "[XXXX" has already been sent  *
; * by the code calling this routine -                                        *
; *                                                                           *
; *     [XXXX <pin>=<value> ]                                                 *
; *                                                                           *
; *****************************************************************************

ShowPinPlusResult:

  #IfDef _isM2
    #IfDef _08M2
      b0 = "C"
    #Else
      LookUp w1.bit3, ( "BC" ), b0
    #EndIf
  #EndIf

  #IfDef _isX2
    #IfDef _20X2
      LookUp w1.bit3, ( "BC" ), b0
    #Else
      b0 = w1 >> 3 & 3
      Lookup b0, ( "BCAD" ), b0
    #EndIf
  #EndIf

  b1 = w1 & 7
  SerTxd( SPACE, b0, #b1 )

ShowResult:

  SerTxd( "=", #w2 )

  Goto WaitForCommand

; *****************************************************************************
; *                                                                           *
; * Handle Poll reporting for ports when we are in verbose mode               *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * In normal mode the pins/dirs reports will be in the form of -             *
; *                                                                           *
; *     <port>=<pins>/<dirs>                                                  *
; *                                                                           *
; * For example, "C=4/1". This keeps transmission to the minimum.             *
; *                                                                           *
; * When we are verbose mode we include additional information on what the    *
; * data is and also present that in biary format to make the bits clearer.   *
; * The format becomes -                                                      *
; *                                                                           *
; *     pins<port>=%<pins>,dirs<port>=%<dirs>                                 *
; *                                                                           *
; * For example, "pinsC=%00000100,dirsC=%00000001"                            *
; *                                                                           *
; *****************************************************************************

#IfDef VERBOSE

PollInit:

  SerTxd( "POLL", SPACE )
  Goto PollInfo

PollNext:

  SerTxd( COMMA )

PollInfo:

  #IfDef _isM2
    Select Case w2
      Case "B" : w0.msb = pinsB : w0.lsb = dirsB
      Case "C" : w0.msb = pinsC : w0.lsb = dirsC
    End Select
  #EndIf

  #IfDef _isX2
    Select Case w2
      Case "A" : w0.msb = pinsA : w0.lsb = dirsA
      Case "B" : w0.msb = pinsB : w0.lsb = dirsB
      Case "C" : w0.msb = pinsC : w0.lsb = dirsC
      Case "D" : w0.msb = pinsD : w0.lsb = dirsD
    End Select
  #EndIf

  SerTxd( "pins", w2, "=%", #bit15, #bit14, #bit13, #bit12,        _
                            #bit11, #bit10, #bit9,  #bit8,  COMMA, _
          "dirs", w2, "=%", #bit7,  #bit6,  #bit5,  #bit4,         _
                            #bit3,  #bit2,  #bit1,  #bit0          )

  w2 = w2 + 1
  Return

#EndIf

; *****************************************************************************
; *                                                                           *
; * ADC Handling                                                              *
; *                                                                           *
; *****************************************************************************

; .---------------------------------------------------------------------------.
; | Set a particular pin for ADC use                                          |
; |---------------------------------------------------------------------------|
; | The pin number is set in w1 0..15 which is used to set the appropriate    |
; | bit in adcMaskCB od adcMaskDA.                                            |
; `---------------------------------------------------------------------------'

SetAdcMaskBitSub:
  #IfDef _isM2
    If w1 < 8 Then
      Read w1, w0
    Else
      w0 = w1 & 7
      Read w0, w0.msb : w0.lsb = 0
    End If
    adcMaskCB = w0 | adcMaskCB & MASK_CB
  #Else
    If w1 <= 15 Then
      adcMaskCB = 1 << w1 | adcMaskCB & MASK_CB
    Else
      w0 = w1 & 15
      adcMaskDA = 1 << w0 | adcMaskDA & MASK_DA
    End If
  #EndIf

SetAdcSetupBitSub:
  #IfDef _isM2
    #IfDef _08M2
      adcSetup = adcSetup | adcMaskC
    #Else
      adcSetup = adcSetup | adcMaskCB
    #EndIf
  #Else
    Gosub GetAdcChannelNumber
    If bit7 = 0 Then
      #IfDef _20X2
        adcSetup = 1 << w0 | adcSetup
      #Else
        If w0 < 16 Then
          adcSetup = 1 << w0 | adcSetup
        Else
          w0 = w0 & 15
          adcSetup2 = 1 << w0 | adcSetup2
        End If
      #EndIf
    End If
  #EndIf
  Return

; .---------------------------------------------------------------------------.
; | Clear a pin after ADC use ( ie, make it digital )                         |
; |---------------------------------------------------------------------------|
; | The pin number is set in w1 0..15 which is used to clear the appropriate  |
; | bit in adcMaskCB or adcMaxkDA.                                            |
; `---------------------------------------------------------------------------'

ClrAdcMaskBitSub:
  #IfDef _isM2
    If w1 < 8 Then
      Read w1, w0
    Else
      w0 = w1 & 7
      Read w0, w0.msb : w0.lsb = 0
    End If
    adcMaskCB = w0 ^ $FFFF & adcMaskCB & MASK_CB
  #Else
    If w1 <= 15 Then
      adcMaskCB = 1 << w1 ^ $FFFF & adcMaskCB & MASK_CB
    Else
      w0 = w1 & 15
      adcMaskDA = 1 << w0 ^ $FFFF & adcMaskDA & MASK_DA
    End If
  #EndIf

ClrAdcSetupBitSub:
  #IfDef _isM2
    #IfDef _08M2
      adcSetup = adcSetup & adcMaskC
    #Else
      adcSetup = adcSetup & adcMaskCB
    #EndIf
  #Else
    Gosub GetAdcChannelNumber
    If bit7 = 0 Then
      #IfDef _20X2
        w0 = 1 << w0
        adcSetup = adcSetup &/ w0
      #Else
        If w0 < 16 Then
          w0 = 1 << w0
          adcSetup = adcSetup &/ w0
        Else
          w0 = w0 & 15
          w0 = 1 << w0
          adcSetup2 = adcSetup2 &/ w0
        End If
      #EndIf
    End If
  #EndIf
  Return

GetAdcChannelNumber:
  w0 = $FF
  #IfDef _20X2
    '        ADC = 0    1    2    3    4    5    6    7    8    9    10
    LookDown w1, ( B.0, B.1, C.7, B.2, B.3, B.4, C.3, C.2, C.1, B.5, B.6 ), w0
  #EndIf
  #IfDef _28X2
    '        ADC = 0    1    2    3    4    5    6    7    8    9    10   11   12   13   14   15   16   17   18   19
    LookDown w1, ( A.0, A.1, A.2, A.3, C.3, $FF, $FF, $FF, B.2, B.3, B.1, B.4, B.0, B.5, C.2, $FF, C.4, C.5, C.6, C.7 ), w0
  #EndIf
  #IfDef _40X2
    '        ADC = 0    1    2    3    4    5    6    7    8    9    10   11   12   13   14   15   16   17   18   19   20   21   22   23   24   25   26   27
    LookDown w1, ( A.0, A.1, A.2, A.3, C.3, A.5, A.6, A.7, B.2, B.3, B.1, B.4, B.0, B.5, C.2, $FF, C.4, C.5, C.6, C.7, D.0, D.1, D.2, D.3, D.4, D.5, D.6, D.7 ), w0
  #EndIf
  Return

; *****************************************************************************
; *                                                                           *
; * Eeprom data                                                               *
; *                                                                           *
; *****************************************************************************
; *                                                                           *
; * For the M2 parts we use the Eeprom Data to provide a fast lookup table    *
; * of bit masks; 0->$01, 1->$02, up to 7->$80.                               *
; *                                                                           *
; * For the X2 we don't use Eeprom Data so we use a #No_Data to save having   *
; * to download it.                                                           *
; *                                                                           *
; *****************************************************************************

  #IfDef _isM2

    Eeprom 0, ( $01, $02, $04, $08, $10, $20, $40, $80 )

  #Else

    #No_data

  #EndIf

; .---------------------------------------------------------------------------.
; | We add a copyright notice even if that is not downloaded                  |
; `---------------------------------------------------------------------------'

  Eeprom ( "Copyright (C) Revolution Education Limited" )

; *****************************************************************************
; *                                                                           *
; * End of Program                                                            *
; *                                                                           *
; *****************************************************************************

