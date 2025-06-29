unit uCOMPort;

interface

uses Windows, SysUtils;

const
     //--Konstanten für den Statusreport------------------------------------------------------------
      parity   : array[0..4] of String = ('Keine','Ungerade','Gerade','Markierung','Leerzeichen');
      stopbits : array[0..2] of String = ('1','1,5','2');
     //---------------------------------------------------------------------------------------------

     //--Konstanten zum einfachen Setzen der Portflags----------------------------------------------
     dcb_Binary              = $00000001; // Binärer Modus - In Windows immer auf 1!
     dcb_ParityCheck         = $00000002; // Paritätsüberprüfung

     dcb_OutxCtsFlow         = $00000004; // CTS Flusskontrolle - Sendekontrolle mit Hilfe von CTS
     dcb_OutxDsrFlow         = $00000008; // DSR Flusskontrolle - Sendekontroll mit  Hilfe von DSR

     dcb_DtrControlDisable   = $00000000; // DTR Flusskontrolle - Schließt DTR auf 0 bei Verbindung und hält es auf 0
     dcb_DtrControlEnable    = $00000010; // DTR Flusskontrolle - Öffnet   DTR auf 1 bei Verbindung und hält es auf 1
     dcb_DtrControlHandshake = $00000020; // DTR Flusskontrolle - Handshake-Funktion.
     dcb_DtrControlMask      = $00000030;

     dcb_DsrSensitvity       = $00000040; // Zustandsänderung auf DSR überwachen

     dcb_TXContinueOnXoff    = $00000080; // Stellt ein, ob die Übertragung bei XOff angehalten wird oder nicht

     dcb_OutX                = $00000100; // Flusskontrolle mit XOn/XOff beim Senden
     dcb_InX                 = $00000200; // Flusskontrolle mit XOn/XOff beim Empfangen
     dcb_ErrorChar           = $00000400; // Bestimmt, ob Bytes mit falscher Parität durch den Error-Char ersetzt wird.

     dcb_NullStrip           = $00000800; // Null-Bytes werden beim Empfangen ignoriert

     dcb_RtsControlDisable   = $00000000; // RTS-Flusskontrolle - Schließt RTS auf 0 bei Verbindung und hält es auf 0
     dcb_RtsControlEnable    = $00001000; // RTS-Flusskontrolle - Öffnet   RTS auf 1 bei Verbindung und hält es auf 1
     dcb_RtsControlHandshake = $00002000; // RTS-Flusskontrolle - Handshake-Funktion
     dcb_RtsControlToggle    = $00003000; // RTS-Flusskontrolle - RTS ist an wenn Bytes zu senden sind, wenn keine zu senden sind ist RTS auf 0
     dcb_RtsControlMask      = $00003000; // RTS-Flusskontrolle

     dcb_AbortOnError        = $00004000; // Wenn ein Fehler auftritt, stoppt jede Transmission und der
                                          // Fehler muss mit Hilfe von ClearCommError beseitigt werden.

     dcb_Reserveds           = $FFFF8000; // Reserviert! Nicht benutzen!
//------------------------------------------------------------------------------------------------------------------------

type TComPort = class
 private
    PortHandle : THandle;                        // Handle (u.a. Zeiger) auf den COM-Port.
    DCB : TDCB;                                  // Data-Control-Block-Struktur zum Kontrollieren der Parameter der seriellen Schnittstelle
    procedure GetDCB;

    procedure SetParity (Parity : byte);         // Den Modus der Paritätskontrolle:
    function  GetParity : byte;                  // 0 = Keine, 1=ungerade, 2=gerade, 3=Merkierung, 4=Leerzeichen

    procedure SetBaudRate (Baudrate : Word);     // Setzt die Übertragungsgeschwindigkeit des Ports in Baud
    function  GetBaudrate : Word;

    function GetStopBits : byte;                 // Setzt die Anzahl der Stopbits
    procedure SetStopBits (bits : byte);         // 0 = 1 Stopbit, 1 = 1.5 Stopbits, 2 = 2 Stopbits

    function  GetByteSize : byte;                // Fragt die Anzhal der Bits/Byte ab.
    procedure SetByteSize (bytesize : byte);     // Setzt die Anzahl der Bits/Byte (Standard: 8)
 public
    function OpenCOM (Port : pchar) : Integer;   // Öffnet COM-Port (Parameter-Beispiel: 'COM1')
    procedure CloseCOM;                          // Schließt das Handle für den COM-Port

    //-------------------------------------------Ausgaben - Indikatoren für angeschlossene Geräte

    procedure TXD (State : integer);             // TxD = Sendeleitung --> Hier Prozedur für Dauerspannung auf TxD
    procedure RTS (State : integer);             // "Request-To-Send" --> Computer signalisiert, dass er senden möchte
    procedure DTR (State : integer);             // "Data-Terminal-Ready" --> Computer ist bereit

    //-------------------------------------------Eingaben - Indikatoren für bestimmte Ereignisse.

    function CTS : integer;                      // "Clear-To-Send" --> Dem Computer wird angezeigt,
                                                 //   dass das angeschlossene Gerät bereit ist Daten zu emfpangen

    function DSR      : integer;                 // "Data-Set-Ready" --> Angeschlossenes Gerät ist bereit
    function RI       : integer;                 // "Ring-Indicator" --> Klingelzeichen, ähnlich beim Telefon
    function DCD      : integer;                 // "Data-Carrier-Detect --> Computer ist bereit Daten zu empfangen
    function INPUTS   : integer;
    //--------------------------------------------------------------------------------------------

    function GetHndl  : Integer;                 // Gibt das geöffnete Handle des Ports zurück
    //--------------------------------------------------------------------------------------------

    function GetFlags : Integer;                // Fragt die Port-Flags ab.
    function SetFlags (Flag : Integer; Enable : Boolean) : boolean; //Setzt die Port-Flags (siehe weiter oben)

    //------------------------------------------Sendefunktionen

    procedure BufferSize (Size : Integer);      // Setzt die Größe des Sende- und Empfangspuffers für Zeichenübertragungen

    function  CharInTXBuffer : Cardinal;        // Aktuelle Länge des Sendepuffersd
    function  CharInRXBuffer : Cardinal;        // Aktuelle Länge des Empfangspuffers
    procedure ClearBuffer;                      // Sende- und Empfangspuffer werden gelöscht
    procedure SENDBYTE  (Dat: Integer);         // Byte über die serielle Schnittstelle senden
    procedure SENDSTRING(Buffer: Pchar);        // Text über die serielle Schnittstelle senden
    function  READBYTE()   : Integer;           // Byte über die serielle Schnittstelle empfangen
    function  READSTRING() : Pchar;             // Text über die serielle Schnittstelle empfangen
    procedure Timeouts (TOut : Integer);        // Setzt die Timeouts zum Senden
    function  GetStatusReport : String;         // Gibt einen ausführlich formulierten Statusreport des Ports zurück.
    //---------------------------------------------------------------------------------------------

    property Parity   : byte read GetParity    write SetParity;
    property BaudRate : Word read GetBaudRate  write SetBaudRate;
    property StopBits : byte read GetStopBits  write SetStopBits;
    property ByteSize : byte read GetByteSize  write SetByteSize;
    //*********************************************************************************************
     destructor Destroy; override;
     constructor Create (AutoInit : Integer);
    //*********************************************************************************************

end;

implementation

constructor TComPort.Create (AutoInit : Integer);
begin
 case AutoInit of
  1 : OpenCOM('COM1');
  2 : OpenCOM('COM2');
  end; {CASE}
end;


function TComPort.OpenCOM (port : pchar) : Integer;
var
 PortStr, Parameter : String;

begin
 Result := 0;
 // Wenn Port-Handle geöffnet, dann Handle schließen
//if PortHandle > 0 then CloseHandle(PortHandle);
 // übermittelter COM-Port 'herausfiltern'
 Parameter := port;
 PortStr := copy(Parameter,1,4);
 // COM-Port öffnen
 PortHandle := CreateFile (PChar(PortStr), GENERIC_READ or GENERIC_WRITE,
                           0,nil,OPEN_EXISTING,0,0);
 //Status des Ports überprüfen und DCB-Struktur füllen
 //GetCommState(PortHandle,dcb);
 //DCB-Struktur mit Standardwerten füllen
 BuildCommDCB(PChar(Parameter),dcb);
 //Eigene Flags setzen
 DCB.Flags := 1;
 //Änderungen auf den Port anwenden und auf Erfolg überprüfen
 if SetCommState (PortHandle, DCB) then Result := 1;
end;

procedure TComPort.CloseCOM;
begin
 //Port schließen und Handle zurücksetzen (wegen OpenCOM!)
 GetCommState(PortHandle,dcb);
 SetParity(0);
 SetBaudrate(1200);
 SetStopBits(0);
 SetByteSize(8);
 SetCommState(PortHandle,dcb);
 CloseHandle(PortHandle);
 PortHandle := 0;
end;

procedure TComport.TXD (State: Integer);
begin
 if State=0 then
  EscapeCommFunction(PortHandle,CLRBREAK)
 else
  EscapeCommFunction(PortHandle,SETBREAK);

end;

procedure TComPort.RTS (State:Integer);
begin
 if State=0 then
  EscapeCommFunction(PortHandle,CLRRTS)
 else
  EscapeCommFunction(PortHandle,SETRTS);
end;

procedure TComPort.DTR (State : integer);
begin
 if State = 0 then
  EscapeCommFunction(PortHandle,CLRDTR)
 else
  EscapeCommFunction(PortHandle,SETDTR);
end;

function TComPort.CTS : Integer;
var
 mask : DWord;
begin
 GetCommModemStatus(PortHandle,mask);
 if (mask and MS_CTS_ON) = 0 then
  result := 0
 else
  result := 1;
end;

function TComPort.DSR : Integer;
var
 mask : DWord;
begin
 GetCommModemStatus(PortHandle,mask);
 if (mask and MS_DSR_ON) = 0 then
  result := 0
 else
  result := 1;
end;

function TComPort.RI : Integer;
var
 mask : DWord;
begin
 GetCommModemStatus(PortHandle,mask);
 if (mask and MS_RING_ON) = 0 then
  result := 0
 else
  result := 1;
end;

function TComPort.DCD : Integer;
var
 mask : DWord;
begin
 GetCommModemStatus(PortHandle,mask);
 if (mask and MS_RLSD_ON) = 0 then
  result := 0
 else
  result := 1;
end;

function TComPort.Inputs : Integer;
var
 mask : DWord;
begin
 GetCommModemStatus(PortHandle,mask);
 result := (mask div 16) and 15;
end;

function TComPort.GetHndl : integer;
begin
 result := PortHandle;
end;

procedure TComPort.SetParity (Parity : byte);
begin
  if (PortHandle > 0) and (Parity in [0..4]) then
   begin
    GetDCB;
    DCB.Parity := Parity;
    windows.SetCommState(PortHandle,DCB)
   end;
end;

function TComport.GetParity : byte;
var
 temp : TDCB;
begin
 if (PortHandle > 0) then
  begin
   GetCommState(PortHandle,temp);
   result := temp.Parity;
  end
 else
  result := 255;
end;

function TComport.GetBaudrate : Word;
var
 temp : TDCB;
begin
 if (PortHandle > 0) then
  begin
   GetCommState(PortHandle,temp);
   result := temp.BaudRate;
  end
 else
  result := 0;
end;

procedure TComPort.SetBaudRate(Baudrate : Word);
begin
 if (PortHandle > 0) then
 begin
  GetCommState(PortHandle,DCB);
  DCB.BaudRate := Baudrate;
  SetCommState(PortHandle,DCB)
 end;

end;

function TComPort.GetFlags : Integer;
var
 temp : TDCB;
begin
 if (PortHandle > 0) then
  begin
   GetCommState(PortHandle,temp);
   result := temp.Flags;
  end
 else
   result := -1;
end;

function TComport.GetStopBits : byte;
var
 temp : TDCB;
begin
 if (PortHandle > 0) then
  begin
   GetCommState(PortHandle,temp);
   result := temp.StopBits;
  end
 else
  result := 255;

end;

procedure TComport.SetStopBits(bits : byte);
begin
 if (bits > 0) and (bits <= 2) then   // Der gültige Eingabebereich wird festgelegt
  begin
   GetDCB;
   DCB.StopBits := bits;
   SetCommState (PortHandle,DCB);
  end;

end;

function TComport.GetByteSize : byte;
var
 temp : TDCB;
begin
 GetCommState(PortHandle,temp);
 result := temp.ByteSize;
end;

procedure TComport.SetByteSize(bytesize : byte);
begin
  if bytesize in [1..8] then
   begin
    GetDCB;
    DCB.ByteSize := bytesize;
    SetCommState (PortHandle,DCB);
   end;
end;

procedure TComport.BufferSize(Size : Integer);
begin
 SetupComm(PortHandle,Size,Size);
end;

function  TComport.CharInTXBuffer : Cardinal;
var
 Comstat : _Comstat;
 Errors : DWord;
begin
 if windows.ClearCommError(PortHandle,Errors,@Comstat) then
  result := Comstat.cbOutQue else result := 0;
end;

function TComport.CharInRXBuffer : Cardinal;
var
 Comstat : _Comstat;
 Errors : DWord;
begin
 if windows.ClearCommError(PortHandle,Errors,@Comstat) then
  result := Comstat.cbInQue else result := 0;
end;

procedure TComport.ClearBuffer;
begin
 windows.PurgeComm(PortHandle,PURGE_TXCLEAR);
 windows.PurgeComm(PortHandle,PURGE_RXCLEAR);
end;

procedure TComport.SENDBYTE (Dat: Integer);
var BytesWritten: DWord;
begin
 WriteFile(PortHandle,Dat,1,BytesWritten,NIL);
END;

function TComport.READBYTE(): Integer;
var Dat: Byte;
    BytesRead: DWORD;
begin
 ReadFile(PortHandle,Dat,1,BytesRead,NIL);
 if BytesRead = 1 then Result:=Dat else Result := -1;
end;

procedure TComport.SENDSTRING (Buffer: Pchar);
var BytesWritten: DWord;
begin
  WriteFile(PortHandle,Buffer^,Length(Buffer),BytesWritten,NIL);
END;

function TComport.READSTRING(): Pchar;
var Dat: Integer;
    Data: STRING;
begin
  Dat := 0;
  while ((Dat > -1) and (Dat <> 13)) do begin
    Dat := ReadByte();
    if ((Dat > -1) and (Dat <> 13)) then Data := Data + Chr(Dat);
  end;
  result := pchar(Data);
end;

destructor TComport.Destroy;
begin
 if PortHandle > 0 then
  CloseCom;
 inherited;
end;

procedure Tcomport.Timeouts (TOut : Integer);
var
 Timeout : TCommTimeOuts;
begin
 TimeOut.ReadIntervalTimeout := 1;
 TimeOut.ReadTotalTimeoutMultiplier := 1;
 TimeOut.ReadTotalTimeoutConstant := TOut;
 TimeOut.WriteTotalTimeoutMultiplier := 10;
 TimeOut.WriteTotalTimeoutConstant := TOut;
 SetCommTImeouts(PortHandle,Timeout);
end;

procedure TComport.GetDCB;
begin
 GetCommState(PortHandle,DCB);
end;

function  TComport.SetFlags (Flag : Integer; Enable : Boolean) : boolean;
begin
 GetDCB;
 if Enable then
  DCB.Flags := DCB.Flags or Flag
 else
   DCB.Flags := DCB.Flags and (not Flag);

 result := Boolean(SetCommState(PortHandle,DCB));
end;

function  TComport.GetStatusReport  : String;
var
 Str : String;
begin
 Str := 'Baudrate von COM1: ' + IntToStr(Baudrate);
 //Str := Str + chr(13) + 'Parität von COM1: ' + parity[Parity];
 Str := Str + chr(13) + 'Flags von COM1: ' + IntToStr(GetFlags);
 Str := Str + chr(13) + 'Bits/Byte von COM1: ' + IntToStr(ByteSize);
 //Str := Str + chr(13) + 'Stopbits von COM1: ' + stopbits[StopBits];
 Str := Str + chr(13) + 'Zeichen im RX-Puffer: ' + IntToStr(CharInRXBuffer);
 Str := Str + chr(13) + 'Zeichen im TX-Puffer: ' + IntToStr(CharInTXBuffer);
 result := Str;
end;


end.
