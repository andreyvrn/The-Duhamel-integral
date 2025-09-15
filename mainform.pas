unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAChartListbox, Forms,
  Controls, Graphics, Dialogs, Grids, StdCtrls, ExtCtrls, Calculations;

type

  { TMainForm }

  TMainForm = class(TForm)
    PlotInputButton: TButton;
    PlotOutputButton: TButton;
    SignalChart: TChart;
    InputSeries: TLineSeries;
    OutputSeries: TLineSeries;
    AuthorLabel: TLabel;
    DataGrid: TStringGrid;
    procedure AuthorLabelClick(Sender: TObject);
    procedure PlotInputButtonClick(Sender: TObject);
    procedure PlotOutputButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

const
  SampleCount = 100;
  IntegrationSteps = 100;

procedure TMainForm.PlotInputButtonClick(Sender: TObject);
var
  timePoint, sampleInterval, signalValue: double;
  sampleIndex, totalSamples: Integer;
begin
  InputSeries.Clear;
  sampleInterval := 0.00005;
  totalSamples := Trunc(TimeRange / sampleInterval);

  for sampleIndex := 1 to totalSamples do
  begin
    timePoint := sampleIndex * sampleInterval;
    DataGrid.Cells[0, sampleIndex] := IntToStr(sampleIndex);
    DataGrid.Cells[1, sampleIndex] := FloatToStr(timePoint);
    signalValue := InputSignal(timePoint);
    DataGrid.Cells[2, sampleIndex] := FloatToStr(signalValue);
    InputSeries.AddXY(timePoint, signalValue);
  end;
end;

procedure TMainForm.PlotOutputButtonClick(Sender: TObject);
var
  integralValue, sampleInterval, timePoint: double;
  sampleIndex: Integer;
begin
  OutputSeries.Clear;

  sampleInterval := TimeRange / SampleCount;
  for sampleIndex := 1 to SampleCount do
  begin
    timePoint := sampleIndex * sampleInterval;
    integralValue := Integral(0, timePoint, IntegrationSteps, timePoint);
    DataGrid.Cells[3, sampleIndex] := FloatToStr(integralValue);
    OutputSeries.AddXY(timePoint, integralValue);
  end;
end;

procedure TMainForm.AuthorLabelClick(Sender: TObject);
begin
end;

end.
