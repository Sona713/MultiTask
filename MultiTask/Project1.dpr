program MultiTask;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Classes;

type
  TTaskThread = class(TThread)
  private
    FTaskIndex: Integer;
    FResult: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(TaskIndex: Integer);
    property Result: Integer read FResult;
  end;

constructor TTaskThread.Create(TaskIndex: Integer);
begin
  FTaskIndex := TaskIndex;
  inherited Create(False);
end;

procedure TTaskThread.Execute;
begin
  Sleep(Random(5) * 1000);
  if FTaskIndex = 2 then

    raise Exception.Create(Format('Task %d failed', [FTaskIndex]));
  FResult := (FTaskIndex + 1) * 10;
end;

var
  I: Integer;
  FTasks: array of TTaskThread;

begin
  Randomize;
  SetLength(FTasks, 5);

  for I := 0 to High(FTasks) do
    FTasks[I] := TTaskThread.Create(I);

  for I:= 0 to High(FTasks) do
    FTasks[I].WaitFor;

  for I:= 0 to High(FTasks) do
  begin
    try
     Writeln('Task ', I, ' result: ', FTasks[I].Result);
    except
      on E: Exception do
       Writeln('Error in Task ',I,': ', E.Message);

    end;

  end;

  for I:= 0 to High(FTasks) do


    FTasks[I].Free;
  readln;
end.

