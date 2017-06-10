Imports System.Data
Imports System.Data.SqlClient

Partial Class productos_remove_categ
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public username As String
    Protected Sub Remove_Click(sender As Object, e As System.EventArgs) Handles Remove.Click
        Dim category As Integer
        Dim categoryt As Integer
        Dim logevent As String
        username = Membership.GetUser().UserName
        category = categoryDD.SelectedValue


        logevent = "Elimino la categoria: " + categoryDD.SelectedItem.Text.ToString() + " del sistema"

        If trans_prods.Checked Then
            categoryt = trans_categDDL.SelectedValue
            If category.ToString() = categoryt.ToString() Then
                lblerror.Text = "Por favor elija una categoría distinta."
            Else
                query = "update products set category = " + categoryt.ToString() + " where category = " + category.ToString()
                Dataconnect.runquery(query)
                query = "delete from categories where id = " + category.ToString()
                Dataconnect.runquery(query)
                logevent += " transfiriendo los productos a la categoria: " + trans_categDDL.SelectedItem.Text.ToString()
                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + Replace(logevent.ToString(), "'", "''") + "', getDate())"
                Dataconnect.runquery(queryLog)
                Response.Redirect("remove_categ.aspx")
            End If
        Else
            query = "delete from products where category = " + category.ToString()
            Dataconnect.runquery(query)
            query = "delete from categories where id = " + category.ToString()
            Dataconnect.runquery(query)
            logevent += " borrando todos sus productos"
            queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + Replace(logevent.ToString(), "'", "''") + "', getDate())"
            Dataconnect.runquery(queryLog)
            Response.Redirect("remove_categ.aspx")
        End If



    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If trans_prods.Checked Then
            trans_categDDL.Visible = True
        Else
            trans_categDDL.Visible = False
        End If
    End Sub
End Class
