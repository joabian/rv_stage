Imports Microsoft.VisualBasic
Imports System.Data.SqlClient
Imports System.Data

Public Class DataConn_login

    Public Inserted_ID As Integer

    Public Function GetAll(ByVal Query As String) As DataSet
        Dim SQLConn As SqlConnection = New SqlConnection("Data Source=204.93.178.157;Initial Catalog=vencedo2_stage;User Id=vencedo2_stage_user;Password=St4g3@rv")
        'Dim SQLConn As New SqlConnection()
        'SQLConn.ConnectionString = ConfigurationManager.AppSettings("vencedoresConnectionString")

        Dim ds As New DataSet

        Try
            SQLConn.Open()

            Dim cmd As New SqlCommand()

            With cmd
                .Connection = SQLConn
                .CommandText = Query
                .CommandTimeout = 60
                '.ExecuteNonQuery()
                Dim da As New SqlDataAdapter(cmd)
                Try
                    da.Fill(ds)
                    .Dispose()
                    Return ds
                Catch ex As System.Configuration.ConfigurationErrorsException
                    Throw ex
                Catch ex As Exception
                    Throw ex
                End Try
            End With
        Catch ex As SqlException
            Throw ex
        Catch ex As Exception
            Throw ex
        Finally
            SQLConn.Close()
            SQLConn.Dispose()
        End Try
    End Function

    Public Sub runquery(ByVal Query As String)
        Dim SQLConn As SqlConnection = New SqlConnection("Data Source=204.93.178.157;Initial Catalog=vencedo2_stage;User Id=vencedo2_stage_user;Password=St4g3@rv")
        'Dim SQLConn As New SqlConnection()
        'SQLConn.ConnectionString = ConfigurationManager.AppSettings("vencedoresConnectionString")

        Dim ds As New DataSet
        Query += "; SELECT @thisId = SCOPE_IDENTITY();"
        Try
            SQLConn.Open()

            Dim cmd As New SqlCommand()

            cmd.Parameters.Add("@thisId", System.Data.SqlDbType.Int).Direction = ParameterDirection.Output

            With cmd
                .Connection = SQLConn
                .CommandTimeout = 60
                .CommandText = Query
                .ExecuteNonQuery()
                Try
                    Inserted_ID = Convert.ToInt32(.Parameters("@thisId").Value.ToString())
                Catch ex As Exception
                End Try
            End With
        Catch ex As SqlException
            Throw ex
        Catch ex As Exception
            Throw ex
        Finally

            SQLConn.Close()
            SQLConn.Dispose()
        End Try
    End Sub

    Public Function GetAll_asp(ByVal Query As String) As DataSet
        Dim SQLConn As SqlConnection = New SqlConnection("Data Source=204.93.178.157;Initial Catalog=vencedo2_ASPNETDB;User Id=vencedo2_stage_user;Password=St4g3@rv")
        'Dim SQLConn As New SqlConnection()
        'SQLConn.ConnectionString = ConfigurationManager.AppSettings("ApplicationServices")

        Dim ds As New DataSet

        Try
            SQLConn.Open()

            Dim cmd As New SqlCommand()

            With cmd
                .Connection = SQLConn
                .CommandTimeout = 60
                .CommandText = Query
                '.ExecuteNonQuery()
                Dim da As New SqlDataAdapter(cmd)
                Try
                    da.Fill(ds)
                    .Dispose()
                    Return ds
                Catch ex As System.Configuration.ConfigurationErrorsException
                    Throw ex
                Catch ex As Exception
                    Throw ex
                End Try
            End With
        Catch ex As SqlException
            Throw ex
        Catch ex As Exception
            Throw ex
        Finally
            SQLConn.Close()
            SQLConn.Dispose()
        End Try
    End Function

    Public Sub runquery_asp(ByVal Query As String)
        Dim SQLConn As SqlConnection = New SqlConnection("Data Source=204.93.178.157;Initial Catalog=vencedo2_ASPNETDB;User Id=vencedo2_stage_user;Password=St4g3@rv")
        'Dim SQLConn As New SqlConnection()
        'SQLConn.ConnectionString = ConfigurationManager.AppSettings("ApplicationServices")

        Dim ds As New DataSet
        Query += "; SELECT @thisId = SCOPE_IDENTITY();"
        Try
            SQLConn.Open()

            Dim cmd As New SqlCommand()

            cmd.Parameters.Add("@thisId", System.Data.SqlDbType.Int).Direction = ParameterDirection.Output

            With cmd
                .Connection = SQLConn
                .CommandTimeout = 60
                .CommandText = Query
                .ExecuteNonQuery()
                Try
                    Inserted_ID = Convert.ToInt32(.Parameters("@thisId").Value.ToString())
                Catch ex As Exception
                End Try
            End With
        Catch ex As SqlException
            Throw ex
        Catch ex As Exception
            Throw ex
        Finally

            SQLConn.Close()
            SQLConn.Dispose()
        End Try
    End Sub
End Class
