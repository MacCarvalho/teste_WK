unit Model.Connection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  Tdm = class(TDataModule)
    Connection: TFDConnection;
    mysqlDrive: TFDPhysMySQLDriverLink;
    qryView: TFDQuery;
    qryExec: TFDQuery;
    procedure ConnectionBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses View.Main;
{$R *.dfm}

procedure Tdm.ConnectionBeforeConnect(Sender: TObject);
begin
  mysqlDrive.VendorLib := extractfilepath(paramstr(0)) + 'libmysql.dll';
  //carrega os dados
  Connection.Params.UserName := frmMain.edUsuario.text;
  Connection.Params.Password := frmMain.edSenha.text;
  Connection.Params.Database := frmMain.edBancoDados.text;
end;

end.
