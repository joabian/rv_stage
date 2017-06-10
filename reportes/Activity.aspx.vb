Imports System.Data
Partial Class reportes_Activity
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        query = "select user_name as [Usuario], event as [Evento], date as [Fecha] from logs where date >= (getdate() - 15) order by date desc"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            GridView1.DataSource = ds.Tables(0)
            GridView1.DataBind()
        Else
            GridView1.DataSource = Nothing
            GridView1.DataBind()
        End If
    End Sub
End Class
