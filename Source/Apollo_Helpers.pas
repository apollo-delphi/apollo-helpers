unit Apollo_Helpers;

interface

uses
  System.Classes;

type
  TStringTools = record
    class function GetHash(const aStr: string): string; static;
    class function GetHash16(const aStr: string): string; static;
  end;

  TFileTools = record
    class function CreateFileStream(const aFilePath: string): TFileStream; static;
    class function GetFiles(const aDirectoryPath: string; const aAllDirectories: Boolean = True): TArray<string>; static;
    class procedure ClearDirectory(const aDirectoryPath: string); static;
    class procedure CreateDirIfNotExists(const aDirectoryPath: string); static;
  end;

  TStrArrHelper = record helper for TArray<string>
    function Contains(const aValue: string): Boolean;
    function CommaText: string;
    function Count: Integer;
  end;

  TIntArrHelper = record helper for TArray<Integer>
    function CommaText: string;
    function Count: Integer;
    function IsEmpty: Boolean;
    procedure Clear;
    procedure SplitCommaText(const aText: string);
  end;

implementation

uses
  System.Hash,
  System.IOUtils,
  System.SysUtils;

{TIntArrHelper}

function TIntArrHelper.IsEmpty: Boolean;
begin
  Result := Length(Self) = 0;
end;

procedure TIntArrHelper.Clear;
begin
  SetLength(Self, 0);
end;

function TIntArrHelper.Count: Integer;
begin
  Result := Length(Self);
end;

procedure TIntArrHelper.SplitCommaText(const aText: string);
var
  Value: string;
  Values: TArray<string>;
begin
  Self := [];
  Values := aText.Split([',']);

  for Value in Values do
    Self := Self + [Value.ToInteger];
end;

function TIntArrHelper.CommaText: string;
var
  Value: Integer;
begin
  Result := '';

  for Value in Self do
  begin
    if not Result.IsEmpty then
      Result := Result + ',';
    Result := Result + Value.ToString;
  end;
end;

{TStrArrHelper}

function TStrArrHelper.Contains(const aValue: string): Boolean;
var
  Value: string;
begin
  Result := False;
  for Value in Self do
    if Value = aValue then
      Exit(True);
end;

function TStrArrHelper.Count: Integer;
begin
  Result := Length(Self);
end;

function TStrArrHelper.CommaText: string;
begin
  Result := string.Join(',', Self);
end;

{TStringTools}

class function TStringTools.GetHash(const aStr: string): string;
begin
  Result := THashMD5.GetHashString(aStr).ToUpper;
end;

class function TStringTools.GetHash16(const aStr: string): string;
begin
  Result := GetHash(aStr).Substring(0, 15);
end;

{TFileTools}

class procedure TFileTools.CreateDirIfNotExists(const aDirectoryPath: string);
begin
  if not TDirectory.Exists(aDirectoryPath) then
    TDirectory.CreateDirectory(aDirectoryPath);
end;

class procedure TFileTools.ClearDirectory(const aDirectoryPath: string);
var
  FilePath: string;
  FilePaths: TArray<string>;
begin
  FilePaths := GetFiles(aDirectoryPath, False{aAllDirectories});

  for FilePath in FilePaths do
    TFile.Delete(FilePath);
end;

class function TFileTools.GetFiles(const aDirectoryPath: string; const aAllDirectories: Boolean = True): TArray<string>;
begin
  if aAllDirectories then
    Result := TDirectory.GetFiles(aDirectoryPath, '*', TSearchOption.soAllDirectories)
  else
    Result := TDirectory.GetFiles(aDirectoryPath, '*', TSearchOption.soTopDirectoryOnly);
end;

class function TFileTools.CreateFileStream(const aFilePath: string): TFileStream;
begin
  Result := TFile.OpenWrite(aFilePath);
end;

end.
