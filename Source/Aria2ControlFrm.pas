﻿{ *********************************************************************** }
{                                                                         }
{   AriaNg WKE 自动化浏览器项目单元                                       }
{                                                                         }
{   设计：Lsuper 2017.09.11                                               }
{   备注：                                                                }
{   审核：                                                                }
{                                                                         }
{   Copyright (c) 1998-2019 Super Studio                                  }
{                                                                         }
{ *********************************************************************** }

unit Aria2ControlFrm;

interface

uses
  System.SysUtils, Vcl.Forms, Langji.Wke.Webbrowser;

type
  TAria2ControlForm = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FWebBrowser: TWkeWebBrowser;
  private
    procedure ExtractWebIndexFile(const AFile: string);
  private
    procedure WkeWebBrowser1TitleChange(Sender: TObject; sTitle: string);
  end;

var
  Aria2ControlForm: TAria2ControlForm;

implementation

{$R *.dfm}
{$R *.res} { index.html }

uses
  System.Classes, System.Types, Vcl.Controls, Langji.Wke.Lib;

{ TAria2ControlForm }

procedure TAria2ControlForm.ExtractWebIndexFile(const AFile: string);
var
  F: string;
  S: TResourceStream;
begin
  F := ExtractFileDir(AFile);
  if not DirectoryExists(F) then
    ForceDirectories(F);
  if not DirectoryExists(F) then
    Exit;
  S := TResourceStream.Create(HInstance, 'INDEX', RT_RCDATA);
  with TFileStream.Create(AFile, fmCreate) do
  try
    CopyFrom(S, S.Size);
  finally
    Free;
    S.Free;
  end;
end;

procedure TAria2ControlForm.FormCreate(Sender: TObject);
const
  defLocalStoragePathFmt    = '%s\LocalStorage';
var
  S: string;
begin
  S := GetModuleName(0);
  S := ExtractFileDir(S);

  wkeLibFileName := Format('%s\WKE.dll', [S]);

  FWebBrowser := TWkeWebBrowser.Create(Self);
  FWebBrowser.Parent := Self;
  FWebBrowser.Align := alClient;

  S := Format(defLocalStoragePathFmt, [S]);
  if not DirectoryExists(S) then
    ForceDirectories(S);
  FWebBrowser.CookiePath := S;
  FWebBrowser.CookieEnabled := True;
  FWebBrowser.LocalStoragePath := S;

  FWebBrowser.OnTitleChange := WkeWebBrowser1TitleChange;
end;

procedure TAria2ControlForm.FormShow(Sender: TObject);
var
  F: string;
begin
  F := GetModuleName(0);
  F := ExtractFilePath(F);
  F := F + 'App\index.html';
  if not FileExists(F) then
    ExtractWebIndexFile(F);
  if FileExists(F) then
    FWebBrowser.LoadFile(F);
end;

procedure TAria2ControlForm.WkeWebBrowser1TitleChange(Sender: TObject; sTitle: string);
begin
  Caption := sTitle;
end;

end.
