Imports System.Data

Partial Class movimientos_nuevo_cliente
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Protected Sub save_Click(sender As Object, e As EventArgs) Handles btn_save.Click
        save_record()
    End Sub

    Public Sub save_record()
        Dim contact, comp_name, client_type, terms, email, ship_address, bill_addres, phone, same_address, rfc, sucursal As String
        Dim street, paqueteria, serv_paq, flete, precio As String

        contact = Replace(tbx_contact.Text & "'", "'", "").ToString().ToUpper
        comp_name = Replace(tbx_company.Text & "'", "'", "").ToString().ToUpper
        client_type = ddl_tipo_cliente.SelectedValue.ToString()
        terms = ddl_terms.SelectedValue.ToString()
        email = Replace(tbx_email.Text & "'", "'", "").ToString().ToUpper
        phone = Replace(tbx_phone.Text & "'", "'", "").ToString()
        rfc = Replace(tbx_rfc.Text & "'", "'", "").ToString()
        same_address = cbx_same_address.Checked.ToString()
        precio = Replace(tbx_precio.Text & "'", "'", "").ToString()
        paqueteria = Replace(tbx_paqueteria.Text & "'", "'", "").ToString()
        serv_paq = Replace(tbx_serv_paq.Text & "'", "'", "").ToString()
        flete = Replace(tbx_flete.Text & "'", "'", "").ToString()
        street = Replace(tbx_bill_address.Text & "'", "'", "").ToString().ToUpper
        sucursal = location.SelectedValue.ToString()

        If contact = "" Or comp_name = "" Or street = "" Or sucursal = "0" Or precio = "" Or client_type = "0" Then
            lbl_error.Text = "Algún campo obligatorio está vacío"
        ElseIf Not IsNumeric(precio) Then
            lbl_error.Text = "El precio no es numérico"
        Else
            bill_addres = street.ToString()

            If same_address = "True" Then
                ship_address = bill_addres
            Else
                ship_address = Replace(tbx_ship_address.Text & "'", "'", "").ToString().ToUpper
            End If

            query = "insert into clients (name,terms,contact_name,email,ship_address,bill_address,active,telephone, rfc, location, default_price,paqueteria,serv_paq,flete,tipo_cliente) values ("
            query += "'" + comp_name.ToString() + "', '" + terms.ToString() + "', '" + contact.ToString() + "', '" + email
            query += "','" + ship_address.ToString() + "', '" + bill_addres.ToString() + "', 1, '" + phone.ToString() + "', '"
            query += rfc.ToString() + "','" + sucursal.ToString() + "','" + precio.ToString() + "','" + paqueteria + "', '" + serv_paq + "', '" + flete + "', " + client_type + ")"
            Dataconnect.runquery(query)
            cleanFields()
            lbl_error.ForeColor = Drawing.Color.Green
            lbl_error.Text = "Cliente guardado con éxito"
        End If
    End Sub

    Public Sub cleanFields()
        tbx_contact.Text = ""
        tbx_company.Text = ""
        ddl_tipo_cliente.SelectedValue = "0"
        ddl_terms.SelectedIndex = 1
        tbx_email.Text = ""
        tbx_phone.Text = ""
        tbx_rfc.Text = ""
        cbx_same_address.Checked = False
        tbx_precio.Text = ""
        tbx_paqueteria.Text = ""
        tbx_serv_paq.Text = ""
        tbx_flete.Text = ""
        tbx_bill_address.Text = ""
        location.SelectedValue = "0"
        tbx_ship_address.Text = ""
        lbl_error.Text = ""
    End Sub

    Public Sub populate_ddl_locations()
        Dim username As String
        Dim location_st, location_alias As String
        username = Membership.GetUser().UserName
        query = "select location,alias from users left join locations on users.location = locations.id where user_name = '" + username + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            location_st = ds.Tables(0).Rows(0)("location").ToString()
            location_alias = ds.Tables(0).Rows(0)("alias").ToString()
            If location_st = "0" Then
                query = "select id, alias from locations"
            Else
                query = "select id, alias from locations where id = " + location_st.ToString()
            End If
            ds = Dataconnect.GetAll(query)

            If ds.Tables(0).Rows.Count > 0 Then
                location.DataSource = ds.Tables(0)
                location.DataValueField = "id"
                location.DataTextField = "alias"
                location.DataBind()
                If location_st <> "0" Then
                    location.SelectedValue = location_alias
                End If
            Else
                location.DataSource = Nothing
                location.DataBind()
            End If
        End If
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            populate_ddl_locations()
            populate_ddl_tipo_cliente()
            If Request.QueryString("cliente") <> Nothing Then
                Dim cliente As String = Request.QueryString("cliente")
                hifd_cliente.Value = cliente
                populateInfo(cliente)
                btn_save.Visible = False
                btn_update.Visible = True
            Else
                btn_save.Visible = True
                btn_update.Visible = False
            End If
        End If
    End Sub

    Private Sub populate_ddl_tipo_cliente()
        Dim idTipo, tipoCliente As String
        query = "SELECT idTipoCliente, tipoCliente FROM tipos_cliente"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            idTipo = ds.Tables(0).Rows(0)("idTipoCliente").ToString()
            tipoCliente = ds.Tables(0).Rows(0)("tipoCliente").ToString()
            ddl_tipo_cliente.DataSource = ds.Tables(0)
            ddl_tipo_cliente.DataValueField = "idTipoCliente"
            ddl_tipo_cliente.DataTextField = "tipoCliente"
            ddl_tipo_cliente.DataBind()
            If idTipo <> "0" Then
                ddl_tipo_cliente.SelectedValue = tipoCliente
            End If
        Else
            location.DataSource = Nothing
            location.DataBind()
        End If
    End Sub

    Public Sub populateInfo(ByVal cliente As String)
        query = "select * from clients where id = " + cliente.ToString()
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            tbx_company.Text = ds.Tables(0).Rows(0)("name").ToString()
            ddl_tipo_cliente.SelectedValue = ds.Tables(0).Rows(0)("tipo_cliente").ToString()
            ddl_terms.SelectedValue = ds.Tables(0).Rows(0)("terms").ToString()
            tbx_contact.Text = ds.Tables(0).Rows(0)("contact_name").ToString()
            tbx_email.Text = ds.Tables(0).Rows(0)("email").ToString()
            tbx_phone.Text = ds.Tables(0).Rows(0)("telephone").ToString()
            tbx_rfc.Text = ds.Tables(0).Rows(0)("rfc").ToString()
            location.SelectedValue = ds.Tables(0).Rows(0)("location").ToString()
            tbx_precio.Text = ds.Tables(0).Rows(0)("default_price").ToString()
            tbx_paqueteria.Text = ds.Tables(0).Rows(0)("paqueteria").ToString()
            tbx_serv_paq.Text = ds.Tables(0).Rows(0)("serv_paq").ToString()
            tbx_flete.Text = ds.Tables(0).Rows(0)("flete").ToString()
        End If
    End Sub

    Protected Sub btn_update_Click(sender As Object, e As EventArgs) Handles btn_update.Click
        Dim contact, comp_name, client_type, terms, email, ship_address, bill_addres, phone, same_address, rfc, sucursal As String
        Dim street, paqueteria, serv_paq, flete, precio As String

        contact = Replace(tbx_contact.Text & "'", "'", "").ToString().ToUpper
        comp_name = Replace(tbx_company.Text & "'", "'", "").ToString().ToUpper
        client_type = ddl_tipo_cliente.SelectedValue.ToString()
        terms = ddl_terms.SelectedValue.ToString()
        email = Replace(tbx_email.Text & "'", "'", "").ToString().ToUpper
        phone = Replace(tbx_phone.Text & "'", "'", "").ToString()
        rfc = Replace(tbx_rfc.Text & "'", "'", "").ToString()
        same_address = cbx_same_address.Checked.ToString()
        precio = Replace(tbx_precio.Text & "'", "'", "").ToString()
        paqueteria = Replace(tbx_paqueteria.Text & "'", "'", "").ToString()
        serv_paq = Replace(tbx_serv_paq.Text & "'", "'", "").ToString()
        flete = Replace(tbx_flete.Text & "'", "'", "").ToString()

        street = Replace(tbx_bill_address.Text & "'", "'", "").ToString().ToUpper
        sucursal = location.SelectedValue.ToString()

        If contact = "" Or comp_name = "" Or street = "" Or sucursal = "0" Or precio = "" Then
            lbl_error.Text = "Algún campo obligatorio está vacío"
        ElseIf Not IsNumeric(precio) Then
            lbl_error.Text = "El precio no es numérico"
        Else
            bill_addres = street.ToString()

            If same_address = "True" Then
                ship_address = bill_addres
            Else
                ship_address = Replace(tbx_ship_address.Text & "'", "'", "").ToString().ToUpper
            End If

            query = "update clients set name = '" + comp_name.ToString() + "'"
            query += ",terms = '" + terms.ToString() + "'"
            query += ",contact_name = '" + contact.ToString() + "'"
            query += ",email = '" + email.ToString() + "'"
            query += ",ship_address = '" + ship_address.ToString() + "'"
            query += ",bill_address = '" + bill_addres.ToString() + "'"
            query += ",telephone = '" + phone.ToString() + "'"
            query += ", rfc = '" + rfc.ToString() + "'"
            query += ", location = '" + sucursal.ToString() + "'"
            query += ", default_price = '" + precio.ToString() + "'"
            query += ",paqueteria = '" + paqueteria.ToString() + "'"
            query += ",serv_paq = '" + serv_paq.ToString() + "'"
            query += ",flete = '" + flete.ToString() + "'"
            query += ",tipo_cliente = " + client_type.ToString() + ""
            query += " where id = '" + hifd_cliente.Value.ToString() + "'"
            Dataconnect.runquery(query)
            cleanFields()
            lbl_error.ForeColor = Drawing.Color.Green
            lbl_error.Text = "Cliente guardado con éxito"
        End If
    End Sub
End Class
