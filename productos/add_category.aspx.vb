Imports System.Data
Partial Class productos_add_category
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Protected Sub save_Click(sender As Object, e As System.EventArgs) Handles save.Click
        query = "select * from categories where name = '" + Replace(category.Text, "'", "''") + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count = 0 Then

            If category.Text <> "" Then
                query = "INSERT INTO categories (name) VALUES ('" + Replace(category.Text, "'", "''") + "')"
                Dataconnect.runquery(query)
                Response.Redirect("add_category.aspx")
            Else
                errorlbl.Text = "Porfavor Indique el nombre de la nueva categoria"
            End If
        Else
            errorlbl.Text = "La categoria ya existe"
        End If

    End Sub

End Class
