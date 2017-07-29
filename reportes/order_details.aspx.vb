Imports System.Data
Partial Class reportes_order_details
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        ''query = "select * from sale_order order by id desc"
        ''ds = Dataconnect.GetAll(query)
        If Not IsPostBack Then
            If Request.QueryString("order_no") <> "" Then
                hf_order_number.Value = Request.QueryString("order_no")
            End If
            populate_order_info()
            populateItemsGridView()
        End If
    End Sub

    Sub populateItemsGridView()
        query = "select sale_order_items.product_code as [Codigo], products.description as [Descripcion],"
        query += " sale_order_items.qty as [Cantidad Pedida], sale_order_items.qty_picked as [Cantidad Surtida],"
        query += " sale_order_items.sold_price as [Precio Unitario], (sale_order_items.qty_picked * "
        query += " sale_order_items.sold_price) as [Total] from sale_order_items"
        query += " inner join products on products.code = sale_order_items.product_code"
        query += " inner join sale_order on sale_order.id = sale_order_items.order_id"
        query += " left join max_min on sale_order_items.product_code = max_min.product_code"
        query += " and max_min.location_id = sale_order.location"
        query += " where sale_order_items.order_id = " + hf_order_number.Value.ToString()
        query += " and sale_order_items.active = 1"

        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            gv_Items.DataSource = ds.Tables(0)
            gv_Items.DataBind()
        Else
            gv_Items.DataSource = Nothing
            gv_Items.DataBind()
        End If
    End Sub

    Sub populate_order_info()
        query = "select "
        query += " clients.name"
        query += " ,employees.name + ' ' + employees.last_name as empleado"
        query += " ,sale_order.id"
        query += " ,clients.bill_address"
        query += " ,clients.contact_name as contact_info"
        query += " ,convert(varchar, sale_order.date, 101) as fecha"
        query += " ,sale_order.notes"
        query += " ,order_status.status"
        query += " ,sale_order.subtotal"
        query += " ,isnull(sale_order.tax, 0) as tax"
        query += " ,sale_order.total "
        query += " ,sale_order.location"
        query += " ,clients.ship_address as shipping_address"
        query += " ,sale_order.terms"
        query += " , sale_order.currency"
        query += " , sale_order.exchange_rate"
        query += " , convert(varchar, sale_order.rsd, 101) as rsd"
        query += " , clients.telephone as tel"
        query += " , clients.email"
        query += " , sale_order.ship_date as [f_envio] "
        query += " , isnull(sale_order.cajas,0) as cajas"
        query += " , isnull(sale_order.paqueteria,'N/A') as paqueteria"
        query += " from sale_order"
        query += " inner join clients on sale_order.customer = clients.id"
        query += " inner join employees on sale_order.vendor = employees.id"
        query += " inner join order_status on sale_order.status = order_status.id"
        query += " where sale_order.id = " + hf_order_number.Value.ToString()
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then

            lbl_Client.Text = ds.Tables(0).Rows(0)("name").ToString()
            ddl_terms.Text = ds.Tables(0).Rows(0)("terms").ToString()
            lbl_order_number.Text = ds.Tables(0).Rows(0)("id").ToString()
            txt_contact.Text = ds.Tables(0).Rows(0)("contact_info").ToString()
            ddl_vendor.Text = ds.Tables(0).Rows(0)("empleado").ToString()
            lbl_date.Text = ds.Tables(0).Rows(0)("fecha").ToString()
            txt_Phones.Text = ds.Tables(0).Rows(0)("tel").ToString()
            ddl_Status.Text = ds.Tables(0).Rows(0)("status").ToString()
            txt_Billing_Address.Text = ds.Tables(0).Rows(0)("bill_address").ToString()
            txt_Shipping_Address.Text = ds.Tables(0).Rows(0)("shipping_address").ToString()
            txt_ReqShipDate.Text = ds.Tables(0).Rows(0)("rsd").ToString()
            txt_notes.Text = ds.Tables(0).Rows(0)("notes").ToString()
            txt_email.Text = ds.Tables(0).Rows(0)("email").ToString()
            lbl_cajas.Text = ds.Tables(0).Rows(0)("cajas").ToString()
            lbl_paqueteria.Text = ds.Tables(0).Rows(0)("paqueteria").ToString()

            query = "select round(sum(sold_price * qty_picked),2) as subtotal, round(sum((sold_price * qty_picked) * (1 + (cast(isnull(sale_order.tax, 0) as float) / 100 ))),2)"
            query += " as total from sale_order_items"
            query += " inner join sale_order on sale_order.id = sale_order_items.order_id"
            query += " where order_id = " + hf_order_number.Value.ToString() + " and sale_order_items.active = 1"

            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                lbl_subtotal.Text = ds.Tables(0).Rows(0)("subtotal").ToString()
                lbl_total.Text = ds.Tables(0).Rows(0)("total").ToString()
            Else
                lbl_subtotal.Text = "0.00"
                lbl_total.Text = "0.00"
            End If

        Else
            lbl_Client.Text = ""
            ddl_terms.Text = "EFECTIVO"
            lbl_order_number.Text = ""
            txt_contact.Text = ""
            ddl_vendor.Text = "0"
            lbl_date.Text = ""
            txt_Phones.Text = ""
            ddl_Status.Text = "1"
            txt_Billing_Address.Text = ""
            txt_Shipping_Address.Text = ""
            txt_ReqShipDate.Text = ""
            lbl_subtotal.Text = "0"
            txt_notes.Text = ""

            lbl_total.Text = "0"
            txt_email.Text = ""
            lbl_cajas.Text = ""
            lbl_paqueteria.Text = ""
        End If

    End Sub

    Protected Sub btn_export_word_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btn_export_word.Click
        query = "select "
        query += " clients.name"
        query += " , employees.name + ' ' + employees.last_name as empleado"
        query += " , sale_order.id"
        query += " , clients.bill_address"
        query += " , clients.contact_name as contact_info"
        query += " , convert(varchar, sale_order.date, 101) as fecha"
        query += " , sale_order.notes"
        query += " , order_status.status"
        query += " , sale_order.subtotal"
        query += " , isnull(sale_order.tax, 0) as tax"
        query += " , sale_order.total "
        query += " , sale_order.location"
        query += " , clients.ship_address as shipping_address"
        query += " , sale_order.terms"
        query += " , sale_order.currency"
        query += " , sale_order.exchange_rate"
        query += " , convert(varchar, sale_order.rsd, 101) as rsd"
        query += " , clients.telephone as tel"
        query += " , clients.email"
        query += " , sale_order.ship_date as [f_envio] "
        query += " , isnull(sale_order.cajas,0) as cajas"
        query += " , isnull(sale_order.paqueteria,'N/A') as paqueteria"
        query += " , isnull(locations.alias,'N/A') as location_name"
        query += " , isnull(sale_order.flete,-1.0) as flete"
        query += " from sale_order"
        query += " inner join clients on sale_order.customer = clients.id"
        query += " inner join employees on sale_order.vendor = employees.id"
        query += " inner join order_status on sale_order.status = order_status.id"
        query += " left join locations on sale_order.location = locations.id"
        query += " where sale_order.id = " + hf_order_number.Value.ToString()
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim client, terms, order_number, contact, vendedor, open_date, phone, status, bill_address, ship_address As String
            Dim req_date, ship_date, notes, tax, email, sub_total, total, location_name, flete As String

            client = ds.Tables(0).Rows(0)("name").ToString()
            terms = ds.Tables(0).Rows(0)("terms").ToString()
            order_number = ds.Tables(0).Rows(0)("id").ToString()
            contact = ds.Tables(0).Rows(0)("contact_info").ToString()
            vendedor = ds.Tables(0).Rows(0)("empleado").ToString()
            open_date = ds.Tables(0).Rows(0)("fecha").ToString()
            phone = ds.Tables(0).Rows(0)("tel").ToString()
            status = ds.Tables(0).Rows(0)("status").ToString()
            bill_address = ds.Tables(0).Rows(0)("bill_address").ToString()
            ship_address = ds.Tables(0).Rows(0)("shipping_address").ToString()
            req_date = ds.Tables(0).Rows(0)("rsd").ToString()
            notes = ds.Tables(0).Rows(0)("notes").ToString()
            tax = ds.Tables(0).Rows(0)("tax").ToString()
            email = ds.Tables(0).Rows(0)("email").ToString()
            ship_date = ds.Tables(0).Rows(0)("f_envio").ToString()
            flete = ds.Tables(0).Rows(0)("flete").ToString()
            location_name = ds.Tables(0).Rows(0)("location_name").ToString()

            If flete = "-1.0000" Then
                'no ha ingresado flete, verificar si lo puso en el tbx

                If tbx_flete.Text = "" Then
                    lbl_msg.ForeColor = Drawing.Color.Red
                    lbl_msg.Text = "Ingrese costo de flete!"
                ElseIf Not IsNumeric(tbx_flete.Text) Then
                    lbl_msg.ForeColor = Drawing.Color.Red
                    lbl_msg.Text = "Costo de flete numerico!"
                Else
                    query = "update sale_order set flete = '" + tbx_flete.Text + "' where id = '" + lbl_order_number.Text.ToString() + "'"
                    Dataconnect.runquery(query)

                    'ya tiene costo el flete se puede proceder
                    query = "select round(sum(sold_price * qty_picked),2) as subtotal, round(sum(sold_price * qty_picked),2)"
                    query += " as total from sale_order_items"
                    query += " inner join sale_order on sale_order.id = sale_order_items.order_id"
                    query += " where order_id = " + hf_order_number.Value.ToString() + " and sale_order_items.active = 1"

                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        sub_total = ds.Tables(0).Rows(0)("subtotal").ToString()
                        total = (Convert.ToDouble(ds.Tables(0).Rows(0)("total")) + Convert.ToDouble(tbx_flete.Text)).ToString()
                    Else
                        sub_total = "0.00"
                        total = "0.00"
                    End If

                    Dim response_string As String
                    Response.Clear()
                    Response.Buffer = True
                    Response.ContentType = "application/vnd.ms-excel"
                    Response.Charset = "UTF-8?"
                    Response.AddHeader("Content-Disposition", "attachment;filename=Pedido_" + hf_order_number.Value.ToString() + ".xls")
                    Response.ContentEncoding = Encoding.Default
                    response_string = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">"
                    'response_string += "<img class='isd_print' src='http://www.radiadoresvencedores.com/images/logovencedores2.png' alt='' style='position:absolute;margin-left:0;margin-top:0;width:71.4pt;height:57.6pt;z-index:1;visibility:visible' />"
                    response_string += "<font style='font-size:11.0pt;'>"
                    response_string += "<Table bgColor='#ffffff' cellSpacing='0' cellPadding='0' style='font-size:12.0pt; background:white;'>"
                    'cada tr es de 10 columnas
                    'inf vencedores y orden
                    response_string += "<tr><td colspan='2'><b>RADIADORES VENCEDORES</b></td><td></td><td></td><td></td><td style='text-align:right'>Orden:</td><td colspan='2' style='text-align:left'><b>" + hf_order_number.Value.ToString() + "</b></td><td></td><td></td></tr>"
                    response_string += "<tr><td colspan='2'>Ave. Henequen No. 324</td><td></td><td></td><td></td><td style='text-align:right'>Fecha:</td><td colspan='2' style='text-align:left'>" + open_date.ToString() + "</td><td></td><td></td></tr>"
                    response_string += "<tr><td colspan='2'>Col. Terrenos Nacionales Sur</td><td></td><td></td><td></td><td style='text-align:right'>Fecha Req:</td><td colspan='2' style='text-align:left'>" + req_date.ToString() + "</td><td></td><td></td></tr>"
                    response_string += "<tr><td colspan='2'>Cd. Juarez, Chih. Mex</td><td></td><td></td><td></td><td style='text-align:right'>Fecha envio:</td><td colspan='2' style='text-align:left'>" + ship_date.ToString() + "</td><td></td><td></td></tr>"
                    response_string += "<tr><td colspan='2'>Tels 656-171-72-74 y 656-171-79-74</td><td></td><td></td><td></td><td style='text-align:right'>Vendedor:</td><td colspan='2' style='text-align:left'>" + vendedor.ToString() + "</td><td></td><td></td></tr>"
                    response_string += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>"
                    'inf cliente
                    response_string += "<tr><td style='text-align:right'>Cliente</td><td colspan='7'><b>" + client.ToString() + "</b></td></tr>"
                    response_string += "<tr><td style='text-align:right'>Contacto</td><td colspan='7'>" + contact.ToString() + "</td></tr>"
                    response_string += "<tr><td style='text-align:right'>Terminos</td><td>" + terms.ToString() + "</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>"
                    response_string += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>"
                    response_string += "</Table>"

                    'direcciones
                    response_string += "<Table border='1' bgColor='#ffffff' borderColor='#000000' cellSpacing='0' cellPadding='0' style='font-size:12.0pt; background:white; text-align:center'>"
                    response_string += "<tr><td colspan='4'>Dirección de facturación:</td><td colspan='4'>Dirección de Envio</td></tr>"
                    response_string += "<tr><td rowspan='2' colspan='4' style='vertical-align:middle'>" + bill_address.ToString() + "</td><td rowspan='2' colspan='4' style='vertical-align:middle'>" + ship_address.ToString() + "</td></tr>"
                    response_string += "</Table>"

                    response_string += "<Table>"
                    response_string += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>"
                    'lista de items
                    'response_string += "<tr><td colspan='10'>Lista de items</td></tr>"
                    response_string += "</Table>"

                    query = "select sale_order_items.product_code, description, qty, qty_picked,"
                    query += " sold_price, (qty_picked * sold_price) as line_total, stock.total as qty_suc"
                    query += " from sale_order_items inner join products on products.code = sale_order_items.product_code"
                    query += " left join (select product_code, location, sum(qty) as total from stock group by product_code,location) as stock "
                    query += " on sale_order_items.product_code = stock.product_code and stock.location = '" + location_name.ToString() + "'"
                    query += " where order_id = " + hf_order_number.Value.ToString() + " and sale_order_items.active = 1"


                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        Dim code, desc, qty, qty_picked, price, line_total, qty_suc As String
                        response_string += "<Table border='1' bgColor='#ffffff' borderColor='#000000' cellSpacing='0' cellPadding='0' style='font-size:12.0pt; background:white; text-align:center'>"
                        response_string += "<tr style='text-align:center;'><td style='background-color:blue; color:white;'>Codigo</td><td colspan='3' style='background-color:blue; color:white;'>Descripcion</td><td style='background-color:blue; color:white;'>Requerido</td><td style='background-color:blue; color:white;'>Surtido</td><td style='background-color:blue; color:white;'>P.U.</td><td style='background-color:blue; color:white;'>Total</td></tr>"

                        For i = 0 To ds.Tables(0).Rows.Count - 1
                            code = ds.Tables(0).Rows(i)("product_code").ToString()
                            desc = ds.Tables(0).Rows(i)("description").ToString()
                            qty = ds.Tables(0).Rows(i)("qty").ToString()
                            qty_picked = ds.Tables(0).Rows(i)("qty_picked").ToString()
                            price = ds.Tables(0).Rows(i)("sold_price").ToString()
                            line_total = ds.Tables(0).Rows(i)("line_total").ToString()
                            qty_suc = ds.Tables(0).Rows(i)("qty_suc").ToString()

                            If qty_picked < qty Then
                                If qty_suc >= qty_picked Then
                                    response_string += "<tr style='text-align:center;background-color:red;'>"
                                Else
                                    response_string += "<tr style='text-align:center;'>"
                                End If
                            Else
                                response_string += "<tr style='text-align:center;'>"
                            End If

                            response_string += "<td>" + code.ToString() + "</td><td colspan='3'>" + desc.ToString() + "</td><td>" + qty.ToString() + "</td><td>" + qty_picked.ToString() + "</td><td>$" + price.ToString() + "</td><td>$" + line_total.ToString() + "</td></tr>"

                        Next

                        response_string += "<tr><td rowspan='3' colspan='6' style='vertical-align:middle'>Notas: " + notes.ToString() + "</td><td style='text-align:right;background-color:blue; color:white;'>Subtotal</td><td style='text-align:center'>$" + sub_total.ToString() + "</td></tr>"
                        'totales
                        response_string += "<tr><td style='text-align:right;background-color:blue; color:white;'>Flete</td><td style='text-align:center'>$" + flete.ToString() + "</td></tr>"
                        response_string += "<tr><td style='text-align:right;background-color:blue; color:white;'>Total</td><td style='text-align:center'><b>$" + total.ToString() + "</b></td></tr>"
                        response_string += "</Table>"


                    End If

                    response_string += "</font>"


                    Response.Write(response_string)
                    Response.End()



                End If

            Else
                'ya tiene costo el flete se puede proceder
                query = "select round(sum(sold_price * qty_picked),2) as subtotal, round(sum(sold_price * qty_picked),2)"
                query += " as total from sale_order_items"
                query += " inner join sale_order on sale_order.id = sale_order_items.order_id"
                query += " where order_id = " + hf_order_number.Value.ToString() + " and sale_order_items.active = 1"

                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    sub_total = ds.Tables(0).Rows(0)("subtotal").ToString()
                    total = (Convert.ToDouble(ds.Tables(0).Rows(0)("total")) + Convert.ToDouble(flete)).ToString()
                Else
                    sub_total = "0.00"
                    total = "0.00"
                End If

                Dim response_string As String
                Response.Clear()
                Response.Buffer = True
                Response.ContentType = "application/vnd.ms-excel"
                Response.Charset = "UTF-8?"
                Response.AddHeader("Content-Disposition", "attachment;filename=Pedido_" + hf_order_number.Value.ToString() + ".xls")
                Response.ContentEncoding = Encoding.Default
                response_string = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">"
                'response_string += "<img class='isd_print' src='http://www.radiadoresvencedores.com/images/logovencedores2.png' alt='' style='position:absolute;margin-left:0;margin-top:0;width:71.4pt;height:57.6pt;z-index:1;visibility:visible' />"
                response_string += "<font style='font-size:11.0pt;'>"
                response_string += "<Table bgColor='#ffffff' cellSpacing='0' cellPadding='0' style='font-size:12.0pt; background:white;'>"
                'cada tr es de 10 columnas
                'inf vencedores y orden
                response_string += "<tr><td colspan='2'><b>RADIADORES VENCEDORES</b></td><td></td><td></td><td></td><td style='text-align:right'>Orden:</td><td colspan='2' style='text-align:left'><b>" + hf_order_number.Value.ToString() + "</b></td><td></td><td></td></tr>"
                response_string += "<tr><td colspan='2'>Ave. Henequen No. 324</td><td></td><td></td><td></td><td style='text-align:right'>Fecha:</td><td colspan='2' style='text-align:left'>" + open_date.ToString() + "</td><td></td><td></td></tr>"
                response_string += "<tr><td colspan='2'>Col. Terrenos Nacionales Sur</td><td></td><td></td><td></td><td style='text-align:right'>Fecha Req:</td><td colspan='2' style='text-align:left'>" + req_date.ToString() + "</td><td></td><td></td></tr>"
                response_string += "<tr><td colspan='2'>Cd. Juarez, Chih. Mex</td><td></td><td></td><td></td><td style='text-align:right'>Fecha envio:</td><td colspan='2' style='text-align:left'>" + ship_date.ToString() + "</td><td></td><td></td></tr>"
                response_string += "<tr><td colspan='2'>Tels 656-171-72-74 y 656-171-79-74</td><td></td><td></td><td></td><td style='text-align:right'>Vendedor:</td><td colspan='2' style='text-align:left'>" + vendedor.ToString() + "</td><td></td><td></td></tr>"
                response_string += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>"
                'inf cliente
                response_string += "<tr><td style='text-align:right'>Cliente</td><td colspan='7'><b>" + client.ToString() + "</b></td></tr>"
                response_string += "<tr><td style='text-align:right'>Contacto</td><td colspan='7'>" + contact.ToString() + "</td></tr>"
                response_string += "<tr><td style='text-align:right'>Terminos</td><td>" + terms.ToString() + "</td><td></td><td></td><td></td><td></td><td></td><td></td></tr>"
                response_string += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>"
                response_string += "</Table>"

                'direcciones
                response_string += "<Table border='1' bgColor='#ffffff' borderColor='#000000' cellSpacing='0' cellPadding='0' style='font-size:12.0pt; background:white; text-align:center'>"
                response_string += "<tr><td colspan='4'>Dirección de facturación:</td><td colspan='4'>Dirección de Envio</td></tr>"
                response_string += "<tr><td rowspan='2' colspan='4' style='vertical-align:middle'>" + bill_address.ToString() + "</td><td rowspan='2' colspan='4' style='vertical-align:middle'>" + ship_address.ToString() + "</td></tr>"
                response_string += "</Table>"

                response_string += "<Table>"
                response_string += "<tr><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>"
                'lista de items
                'response_string += "<tr><td colspan='10'>Lista de items</td></tr>"
                response_string += "</Table>"

                query = "select sale_order_items.product_code, description, qty, qty_picked,"
                query += " sold_price, (qty_picked * sold_price) as line_total, stock.total as qty_suc"
                query += " from sale_order_items inner join products on products.code = sale_order_items.product_code"
                query += " left join (select product_code, location, sum(qty) as total from stock group by product_code,location) as stock "
                query += " on sale_order_items.product_code = stock.product_code and stock.location = '" + location_name.ToString() + "'"
                query += " where order_id = " + hf_order_number.Value.ToString() + " and sale_order_items.active = 1"


                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    Dim code, desc, qty, qty_picked, price, line_total, qty_suc As String
                    response_string += "<Table border='1' bgColor='#ffffff' borderColor='#000000' cellSpacing='0' cellPadding='0' style='font-size:12.0pt; background:white; text-align:center'>"
                    response_string += "<tr style='text-align:center;'><td style='background-color:blue; color:white;'>Codigo</td><td colspan='3' style='background-color:blue; color:white;'>Descripcion</td><td style='background-color:blue; color:white;'>Requerido</td><td style='background-color:blue; color:white;'>Surtido</td><td style='background-color:blue; color:white;'>P.U.</td><td style='background-color:blue; color:white;'>Total</td></tr>"

                    For i = 0 To ds.Tables(0).Rows.Count - 1
                        code = ds.Tables(0).Rows(i)("product_code").ToString()
                        desc = ds.Tables(0).Rows(i)("description").ToString()
                        qty = ds.Tables(0).Rows(i)("qty").ToString()
                        qty_picked = ds.Tables(0).Rows(i)("qty_picked").ToString()
                        price = ds.Tables(0).Rows(i)("sold_price").ToString()
                        line_total = ds.Tables(0).Rows(i)("line_total").ToString()
                        qty_suc = ds.Tables(0).Rows(i)("qty_suc").ToString()

                        If qty_picked < qty Then
                            If qty_suc >= qty_picked Then
                                response_string += "<tr style='text-align:center;background-color:red;'>"
                            Else
                                response_string += "<tr style='text-align:center;'>"
                            End If
                        Else
                            response_string += "<tr style='text-align:center;'>"
                        End If

                        response_string += "<td>" + code.ToString() + "</td><td colspan='3'>" + desc.ToString() + "</td><td>" + qty.ToString() + "</td><td>" + qty_picked.ToString() + "</td><td>$" + price.ToString() + "</td><td>$" + line_total.ToString() + "</td></tr>"

                    Next

                    response_string += "<tr><td rowspan='3' colspan='6' style='vertical-align:middle'>Notas: " + notes.ToString() + "</td><td style='text-align:right;background-color:blue; color:white;'>Subtotal</td><td style='text-align:center'>$" + sub_total.ToString() + "</td></tr>"
                    'totales
                    response_string += "<tr><td style='text-align:right;background-color:blue; color:white;'>Flete</td><td style='text-align:center'>$" + flete.ToString() + "</td></tr>"
                    response_string += "<tr><td style='text-align:right;background-color:blue; color:white;'>Total</td><td style='text-align:center'><b>$" + total.ToString() + "</b></td></tr>"
                    response_string += "</Table>"


                End If

                response_string += "</font>"

                
                Response.Write(response_string)
                Response.End()

            End If

            


        End If



    End Sub

    Protected Sub btn_ship_Click(sender As Object, e As EventArgs) Handles btn_ship.Click
        Dim total As Double
        Dim idCte = ""
        Dim username As String
        Dim logevent As String
        username = Membership.GetUser().UserName

        If tbx_flete.Text = "" Then
            lbl_msg.ForeColor = Drawing.Color.Red
            lbl_msg.Text = "Ingrese costo de flete!"
        ElseIf Not IsNumeric(tbx_flete.Text) Then
            lbl_msg.ForeColor = Drawing.Color.Red
            lbl_msg.Text = "Costo de flete numérico!"
        Else
            query = "SELECT id FROM clients WHERE name = '" + lbl_Client.Text.ToString() + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                idCte = ds.Tables(0).Rows(0)("id")
            End If

            total = Convert.ToDouble(tbx_flete.Text) + Convert.ToDouble(lbl_total.Text)

            query = "update sale_order set status = '5', flete = '" + tbx_flete.Text + "' where id = '" + lbl_order_number.Text.ToString() + "'"
            query += "INSERT INTO pagosOrdenes (idOrden, idCliente, status) VALUES ("
            query += lbl_order_number.Text.ToString() + ", " + idCte + ", 1)"
            Dataconnect.runquery(query)

            logevent = "Actualizacion de pedido: " + lbl_order_number.Text.ToString() + " status nuevo: Enviada"
            queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
            Dataconnect.runquery(queryLog)

            lbl_msg.ForeColor = Drawing.Color.Green
            lbl_msg.Text = "Salvada con exito!"
        End If


        'Response.Redirect("sales_order.aspx?order=" + lbl_order_number.Text.ToString())
    End Sub



End Class
