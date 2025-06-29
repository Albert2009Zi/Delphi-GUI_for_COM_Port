program prjComPortTest;

uses
  Vcl.Forms,
  AppTestComPort in 'AppTestComPort.pas' {TestComPort},
  BasicFunctions in 'BasicFunctions.pas',
  OptionsPanel in 'OptionsPanel.pas' {frmOptions};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTestComPort, TestComPort);
  Application.CreateForm(TfrmOptions, frmOptions);
  Application.Run;
end.
