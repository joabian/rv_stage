Imports System.Data
Partial Class sucursales_agreg_suc
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public username As String


    Protected Sub agreg_suc_Click(sender As Object, e As System.EventArgs) Handles agreg_suc.Click
        Dim nombre, tel, direccion, ciudad, estado, pais, gerente, correo, tel2, nextel, trans As String

        If tbx_nombre.Text <> "" Then
            nombre = Replace(tbx_nombre.Text, "'", "").ToString()
        End If
        If tbx_tel.Text <> "" Then
            tel = Replace(tbx_tel.Text, "'", "").ToString()
        End If
        If tbx_dir.Text <> "" Then
            direccion = Replace(tbx_dir.Text, "'", "").ToString()
        End If
        If tbx_ciudad.Text <> "" Then
            ciudad = Replace(tbx_ciudad.Text, "'", "").ToString()
        End If
        If tbx_estado.Text <> "" Then
            estado = Replace(tbx_estado.Text, "'", "").ToString()
        End If
        pais = ddl_pais.SelectedValue.ToString()
        If tbx_gerente.Text <> "" Then
            gerente = Replace(tbx_gerente.Text, "'", "").ToString()
        End If
        If tbx_correo.Text <> "" Then
            correo = Replace(tbx_correo.Text, "'", "").ToString()
        End If
        If tbx_tel2.Text <> "" Then
            tel2 = Replace(tbx_tel2.Text, "'", "").ToString()
        End If
        If tbx_nextel.Text <> "" Then
            nextel = Replace(tbx_nextel.Text, "'", "").ToString()
        End If
        trans = ddl_trans.SelectedValue.ToString()
        username = Membership.GetUser().UserName

        If nombre <> "" Then
            query = "Insert into locations (alias, address, city, state, country, tel, tel_sec, nextel, transit, email) values ('"
            query += nombre + "', '" + direccion + "', '" + ciudad + "', '" + estado + "', '" + pais + "', '" + tel + "', '" + tel2 + "', '" + nextel
            query += "', " + trans + ", '" + correo + "')"
            Dataconnect.runquery(query)

            queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', 'Se agrego una nueva sucursal: " + nombre + "', getDate())"
            Dataconnect.runquery(queryLog)

            Response.Redirect("agreg_suc.aspx")
        Else
            lbl_error.Text = "Necsita al menos especificar el nombre de la sucursal"

        End If
    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        lbl_error.Text = ""
    End Sub
End Class
