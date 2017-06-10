Imports System.Data

Partial Class usuarios_edit_user
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim DataTable As MembershipUserCollection = Membership.GetAllUsers()
            ddl_users.DataSource = DataTable
            'lista_usuarios.DataBind()

            Dim Row As MembershipUser
            For Each Row In DataTable
                If Row.UserName.ToString() <> "admin" Then
                    ddl_users.Items.Add(Row.UserName.ToString())
                End If
            Next

            Dim rolesArray() As String

            rolesArray = Roles.GetAllRoles()
            ddl_roles.DataSource = rolesArray
            ddl_roles.DataBind()

            query = "select id, alias from locations where transit = 0 and id <> 18"
            ds = Dataconnect.GetAll(query)
            ddl_locations.DataSource = ds.Tables(0)
            ddl_locations.DataValueField = "id"
            ddl_locations.DataTextField = "alias"
            ddl_locations.DataBind()

        End If
    End Sub

    Protected Sub btn_unlock_user_Click(sender As Object, e As EventArgs) Handles btn_unlock_user.Click
        Dim username As String
        username = ddl_users.SelectedValue.ToString()

        If username <> "0" Then

            Dim locked_user As MembershipUser = Membership.GetUser(username)
            locked_user.UnlockUser()
            Membership.UpdateUser(locked_user)
            lbl_error.Text = ""
        Else
            lbl_error.Text = "Seleccione un usuario"
        End If

        show_info(username)

    End Sub


    Protected Sub btn_change_pass_Click(sender As Object, e As EventArgs) Handles btn_change_pass.Click
        Dim username As String
        username = ddl_users.SelectedValue.ToString()

        If username <> "0" Then
            Dim pass, pass_conf As String
            pass = txb_pass.Text
            pass_conf = txb_pass_conf.Text

            If pass = "" Or pass_conf = "" Or pass <> pass_conf Then
                lbl_error.Text = "Verifique la contraseña"
            Else
                Dim user As MembershipUser = Membership.GetUser(username)
                user.ChangePassword(user.ResetPassword(), pass)
                query = "update users set password = '" + pass.ToString() + "' where user_name = '" + username.ToString() + "'"
                Dataconnect.runquery(query)
                lbl_error.Text = ""
            End If
        Else
            lbl_error.Text = "Seleccione un usuario"
        End If

        show_info(username)

    End Sub

    Protected Sub ddl_users_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddl_users.SelectedIndexChanged
        Dim username As String
        username = ddl_users.SelectedValue.ToString()
        show_info(username)
    End Sub

    Public Sub show_info(ByVal username As String)
        If username <> "0" Then
            Dim user As MembershipUser = Membership.GetUser(username)

            If user.IsLockedOut Then
                lbl_userStatus.ForeColor = Drawing.Color.Red
                lbl_userStatus.Text = "Bloqueado"
                btn_unlock_user.Enabled = True
            Else
                lbl_userStatus.ForeColor = Drawing.Color.Green
                lbl_userStatus.Text = "Activo"
                btn_unlock_user.Enabled = False
            End If


            Dim rolesUser() As String
            rolesUser = Roles.GetRolesForUser(username)
            Dim roles_str As String = ""
            For i = 0 To rolesUser.Length - 1
                Dim role_name As String
                role_name = rolesUser(i).ToString()
                roles_str += role_name + ", "
            Next
            If roles_str.Length > 2 Then
                lbl_roles.Text = roles_str.Substring(0, roles_str.Length - 2)
            Else
                lbl_roles.Text = ""
            End If

            query = "select location from users where user_name = '" + user.ToString() + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                ddl_locations.SelectedValue = ds.Tables(0).Rows(0)("location")
            Else
                ddl_locations.SelectedValue = "na"
            End If

        Else
            lbl_error.Text = "Seleccione un usuario"
            lbl_userStatus.Text = ""
        End If

    End Sub

    Protected Sub btn_add_role_Click(sender As Object, e As EventArgs) Handles btn_add_role.Click

        Dim username, role As String
        username = ddl_users.SelectedValue.ToString()
        role = ddl_roles.SelectedValue.ToString()
        If username <> "0" And role <> "0" Then
            Dim user As MembershipUser = Membership.GetUser(username)
            If Roles.IsUserInRole(username, role) Then
                lbl_error.Text = "Este acceso ya ha sido asignado"
            Else
                Roles.AddUserToRole(username, role)
                lbl_error.Text = ""
            End If

        Else
            lbl_error.Text = "Seleccione un usuario y acceso valido"

        End If

        show_info(username)

    End Sub


    Protected Sub btn_del_role_Click(sender As Object, e As EventArgs) Handles btn_del_role.Click
        Dim username, role As String
        username = ddl_users.SelectedValue.ToString()
        role = ddl_roles.SelectedValue.ToString()
        If username <> "0" And role <> "0" Then
            Dim user As MembershipUser = Membership.GetUser(username)
            If Roles.IsUserInRole(username, role) Then
                Roles.RemoveUserFromRole(username, role)
                lbl_error.Text = ""
            Else
                lbl_error.Text = "Este acceso ya ha sido removido"
            End If

        Else
            lbl_error.Text = "Seleccione un usuario y acceso valido"

        End If

        show_info(username)
    End Sub

    Protected Sub btn_change_location_Click(sender As Object, e As EventArgs) Handles btn_change_location.Click
        Dim username, location As String
        username = ddl_users.SelectedValue.ToString()
        location = ddl_locations.SelectedValue.ToString()
        If username <> "0" And location <> "na" Then
            query = "update users set location = " + ddl_locations.SelectedValue.ToString() + "where user_name = '" + username + "'"
            Dataconnect.runquery(query)

        Else
            lbl_error.Text = "Seleccione un usuario y sucursal validos"

        End If

        show_info(username)
    End Sub
End Class
