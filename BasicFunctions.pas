{*******************************************************************************
 * Unit Name  : BasicFunctions
 * Author     : Albert Ziatdinov
 * Created    : 20.11.2022
 * Purpose    : Provides basic COM port communication functions (open, send, receive, close)
 * Description:
 *   - OpenCOM: opens and configures a serial COM port.
 *   - SendText: sends a string via COM port.
 *   - ReadText: reads available data from COM port.
 *   - CloseCOM: closes the COM port.
 * Compatible : Delphi / RAD Studio
 * Comment    : All methods use standard WinAPI functions.
 *******************************************************************************}

unit BasicFunctions;

interface

uses Windows,
     Vcl.Dialogs,
     Messages,
     SysUtils,
     Classes;

const
  ComBufferSize = 4096;  //Fixed size of the communication I/O buffer

type

{*******************************************************************************
 * TComPort class interface
 *
 * All functions are public methods of the TComPort class.
 * Encapsulation is intentionally not used, as this is a minimal GUI example
 * for testing basic COM port functionality.
 *******************************************************************************}
TComPort = class(TComponent)
 private
 public
  FHandle:  THandle;
  function  OpenCOM (port : pchar)         : Boolean;
  procedure SendText(sendCmd: AnsiString);
  function  CloseCOM                       : Boolean;
 end;

var
  ComHandle: THandle;

implementation


{*******************************************************************************
 * Function  : OpenCOM
 * Purpose   : Opens and configures the specified COM port.
 * Description:
 *   - Opens the COM port handle.
 *   - Sets baud rate, parity, byte size, stop bits.
 *   - Configures communication timeouts.
 *   - Sets event mask for receiving data.
 * Parameters:
 *   port : PChar - COM port name (e.g. 'COM1').
 * Returns:
 *   Boolean - True if port opened and configured successfully, False otherwise.
 ******************************************************************************}
function TComPort.OpenCOM (port : pchar) : Boolean;
var
  DCB:TDCB;
  Timeouts:TCommTimeouts;
begin
  Result  := False;
  FHandle := CreateFile(PChar(port), GENERIC_READ or GENERIC_WRITE,
             0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL {FILE_FLAG_OVERLAPPED}, 0);
  if (FHandle = INVALID_HANDLE_VALUE) or (FHandle = 0) then
    Exit;

  PurgeComm(FHandle, Purge_TXabort or Purge_RXabort or Purge_TXclear or Purge_RXclear); //Clear the selected buffer

  //Configuration of COM port parameters
  if not (Windows.GetCommState(FHandle,DCB)) then
    Exit;
  DCB.BaudRate := 115200;
  DCB.Parity   := NOPARITY;
  DCB.ByteSize := 8;
  DCB.StopBits := ONESTOPBIT;                        //or can be TWOSTOPBITS;
  DCB.Flags    := DCB.Flags or DTR_CONTROL_ENABLE;
  if not(Windows.SetCommState(FHandle,DCB)) then
    Exit;
  if Not SetupComm(FHandle,ComBufferSize,ComBufferSize) then
    begin
      ShowMessage('Buffer init error!!!');
      CloseHandle(FHandle);
      Exit;
    end;
  if GetCommTimeouts(FHandle,Timeouts) then
    begin
      Timeouts.ReadIntervalTimeout         :=MAXWORD;
      Timeouts.ReadTotalTimeoutMultiplier  :=0;
      Timeouts.ReadTotalTimeoutConstant    :=10;
      Timeouts.WriteTotalTimeoutMultiplier :=0;
      Timeouts.WriteTotalTimeoutConstant   :=10;
      if not SetCommTimeouts(FHandle,Timeouts) then
        Exit;
    end
  else
    Exit;
  if not(PurgeComm(FHandle, PURGE_TXABORT or PURGE_RXABORT or PURGE_TXCLEAR or PURGE_RXCLEAR)) then
    Exit;
 // EscapeCommFunction(FHandle, CLRRTS);
  if not SetCommMask(FHandle, EV_RXCHAR) then
     Exit;
    EscapeCommFunction(FHandle, SETDTR);
    EscapeCommFunction(FHandle, SETRTS);
  SetCommMask(FHandle, EV_RXCHAR);               //Set the mask to trigger on the event "a byte received at the port"
  Result:=True;
end;


{*******************************************************************************
 * Procedure : SendText
 * Purpose   : Sends a string of data to the open COM port.
 * Description:
 *   - Writes the content of sendCmd to the COM port.
 * Parameters:
 *   sendCmd : AnsiString - Data to send.
 ******************************************************************************}
procedure TComPort.SendText(sendCmd: AnsiString);
var
  dataPtr  : PByte;
  bytesWrt : DWORD;
begin
  dataPtr  := PByte(PAnsiChar(sendCmd));
  WriteFile(FHandle, dataPtr^, Length(sendCmd), bytesWrt, nil);
end;


{*******************************************************************************
 * Function  : CloseCOM
 * Purpose   : Closes the open COM port handle.
 * Description:
 *   - Releases the COM port handle.
 * Returns:
 *   Boolean - True if the handle was closed successfully, False otherwise.
 ******************************************************************************}
function TComPort.CloseCom: boolean;
begin
  Result := Windows.CloseHandle(FHandle);
end;


end.
