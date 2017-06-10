Imports System.Data
Partial Class movimientos_new_order
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public Sendemail As New email_mng

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        ''query = "select * from sale_order order by id desc"
        ''ds = Dataconnect.GetAll(query)
        If Not IsPostBack Then
            Dim user As String
            user = Membership.GetUser().UserName
            query = "select position, location from users where user_name = '" + user + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                Dim pos As String = ds.Tables(0).Rows(0)("position").ToString()
                Dim loc As String = ds.Tables(0).Rows(0)("location").ToString()

                If pos = "admin" Or pos = "inventory" Or pos = "vendedor" Then
                    'populate_ddl_sellers(loc)
                    'populate_ddl_clients()
                    populate_open_orders(loc)
                Else
                    Response.Redirect("../no_access.aspx")
                End If


            Else
                Response.Redirect("../no_access.aspx")
            End If

        End If

    End Sub

    Public Sub populate_open_orders(ByVal location As String)
        Dim location_st As String = ""
        If location <> "0" Then
            location_st = " and sale_order.location = " + location.ToString()
        End If

        query = "select sale_order.id, isnull(convert(varchar, sale_order.id, 100),'0') + ' - ' + isnull(clients.name,'Cliente sin definir') + ' (' + convert(varchar, order_status.status, 101) + ')' as cust from sale_order"
        query += " inner join clients on sale_order.customer = clients.id "
        query += " left join order_status on sale_order.status = order_status.id"
        query += " where sale_order.status in (1,2,3)" + location_st.ToString()
        query += " order by sale_order.id"
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            'do something
            ddl_opn_orders.DataSource = ds.Tables(0)
            ddl_opn_orders.DataValueField = "id"
            ddl_opn_orders.DataTextField = "cust"
            ddl_opn_orders.DataBind()
        Else
            'No data
            ddl_opn_orders.DataSource = Nothing
            ddl_opn_orders.DataBind()
        End If

    End Sub

    'Public Sub populate_ddl_sellers(ByVal location As String)
    '    Dim location_st As String = ""
    '    If location <> "0" Then
    '        location_st = " and location = " + location.ToString()
    '    End If


    '    query = "select id, name + ' ' + last_name as name from employees where position = 'vendedor' and active = 1 "
    '    query += location_st
    '    query += " order by name"
    '    ds = Dataconnect.GetAll(query)
    '    If ds.Tables(0).Rows.Count > 0 Then
    '        ddl_vendor.DataSource = ds.Tables(0)
    '        ddl_vendor.DataTextField = "name"
    '        ddl_vendor.DataValueField = "id"
    '        ddl_vendor.DataBind()

    '    End If
    'End Sub

    'Public Sub populate_ddl_clients()
    '    query = "select id, name as name from clients where active = 1 order by name"
    '    ds = Dataconnect.GetAll(query)
    '    If ds.Tables(0).Rows.Count > 0 Then
    '        ddl_client.DataSource = ds.Tables(0)
    '        ddl_client.DataTextField = "name"
    '        ddl_client.DataValueField = "id"
    '        ddl_client.DataBind()

    '    End If
    'End Sub

    'Protected Sub ddl_client_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddl_client.SelectedIndexChanged
    '    Dim id As String = ddl_client.SelectedValue.ToString()
    'End Sub

    'Protected Sub client_search_Click(sender As Object, e As EventArgs) Handles client_search.Click
    '    Dim clientInfo As String = Request.Form("Cliente")
    '    Dim clients() As String = clientInfo.Split("-")
    '    Dim id As String = Trim(clients(0).ToString())

    '    If id <> "" Then
    '        If clients.Length > 1 Then
    '            Dim cliente As String = Trim(clients(1).ToString())
    '            hifd_clientName.Value = cliente
    '            hifd_client.Value = id
    '            populateCliente(id)
    '        Else
    '            lbl_error_update.Text = "Seleccione una de las opciones sugeridas cuando escribe una palabra"
    '        End If

    '    End If

    'End Sub

    'Public Sub populateCliente(ByVal id As String)
    '    query = "select * from clients where id = " + id.ToString()
    '    ds = Dataconnect.GetAll(query)
    '    If ds.Tables(0).Rows.Count > 0 Then
    '        Dim contacto, tel, email, ship_address, bill_address As String

    '        contacto = ds.Tables(0).Rows(0)("contact_name").ToString()
    '        tel = ds.Tables(0).Rows(0)("telephone").ToString()
    '        email = ds.Tables(0).Rows(0)("email").ToString()
    '        ship_address = ds.Tables(0).Rows(0)("ship_address").ToString()
    '        bill_address = ds.Tables(0).Rows(0)("bill_address").ToString()

    '        tb_contact.Text = contacto
    '        txt_Phones.Text = tel
    '        tb_email.Text = email
    '        txt_Billing_Address.Text = bill_address
    '        txt_Shipping_Address.Text = ship_address
    '        btn_open.Enabled = True

    '    Else
    '        tb_contact.Text = ""
    '        txt_Phones.Text = ""
    '        tb_email.Text = ""
    '        txt_Billing_Address.Text = ""
    '        txt_Shipping_Address.Text = ""
    '        btn_open.Enabled = False
    '    End If
    'End Sub

    Protected Sub btn_open_Click(sender As Object, e As EventArgs) Handles btn_open.Click
        Dim contacto, tel, email, ship_address, bill_address As String

        'If tb_contact.Text = "" Then
        '    contacto = "N/A"
        'Else
        '    contacto = Replace(tb_contact.Text, "'", "").ToUpper()
        'End If

        'If txt_Phones.Text = "" Then
        '    tel = "N/A"
        'Else
        '    tel = Replace(txt_Phones.Text, "'", "").ToUpper()
        'End If

        'If tb_email.Text = "" Then
        '    email = "N/A"
        'Else
        '    email = Replace(tb_email.Text, "'", "").ToUpper()
        'End If

        'If txt_Shipping_Address.Text = "" Then
        '    ship_address = "N/A"
        'Else
        '    ship_address = Replace(txt_Shipping_Address.Text, "'", "").ToUpper()
        'End If

        'If txt_Billing_Address.Text = "" Then
        '    bill_address = "N/A"
        'Else
        '    bill_address = Replace(txt_Billing_Address.Text, "'", "").ToUpper()
        'End If

        'Dim rsd As String = Request.Form("to_date").ToString()
        'If rsd = "" Or Not IsDate(rsd) Then
        '    rsd = "NULL"
        'Else
        '    rsd = "'" + Replace(rsd, "'", "") + "'"
        'End If

        Dim username As String
        Dim logevent As String
        username = Membership.GetUser().UserName
        'Dim location_st As String = ""
        'query = "select location from users where user_name = '" + username + "'"
        'ds = Dataconnect.GetAll(query)
        'If ds.Tables(0).Rows.Count > 0 Then
        '    location_st = ds.Tables(0).Rows(0)("location").ToString()
        'End If



        query = "insert into sale_order (date,status,rsd,vendor,location) values ("
        query += "getdate(), 1, getdate()+1,5,0)"
        Dataconnect.runquery(query)
        Dim insID As String = Dataconnect.Inserted_ID.ToString()

        'logevent = "Nuevo pedido: " + insID.ToString()
        'queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
        'Dataconnect.runquery(queryLog)

        'Dim body As String = bodyHtml(insID, username)
        'Dim distro As String = "joabian.alvarez@radiadoresvencedores.com"

        'Sendemail.sendEmail(distro, "Nuevo Pedido", body)

        Response.Redirect("sales_order.aspx?order=" + insID.ToString())

    End Sub

    Function bodyHtml(ByVal order_id As String, ByVal username As String) As String
        Dim html As String = ""

        html += "<h1>Notificacion</h1><br />"
        html += "<h2>Ha sido creado un nuevo pedido</h2><br />"
        html += "<h2>Numero de Pedido: <b>" + order_id.ToString() + "</b><br />"

        query = "select sale_order.shipping_address, contact_info, convert(varchar, date, 101) as fecha,"
        query += " convert(varchar, rsd, 101) as rsd, clients.name as cliente,"
        query += " employees.name + ' ' + employees.last_name as vendedor"
        query += " from sale_order"
        query += " inner join clients on sale_order.customer = clients.id"
        query += " inner join employees on sale_order.vendor = employees.id"
        query += " where sale_order.id = " + order_id.ToString()
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            Dim cliente, ship_address, contact, fecha, rsd, vendedor As String
            cliente = ds.Tables(0).Rows(0)("cliente").ToString()
            ship_address = ds.Tables(0).Rows(0)("shipping_address").ToString()
            contact = ds.Tables(0).Rows(0)("contact_info").ToString()
            fecha = ds.Tables(0).Rows(0)("fecha").ToString()
            rsd = ds.Tables(0).Rows(0)("rsd").ToString()
            vendedor = ds.Tables(0).Rows(0)("vendedor").ToString()

            html += "<h3><b>Informacion del pedido</b><br />"
            html += "Cliente: <b>" + cliente.ToString() + "</b><br />"
            html += "Contacto: <b>" + contact.ToString() + "</b><br />"
            html += "Vendedor: <b>" + vendedor.ToString() + "</b><br />"
            html += "Direccion de envio: <b>" + ship_address.ToString() + "</b><br />"
            html += "Fecha de apertura: <b>" + fecha.ToString() + "</b><br />"
            html += "Fecha requerido: <b>" + rsd.ToString() + "</b><br /></h3>"
        Else
            html += "<b> No se tiene mas informacion del pedido</b>"
        End If

        Return html
    End Function

    Protected Sub btn_update_order_Click(sender As Object, e As EventArgs) Handles btn_update_order.Click
        Dim order_id As String
        order_id = ddl_opn_orders.SelectedValue
        If order_id = "0" Then
            lbl_error_update.Text = "Seleccione un pedido"
        Else
            Response.Redirect("sales_order.aspx?order=" + order_id.ToString())
        End If
    End Sub



End Class
