unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Bass, Vcl.ExtCtrls;

const
  fftCount = 128;

type
  TFormMain = class(TForm)
    TimerVisual: TTimer;
    PaintBoxVisual: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TimerVisualTimer(Sender: TObject);
    procedure PaintBoxVisualPaint(Sender: TObject);
  private
    Stream: HSTREAM;
    FftValues: array [0..fftCount-1] of Single;
    procedure PrepareFftValue();
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  Math;

const
  FileName = 'Mic_Paroxyzm.mp3';

procedure TFormMain.FormCreate(Sender: TObject);
begin
  // инициализация bass.dll
  if not BASS_Init(-1, 44100, 0, 0, nil) then
    raise Exception.Create('BASS_Init fail');

  // создаем стрим для файла
  Stream := BASS_StreamCreateFile(False, PChar(FileName), 0, 0, BASS_UNICODE);
  if Stream = 0 then
    raise Exception.Create('BASS_StreamCreateFile fail');
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  // освобождаем стрим
  BASS_StreamFree(Stream);
  // освобождаем bass.dll
  BASS_Free();
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  // воспроизводим
  if not BASS_ChannelPlay(stream, False) then
    raise Exception.Create('BASS_ChannelPlay fail');
end;

procedure TFormMain.PaintBoxVisualPaint(Sender: TObject);
const
  SkipBarCount = 33;
var
  I: Integer;
  PaintBox: TPaintBox;
  BarWidth: Integer;
begin
  PaintBox := TPaintBox(Sender);

  PaintBox.Canvas.Brush.Color := RGB(120, 0, 255);
  PaintBox.Canvas.Pen.Color := RGB(0, 0, 255);
  BarWidth := PaintBox.Width div (Length(FftValues) - SkipBarCount);
  for I := 0 to High(FftValues) - SkipBarCount do
  begin
    PaintBox.Canvas.Rectangle(
      I * BarWidth, // x1
      PaintBox.Height, // y1
       (I + 1) * BarWidth, // x2
       PaintBox.Height - Trunc(FftValues[I] * PaintBox.Height)// y2
    );
  end;
end;

procedure TFormMain.PrepareFftValue;
var
  fft: array [0..fftCount-1] of Single;
  I: Integer;
  Value: Single;
begin
  BASS_ChannelGetData(stream, @fft[0], BASS_DATA_FFT256);

  for I := 0 to High(FftValues) do
  begin
    FftValues[I] := Math.Max(FftValues[I] - 0.02, 0);
  end;

  for I := 0 to High(FftValues) do
  begin
    Value := Math.Log10(fft[I] * 100 + 1.0);
    if FftValues[I] < Value then
      FftValues[I] := Value;
  end;
end;

procedure TFormMain.TimerVisualTimer(Sender: TObject);
begin
  PrepareFftValue();
  PaintBoxVisual.Invalidate();

  if BASS_ChannelIsActive(stream) <> BASS_ACTIVE_PLAYING then
    Close();
end;

end.
