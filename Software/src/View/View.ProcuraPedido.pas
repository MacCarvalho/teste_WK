unit View.ProcuraPedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.DialogService,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Edit, System.Rtti,
  FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, Data.Bind.EngExt, FMX.Bind.DBEngExt,
  FMX.Bind.Grid, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope;

type
  TfrmProcuraPedido = class(TForm)
    Layout1: TLayout;
    Label1: TLabel;
    edPesquisaPedido: TEdit;
    Layout2: TLayout;
    GridResultado: TStringGrid;
    bsLink: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    btAbrir: TButton;
    btFechar: TButton;
    btDeletar: TButton;
    procedure edPesquisaPedidoKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure btFecharClick(Sender: TObject);
    procedure btDeletarClick(Sender: TObject);
    procedure btAbrirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RemoverPedido(id: string);
  end;

var
  frmProcuraPedido: TfrmProcuraPedido;

implementation

{$R *.fmx}

uses Controller.PreparaQuery, Model.Connection, View.Pedido;

procedure TfrmProcuraPedido.btAbrirClick(Sender: TObject);
begin
  frmPedido.CarregarPedido(dm.qryView.fieldbyname('codigo').asstring);
  self.close;
end;

procedure TfrmProcuraPedido.btDeletarClick(Sender: TObject);
begin
  TDialogService.MessageDialog('Deseja realmente excluir?',
    TMsgDlgType.mtConfirmation, FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, 0,
    procedure(const AResult: TModalResult)
    begin
      case AResult of
        mrYes:
          RemoverPedido(dm.qryView.fieldbyname('codigo').asstring);
      end;
    end);
end;

procedure TfrmProcuraPedido.btFecharClick(Sender: TObject);
begin
  dm.qryView.close;
  self.close;
end;

procedure TfrmProcuraPedido.edPesquisaPedidoKeyUp(Sender: TObject;
var Key: Word; var KeyChar: Char; Shift: TShiftState);
var
  sql: string;
begin
  if (Key = vkReturn) and trim(edPesquisaPedido.text).IsEmpty = false then
  begin
    sql := 'select pedidos.codigo, sum(pedidos_produtos.qtde) as qtde, pedidos.valor_total  as total from pedidos ';
    sql := sql +
      ' inner join pedidos_produtos on pedidos.codigo = pedidos_produtos.pedidos_codigo ';
    sql := sql + 'where pedidos.codigo =' + edPesquisaPedido.text;
    ViewSQL(sql);
    GridResultado.Columns[0].Header := 'C�digo';
    GridResultado.Columns[0].Width := 50;
    GridResultado.Columns[1].Header := 'QTDE de itens';
    GridResultado.Columns[1].Width := 150;
    GridResultado.Columns[2].Header := 'Valor total do pedido';
    GridResultado.Columns[2].Width := 150;
  end;
end;

procedure TfrmProcuraPedido.FormShow(Sender: TObject);
begin
  edPesquisaPedido.SetFocus;
end;

procedure TfrmProcuraPedido.RemoverPedido(id: string);
var
  sql: string;
begin
  sql := 'delete from pedidos_produtos where pedidos_codigo = ' + id;
  ExecSQL(sql);
  sql := 'delete from pedidos where codigo = ' + id;
  ExecSQL(sql);
  showmessage('Pedido Removido');
  self.close;
end;

end.
