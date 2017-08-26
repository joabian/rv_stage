Imports System.Data
Partial Class reportes_orders
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet
    Public username As String
    Public location_st As String


    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        username = Membership.GetUser().UserName

        query = "select location from users left join locations on users.location = locations.id where user_name = '" + username + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            location_st = ds.Tables(0).Rows(0)("location").ToString()
        Else
            location_st = "0"
        End If

        query = "select sale_order.id as [No. Orden], clients.name as [Cliente], sale_order.contact_info as [Contacto],"
        query += " employees.name + ' ' + employees.last_name as [Vendedor], sale_order.date as"
        query += " [Fecha Apertura], start_date as [Fecha Comienzo Surtido], order_status.status as [Estatus], 'Ver Detalles'"
        query += " as Link from sale_order inner join clients on sale_order.customer = clients.id"
        query += " inner join order_status on sale_order.status = order_status.id left join employees on sale_order.vendor = employees.id"
        query += " where order_status.id in (4)"
        If location_st <> "0" Then
            query += " and clients.location = '" + location_st.ToString() + "'"
        End If
        query += " order by sale_order.date desc, sale_order.id"
        hf_qry.Value = query

        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            gv_results.DataSource = ds
            gv_results.DataBind()
            btn_export.Enabled = True
            lbl_error.Text = ""
        Else
            gv_results.DataSource = Nothing
            gv_results.DataBind()
            btn_export.Enabled = False
            lbl_error.Text = "No existen pedidos para esta seleccion"
        End If
    End Sub

    Protected Sub btn_get_report_Click(sender As Object, e As EventArgs) Handles btn_get_report.Click
        Dim from_d As String = Replace(from_date.Text & "'", "'", "").ToString()
        Dim to_d As String = Replace(to_date.Text & "'", "'", "").ToString()
        
        If IsDate(from_d) And IsDate(to_d) Then

            query = "select sale_order.id as [No. Orden], clients.name as [Cliente], sale_order.contact_info as [Contacto],"
            query += " employees.name + ' ' + employees.last_name as [Vendedor], sale_order.date as"
            query += " [Fecha Apertura], start_date as [Fecha Comienzo Surtido], order_status.status as [Estatus], 'Ver Detalles'"
            query += " as Link from sale_order inner join clients on sale_order.customer = clients.id"
            query += " inner join order_status on sale_order.status = order_status.id left join employees on sale_order.vendor = employees.id"
            query += " where cast(convert(varchar, sale_order.date, 101) as date) >= '" + from_d + "'"
            query += " and cast(convert(varchar, sale_order.date, 101) as date) <= '" + to_d + "'"
            If location_st <> "0" Then
                query += " and clients.location = '" + location_st.ToString() + "'"
            End If
            query += " order by sale_order.date desc, sale_order.id"
            hf_qry.Value = query
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                gv_results.DataSource = ds
                gv_results.DataBind()
                btn_export.Enabled = True
                lbl_error.Text = ""
            Else
                gv_results.DataSource = Nothing
                gv_results.DataBind()
                btn_export.Enabled = False
                lbl_error.Text = "No existen pedidos para esta selección"
            End If

        Else
            btn_export.Enabled = False
            lbl_error.Text = "Formato de fechas incorrecto"
        End If

    End Sub

    Protected Sub btn_export_Click(sender As Object, e As EventArgs) Handles btn_export.Click
        Dim strFilename As String = "Pedidos_" + Now.Date.Day.ToString + "/" + Now.Date.Month.ToString + "/" + Now.Date.Year.ToString

        ds = Dataconnect.GetAll(hf_qry.Value)
        If ds.Tables(0).Rows.Count > 0 Then
            Response.AddHeader("content-disposition", "attachment;filename=" & strFilename & ".xls")
            Response.Clear()
            Response.Charset = ""
            Response.ContentType = "application/vnd.ms-excel"

            Dim stringWrite As System.IO.StringWriter = New System.IO.StringWriter()
            Dim htmlWrite As System.Web.UI.HtmlTextWriter = New System.Web.UI.HtmlTextWriter(stringWrite)
            Dim dg As System.Web.UI.WebControls.DataGrid = New System.Web.UI.WebControls.DataGrid()
            dg.DataSource = ds
            dg.DataBind()

            dg.RenderControl(htmlWrite)
            Response.Write(stringWrite.ToString())

            Response.End()
        End If
    End Sub

    Protected Sub gv_results_RowDataBound(ByVal sender As System.Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gv_results.RowDataBound
        Dim order_number As String
        order_number = e.Row.Cells(0).Text
        
        If order_number <> "No. orden" Then
            Dim Location As String = ResolveUrl("~/reportes/order_details.aspx") & "?order_no=" & order_number.ToString()

            e.Row.Cells(7).Attributes("onClick") = String.Format("javascript:window.location='{0}';", Location)
            e.Row.Cells(7).Style("cursor") = "pointer"
            e.Row.Cells(7).Style("color") = "blue"
        End If

    End Sub

    Protected Sub btn_get_report_items_Click(sender As Object, e As EventArgs) Handles btn_get_report_items.Click
        Dim from_d As String = Replace(from_date.Text & "'", "'", "").ToString()
        Dim to_d As String = Replace(to_date.Text & "'", "'", "").ToString()

        If IsDate(from_d) And IsDate(to_d) Then

            query = "select "
            'query += " --* "
            query += " order_id as [Pedido]"
            query += " ,items.PRODUCT_CODE AS [Producto]"
            query += " ,qty as [Cantidad Pedida]"
            query += " ,qty_picked as [Cantidad Surtida]"
            query += " ,(qty - qty_picked) as [Cantidad Negada]"
            query += " ,clients.name + ' ('+ clients.contact_name +')' as [Cliente]"
            query += " ,myorder.date as [Fecha]"
            'query += " ,mystatus.status as [Estatus]"
            'query += " ,employees.name + ' ' + employees.last_name as [Vendedor]"
            query += " ,'ver detalles' as link"
            query += " from sale_order_items items"
            query += " inner join sale_order myorder on items.order_id = myorder.id"
            query += " inner join order_status mystatus on myorder.status = mystatus.id"
            query += " inner join clients on myorder.customer = clients.id"
            query += " inner join employees on myorder.vendor = employees.id"
            query += " where cast(convert(varchar, myorder.date, 101) as date) >= '" + from_d + "'"
            query += " and cast(convert(varchar, myorder.date, 101) as date) <= '" + to_d + "'"

            If location_st <> "0" Then
                query += " and clients.location = '" + location_st.ToString() + "'"
            End If

            query += " order by myorder.date desc, order_id"

            hf_qry.Value = query
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                gv_results.DataSource = ds
                gv_results.DataBind()
                btn_export.Enabled = True
                lbl_error.Text = ""
            Else
                gv_results.DataSource = Nothing
                gv_results.DataBind()
                btn_export.Enabled = False
                lbl_error.Text = "No existen pedidos para esta seleccion"
            End If

        Else
            btn_export.Enabled = False
            lbl_error.Text = "formato de fechas incorrecto"
        End If
    End Sub

    
End Class
