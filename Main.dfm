object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'FormMain'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object PaintBoxVisual: TPaintBox
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    Align = alClient
    OnPaint = PaintBoxVisualPaint
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object TimerVisual: TTimer
    Interval = 20
    OnTimer = TimerVisualTimer
    Left = 376
    Top = 272
  end
end
