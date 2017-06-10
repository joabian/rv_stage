Imports System.Data
Imports System.Runtime.InteropServices

Partial Class movimientos_make_order
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public sendEmail As New email_mng

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim user As String
            user = Membership.GetUser().UserName

            query = "select position, isnull(alias,'ALL') as sucursal from users "
            query += " left join locations on location = locations.id"
            query += " where user_name = '" + user + "'"

            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                Dim pos As String = ds.Tables(0).Rows(0)("position").ToString()
                hifd_location.Value = ds.Tables(0).Rows(0)("sucursal").ToString()

                If pos = "admin" Or pos = "inventory" Or pos = "vendedor" Then
                    If Request.QueryString("order") <> "" Then
                        hf_order_id.Value = Request.QueryString("order").ToString()
                        ddl_opn_orders.Visible = False
                    Else
                        ddl_opn_orders.Visible = True
                        populate_open_orders()
                    End If
                    populate_gv_items()
                    populate_locations()

                Else
                    Response.Redirect("../no_access.aspx")
                End If


            Else
                Response.Redirect("../no_access.aspx")
            End If
        End If

    End Sub

    Public Sub populate_locations()
        query = "select alias from locations where transit = 0"
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            'do something
            ddl_locations.DataSource = ds.Tables(0)
            ddl_locations.DataTextField = "alias"
            ddl_locations.DataValueField = "alias"
            ddl_locations.DataBind()

            If hifd_location.Value <> Nothing Then
                If hifd_location.Value.ToString <> "ALL" Then
                    ddl_locations.SelectedValue = hifd_location.Value
                End If

            End If

        Else
            'No data
            ddl_locations.DataSource = Nothing
            ddl_locations.DataBind()
        End If



    End Sub

    Public Sub populate_open_orders()
        Dim user As String
        user = Membership.GetUser().UserName
        query = "select location from users where user_name = '" + user + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim location As String = ds.Tables(0).Rows(0)("location").ToString()
            Dim location_st As String = ""
            If location <> "0" Then
                location_st = " and sale_order.location = " + location.ToString()
            End If

            query = "select sale_order.id, convert(varchar, sale_order.id, 100) + ' - ' + clients.name + ' ('"
            query += " + convert(varchar, order_status.status, 101) + ')' as cust from sale_order"
            query += " inner join clients on sale_order.customer = clients.id "
            query += " inner join order_status on sale_order.status = order_status.id"
            query += " where sale_order.status in (1,2,3,4,5) " + location_st.ToString()
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
        Else
            'No data
            ddl_opn_orders.DataSource = Nothing
            ddl_opn_orders.DataBind()
        End If

    End Sub

    Protected Sub tbx_code_TextChanged(sender As Object, e As EventArgs) Handles tbx_code.TextChanged
        Dim Sound As New System.Media.SoundPlayer()
        'Sound.SoundLocation = "e:\HostingSpaces\vencedo2\radiadoresvencedores.com\wwwroot\sounds\error.wav"
        'Sound.Load()


        Dim order, item, sucursal As String
        If hf_order_id.Value <> "" Then
            order = hf_order_id.Value
        Else
            order = ddl_opn_orders.SelectedValue.ToString()
        End If
        lbl_msg.Text = ""
        sucursal = ddl_locations.SelectedValue

        If sucursal = "0" Then
            lbl_error.Text = "Seleccione una sucursal"
        Else
            If order = "0" Then
                lbl_error.Text = "Seleccione un pedido"
            Else
                item = Replace(Replace(tbx_code.Text & "'", "'", ""), " ", "").ToUpper()
                If item = "" Then
                    lbl_error.Text = "Ingrese o Escane un codigo"
                Else
                    query = "select * from products left join default_locators loc on products.code = loc.code and loc.location = '" + sucursal.ToString() + "' where products.code = '" + item.ToString() + "'"
                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        Dim default_locator As String = ds.Tables(0).Rows(0)("rack").ToString()
                        If default_locator = "" Then
                            lbl_error.Text = "Este producto no tiene una locacion por default, corrija este dato antes de continuar"
                        Else
                            query = "select * from sale_order_items where order_id = " + order.ToString() + " and product_code = '"
                            query += item.ToString() + "' and qty_picked < qty and active = 1"
                            ds = Dataconnect.GetAll(query)
                            If ds.Tables(0).Rows.Count > 0 Then
                                Dim order_item_id As String = ds.Tables(0).Rows(0)("id").ToString()

                                query = "select top 1 * from stock where product_code = '" + item.ToString() + "' and location = '" + sucursal.ToString() + "'"
                                query += " and qty > 0 and rack = '" + default_locator + "'"
                                ds = Dataconnect.GetAll(query)
                                If ds.Tables(0).Rows.Count > 0 Then
                                    'do something
                                    Dim stock_id As String = ds.Tables(0).Rows(0)("id").ToString()
                                    Dim rack As String = default_locator 'ds.Tables(0).Rows(0)("rack").ToString()
                                    Dim product_id As String = ds.Tables(0).Rows(0)("product_id").ToString()

                                    lbl_error.Text = ""
                                    tbx_code.Text = ""
                                    query = "update stock set qty = (qty - 1) where id = " + stock_id.ToString()
                                    query += " update sale_order_items set update_date = getdate(), qty_picked = (qty_picked + 1) where id = " + order_item_id.ToString()
                                    query += " delete from stock where qty <= 0"
                                    Dataconnect.runquery(query)

                                    Dim username As String
                                    Dim logevent As String
                                    username = Membership.GetUser().UserName

                                    query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (" + product_id.ToString() + ", '" + item.ToString() + "', 'Pedido', 'Salida', 'salida por surtido de pedido', '" + ddl_locations.SelectedValue.ToString() + "', '" + rack.ToString() + "', '" + username.ToString() + "', getDate(), 1)"
                                    Dataconnect.runquery(query)

                                    logevent = "Surtido de pedido: " + order.ToString() + " producto: " + item.ToString() + " de la sucursal: " + ddl_locations.SelectedValue.ToString() + " del rack: " + rack.ToString()
                                    queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                                    Dataconnect.runquery(queryLog)

                                    query = "select status from sale_order where id = " + order.ToString()
                                    ds = Dataconnect.GetAll(query)
                                    If ds.Tables(0).Rows.Count > 0 Then
                                        Dim status As String = ds.Tables(0).Rows(0)("status").ToString()
                                        If status <> "2" Then
                                            query = "update sale_order set status = 2 where id = " + order.ToString()
                                            Dataconnect.runquery(query)

                                            logevent = "Actualizacion de pedido: " + order.ToString() + " nuevo status: Preparando"
                                            queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                                            Dataconnect.runquery(queryLog)

                                        End If
                                    Else
                                        'No data
                                    End If

                                    query = "select sum(qty_picked) as picked from sale_order_items where active =1 and order_id = " + order.ToString()
                                    query += "having sum(qty_picked) = sum(qty)"

                                    ds = Dataconnect.GetAll(query)
                                    If ds.Tables(0).Rows.Count > 0 Then
                                        'do something
                                        query = "update sale_order set status = 4 where id = " + order.ToString()
                                        Dataconnect.runquery(query)

                                        logevent = "Actualizacion de pedido: " + order.ToString() + " nuevo status: Por Verificar"
                                        queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                                        Dataconnect.runquery(queryLog)

                                        'Dim body As String = bodyHtml(order.ToString(), username)
                                        'Dim distro As String = "joabian.alvarez@radiadoresvencedores.com,samuel.gonzalez@radiadoresvencedores.com"

                                        'sendEmail.sendEmail(distro, "Pedido Listo", body)

                                    Else
                                        'No data
                                    End If

                                    'Beep()
                                    lbl_msg.Text = "Producto ingresado con exito, la baja se dio del rack " + rack.ToString()
                                    populate_gv_items()
                                Else
                                    'Sound.Play()
                                    lbl_error.Text = "No existe suficiente inventario en la locacion default de la sucursal seleccionada"
                                    tbx_code.Text = ""
                                    tbx_code.Focus()

                                End If
                            Else
                                'Sound.Play()
                                lbl_error.Text = "Este producto no forma parte del pedido o ya se surtio por completo"
                                tbx_code.Text = ""
                                tbx_code.Focus()
                            End If
                        End If
                        'do something

                    Else
                        lbl_error.Text = "Producto inexistente en la base de datos"
                        tbx_code.Text = ""
                        tbx_code.Focus()
                    End If
                End If
            End If
        End If
        tbx_code.Focus()
    End Sub

    Protected Sub ddl_opn_orders_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddl_opn_orders.SelectedIndexChanged
        lbl_error.Text = ""
        tbx_code.Text = ""
        populate_gv_items()
    End Sub

    Public Sub populate_gv_items()
        Dim order As String
        If hf_order_id.Value <> "" Then
            order = hf_order_id.Value.ToString()
        Else
            order = ddl_opn_orders.SelectedValue.ToString()
        End If
        Dim sucursal = ddl_locations.SelectedValue

        If sucursal = "0" Then
            lbl_error.Text = "Seleccione una sucursal"
        Else
            'query = "select product_code as [Codigo], qty as [Cantidad Pedida], qty_picked as [Cantidad Surtida],"
            'query += " (qty - qty_picked) as [Cantidad faltante]"
            'query += " from sale_order_items where active = 1 and order_id = " + order.ToString()

            query = "select pedido.product_code as [Codigo], pedido.qty as [Cantidad Pedida], pedido.qty_picked as [Cantidad Surtida],"
            query += " (pedido.qty - pedido.qty_picked) as [Cantidad faltante] ,isnull(stock.qty, 0) as [Cantidad en locacion default], "
            query += " isnull(totales_suc.qty,0) as [Total en " + sucursal.ToString() + "], isnull(totales.qty,0) as [Total en Todas las Sucursales]"
            query += " from sale_order_items as pedido left join default_locators as locators on pedido.product_code = locators.code and "
            query += " locators.location = '" + sucursal.ToString() + "' left join stock on pedido.product_code = stock.product_code and stock.location = "
            query += " '" + sucursal.ToString() + "' and stock.rack = locators.rack left join (select product_code, sum(qty) as qty from stock where location"
            query += "  = '" + sucursal.ToString() + "' group by product_code) as totales_suc on pedido.product_code = totales_suc.product_code left join "
            query += " (select product_code, sum(qty) as qty from stock group by product_code) as totales on pedido.product_code = "
            query += " totales .product_code where pedido.active = 1 and pedido.order_id = " + order.ToString() + " order by update_date desc"

            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                'do something
                gv_items.DataSource = ds.Tables(0)
                gv_items.DataBind()
                btn_complete_order.Enabled = True
            Else
                'No data
                gv_items.DataSource = Nothing
                gv_items.DataBind()
                btn_complete_order.Enabled = False
            End If

            query = "select status from sale_order where id = " + order.ToString()
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                If ds.Tables(0).Rows(0)("status").ToString() = "1" Then
                    tbx_code.Enabled = False
                    ddl_locations.Enabled = False
                Else
                    tbx_code.Enabled = True
                    ddl_locations.Enabled = True
                End If
            Else
                tbx_code.Enabled = False
                ddl_locations.Enabled = False
            End If

        End If

    End Sub

    Protected Sub gv_items_RowDataBound(ByVal sender As System.Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gv_items.RowDataBound
        Dim qty_faltante, qty_pedida As String
        qty_faltante = e.Row.Cells(3).Text
        qty_pedida = e.Row.Cells(1).Text
        If qty_faltante = "Cantidad faltante" Then

        Else

            If qty_faltante = "0" Then
                e.Row.BackColor = Drawing.Color.GreenYellow

            ElseIf qty_faltante <> qty_pedida Then
                e.Row.BackColor = Drawing.Color.Yellow
            End If
        End If

    End Sub

    Protected Sub btn_complete_order_Click(sender As Object, e As EventArgs) Handles btn_complete_order.Click
        Dim order As String
        If hf_order_id.Value <> "" Then
            order = hf_order_id.Value.ToString()
        Else
            order = ddl_opn_orders.SelectedValue.ToString()
        End If

        query = "update sale_order set status = 7 where id = " + order.ToString()
        Dataconnect.runquery(query)

        Dim username As String
        Dim logevent As String
        username = Membership.GetUser().UserName

        logevent = "Actualizacion de pedido: " + order.ToString() + " nuevo status: Por Verificar"
        queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
        Dataconnect.runquery(queryLog)

        'Dim body As String = bodyHtml(order.ToString(), username)
        'Dim distro As String = "joabian.alvarez@radiadoresvencedores.com,samuel.gonzalez@radiadoresvencedores.com"

        'sendEmail.sendEmail(distro, "Pedido Listo", body)

        Response.Redirect("make_order.aspx")
    End Sub

    Function bodyHtml(ByVal order_id As String, ByVal username As String) As String
        Dim html As String = ""

        html += "<h1>Notificacion</h1><br />"
        html += "<h2>Ha sido surtido un pedido</h2><br />"
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

        query = "select product_code, qty, qty_picked, (qty - qty_picked) as missing"
        query += " from sale_order_items where active = 1 and order_id = " + order_id.ToString()
        ds = Dataconnect.GetAll(query)

        If ds.Tables(0).Rows.Count > 0 Then
            html += "Lista de productos: <br /><br />"
            html += "<table border='1' style='border-collapse:collapse'><tr>"
            html += "<th>Producto</th><th>Cantidad Reqerida</th><th>Surtida</th><th>Faltante</th>"
            html += "</tr>"

            For i = 0 To ds.Tables(0).Rows.Count - 1
                html += "<tr>"
                html += "<td>" + ds.Tables(0).Rows(i)("product_code").ToString() + "</td>"
                html += "<td>" + ds.Tables(0).Rows(i)("qty").ToString() + "</td>"
                html += "<td>" + ds.Tables(0).Rows(i)("qty_picked").ToString() + "</td>"
                html += "<td>" + ds.Tables(0).Rows(i)("missing").ToString() + "</td>"
                html += "</tr>"
            Next

        Else
            'No data
        End If




        Return html
    End Function

    Protected Sub ddl_locations_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddl_locations.SelectedIndexChanged
        populate_gv_items()
    End Sub
End Class
