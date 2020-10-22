UNIT VOCTOOL;
{* Unit - uses CT-VOICE.DRV. *}
INTERFACE
TYPE
   VOCFileTyp = File;
CONST
   VOCToolVersion  = 'v1.5';
   VOCBreakEnd     = 0;
   VOCBreakNow     = 1;
VAR
   VOCStatusWord        : WORD;
   VOCErrStat           : WORD;
   VOCFileHeader        : STRING;
   VOCFileHeaderLength  : BYTE;
   VOCPaused            : BOOLEAN;
   VOCDriverInstalled   : BOOLEAN;
   VOCDriverVersion     : WORD;
   VOCPtrToDriver       : Pointer;
   OldExitProc          : Pointer;
PROCEDURE PrintVOCErrMessage;
FUNCTION  VOCGetBuffer(VAR VoiceBuff : Pointer; Voicefile : STRING):BOOLEAN;
FUNCTION  VOCFreeBuffer(VAR VoiceBuff : Pointer):BOOLEAN;
FUNCTION  VOCGetVersion:WORD;
PROCEDURE VOCSetPort(PortNumber : WORD);
PROCEDURE VOCSetIRQ(IRQNumber : WORD);
FUNCTION  VOCInitDriver:BOOLEAN;
PROCEDURE VOCDeInstallDriver;
PROCEDURE VOCSetSpeaker(OnOff:BOOLEAN);
PROCEDURE VOCOutput(BufferAddress : Pointer);
PROCEDURE VOCOutputLoop (BufferAddress : Pointer);
PROCEDURE VOCStop;
PROCEDURE VOCPause;
PROCEDURE VOCContinue;
PROCEDURE VOCBreakLoop(BreakMode : WORD);
IMPLEMENTATION
USES DOS,Crt;
TYPE
   TypeCastType = ARRAY [0..6000] of Char;
VAR
   Regs : Registers;
PROCEDURE PrintVOCErrMessage;
{* INPUT   : None
 * OUTPUT  : None
 * PURPOSE : Displays SB error as text; no change to error status. }
BEGIN
   CASE VOCErrStat OF
      100 : Write(' Driver file CT-VOICE.DRV not found ');
      110 : Write(' No memory available for driver file ');
      120 : Write(' False driver file ');
      200 : Write(' VOC file not found ');
      210 : Write(' No memory available for driver file ');
      220 : Write(' File not in VOC format ');
      300 : Write(' Memory allocation error occurred ');
      400 : Write(' No sound blaster card found ');
      410 : Write(' False port address used ');
      420 : Write(' False interrupt used ');
      500 : Write(' No loop in process ');
      510 : Write(' No sample for output ');
      520 : Write(' No sample available ');
      END;
   END;

FUNCTION Exists (Filename : STRING):BOOLEAN;
{* INPUT   : Filename as string
 * OUTPUT  : TRUE if file is available, FALSE if not
 * PURPOSE : Checks for availability of file then returns Boolean exp. }
VAR
   F : File;
BEGIN
   Assign(F,Filename);
{$I-}
   Reset(F);
   Close(F);
{$I+}
   Exists := (IoResult = 0) AND (Filename <> '');
   END;
PROCEDURE AllocateMem (VAR Pt : Pointer; Size : LongInt);
{* INPUT   : Buffer variable as pointer, buffer size as LongInt
 * OUTPUT  : Pointer to buffer in variable or NIL
 * PURPOSE : Reserves as many bytes as Size allows, then moves pointer in
             the Pt variable. If not enough memory is available, Pt = NIL. }
VAR
   SizeIntern : WORD;
BEGIN
   Inc(Size,15);
   SizeIntern := (Size shr 4);
   Regs.AH := $48;
   Regs.BX := SizeIntern;
   MsDos(Regs);
   IF (Regs.BX <> SizeIntern) THEN Pt := NIL
   ELSE Pt := Ptr(Regs.AX,0);
   END;
FUNCTION  CheckFreeMem (VAR VoiceBuff : Pointer; VoiceSize : LongInt):BOOLEAN;
{* INPUT   : Buffer variable as pointer, size as LongInt
 * OUTPUT  : Pointer to buffer, TRUE/FALSE, after AllocateMem
 * PURPOSE : Checks for sufficient memory to store a VOC file. }
BEGIN
   AllocateMem(VoiceBuff,VoiceSize);
   CheckFreeMem := VoiceBuff <> NIL;
   END;
FUNCTION  VOCGetBuffer (VAR VoiceBuff : Pointer; Voicefile : STRING):BOOLEAN;
{* INPUT   : Buffer variable as pointer, file name as string
 * OUTPUT  : Pointer to buffer with VOC data, TRUE/FALSE
 * PURPOSE : Loads a file into memory and returns TRUE if file loaded
             successfully, and FALSE if not. }
VAR
   SampleSize : LongInt;
   FPresent   : BOOLEAN;
   VFile      : VOCFileTyp;
   Segs       : WORD;
   Read       : WORD;
BEGIN
   FPresent := Exists(VoiceFile);
{ VOC file not found }
   IF Not(FPresent) THEN BEGIN
      VOCGetBuffer := FALSE;
      VOCErrStat   := 200;
      EXIT
      END;
   Assign(VFile,Voicefile);
   Reset(VFile,1);
   SampleSize := Filesize(VFile);
   AllocateMem(VoiceBuff,SampleSize);
{ Insufficient memory for the VOC file }
   IF (VoiceBuff = NIL) THEN BEGIN
      Close(VFile);
      VOCGetBuffer := FALSE;
      VOCErrStat   := 210;
      EXIT;
      END;
   Segs := 0;
   REPEAT
      Blockread(VFile,Ptr(seg(VoiceBuff^)+4096*Segs,Ofs(VoiceBuff^))^,$FFFF,Read);
      Inc(Segs);
      UNTIL Read = 0;
   Close(VFile);
{ File not in VOC format }
   IF (TypeCastType(VoiceBuff^)[0]<>'C') OR
      (TypeCastType(VoiceBuff^)[1]<>'r') THEN BEGIN
      VOCGetBuffer := FALSE;
      VOCErrStat := 220;
      EXIT;
      END;
{ Load successful }
   VOCGetBuffer := TRUE;
   VOCErrStat   := 0;
{ Read header length from file }
   VOCFileHeaderLength := Ord(TypeCastType(VoiceBuff^)[20]);
   END;
FUNCTION VOCFreeBuffer (VAR VoiceBuff : Pointer):BOOLEAN;
{* INPUT   : Buffer pointer
 * OUTPUT  : None
 * PURPOSE : Frees memory allocated for VOC data. }
BEGIN
   Regs.AH := $49;
   Regs.ES := seg(VoiceBuff^);
   MsDos(Regs);
   VOCFreeBuffer := TRUE;
   IF (Regs.AX = 7) OR (Regs.AX = 9) THEN BEGIN
      VOCFreeBuffer := FALSE;
      VOCErrStat := 300
      END;
   END;
FUNCTION VOCGetVersion:WORD;
{* INPUT   : None
 * OUTPUT  : Driver version number
 * PURPOSE : Returns driver version number. }
VAR
   VDummy : WORD;
BEGIN
   ASM
      MOV       BX,0
      CALL      VOCPtrToDriver
      MOV       VDummy, AX
      END;
   VOCGetVersion := VDummy;
   END;
PROCEDURE VOCSetPort(PortNumber : WORD);
{* INPUT   : Port address number
 * OUTPUT  : None
 * PURPOSE : Specifies port address before initialization. }
BEGIN
   ASM
      MOV    BX,1
      MOV    AX,PortNumber
      CALL   VOCPtrToDriver
      END;
   END;
PROCEDURE VOCSetIRQ(IRQNumber : WORD);
{* INPUT   : Interrupt number
 * OUTPUT  : None
 * PURPOSE : Specifies interrupt number before initialization.}
BEGIN
   ASM
      MOV    BX,2
      MOV    AX,IRQNumber
      CALL   VOCPtrToDriver
      END;
   END;
FUNCTION  VOCInitDriver: BOOLEAN;
{* INPUT   : None
 * OUTPUT  : Error message number, and initialization result
 * PURPOSE : Initializes driver software. }
VAR
   Out, VSeg, VOfs : WORD;
   F   : File;
   Drivername,
   Pdir        : DirStr;
   Pnam        : NameStr;
   Pext        : ExtStr;
BEGIN
{ Search path for CT-VOICE.DRV driver }
   {Pdir := );
  { Fsplit(ParamStr(0),Pdir,Pnam,Pext);}
   Drivername := 'CT-VOICE.DRV';
   VOCInitDriver := TRUE;
{ Driver file not found }
   IF Not Exists(Drivername) THEN BEGIN
      VOCInitDriver := FALSE;
      VOCErrStat    := 100;
      EXIT;
      END;
{ Load driver }
   Assign(F,Drivername);
   Reset(F,1);
   AllocateMem(VOCPtrToDriver,Filesize(F));
{ No memory can be allocated for the driver }
   IF VOCPtrToDriver = NIL THEN BEGIN
      VOCInitDriver := FALSE;
      VOCErrStat    := 110;
      EXIT;
      END;
   Blockread(F,VOCPtrToDriver^,Filesize(F));
   Close(F);
{ Driver file doesn't begin with "CT" - false driver }
   IF (TypeCastType(VOCPtrToDriver^)[3]<>'C') OR
      (TypeCastType(VOCPtrToDriver^)[4]<>'T') THEN BEGIN
         VOCInitDriver := FALSE;
         VOCErrStat    := 120;
         EXIT;
         END;
{ Get version number and pass to global variable }
   VOCDriverVersion := VOCGetVersion;
{ Start driver }
   Vseg := Seg(VOCStatusWord);
   VOfs := Ofs(VOCStatusWord);
   ASM
      MOV       BX,3
      CALL      VOCPtrToDriver
      MOV       Out,AX
      MOV       BX,5
      MOV       ES,VSeg
      MOV       DI,VOfs
      CALL      VOCPtrToDriver
      END;
{ No Sound Blaster card found }
   IF Out = 1 THEN BEGIN
      VOCInitDriver := FALSE;
      VOCErrStat    := 400;
      EXIT;
      END;
{ False port address used }
   IF Out = 2 THEN BEGIN
      VOCInitDriver := FALSE;
      VOCErrStat    := 410;
      EXIT;
      END;
{ False interrupt used }
   IF Out = 3 THEN BEGIN
      VOCInitDriver := FALSE;
      VOCErrStat    := 420;
      EXIT;
      END;
   END;
PROCEDURE VOCDeInstallDriver;
{* INPUT   : None
 * OUTPUT  : None
 * PURPOSE : Disables driver and releases memory. }
VAR
   Check : BOOLEAN;
BEGIN
   IF VOCDriverInstalled THEN
   ASM
      MOV       BX,9
      CALL      VOCPtrToDriver
      END;
   Check := VOCFreeBuffer(VOCPtrToDriver);
   END;
PROCEDURE VOCSetSpeaker(OnOff:BOOLEAN);
{* INPUT   : TRUE=Speaker on, FALSE=Speaker off
 * OUTPUT  : None
 * PURPOSE : Sound Blaster output status. }
VAR
   Switch : BYTE;
BEGIN
   Switch := Ord(OnOff) AND $01;
   ASM
      MOV       BX,4
      MOV       AL,Switch
      CALL      VOCPtrToDriver
      END;
   END;
PROCEDURE VOCOutput (BufferAddress : Pointer);
{* INPUT   : Pointer to sample data
 * OUTPUT  : None
 * PURPOSE : Plays sample. }
VAR
   VSeg, VOfs : WORD;
BEGIN
   VOCSetSpeaker(TRUE);
   VSeg := Seg(BufferAddress^);
   VOfs := Ofs(BufferAddress^)+VOCFileHeaderLength;
   ASM
      MOV       BX,6
      MOV       ES,VSeg
      MOV       DI,VOfs
      CALL      VOCPtrToDriver
      END;
   END;
PROCEDURE VOCOutputLoop (BufferAddress : Pointer);
{*    Different from VOCOutput :
 *    Speaker does not switch on with every sample output, so a
 *    crackling noise may occur with some Sound Blaster cards. }
VAR
   VSeg, VOfs : WORD;
BEGIN
   VSeg := Seg(BufferAddress^);
   VOfs := Ofs(BufferAddress^)+VOCFileHeaderLength;
   ASM
      MOV       BX,6
      MOV       ES,VSeg
      MOV       DI,VOfs
      CALL      VOCPtrToDriver
      END;
   END;
PROCEDURE VOCStop;
{* INPUT   : None
 * OUTPUT  : None
 * PURPOSE : Stops a sample. }
BEGIN
   ASM
      MOV       BX,8
      CALL      VOCPtrToDriver
      END;
   END;
PROCEDURE VOCPause;
{* INPUT   : None
 * OUTPUT  : None
 * PURPOSE : Pauses a sample. }
VAR
   Switch : WORD;
BEGIN
   VOCPaused := TRUE;
   ASM
      MOV       BX,10
      CALL      VOCPtrToDriver
      MOV       Switch,AX
      END;
   IF (Switch = 1) THEN BEGIN
      VOCPaused := FALSE;
      VOCErrStat := 510;
      END;
   END;
PROCEDURE VOCContinue;
{* INPUT   : None
 * OUTPUT  : None
 * PURPOSE : Continues a paused sample. }
VAR
   Switch : WORD;
BEGIN
   ASM
      MOV       BX,11
      CALL      VOCPtrToDriver
      MOV       Switch,AX
      END;
   IF (Switch = 1) THEN BEGIN
      VOCPaused := FALSE;
      VOCErrStat := 520;
      END;
   END;
PROCEDURE VOCBreakLoop(BreakMode : WORD);
{* INPUT   : Break mode
 * OUTPUT  : None
 * PURPOSE : Breaks a sample loop. }
BEGIN
   ASM
      MOV       BX,12
      MOV       AX,BreakMode
      CALL      VOCPtrToDriver
      MOV       BreakMode,AX
      END;
   IF (BreakMode = 1) THEN VOCErrStat := 500;
   END;
{$F+}
PROCEDURE VoiceToolsExitProc;
{$F-}
{* INPUT   : None
 * OUTPUT  : None
 * PURPOSE : De-installs voice driver. }
BEGIN
   VOCDeInstallDriver;
   ExitProc := OldExitProc;
   END;
BEGIN
{* The following statements execute automatically, as soon as the
 * unit is linked to a program, and the program starts. }
{ Replaces old ExitProc with new one from Tool unit }
   OldExitProc := ExitProc;
   ExitProc := @VoiceToolsExitProc;
{ Initialize values }
   VOCStatusWord := 0;
   VOCErrStat    := 0;
   VOCPaused     := FALSE;
   VOCFileHeaderLength := $1A;
   VOCFileHeader :=
      'Creative Voice File'+#$1A+#$1A+#$00+#$0A+#$01+#$29+#$11+#$01;
{* After installation, VOCDriverInstalled contains either TRUE or FALSE. }
   VOCDriverInstalled := VOCInitDriver;
   END.
