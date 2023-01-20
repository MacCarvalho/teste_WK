program WK;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.Main in 'src\View\View.Main.pas' {frmMain},
  Model.Connection in 'src\Model\Model.Connection.pas' {dm: TDataModule},
  View.Cliente_Produto in 'src\View\View.Cliente_Produto.pas' {frmCadClienteProduto},
  View.Pedido in 'src\View\View.Pedido.pas' {frmPedido},
  Controller.PreparaQuery in 'src\Controller\Controller.PreparaQuery.pas',
  View.ProcuraPedido in 'src\View\View.ProcuraPedido.pas' {frmProcuraPedido};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
