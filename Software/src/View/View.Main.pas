unit View.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit,
  System.Actions, FMX.ActnList;

type
  TfrmMain = class(TForm)
    Path1: TPath;
    Rectangle1: TRectangle;
    Expander1: TExpander;
    edBancoDados: TEdit;
    Label1: TLabel;
    edUsuario: TEdit;
    Label2: TLabel;
    edSenha: TEdit;
    Label3: TLabel;
    btTestarConexao: TButton;
    Label4: TLabel;
    Rectangle2: TRectangle;
    Path2: TPath;
    Label5: TLabel;
    ActionList1: TActionList;
    AbrirPedidos: TAction;
    AbrirProdutos: TAction;
    procedure btTestarConexaoClick(Sender: TObject);
    procedure AbrirProdutosExecute(Sender: TObject);
    procedure AbrirPedidosExecute(Sender: TObject);
    procedure Rectangle1Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses Model.Connection, View.Cliente_Produto, View.Pedido;

procedure TfrmMain.AbrirPedidosExecute(Sender: TObject);
begin
  Application.CreateForm(TfrmPedido,frmPedido);
  frmPedido.Show;
end;

procedure TfrmMain.AbrirProdutosExecute(Sender: TObject);
begin
  Application.CreateForm(TfrmCadClienteProduto,frmCadClienteProduto);
  frmCadClienteProduto.show;
end;

procedure TfrmMain.btTestarConexaoClick(Sender: TObject);
begin
  dm.Connection.connected := true;
    if dm.Connection.connected = true then
    begin
      showmessage('Conectado');
    end else
    begin
      showmessage('Sem conex�o');
    end;

end;

procedure TfrmMain.Label5Click(Sender: TObject);
begin
  AbrirProdutos.Execute;
end;

procedure TfrmMain.Rectangle1Click(Sender: TObject);
begin
  AbrirPedidos.Execute;
end;

end.