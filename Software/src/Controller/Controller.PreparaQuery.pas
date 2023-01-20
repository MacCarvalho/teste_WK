unit Controller.PreparaQuery;

interface

procedure ViewSQL(SQL: string);
procedure ExecSQL(SQL: string);

implementation

uses Model.Connection;

procedure ViewSQL(SQL: string);
begin
  dm.qryView.Close;
  dm.qryView.SQL.Clear;
  dm.qryView.SQL.Add(sql);
  dm.qryView.Open;
end;

procedure ExecSQL(SQL: string);
begin
  dm.qryExec.Close;
  dm.qryExec.SQL.Clear;
  dm.qryExec.SQL.Add(sql);
  dm.qryExec.ExecSQL;
end;

end.


