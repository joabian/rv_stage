
Partial Class usuarios_elim_user
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim DataTable As MembershipUserCollection = Membership.GetAllUsers()
            lista_usuarios.DataSource = DataTable
            'lista_usuarios.DataBind()

            Dim Row As MembershipUser
            For Each Row In DataTable
                If Row.UserName.ToString() <> "admin" Then
                    lista_usuarios.Items.Add(Row.UserName.ToString())
                End If

            Next
        End If
    End Sub

    Protected Sub Button1_Click(sender As Object, e As System.EventArgs) Handles Button1.Click
        Dim user_name = lista_usuarios.SelectedValue.ToString()
        Membership.DeleteUser(user_name)
        Response.Redirect("elim_user.aspx")
    End Sub
End Class
