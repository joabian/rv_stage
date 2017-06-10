Imports System.Data

Partial Class usuarios_agreg_user
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            populateLocations()
        End If


    End Sub

    Public Sub populateLocations()
        query = "select id, alias from locations where transit = 0 and id <> 18"
        ds = Dataconnect.GetAll(query)
        ddl_locations.DataSource = ds.Tables(0)
        ddl_locations.DataValueField = "id"
        ddl_locations.DataTextField = "alias"
        ddl_locations.DataBind()
    End Sub


    Protected Sub btn_save_Click(sender As Object, e As EventArgs) Handles btn_save.Click
        saveUser()
    End Sub

    Public Sub saveUser()
        Dim msg As String = confirmData()
        If msg <> "" Then
            lbl_error.Text = msg
        Else
            lbl_error.Text = ""

            Dim newUser As MembershipUser = Membership.CreateUser(Replace(tbx_userName.Text & "'", "'", ""), Replace(tbx_password1.Text & "'", "'", ""), Replace(tbx_email.Text & "'", "'", ""))

            Dim position As String = "na"

            If chbx_emp.Checked = True Then
                Roles.AddUserToRole(Replace(tbx_userName.Text & "'", "'", ""), "employee")
                position = "na"
            End If

            If chbx_inven.Checked = True Then
                Roles.AddUserToRole(Replace(tbx_userName.Text & "'", "'", ""), "inventory")
                position = "inventory"
            End If

            If chbx_admin.Checked = True Then
                Roles.AddUserToRole(Replace(tbx_userName.Text & "'", "'", ""), "admin")
                position = "admin"
            End If

            query = "insert into users (name,f_lastname,s_lastname,access_level,active,user_name,password,position,location,precios) values ("
            query += " '" + Replace(tbx_name.Text, "'", "") + "'"
            query += ", '" + Replace(tbx_flastname.Text, "'", "") + "'"
            query += ", '" + Replace(tbx_slastname.Text & "'", "'", "") + "'"
            query += ", '2', 1, '" + Replace(tbx_userName.Text, "'", "") + "'"
            query += ", '" + Replace(tbx_password1.Text, "'", "") + "'"
            query += ", '" + position.ToString() + "'"
            query += ", '" + ddl_locations.SelectedValue.ToString() + "'"
            query += ", ',PRECIO_JUAREZ,PRECIO_2_JUAREZ,PRECIO_3_JUAREZ,PRECIO_MAYOREO_JUAREZ,PRECIO_INSTALADO_JUAREZ,PRECIO_DLLS_JUAREZ'"
            query += ")"
            Dataconnect.runquery(query)

            clearControls()

            lbl_error.ForeColor = Drawing.Color.Green
            lbl_error.Text = "Usuario Salvado"

        End If
    End Sub

    Public Sub clearControls()
        tbx_email.Text = ""
        tbx_flastname.Text = ""
        tbx_name.Text = ""
        tbx_password1.Text = ""
        tbx_password2.Text = ""
        tbx_slastname.Text = ""
        tbx_userName.Text = ""
        chbx_admin.Checked = False
        chbx_emp.Checked = False
        chbx_inven.Checked = False
        ddl_locations.SelectedValue = "-"
        lbl_error.Text = ""
    End Sub

    Public Function confirmData() As String
        Dim msg As String = ""

        If tbx_userName.Text = "" Then
            msg = "Ingrese el nombre del usuario"
        End If

        If tbx_password1.Text = "" Or tbx_password2.Text = "" Then
            msg = "Ingrese la contraseña"
        End If

        If tbx_password1.Text <> tbx_password2.Text Then
            msg = "Las contraseñas no concuerdan"
        End If

        If tbx_email.Text = "" Then
            msg = "Ingrese un correo electronico"
        End If

        If chbx_admin.Checked = False And chbx_emp.Checked = False And chbx_inven.Checked = False Then
            msg = "Seleccione al menos un tipo de acceso"
        End If

        If ddl_locations.SelectedValue = "-" Then
            msg = "Seleccione sucursal"
        End If

        Return msg
    End Function


End Class
