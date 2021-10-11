object Form1: TForm1
  Left = 229
  Top = 125
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Image Deformator'
  ClientHeight = 281
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object PB1: TPaintBox
    Left = 8
    Top = 8
    Width = 321
    Height = 265
    OnMouseDown = PB1MouseDown
    OnMouseMove = PB1MouseMove
    OnMouseUp = PB1MouseUp
    OnPaint = PB1Paint
  end
end
