Imports System.Data
Imports System.Text
Imports System.Drawing
Imports System.IO
Imports Excel

Partial Class movimientos_sales_order
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public email As New email_mng

    Public username As String = Membership.GetUser().UserName

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        ''query = "select * from sale_order order by id desc"
        ''ds = Dataconnect.GetAll(query)
        If Not IsPostBack Then
            'populate_ddl_locations()
            query = "select position from users where user_name = '" + username + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                Dim pos As String = ds.Tables(0).Rows(0)("position").ToString()

                If pos = "admin" Or pos = "inventory" Or pos = "vendedor" Then
                    If Request.QueryString("order") <> "" Then
                        hf_order_number.Value = Request.QueryString("order")
                    End If

                    populate_order_info()
                    'populate_ddl_vendor()
                    'populate_ddl_status()
                    'populate_ddl_location()
                    'populateItemsGridView()
                    'enableControlState()
                Else
                    Response.Redirect("../no_access.aspx")
                End If


            Else
                Response.Redirect("../no_access.aspx")
            End If

        End If
    End Sub

    'Public Sub populate_ddl_location()
    '    Dim username As String
    '    Dim location_st, location_alias As String
    '    username = Membership.GetUser().UserName
    '    query = "select location,alias from users left join locations on users.location = locations.id where user_name = '" + username + "'"
    '    ds = Dataconnect.GetAll(query)
    '    If ds.Tables(0).Rows.Count > 0 Then
    '        location_st = ds.Tables(0).Rows(0)("location").ToString()
    '        location_alias = ds.Tables(0).Rows(0)("alias").ToString()
    '        If location_st = "0" Then
    '            query = "select id, alias from locations"
    '        Else
    '            query = "select id, alias from locations where id = " + location_st.ToString()
    '        End If
    '        ds = Dataconnect.GetAll(query)

    '        If ds.Tables(0).Rows.Count > 0 Then
    '            ddl_location.DataSource = ds.Tables(0)
    '            ddl_location.DataValueField = "id"
    '            ddl_location.DataTextField = "alias"
    '            ddl_location.DataBind()
    '            If location_st <> "0" Then
    '                ddl_location.SelectedValue = location_st
    '            End If
    '        Else
    '            ddl_location.DataSource = Nothing
    '            ddl_location.DataBind()
    '        End If
    '    End If
    'End Sub

    'Sub populateItemsGridView()
    '    query = "select sale_order_items.id, product_code as [Codigo], description as [Descripcion], qty as [Cantidad],"
    '    query += " sold_price as [Precio Unitario], (qty * sold_price) as [Total]"
    '    query += " from sale_order_items inner join products on products.code = sale_order_items."
    '    query += "product_code where order_id = " + hf_order_number.Value.ToString() + " and active = 1"

    '    ds = Dataconnect.GetAll(query)
    '    If ds.Tables(0).Rows.Count > 0 Then
    '        gv_Items.DataSource = ds.Tables(0)
    '        gv_Items.DataBind()
    '    Else
    '        gv_Items.DataSource = Nothing
    '        gv_Items.DataBind()
    '    End If
    'End Sub

    'Sub populate_ddl_vendor()
    '    Dim username As String
    '    Dim location_st, location_alias As String
    '    username = Membership.GetUser().UserName
    '    query = "select location from users where user_name = '" + username + "'"
    '    ds = Dataconnect.GetAll(query)
    '    If ds.Tables(0).Rows.Count > 0 Then
    '        location_st = ds.Tables(0).Rows(0)("location").ToString()
    '        If location_st <> "0" Then
    '            location_alias = " and location = " + location_st.ToString()
    '        Else
    '            location_alias = ""
    '        End If

    '        query = "select id, name + ' ' + last_name as name from employees where position = 'vendedor' and active = 1 "
    '        query += location_alias
    '        query += " order by name"
    '        ds = Dataconnect.GetAll(query)
    '        If ds.Tables(0).Rows.Count > 0 Then
    '            ddl_vendor.DataSource = ds.Tables(0)
    '            ddl_vendor.DataTextField = "name"
    '            ddl_vendor.DataValueField = "id"
    '            ddl_vendor.DataBind()
    '        Else
    '            ddl_vendor.DataSource = Nothing
    '            ddl_vendor.DataBind()
    '        End If
    '    Else
    '        ddl_vendor.DataSource = Nothing
    '        ddl_vendor.DataBind()
    '    End If

    'End Sub

    Sub populate_order_info()
        query = "select clients.name, sale_order.vendor as empleado, sale_order.id, sale_order.bill_address, sale_order.contact_info,"
        query += " convert(varchar, sale_order.date, 101) as fecha, sale_order.notes, order_status.status, isnull(sale_order.tax, 16) as tax, sale_order.location,"
        query += " sale_order.shipping_address, sale_order.terms, sale_order.currency, sale_order.exchange_rate, convert(varchar, sale_order.rsd, 101) as rsd,"
        query += " sale_order.tel, sale_order.email, clients.default_price, locations.alias, sale_order.guia"
        query += " from sale_order left join clients on sale_order.customer = clients.id"
        query += " left join order_status on sale_order.status = order_status.id"
        query += " left join locations on sale_order.location = locations.id"
        query += " where sale_order.id = " + hf_order_number.Value.ToString()
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then

            lbl_Client.Text = ds.Tables(0).Rows(0)("name").ToString()
            'ddl_terms.SelectedValue = ds.Tables(0).Rows(0)("terms").ToString()
            lbl_order_number.Text = hf_order_number.Value.ToString()
            'txt_contact.Text = ds.Tables(0).Rows(0)("contact_info").ToString()
            'ddl_vendor.SelectedValue = ds.Tables(0).Rows(0)("empleado").ToString()
            'lbl_date.Text = ds.Tables(0).Rows(0)("fecha").ToString()
            'txt_Phones.Text = ds.Tables(0).Rows(0)("tel").ToString()
            Dim mystatus As String = ds.Tables(0).Rows(0)("status").ToString()
            If mystatus = "Cancelada" Then
                lbl_status.ForeColor = Color.Red
                btn_surtir.Visible = False
                btn_ship.Visible = False
                btn_deliver.Visible = False
                btn_cancel.Visible = False
            ElseIf mystatus = "Entregada" Then
                lbl_status.ForeColor = Color.Green
                btn_surtir.Visible = False
                btn_ship.Visible = False
                btn_deliver.Visible = False
                btn_cancel.Visible = False
            ElseIf mystatus = "Enviada" Then
                lbl_status.ForeColor = Color.Blue
                btn_surtir.Visible = True
                btn_ship.Visible = False
                btn_deliver.Visible = True
                btn_cancel.Visible = False
            ElseIf mystatus = "Surtido Completo" Then
                lbl_status.ForeColor = Color.Blue
                btn_surtir.Visible = True
                btn_ship.Visible = True
                btn_deliver.Visible = False

            ElseIf mystatus = "Surtiendo" Then
                lbl_status.ForeColor = Color.Blue
                btn_surtir.Visible = True
                btn_ship.Visible = False
                btn_deliver.Visible = False

            ElseIf mystatus = "Lista para Surtir" Then
                lbl_status.ForeColor = Color.Blue
                btn_surtir.Visible = False
                btn_ship.Visible = False
                btn_deliver.Visible = False

            ElseIf mystatus = "En Captura" Then
                lbl_status.ForeColor = Color.Blue
                btn_surtir.Visible = True
                btn_ship.Visible = False
                btn_deliver.Visible = False

            Else
                lbl_status.ForeColor = Color.Blue
                btn_surtir.Visible = False
                btn_ship.Visible = False
                btn_deliver.Visible = False

            End If
            lbl_status.Text = mystatus.ToString()
            txt_Billing_Address.Text = ds.Tables(0).Rows(0)("bill_address").ToString()
            txt_Shipping_Address.Text = ds.Tables(0).Rows(0)("shipping_address").ToString()
            txt_ReqShipDate.Text = ds.Tables(0).Rows(0)("rsd").ToString()
            txt_notes.Text = ds.Tables(0).Rows(0)("notes").ToString()
            'txt_Tax.Text = ds.Tables(0).Rows(0)("tax").ToString()
            txt_email.Text = ds.Tables(0).Rows(0)("email").ToString()
            'tbx_precio.Text = ds.Tables(0).Rows(0)("default_price").ToString()
            'lbl_location.Text = ds.Tables(0).Rows(0)("alias").ToString()
            tbx_guia.Text = ds.Tables(0).Rows(0)("guia").ToString()
            'ddl_location.SelectedValue = ds.Tables(0).Rows(0)("location").ToString()
            '+ (sum(sold_price * qty) * (cast(max(tax) as float)/cast(100 as float))) 
            query = "select sum(sold_price * qty) as subtotal, sum((sold_price * qty) * (1 + (cast(isnull(sale_order.tax, 0) as float) / 100 ))) as total"
            query += " from sale_order_items"
            query += " inner join sale_order on sale_order.id = sale_order_items.order_id"
            query += " where order_id = " + hf_order_number.Value.ToString() + " and sale_order_items.active = 1"

            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                'lbl_subtotal.Text = ds.Tables(0).Rows(0)("subtotal").ToString()
                'lbl_total.Text = ds.Tables(0).Rows(0)("total").ToString()
            Else
                'lbl_subtotal.Text = "0.00"
                'lbl_total.Text = "0.00"
            End If

        Else
            lbl_Client.Text = ""
            'ddl_terms.SelectedValue = "EFECTIVO"
            lbl_order_number.Text = ""
            txt_contact.Text = ""
            'ddl_vendor.SelectedValue = "0"
            lbl_date.Text = ""
            txt_Phones.Text = ""
            lbl_status.Text = ""
            txt_Billing_Address.Text = ""
            txt_Shipping_Address.Text = ""
            txt_ReqShipDate.Text = ""
            'lbl_subtotal.Text = "0"
            txt_notes.Text = ""
            'txt_Tax.Text = "0"
            'lbl_total.Text = "0"
            txt_email.Text = ""
            'tbx_precio.Text = ""
            'lbl_location.Text = ""
            tbx_guia.Text = ""
        End If

    End Sub

    Protected Sub btn_save_Click(sender As Object, e As EventArgs) Handles btn_save.Click
        update_order()
    End Sub

    Public Sub update_order()
        query = "select clients.name, sale_order.vendor as empleado, sale_order.id, sale_order.bill_address, sale_order.contact_info,"
        query += " convert(varchar, sale_order.date, 101) as fecha, sale_order.notes, sale_order.status, sale_order.subtotal, isnull(sale_order.tax, 16) as tax, sale_order.total, sale_order.location,"
        query += " sale_order.shipping_address, sale_order.terms, sale_order.currency, sale_order.exchange_rate, convert(varchar, sale_order.rsd, 101) as rsd,"
        query += " sale_order.tel, sale_order.email, employees.name + ' ' + employees.last_name as vendor_name, order_status.status as status_name"
        query += " from sale_order inner join clients on sale_order.customer = clients.id"
        query += " inner join employees on sale_order.vendor = employees.id"
        query += " inner join order_status on sale_order.status = order_status.id"
        query += " where sale_order.id = " + hf_order_number.Value.ToString()
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim orig_status, orig_rsd, orig_vendor, orig_notes, orig_contact, orig_tel, orig_billing_add, orig_ship_add As String
            Dim orig_terms, orig_tax, orig_email, orig_location As String
            Dim new_rsd, new_vendor, new_notes, new_contact, new_tel, new_billing_add, new_ship_add As String
            Dim new_email, new_location As String
            'Dim new_terms, new_tax As String
            Dim orig_vendor_name, new_vendor_name, orig_status_name As String

            'new_vendor = ddl_vendor.SelectedValue
            'new_vendor_name = ddl_vendor.SelectedItem.Text.ToString()
            'new_terms = ddl_terms.SelectedValue
            new_rsd = Replace(txt_ReqShipDate.Text & "'", "'", "")
            new_notes = Replace(txt_notes.Text & "'", "'", "")
            new_contact = Replace(txt_contact.Text & "'", "'", "")
            new_tel = Replace(txt_Phones.Text & "'", "'", "")
            new_billing_add = Replace(txt_Billing_Address.Text & "'", "'", "")
            new_ship_add = Replace(txt_Shipping_Address.Text & "'", "'", "")
            'new_tax = Replace(txt_Tax.Text & "'", "'", "")
            new_email = Replace(txt_email.Text & "'", "'", "")
            'new_location = ddl_location.SelectedValue

            orig_status = ds.Tables(0).Rows(0)("status").ToString()
            orig_rsd = ds.Tables(0).Rows(0)("rsd").ToString()
            orig_vendor = ds.Tables(0).Rows(0)("empleado").ToString()
            orig_vendor_name = ds.Tables(0).Rows(0)("vendor_name").ToString()
            orig_notes = ds.Tables(0).Rows(0)("notes").ToString()
            orig_contact = ds.Tables(0).Rows(0)("contact_info").ToString()
            orig_tel = ds.Tables(0).Rows(0)("tel").ToString()
            orig_billing_add = ds.Tables(0).Rows(0)("bill_address").ToString()
            orig_ship_add = ds.Tables(0).Rows(0)("shipping_address").ToString()
            orig_terms = ds.Tables(0).Rows(0)("terms").ToString()
            orig_tax = ds.Tables(0).Rows(0)("tax").ToString()
            orig_email = ds.Tables(0).Rows(0)("email").ToString()
            orig_status_name = ds.Tables(0).Rows(0)("status_name").ToString()
            orig_location = ds.Tables(0).Rows(0)("location").ToString()


            Dim username As String
            Dim logevent As String
            username = Membership.GetUser().UserName

            If new_email <> orig_email Then
                query = "update sale_order set email = '" + new_email.ToString() + "' where id = " + hf_order_number.Value.ToString()
                Dataconnect.runquery(query)

                logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " email original: " + orig_email.ToString() + " email nuevo: " + new_email.ToString()
                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)

            End If
            'If new_terms <> orig_terms Then
            '    query = "update sale_order set terms = '" + new_terms.ToString() + "' where id = " + hf_order_number.Value.ToString()
            '    Dataconnect.runquery(query)

            '    logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " terminos originales: " + orig_terms.ToString() + " terminos nuevos: " + new_terms.ToString()
            '    queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
            '    Dataconnect.runquery(queryLog)


            'End If
            'If new_tax <> orig_tax Then
            '    If new_tax = "" Then new_tax = "0"
            '    query = "update sale_order set tax = '" + new_tax.ToString() + "' where id = " + hf_order_number.Value.ToString()
            '    Dataconnect.runquery(query)

            '    logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " iva original: " + orig_tax.ToString() + " iva nuevo: " + new_tax.ToString()
            '    queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
            '    Dataconnect.runquery(queryLog)

            'End If
            'If new_status <> orig_status Then
            '    Dim enviada As String = ""
            '    If new_status = "4" Then
            '        enviada = ", ship_date = getdate()"
            '    End If
            '    query = "update sale_order set status = '" + new_status.ToString() + "' " + enviada.ToString() + " where id = " + hf_order_number.Value.ToString()
            '    Dataconnect.runquery(query)

            '    logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " status original: " + orig_status_name.ToString() + " status nuevo: " + new_status_name.ToString()
            '    queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
            '    Dataconnect.runquery(queryLog)

            '    'enableControlState()


            '    If new_status = "5" Or new_status = "4" Or new_status = "6" Then
            '        email.sendEmail("joabian.alvarez@radiadoresvencedores.com,samuel.gonzalez@radiadoresvencedores.com", "Actualizacion del pedido: " + hf_order_number.Value.ToString(), bodyHtml(new_status, username.ToString()))
            '    End If

            'End If
            If new_rsd <> orig_rsd Then
                query = "update sale_order set rsd = '" + new_rsd.ToString() + "' where id = " + hf_order_number.Value.ToString()
                Dataconnect.runquery(query)

                logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " fecha requerida original: " + orig_rsd.ToString() + " fecha requerida nueva: " + new_rsd.ToString()
                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)

            End If
            If new_vendor <> orig_vendor Then
                query = "update sale_order set vendor = '" + new_vendor.ToString() + "' where id = " + hf_order_number.Value.ToString()
                Dataconnect.runquery(query)

                logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " vendedor original: " + orig_vendor_name.ToString() + " vendedor nuevo: " + new_vendor_name.ToString()
                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)

            End If
            If new_notes <> orig_notes Then
                query = "update sale_order set notes = '" + new_notes.ToString() + "' where id = " + hf_order_number.Value.ToString()
                Dataconnect.runquery(query)

                logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " notas originales: " + orig_notes.ToString() + " notas nuevas: " + new_notes.ToString()
                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)

            End If
            If new_contact <> orig_contact Then
                query = "update sale_order set contact_info = '" + new_contact.ToString() + "' where id = " + hf_order_number.Value.ToString()
                Dataconnect.runquery(query)

                logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " contacto original: " + orig_contact.ToString() + " contacto nuevo: " + new_contact.ToString()
                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)

            End If
            If new_tel <> orig_tel Then
                query = "update sale_order set tel = '" + new_tel.ToString() + "' where id = " + hf_order_number.Value.ToString()
                Dataconnect.runquery(query)

                logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " telefono original: " + orig_tel.ToString() + " telefono nuevo: " + new_tel.ToString()
                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)

            End If
            If new_billing_add <> orig_billing_add Then
                query = "update sale_order set bill_address = '" + new_billing_add.ToString() + "' where id = " + hf_order_number.Value.ToString()
                Dataconnect.runquery(query)

                logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " direccion original: " + orig_billing_add.ToString() + " direccion nueva: " + new_billing_add.ToString()
                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)

            End If
            If new_ship_add <> orig_ship_add Then
                query = "update sale_order set shipping_address = '" + new_ship_add.ToString() + "' where id = " + hf_order_number.Value.ToString()
                Dataconnect.runquery(query)

                logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " direccion de envio original: " + orig_ship_add.ToString() + " direccion de envio nueva: " + new_ship_add.ToString()
                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)

            End If

            If new_location <> orig_location Then
                query = "update sale_order set location = '" + new_location.ToString() + "' where id = " + hf_order_number.Value.ToString()
                Dataconnect.runquery(query)

                logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " locacion original: " + orig_location.ToString() + " locacion nueva: " + new_location.ToString()
                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)

            End If
            lbl_msg.Text = "Cambios guardados con exito"

        End If

        populate_order_info()

    End Sub

    Function bodyHtml(ByVal status As String, ByVal username As String) As String
        Dim html As String = ""
        Dim status_name As String

        query = "select status from order_status where id = " + status.ToString()
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            status_name = ds.Tables(0).Rows(0)("status").ToString()
        Else
            status_name = "Desconocido"
        End If

        html += "<h1>Notificacion</h1><br />"
        html += "<h2>Cambio de estatus de un pedido</h2><br />"
        html += "<h2>Numero de Pedido: <b>" + hf_order_number.Value.ToString() + "</b><br />"
        html += "Nuevo status: <b>" + status_name.ToString() + "</b><br /></h2>"

        query = "select sale_order.shipping_address, contact_info, convert(varchar, date, 101) as fecha, convert(varchar, rsd, 101) as rsd,"
        query += " case when ship_date is null then 'N/A' else convert(varchar, ship_date, 101) end as shipped, clients.name as cliente,"
        query += " employees.name + ' ' + employees.last_name as vendedor"
        query += " from sale_order"
        query += " inner join clients on sale_order.customer = clients.id"
        query += " inner join employees on sale_order.vendor = employees.id"
        query += " where sale_order.id = " + hf_order_number.Value.ToString()
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim cliente, ship_address, contact, fecha, rsd, envio_fecha, vendedor As String
            cliente = ds.Tables(0).Rows(0)("cliente").ToString()
            ship_address = ds.Tables(0).Rows(0)("shipping_address").ToString()
            contact = ds.Tables(0).Rows(0)("contact_info").ToString()
            fecha = ds.Tables(0).Rows(0)("fecha").ToString()
            rsd = ds.Tables(0).Rows(0)("rsd").ToString()
            envio_fecha = ds.Tables(0).Rows(0)("shipped").ToString()
            vendedor = ds.Tables(0).Rows(0)("vendedor").ToString()

            html += "<h3><b>Informacion del pedido</b><br />"
            html += "Cliente: <b>" + cliente.ToString() + "</b><br />"
            html += "Contacto: <b>" + contact.ToString() + "</b><br />"
            html += "Vendedor: <b>" + vendedor.ToString() + "</b><br />"
            html += "Direccion de envio: <b>" + ship_address.ToString() + "</b><br />"
            html += "Fecha de apertura: <b>" + fecha.ToString() + "</b><br />"
            html += "Fecha requerido: <b>" + rsd.ToString() + "</b><br />"
            html += "Fecha de envio: <b>" + envio_fecha.ToString() + "</b><br /></h3>"
        Else
            html += "<b> No se tiene mas informacion del pedido</b>"
        End If

        Return html
    End Function

    'Protected Sub gv_Items_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gv_Items.RowCreated
    '    e.Row.Cells(1).Visible = False
    'End Sub

    'Protected Sub gv_Items_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles gv_Items.RowDeleting
    '    Dim record_id, producto As String
    '    record_id = gv_Items.Rows(e.RowIndex).Cells(1).Text
    '    producto = gv_Items.Rows(e.RowIndex).Cells(2).Text

    '    query = "update sale_order_items set active = 0 where id = " + record_id
    '    Dataconnect.runquery(query)

    '    Dim username As String
    '    Dim logevent As String
    '    username = Membership.GetUser().UserName

    '    logevent = "Actualizacion de pedido: " + hf_order_number.Value.ToString() + " se elimino el producto: " + producto.ToString()
    '    queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
    '    Dataconnect.runquery(queryLog)

    '    populate_order_info()
    '    populateItemsGridView()

    'End Sub


    Public Sub readExcelNew()
        'Dim filepath As String = "C:\Users\212331260"
        Dim filepath As String = "e:\HostingSpaces\vencedo2\radiadoresvencedores.com\wwwroot\docs"
        Dim uploadedFiles As HttpFileCollection = Request.Files
        Dim i As Integer = 0
        Do Until i = uploadedFiles.Count
            Dim userPostedFile As HttpPostedFile = uploadedFiles(i)
            Try
                If (userPostedFile.ContentLength > 0) Then
                    Dim filename As String = Replace(System.IO.Path.GetFileName(userPostedFile.FileName), "'", "")
                    Dim fullpath As String = filepath & "\" & filename
                    Try
                        userPostedFile.SaveAs(fullpath)

                        Dim stream As FileStream = File.Open(fullpath, FileMode.Open, FileAccess.Read)

                        Dim excelReader As IExcelDataReader = ExcelReaderFactory.CreateOpenXmlReader(stream)
                        excelReader.IsFirstRowAsColumnNames = False
                        Dim result As DataSet = excelReader.AsDataSet()

                        File.Delete(fullpath)

                        uploadItemstoOrderNew(result)

                        'lbl_msg.Text = msg

                    Catch ex As Exception

                    End Try
                End If
            Catch ex As Exception

            End Try
            i += 1
        Loop

    End Sub

    Protected Sub leadexcel_Click(sender As Object, e As EventArgs) Handles leadexcel.Click
        readExcelNew()
    End Sub

    'Protected Sub btn_surtir_pedido_Click(sender As Object, e As EventArgs) Handles btn_surtir_pedido.Click
    '    If ddl_location.SelectedValue = "0" Then
    '        lbl_error_surtir_pedido.Text = "Igrese el precio y la sucursal antes de continuar"
    '    Else
    '        readExcelPedidoNew()
    '    End If

    'End Sub

    Public Sub readExcelPedidoNew()
        'Dim path As String = "C:\Users\212331260\Desktop\ejemplo_vencedores.xlsx"
        Dim filepath As String = "e:\HostingSpaces\vencedo2\radiadoresvencedores.com\wwwroot\docs"
        Dim uploadedFiles As HttpFileCollection = Request.Files
        Dim i As Integer = 0
        Do Until i = uploadedFiles.Count
            Dim userPostedFile As HttpPostedFile = uploadedFiles(i)
            Try
                If (userPostedFile.ContentLength > 0) Then
                    Dim filename As String = Replace(System.IO.Path.GetFileName(userPostedFile.FileName), "'", "")
                    Dim fullpath As String = filepath & "\" & filename
                    Try
                        userPostedFile.SaveAs(fullpath)

                        Dim stream As FileStream = File.Open(fullpath, FileMode.Open, FileAccess.Read)

                        Dim excelReader As IExcelDataReader = ExcelReaderFactory.CreateOpenXmlReader(stream)
                        excelReader.IsFirstRowAsColumnNames = False
                        Dim result As DataSet = excelReader.AsDataSet()

                        File.Delete(fullpath)

                        surtirPedidodeExcel(result)

                        'lbl_msg.Text = msg

                    Catch ex As Exception

                    End Try
                End If
            Catch ex As Exception

            End Try
            i += 1
        Loop

    End Sub

    Public Sub surtirPedidodeExcel(ByVal list_items As DataSet)
        Dim order_number, item, qty, price, error_msg, id_record, rack, qty_picked, mylocation, query_stock As String
        query_stock = ""
        error_msg = ""
        order_number = hf_order_number.Value.ToString()
        price = "0" 'tbx_precio.ToString()
        'mylocation = ddl_location.SelectedItem.Text

        For i = 0 To list_items.Tables(0).Rows.Count - 1

            item = Replace(Replace(list_items.Tables(0).Rows(i)(0).ToString(), "'", "").ToUpper(), " ", "")
            qty = list_items.Tables(0).Rows(i)(1).ToString()
            qty_picked = list_items.Tables(0).Rows(i)(2).ToString()
            rack = list_items.Tables(0).Rows(i)(3).ToString()

            'verificamos que sean cantidades numericas
            If Not IsNumeric(qty) Or Not IsNumeric(price) Or Not IsNumeric(qty_picked) Then
                error_msg += "Campo de Cantidad o Precio estan incorrectos en linea: " + (i + 1).ToString() + "<br />"
            ElseIf rack.ToUpper() = "TEMPORAL" Then
                error_msg += "No es posible dar de baja del rack Temporal en linea: " + (i + 1).ToString() + "<br />"
            Else
                query = "select * from products where code = '" + item.ToString() + "'"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    Dim prod_id As String = ds.Tables(0).Rows(0)("id").ToString()
                    'verificamos si existe suficiente cantidad en el rack
                    query = "select * from stock where product_code = '" + item.ToString() + "' and location = '" + mylocation.ToString() + "' and qty >= " + qty_picked.ToString()
                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        Dim id_stock As String = ds.Tables(0).Rows(0)("id").ToString()
                        query_stock += " update stock set qty = (qty - " + qty_picked.ToString() + ") where id = " + id_stock.ToString()
                        query_stock += " delete from stock where qty <= 0"
                        query_stock += " insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (" + prod_id.ToString() + ", '" + item.ToString() + "', 'Venta', 'Salida', 'Surtido de pedido " + order_number.ToString() + "', '" + mylocation.ToString() + "', '" + rack.ToString() + "', '" + username.ToString() + "', getDate(), " + qty_picked.ToString() + ")"
                        Dim logevent As String = "Salida de producto: " + item.ToString() + " de la sucursal: " + mylocation.ToString() + " del rack: " + rack.ToString() + ", por la cantidad de: " + qty_picked.ToString()
                        query_stock += " INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"

                        'verificamos si existe una linea en la orden, para sumarla a la cantidad actual
                        query = "select * from sale_order_items where active = 1 and order_id = " + order_number.ToString() + " and product_code = '" + item.ToString() + "'"
                        ds = Dataconnect.GetAll(query)
                        If ds.Tables(0).Rows.Count > 0 Then
                            'sumar a la cantidad actual
                            id_record = ds.Tables(0).Rows(0)("id").ToString()
                            query = "update sale_order_items set update_date = getdate(), qty = (qty + " + qty.ToString() + "), qty_picked = (qty_picked + " + qty_picked.ToString() + ") where id = " + id_record.ToString()
                            Dataconnect.runquery(query)
                        Else
                            'ingresar nueva linea
                            query = "insert into sale_order_items (order_id,qty,sold_price,product_code,qty_picked,active,update_date) values ("
                            query += order_number.ToString() + ", " + qty.ToString() + ", " + price.ToString() + ", '" + item.ToString()
                            query += "', " + qty_picked.ToString() + ", 1,getdate())"
                            Dataconnect.runquery(query)
                        End If
                    Else
                        error_msg += "Del item: " + item.ToString() + " no existe suficiente inventario en el Rack " + rack.ToString() + " corrija el inventario y cargue de nuevo el documento<br />"
                    End If
                Else
                    Dim logevent As String = "Posible producto nuevo: " + item.ToString()
                    queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                    Dataconnect.runquery(queryLog)
                    error_msg += "El item: " + item.ToString() + " no existe en la base de datos<br />"
                End If
            End If
        Next

        If error_msg <> "" Then
            'hubo errores no se procesa el log y se eliminan los registros de la orden
            'lbl_error_file.Text = "<br />Corrija los siguiente errores y vuelva a cargar el documento:<br />" + error_msg
            query = "delete from sale_order_items where order_id = " + order_number.ToString()
            Dataconnect.runquery(query)
        Else
            'sin errores, se procesa el log y la actualizacion de inventario
            'lbl_error_file.ForeColor = Color.Green
            'lbl_error_file.Text = "El archivo se cargo con exito!"
            Dataconnect.runquery(query_stock)
            query = "delete from stock where qty <= 0"
            query += " update sale_order set staus = 4 where id = " + order_number.ToString()
            Dataconnect.runquery(query)
        End If

        populate_order_info()
        'populateItemsGridView()

    End Sub

    Public Sub uploadItemstoOrder(ByVal list_items As String)
        Dim order_number, item, qty, price, error_msg, id_record As String
        error_msg = ""
        Dim item_details() As String
        order_number = hf_order_number.Value.ToString()

        Dim items_array() As String = list_items.Split("]")
        For i = 0 To items_array.Length - 1

            item_details = items_array(i).Split("}")
            item = Replace(item_details(0).ToString(), "'", "").ToUpper()
            qty = item_details(1).ToString()
            price = item_details(2).ToString()

            'verificamos que sean cantidades numericas
            If Not IsNumeric(qty) Or Not IsNumeric(price) Then
                error_msg += "Campo de Cantidad o Precio estan incorrectos en linea: " + (i + 1).ToString() + "<br />"
            Else
                query = "select * from products where code = '" + item.ToString() + "'"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    'verificamos si existe una linea en la orden, para sumarla a la cantidad actual
                    query = "select * from sale_order_items where active = 1 and order_id = " + order_number.ToString() + " and product_code = '" + item.ToString() + "'"
                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        'sumar a la cantidad actual
                        id_record = ds.Tables(0).Rows(0)("id").ToString()
                        query = "update sale_order_items set update_date = getdate(), qty = (qty + " + qty.ToString() + ") where id = " + id_record.ToString()
                        Dataconnect.runquery(query)
                    Else
                        'ingresar nueva linea
                        query = "insert into sale_order_items (order_id,qty,sold_price,product_code,qty_picked,active,update_date) values ("
                        query += order_number.ToString() + ", " + qty.ToString() + ", " + price.ToString() + ", '" + item.ToString()
                        query += "', 0, 1,getdate())"
                        Dataconnect.runquery(query)
                    End If
                Else
                    error_msg += "El item: " + item.ToString() + " no existe en la base de datos<br />"
                End If
            End If
        Next

        If error_msg <> "" Then
            'lbl_error_file.Text = "<br />Los siguiente errores fueron detectados:<br />" + error_msg
        Else
            'lbl_error_file.ForeColor = Color.Green
            'lbl_error_file.Text = "El archivo se cargo con exito!"
        End If

        populate_order_info()
        'populateItemsGridView()

    End Sub

    Public Sub uploadItemstoOrderNew(ByVal list_items As DataSet)
        Dim order_number, item, qty, price, cliente As String
        order_number = lbl_order_number.Text.ToString()
        query = "select default_price, name from sale_order inner join clients on sale_order.customer = clients.id where sale_order.id = " + order_number.ToString()
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            price = ds.Tables(0).Rows(0)("default_price").ToString()
            If price = "" Then
                price = "0"
            End If
            cliente = ds.Tables(0).Rows(0)("name").ToString()
        Else
            price = "0"
            cliente = "N/A"
        End If

        For i = 0 To list_items.Tables(0).Rows.Count - 1

            item = Replace(list_items.Tables(0).Rows(i)(0).ToString(), "'", "").ToUpper()
            qty = list_items.Tables(0).Rows(i)(1).ToString()
            'price = "0" 'tbx_precio.Text.ToString()
            addItem(item, qty, price, order_number)
        Next

        'populate_order_info()
        'populateItemsGridView()

        Response.Redirect("sales_order.aspx?order=" + order_number.ToString())

    End Sub

    Public Sub addItem(ByVal item As String, ByVal qty As String, ByVal price As String, ByVal order_number As String)
        'verificamos que sean cantidades numericas
        Dim id_record As String

        If Not IsNumeric(qty) Or Not IsNumeric(price) Then
            'error_msg += "Campo de Cantidad esta incorrecto para producto: " + item.ToString() + " en linea: " + (i + 1).ToString() + "<br />"
        Else
            query = "select * from products where code = '" + item.ToString() + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                'verificamos si existe una linea en la orden, para sumarla a la cantidad actual
                query = "select * from sale_order_items where active = 1 and order_id = " + order_number.ToString() + " and product_code = '" + item.ToString() + "'"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    'sumar a la cantidad actual
                    id_record = ds.Tables(0).Rows(0)("id").ToString()
                    query = "update sale_order_items set update_date = getdate(), qty = (qty + " + qty.ToString() + ") where id = " + id_record.ToString()
                    Dataconnect.runquery(query)
                Else
                    'ingresar nueva linea
                    query = "insert into sale_order_items (order_id,qty,sold_price,product_code,qty_picked,active,update_date) values ("
                    query += order_number.ToString() + ", " + qty.ToString() + ", " + price.ToString() + ", '" + item.ToString()
                    query += "', 0, 1,getdate())"
                    Dataconnect.runquery(query)
                End If
            Else
                'Dim logevent As String = "Tapa negada: " + item.ToString()
                'queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                'Dataconnect.runquery(queryLog)
                'error_msg += "El item: " + item.ToString() + " no existe en la base de datos&nbsp;&nbsp;&nbsp;<input type='button' value='Reportar Negada' onclick='show_negadas_pedidos(""?codigo=" + item.ToString() + "&cantidad=" + qty.ToString() + "&cliente=" + cliente.ToString() + "&sucursal=" + ddl_location.SelectedItem.Text + """);' /><br />"
            End If
        End If

    End Sub

    'Protected Sub btn_Add_Click(sender As Object, e As EventArgs) Handles btn_Add.Click
    '    Dim order_number, item, qty, price, error_msg, cliente As String
    '    error_msg = ""
    '    order_number = hf_order_number.Value.ToString()
    '    query = "select default_price, name from sale_order inner join clients on sale_order.customer = clients.id where sale_order.id = " + hf_order_number.Value.ToString()
    '    ds = Dataconnect.GetAll(query)

    '    If ds.Tables(0).Rows.Count > 0 Then
    '        price = ds.Tables(0).Rows(0)("default_price").ToString()
    '        If price = "" Then
    '            price = "0"
    '        End If
    '        cliente = ds.Tables(0).Rows(0)("name").ToString()
    '    Else
    '        price = "0"
    '        cliente = "N/A"
    '    End If

    '    item = Request.Form("Codigo").ToString()
    '    qty = Request.Form("txt_qty").ToString()
    '    addItem(item, qty, price, order_number)

    '    populate_order_info()
    '    populateItemsGridView()
    'End Sub

    Protected Sub btn_surtir_Click(sender As Object, e As EventArgs) Handles btn_surtir.Click
        Dim username As String
        Dim logevent As String
        username = Membership.GetUser().UserName

        query = "update sale_order set status = '2' where id = '" + lbl_order_number.Text.ToString() + "'"
        Dataconnect.runquery(query)

        logevent = "Actualizacion de pedido: " + lbl_order_number.Text.ToString() + " status nuevo: Lista para Surtir"
        queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
        Dataconnect.runquery(queryLog)
        Response.Redirect("sales_order.aspx?order=" + lbl_order_number.Text.ToString())
    End Sub

    Protected Sub btn_ship_Click(sender As Object, e As EventArgs) Handles btn_ship.Click
        Dim username As String
        Dim logevent As String
        username = Membership.GetUser().UserName

        query = "update sale_order set status = '5' where id = '" + lbl_order_number.Text.ToString() + "'"
        Dataconnect.runquery(query)

        logevent = "Actualizacion de pedido: " + lbl_order_number.Text.ToString() + " status nuevo: Enviada"
        queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
        Dataconnect.runquery(queryLog)
        Response.Redirect("sales_order.aspx?order=" + lbl_order_number.Text.ToString())
    End Sub

    Protected Sub btn_cancel_Click(sender As Object, e As EventArgs) Handles btn_cancel.Click
        Dim username As String
        Dim logevent As String
        username = Membership.GetUser().UserName

        query = "update sale_order set status = '7' where id = '" + lbl_order_number.Text.ToString() + "'"
        Dataconnect.runquery(query)

        logevent = "Actualizacion de pedido: " + lbl_order_number.Text.ToString() + " status nuevo: Cancelada"
        queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
        Dataconnect.runquery(queryLog)
        Response.Redirect("sales_order.aspx?order=" + lbl_order_number.Text.ToString())
    End Sub

    Protected Sub btn_deliver_Click(sender As Object, e As EventArgs) Handles btn_deliver.Click
        Dim username As String
        Dim logevent As String
        username = Membership.GetUser().UserName

        query = "update sale_order set status = '6' where id = '" + lbl_order_number.Text.ToString() + "'"
        Dataconnect.runquery(query)

        logevent = "Actualizacion de pedido: " + lbl_order_number.Text.ToString() + " status nuevo: Entregada"
        queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
        Dataconnect.runquery(queryLog)
        Response.Redirect("sales_order.aspx?order=" + lbl_order_number.Text.ToString())
    End Sub

    
End Class
