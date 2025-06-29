{*******************************************************************************
 * Unit Name  : OptionsPanel
 * Author     : Albert Ziatdinov
 * Created    : 20.11.2022
 * Purpose    : Placeholder for future configuration options
 * Description:
 *   - Defines a form (TfrmOptions) that will contain user-configurable settings,
 *     such as communication parameters (e.g., baud rate).
 *   - Currently contains a radio group for baud rate selection.
 *   - This form is not yet used in the main application.
 *   - Integration with the main GUI (TTestComPort) is planned for a future update.
 * Compatible : Delphi / RAD Studio
 * Comment    : This module is a stub and will be expanded later.
 *******************************************************************************}

unit OptionsPanel;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TfrmOptions = class(TForm)
    rgpBaudrate: TRadioGroup;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

end.
