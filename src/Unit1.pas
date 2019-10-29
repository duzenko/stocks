unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    LinesRead: DWORD;
    Indicators: TStringList;
  public
    procedure ShowStats;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure ReadProc;
var
  s: string;
  sl: TStringList;
begin
  AssignFile(Input, '..\..\output-semicolon-narrow.csv');
  Reset(Input);
  sl := TStringList.Create;
  sl.Delimiter := ';';
  sl.StrictDelimiter := true;
  while not Eof do begin
    Readln(s);
    sl.DelimitedText := s;
//    ListBox1.Items.Add(s);
    Form1.Indicators.Add(sl[3]);
    Inc(Form1.LinesRead);
    if Form1.LinesRead mod 10000 = 0 then
      TThread.Synchronize(nil, Form1.ShowStats);
  end;
  CloseFile(Input);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Indicators := TStringList.Create;
  Indicators.Sorted := true;
  TThread.CreateAnonymousThread(ReadProc).Start;
end;

procedure TForm1.ShowStats;
begin
  if Memo1.Lines.Count <> Indicators.Count then
    Memo1.Lines := Indicators;
  StatusBar1.SimpleText := IntToStr(LinesRead);
end;

end.
