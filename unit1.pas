unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAChartListbox, Forms,
  Controls, Graphics, Dialogs, Grids, StdCtrls, ExtCtrls, Calculations;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Chart1: TChart;
    Chart1LineSeries1: TLineSeries;
    Chart1LineSeries2: TLineSeries;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure Label1Click(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
const
  n = 100;
  otr = 100;

var
  st, t: double;
  npp: word;

procedure TForm1.Button1Click(Sender: TObject);
var
  x, step, value: double;
  y: longint;
begin
  Chart1LineSeries1.Clear;
  step := 0.00005;
  x := 0;
  y := 0;

  while x + step <= TimeRange do
  begin
    x := x + step;
    Inc(y);
    StringGrid1.Cells[0, y] := FloatToStr(y);
    StringGrid1.Cells[1, y] := FloatToStr(x);
    value := InputSignal(x);
    StringGrid1.Cells[2, y] := FloatToStr(value);
    Chart1LineSeries1.AddXY(x, value);
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  value: double;
begin
  Chart1LineSeries2.Clear;

  st := TimeRange / n;
  t := 0;
  npp := 0;
  while t + st <= TimeRange do
  begin
    Inc(npp);
    value := Integral(t, 0, otr, t);
    StringGrid1.Cells[3, npp] := FloatToStr(value);
    Chart1LineSeries2.AddXY(t, value);
    t := t + st;
  end;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  if not (Key in ['0'..'9', ',']) then Key := #0;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;



end.

