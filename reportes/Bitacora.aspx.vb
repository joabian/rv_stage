Imports System.Data
Partial Class reportes_Bitacora
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet

    Protected Sub Button1_Click(sender As Object, e As System.EventArgs) Handles Button1.Click
        If IsDate(Request.Form("to_date").ToString()) Then
            Dim to_d As String = ""
            to_d = Request.Form("to_date")

            Dim strFilename As String = "Bitacora_" + to_d.ToString()

            Response.AddHeader("content-disposition", "attachment;filename=" & strFilename & ".xls")
            Response.Clear()
            Response.Charset = ""
            Response.ContentType = "application/vnd.ms-excel"

            Dim stringWrite As System.IO.StringWriter = New System.IO.StringWriter()
            Dim htmlWrite As System.Web.UI.HtmlTextWriter = New System.Web.UI.HtmlTextWriter(stringWrite)
            Dim dg As System.Web.UI.WebControls.DataGrid = New System.Web.UI.WebControls.DataGrid()

            query = "select update_date as [fecha de salida], product_code as [Codigo], qty as [Cantidad], qty_left as [Restan],"
            query += " name + ' ' + f_lastname as [empleado], destination as [destino] from bitacora"
            query += " inner join users on bitacora.employee = users.id where convert(varchar, update_date, 101)"
            query += " = '" + to_d.ToString() + "' order by update_date desc"

            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                dg.DataSource = ds
                dg.DataBind()
                lblerror.Text = ""
            Else
                dg.DataSource = Nothing
                dg.DataBind()
                lblerror.Text = "No existe bitacora para esta seleccion"
            End If

            dg.DataSource = ds.Tables(0)
            dg.DataBind()
            dg.RenderControl(htmlWrite)

            Response.Write(stringWrite.ToString())
            Response.End()

        Else
            lblerror.Text = "formato de fechas incorrecto"
        End If

        
    End Sub

    Protected Sub btn_get_report_Click(sender As Object, e As EventArgs) Handles btn_get_report.Click
        Dim to_d As String = ""
        to_d = Request.Form("to_date")
        refresh_gv_bitacora(to_d)
    End Sub

    Public Sub refresh_gv_bitacora(ByVal to_d As String)
        
        If IsDate(to_d) Then

            query = "select bitacora.id, convert(varchar, update_date, 101) as [Fecha de salida], convert(varchar, update_date, 108) as [Hora de salida], product_code as [Codigo], qty as [Cantidad], qty_left as [Restan],"
            query += " name + ' ' + f_lastname as [Empleado], destination as [Destino] from bitacora"
            query += " inner join users on bitacora.employee = users.id where convert(varchar, update_date, 101)"
            query += " = '" + to_d.ToString() + "' order by update_date desc"

            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                gv_bitacora.DataSource = ds
                gv_bitacora.DataBind()
                lblerror.Text = ""
            Else
                gv_bitacora.DataSource = Nothing
                gv_bitacora.DataBind()
                lblerror.Text = "No existe bitacora para esta seleccion"
            End If

        Else
            lblerror.Text = "formato de fechas incorrecto"
        End If
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            'populate_ddl_locations()
        End If
    End Sub

    Public Sub populate_ddl_locations()
        'query = "select alias from locations where transit = 0"
        'ds = Dataconnect.GetAll(query)
        'If ds.Tables(0).Rows.Count > 0 Then
        '    ddl_locations.DataSource = ds.Tables(0)
        '    ddl_locations.DataValueField = "alias"
        '    ddl_locations.DataTextField = "alias"
        '    ddl_locations.DataBind()
        'Else
        '    ddl_locations.DataSource = Nothing
        '    ddl_locations.DataBind()
        'End If
    End Sub

    Protected Sub gv_bitacora_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gv_bitacora.RowCreated
        e.Row.Cells(1).Visible = False
    End Sub

    Protected Sub gv_bitacora_RowDataBound(ByVal sender As System.Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gv_bitacora.RowDataBound
        'Dim item, order, palet As String
        'item = e.Row.Cells(4).Text
        'order = e.Row.Cells(6).Text
        'palet = e.Row.Cells(2).Text
        'If item <> "Parte #" Then

        '    query = "select * from tb_shipping_urgencies where active = 1 and item = '" + item + "'"
        '    ds = Dataconnect.GetAll(query)
        '    query_check = "select * from tb_shipping_urgencies where active = 1 and order_config = '" + order + "'"
        '    ds_check = Dataconnect.GetAll(query_check)

        '    If ds.Tables(0).Rows.Count > 0 Or ds_check.Tables(0).Rows.Count > 0 Then
        '        e.Row.BackColor = Drawing.Color.Red
        '        e.Row.ForeColor = Drawing.Color.White
        '    End If

        '    If order <> "&nbsp;" Then
        '        Dim Location As String = ResolveUrl("~/verif_order.aspx") & "?order=" & order
        '        e.Row.Cells(6).Attributes("onClick") = String.Format("javascript:window.location='{0}';", Location)
        '        e.Row.Cells(6).Style("cursor") = "pointer"
        '        'e.Row.Attributes("onClick") = String.Format("javascript:window.location='{0}';", Location)
        '        'e.Row.Style("cursor") = "pointer"
        '    End If

        '    If order = "&nbsp;" Then
        '        Dim Location As String = ResolveUrl("~/palet_id_sheet.aspx") & "?palet=" & palet
        '        e.Row.Cells(2).Attributes("onClick") = String.Format("javascript:window.location='{0}';", Location)
        '        e.Row.Cells(2).Style("cursor") = "pointer"
        '        'e.Row.Attributes("onClick") = String.Format("javascript:window.location='{0}';", Location)
        '        'e.Row.Style("cursor") = "pointer"
        '    End If

        '    query = "select * from tb_shipping_orders where verif = 0 and sales_order = '" + order + "'"
        '    ds = Dataconnect.GetAll(query)
        '    If ds.Tables(0).Rows.Count > 0 Then
        '        e.Row.BackColor = Drawing.Color.Orange
        '        e.Row.ForeColor = Drawing.Color.Black
        '    End If
        'Else

        'End If

    End Sub

    Protected Sub gv_bitacora_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles gv_bitacora.RowDeleting
        Dim record_id, record_date, queryLog, logevent, code, qty As String
        Dim username As String
        username = Membership.GetUser().UserName

        record_id = gv_bitacora.Rows(e.RowIndex).Cells(1).Text
        record_date = gv_bitacora.Rows(e.RowIndex).Cells(2).Text
        code = Replace(gv_bitacora.Rows(e.RowIndex).Cells(4).Text, " ", "")
        qty = gv_bitacora.Rows(e.RowIndex).Cells(5).Text
        Dim ori_qty, new_qty, product_id As String
        query = "delete from bitacora where id = " + record_id
        Dataconnect.runquery(query)
        query = "select * from stock where location = 'henequen' and rack = 'BOD' and product_code = '" + code.ToString() + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            ori_qty = ds.Tables(0).Rows(0)("qty").ToString()
            product_id = ds.Tables(0).Rows(0)("product_id").ToString()
            new_qty = (Convert.ToInt32(ori_qty) + Convert.ToInt32(qty)).ToString()
            query = "update stock set qty = " + new_qty.ToString() + " where location = 'henequen' and rack = 'BOD' and product_code = '" + code.ToString() + "'"
            query += " delete from stock where qty <= 0"
            Dataconnect.runquery(query)
            
        Else
            query = "select * from products inner join categories on products.category = categories.id where code = '" + code.ToString() + "'"
            ds = Dataconnect.GetAll(query)
            Dim description, categ_name, low_invent As String
            product_id = ds.Tables(0).Rows(0)("id").ToString()
            description = ds.Tables(0).Rows(0)("description").ToString()
            categ_name = ds.Tables(0).Rows(0)("name").ToString()
            low_invent = ds.Tables(0).Rows(0)("low_inventory").ToString()

            query = "insert into stock (product_id,product_code,product_description,product_model,product_low_inventory,"
            query += "product_category,qty,location,last_update,rack) values (" + product_id.ToString() + ", '" + code.ToString().ToUpper()
            query += "', '" + description + "', '" + code.ToString() + "', " + low_invent.ToString() + ", '" + categ_name
            query += "', " + qty.ToString() + ", 'henequen', getdate(), 'BOD')"
            Dataconnect.runquery(query)

            'select top 1 * from stock where location = 'henequen' and rack = 'BOD' 
        End If

        query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (" + product_id.ToString() + ", '" + code.ToString() + "', 'Devolucion', 'Entrada', 'Correccion de Bitacora', 'Henequen', 'BOD', '" + username.ToString() + "', getDate(), " + qty.ToString() + ")"
        Dataconnect.runquery(query)

        'select count(product_code) as piezas, product_code from stock where location = 'henequen' and rack = 'BOD' group by product_code order by piezas desc
        logevent = "Se removio registro de bitacora del " + record_date + ": codigo: " + code.ToString() + " por cantidad: " + qty.ToString()

        queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
        Dataconnect.runquery(queryLog)

        refresh_gv_bitacora(record_date)

    End Sub
End Class
