unit MainForm;

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

var
  timeStep, currentTime: double;
  iterationIndex: word;

procedure TMainForm.PlotInputButtonClick(Sender: TObject);
var
  timePoint, inputStepSize, signalValue: double;
  rowIndex: longint;
begin
  InputSeries.Clear;
  inputStepSize := 0.00005;
  timePoint := 0;
  rowIndex := 0;

  while timePoint + inputStepSize <= TimeRange do
  begin
    timePoint := timePoint + inputStepSize;
    Inc(rowIndex);
    DataGrid.Cells[0, rowIndex] := FloatToStr(rowIndex);
    DataGrid.Cells[1, rowIndex] := FloatToStr(timePoint);
    signalValue := InputSignal(timePoint);
    DataGrid.Cells[2, rowIndex] := FloatToStr(signalValue);
    InputSeries.AddXY(timePoint, signalValue);
  end;
end;

procedure TMainForm.PlotOutputButtonClick(Sender: TObject);
var
  integralValue: double;
begin
  OutputSeries.Clear;

  timeStep := TimeRange / SampleCount;
  currentTime := 0;
  iterationIndex := 0;
  while currentTime + timeStep <= TimeRange do
  begin
    Inc(iterationIndex);
    integralValue := Integral(currentTime, 0, IntegrationSteps, currentTime);
    DataGrid.Cells[3, iterationIndex] := FloatToStr(integralValue);
    OutputSeries.AddXY(currentTime, integralValue);
    currentTime := currentTime + timeStep;
  end;
end;

procedure TMainForm.AuthorLabelClick(Sender: TObject);
begin
end;

end.
