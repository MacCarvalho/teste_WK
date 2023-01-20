﻿unit View.Pedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Platform, FMX.Types, FMX.Controls, FMX.Forms,
  FMX.Graphics, FMX.Dialogs, FMX.StdCtrls, FMX.DialogService,
  FMX.Controls.Presentation, FMX.Edit, FMX.ComboEdit, FMX.Layouts,
  FMX.DateTimeCtrls, System.Rtti, FMX.Grid.Style, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.Bind.EngExt, FMX.Bind.DBEngExt,
  FMX.Bind.Grid, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FMX.ScrollBox, FMX.Grid, FMX.Menus;

type
  TfrmPedido = class(TForm)
    lytop: TLayout;
    lytgrid: TLayout;
    lytResumo: TLayout;
    cbxCliente: TComboEdit;
    lytCliente: TLayout;
    Label1: TLabel;
    Label2: TLabel;
    edData: TDateEdit;
    Label3: TLabel;
    lytProdutos: TLayout;
    Label4: TLabel;
    cbxProduto: TComboEdit;
    Layout2: TLayout;
    edQTDEProduto: TEdit;
    Label5: TLabel;
    edValorProduto: TEdit;
    Label6: TLabel;
    Grid_Produtos: TStringGrid;
    tbmem: TFDMemTable;
    tbmemcodigo: TIntegerField;
    tbmemdescricao: TStringField;
    tbmemqtde: TCurrencyField;
    tbmemvalor_unitario: TCurrencyField;
    tbmemvalor_total: TCurrencyField;
    bsLink: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    btAdicionarGrid: TButton;
    tmConsulta: TTimer;
    lytGeral: TLayout;
    ppMenuGrid: TPopupMenu;
    ppMEditar: TMenuItem;
    mmIExcluir: TMenuItem;
    lbTotal: TLabel;
    btGravar: TButton;
    btLocalizarPedido: TButton;
    procedure cbxClienteKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure cbxProdutoKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edQTDEProdutoKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure btAdicionarGridClick(Sender: TObject);
    procedure tmConsultaTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure edValorProdutoKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure ppMEditarClick(Sender: TObject);
    procedure mmIExcluirClick(Sender: TObject);
    procedure btGravarClick(Sender: TObject);
    procedure btLocalizarPedidoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ResultadoSoma: Double;
    procedure MovimentacaoGrid(tipo: integer);
    procedure PreparaEdicao;
    Procedure SomarTotal;
    Procedure CarregarPedido(id: string);

  end;

var
  frmPedido: TfrmPedido;

implementation

{$R *.fmx}

uses Controller.PreparaQuery, Model.Connection, View.ProcuraPedido;

procedure TfrmPedido.btAdicionarGridClick(Sender: TObject);
begin
  MovimentacaoGrid(0);
end;

procedure TfrmPedido.btGravarClick(Sender: TObject);
var
  sql: string;
  idprodutopedido: integer;
begin
  if cbxCliente.ItemHeight < 0 then
  begin
    ShowMessage('Selecione o usuario');
  end
  else
  begin
    // insert na principal

    sql := 'insert into pedidos(data, valor_total, cliente_codigo) values(';
    sql := sql + QuotedStr(FormatDateTime('yyyy/mm/dd', edData.Date)) + ', ';
    sql := sql + ResultadoSoma.ToString + ', ';
    sql := sql + IntToStr
      (integer(cbxCliente.Items.Objects[cbxCliente.ItemIndex])) + ');';
    ExecSQL(sql);
    sql := 'select last_insert_id() as id';
    ViewSQL(sql);
    // pega o id dela
    idprodutopedido := dm.qryView.FieldByName('id').Value;

    // insert na secundaria
    sql := 'insert into pedidos_produtos(pedidos_codigo, produtos_codigo, qtde, valor_unitario, valor_total) values(';
    sql := sql + idprodutopedido.ToString + ', ';
    sql := sql + tbmemcodigo.AsString + ', ';
    sql := sql + tbmemqtde.AsString + ', ';
    sql := sql + tbmemvalor_unitario.AsString + ', ';
    sql := sql + tbmemvalor_total.AsString + ')';
    ExecSQL(sql);
    ShowMessage('Pedido gravado com sucesso! Número do pedido é: ' +
      idprodutopedido.ToString);
      self.Close;
  end;
end;

procedure TfrmPedido.btLocalizarPedidoClick(Sender: TObject);
begin
  Application.CreateForm(TfrmProcuraPedido, frmProcuraPedido);
  frmProcuraPedido.Show;
end;

procedure TfrmPedido.CarregarPedido(id: string);
var
  sql: string;
begin
  sql := 'select clientes.nome, data from pedidos inner join clientes on ';
  sql := sql + 'cliente_codigo = clientes.codigo where pedidos.codigo =' + id;
  ViewSQL(sql);
  cbxCliente.Text := dm.qryView.FieldByName('nome').AsString;
  edData.Text := dm.qryView.FieldByName('data').AsString;
  // carrega o tbmem com os produtos
  sql := 'select pedidos_produtos.codigo, descricao, qtde, valor_unitario, valor_total from pedidos_produtos ';
  sql := sql + 'inner join produtos on produtos.codigo = produtos_codigo ';
  sql := sql + 'where pedidos_codigo = ' + id;
  ViewSQL(sql);
  dm.qryView.first;
  while dm.qryView.eof = false do
  begin
    tbmem.Append;
    tbmemcodigo.Value := dm.qryView.FieldByName('codigo').Value;
    tbmemdescricao.Value := dm.qryView.FieldByName('descricao').Value;
    tbmemqtde.Value := dm.qryView.FieldByName('qtde').Value;
    tbmemvalor_unitario.Value := dm.qryView.FieldByName('valor_unitario').Value;
    tbmemvalor_total.Value := dm.qryView.FieldByName('valor_total').Value;;
    tbmem.Post;
    dm.qryView.next;
  end;
  SomarTotal;
  cbxCliente.Enabled := false;
  lytProdutos.Enabled := false;

end;

procedure TfrmPedido.cbxClienteKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  sql: string;
begin
  if Length(cbxCliente.Text) > 2 then
  begin
    sql := 'select codigo, nome from clientes where nome like ';
    sql := sql + QuotedStr('%' + cbxCliente.Text + '%');
    ViewSQL(sql);
    if dm.qryView.RecNo > 0 then
    begin
      cbxCliente.Items.Clear;
      dm.qryView.first;
      while dm.qryView.eof = false do
      begin
        cbxCliente.Items.AddObject(dm.qryView.FieldByName('nome').AsString,
          TObject(dm.qryView.FieldByName('codigo').AsInteger));
        dm.qryView.next;
      end;
    end
    else
    begin
      cbxCliente.Items.Add('Nada encontrado');
    end;
  end;

end;

procedure TfrmPedido.cbxProdutoKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
var
  sql: string;
  enumero: integer;
begin
  if Length(cbxProduto.Text) > 0 then
  begin
    if Key = vkReturn then
    begin
      if cbxProduto.Text <> dm.qryView.FieldByName('descricao').Value then
      begin
        cbxProduto.ItemIndex := 0;
      end;
      if (integer(cbxProduto.Items.Objects[cbxProduto.ItemIndex])) > 0 then
      begin

        edValorProduto.Text := dm.qryView.FieldByName('preco').AsString;
        edQTDEProduto.SetFocus;
      end;
    end
    else
    begin
      sql := 'select codigo, descricao, preco from produtos where';

      if TryStrToInt(cbxProduto.Text, enumero) = false then
      begin
        sql := sql + ' descricao like ' +
          QuotedStr('%' + cbxProduto.Text + '%');
      end
      else
      begin
        sql := sql + ' codigo like ' + cbxProduto.Text;
      end;

      ViewSQL(sql);
      if dm.qryView.RecNo > 0 then
      begin
        cbxProduto.Items.Clear;
        dm.qryView.first;
        while dm.qryView.eof = false do
        begin
          cbxProduto.Items.AddObject(dm.qryView.FieldByName('descricao')
            .AsString, TObject(dm.qryView.FieldByName('codigo').AsInteger));
          dm.qryView.next;
        end;
      end
      else
      begin
        cbxProduto.Items.Clear;
        cbxProduto.Items.Add('Nada encontrado');
      end;
    end;
  end;

end;

procedure TfrmPedido.edQTDEProdutoKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    edValorProduto.SetFocus;
  end;
end;

procedure TfrmPedido.edValorProdutoKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    MovimentacaoGrid(0);
  end;

end;

procedure TfrmPedido.FormCreate(Sender: TObject);
begin
  tbmem.CreateDataSet;
end;

procedure TfrmPedido.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if (Key = vkReturn) and Grid_Produtos.IsFocused then
  begin
    PreparaEdicao;
  end;

  if (Key = vkDelete) and Grid_Produtos.IsFocused then
  begin
    MovimentacaoGrid(2);
  end;
end;

procedure TfrmPedido.FormShow(Sender: TObject);
begin
  //Define o Separador decimal - OBS: Meu PC ta em en_us
  FormatSettings.DecimalSeparator := '.';
end;

procedure TfrmPedido.mmIExcluirClick(Sender: TObject);
begin
  MovimentacaoGrid(2);
end;

procedure TfrmPedido.MovimentacaoGrid(tipo: integer);
begin
  if tbmem.State in [dsEdit] then
  begin
    tipo := 1;
  end;

  // Adiciona os dados
  if tipo = 0 then
  begin
    tbmem.Append;
    tbmemcodigo.Value := dm.qryView.FieldByName('codigo').Value;
    tbmemdescricao.Value := dm.qryView.FieldByName('descricao').Value;
    tbmemqtde.Value := edQTDEProduto.Text.ToDouble;
    tbmemvalor_unitario.Value := edValorProduto.Text.ToDouble;
    tbmemvalor_total.Value :=
      (edQTDEProduto.Text.ToDouble * edValorProduto.Text.ToDouble);
    tbmem.Post;
    btGravar.Enabled := true;
    btLocalizarPedido.Enabled := false;
  end;
  // Edita os dados
  if tipo = 1 then
  begin
    tbmemcodigo.Value := dm.qryView.FieldByName('codigo').Value;
    tbmemdescricao.Value := dm.qryView.FieldByName('descricao').Value;
    tbmemqtde.Value := edQTDEProduto.Text.ToDouble;
    tbmemvalor_unitario.Value := edValorProduto.Text.ToDouble;
    tbmemvalor_total.Value :=
      (edQTDEProduto.Text.ToDouble * edValorProduto.Text.ToDouble);
    tbmem.Post;
    cbxProduto.Enabled := true;
  end;

  // Deleta os dados
  if tipo = 2 then
  begin
    TDialogService.MessageDialog('Deseja realmente excluir?',
      TMsgDlgType.mtConfirmation, FMX.Dialogs.mbYesNo, TMsgDlgBtn.mbNo, 0,
      procedure(const AResult: TModalResult)
      begin
        case AResult of
          mrYes:
            tbmem.Delete;
        end;
      end);
  end;

  // Limpar os dados
  cbxProduto.ItemIndex := -1;
  cbxProduto.Items.Clear;
  cbxProduto.Text := '';
  edQTDEProduto.Text := '1';
  edValorProduto.Text := '';
  cbxProduto.SetFocus;
  SomarTotal;

end;

procedure TfrmPedido.ppMEditarClick(Sender: TObject);
begin
  PreparaEdicao;
end;

procedure TfrmPedido.PreparaEdicao;
begin
  cbxProduto.Text := tbmemdescricao.Text;
  edQTDEProduto.Text := tbmemqtde.AsString;
  edValorProduto.Text := tbmemvalor_unitario.AsString;
  tbmem.Edit;
  edQTDEProduto.SetFocus;
  cbxProduto.Enabled := false;
end;

procedure TfrmPedido.SomarTotal;
begin
  // Soma o total;
  tbmem.first;
  ResultadoSoma := 0;
  while tbmem.eof = false do
  begin
    ResultadoSoma := ResultadoSoma + tbmemvalor_total.AsCurrency;
    tbmem.next;
  end;
  lbTotal.Text := 'Total: R$ ' + ResultadoSoma.ToString;
end;

procedure TfrmPedido.tmConsultaTimer(Sender: TObject);
begin
  // Garante que os combobox sempre estejam visiveis, retirando o problema de ambientes
  if dm.qryView.RecNo > 0 then
  begin
    if (cbxProduto.ItemIndex < 0) and (cbxProduto.DroppedDown = false) and
      (cbxProduto.IsFocused = true) then
    begin
      cbxProduto.DropDown;
    end;
  end;

  if dm.qryView.RecNo > 0 then
  begin
    if (cbxCliente.ItemIndex < 0) and (cbxCliente.DroppedDown = false) and
      (cbxCliente.IsFocused = true) then
    begin
      cbxCliente.DropDown;
    end;
  end;

end;

end.
