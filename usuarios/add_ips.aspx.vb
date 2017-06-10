Imports System.Data

Partial Class usuarios_add_ips
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Protected Sub Button1_Click(sender As Object, e As System.EventArgs) Handles Button1.Click
        Dim ip As String
        Dim username As String
        Dim logevent As String

        username = Membership.GetUser().UserName
        ip = Replace(TB_ip.Text, "'", "''")

        logevent = "Se ha dado de alta una nueva IP: " + ip.ToString() + " con acceso al sistema"

        query = "select * from ips where ip_num = '" + ip.ToString() + "' and active = 1"
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            Lblerror.Text = "este IP ya existe en el sistema, si no tiene acceso, por favor comuniquese con el administrador"
        Else
            query = "insert into ips (ip_num, active) values ('" + ip.ToString() + "', 1)"
            Dataconnect.runquery(query)
            queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
            Dataconnect.runquery(queryLog)

            Response.Redirect("add_ips.aspx")

        End If

    End Sub
End Class
