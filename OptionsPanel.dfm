object frmOptions: TfrmOptions
  Left = 0
  Top = 0
  Caption = 'Options'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object rgpBaudrate: TRadioGroup
    Left = 8
    Top = 8
    Width = 201
    Height = 105
    Caption = 'Baud rate'
    Columns = 3
    Items.Strings = (
      '300'
      '600'
      '1200'
      '2400'
      '9600'
      '14400'
      '19200'
      '28800'
      '38400'
      '56000'
      '57600'
      '115200'
      '128000'
      '256000'
      'custom')
    TabOrder = 0
  end
end
