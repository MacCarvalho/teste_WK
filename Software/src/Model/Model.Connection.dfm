object dm: Tdm
  Height = 247
  Width = 548
  object Connection: TFDConnection
    Params.Strings = (
      'Database=wk'
      'User_Name=root'
      'Password=Kdz102030'
      'Server=localhost'
      'DriverID=mySQL')
    LoginPrompt = False
    BeforeConnect = ConnectionBeforeConnect
    Left = 96
    Top = 56
  end
  object mysqlDrive: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Users\mateu\Desktop\Wk\db\libmysql_32.dll'
    Left = 344
    Top = 48
  end
  object qryView: TFDQuery
    Connection = Connection
    Left = 112
    Top = 144
  end
  object qryExec: TFDQuery
    Connection = Connection
    Left = 232
    Top = 144
  end
end
