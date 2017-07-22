Imports System.Data
Partial Class reportes_clientes
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            populate_clientes()
        End If
    End Sub

    Public Sub populate_clientes()
        Dim user As String
        lblIdCliente.Text = ""
        lblNombreCliente.Text = ""
        lblTelefono.Text = ""

        user = Membership.GetUser().UserName
        query = "select location from users where user_name = '" + user + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            Dim location As String = ds.Tables(0).Rows(0)("location").ToString()
            Dim location_st As String = ""
            If location <> "0" Then
                location_st = " and location = " + location.ToString()
            End If

            query = "select id, name from clients where active = 1"
            query += location_st.ToString()
            query += " order by name"
            ds = Dataconnect.GetAll(query)

            If ds.Tables(0).Rows.Count > 0 Then
                'do something
                ddl_cliente.DataSource = ds.Tables(0)
                ddl_cliente.DataTextField = "name"
                ddl_cliente.DataValueField = "id"
                ddl_cliente.DataBind()
            Else

            End If
        Else
            'No data

        End If

    End Sub

    Private Sub getData(idCte As String)
        Dim telCte, nomCte As String
        telCte = ""
        nomCte = ""
        query = "SELECT name, telephone FROM clients WHERE id = " + idCte
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            nomCte = ds.Tables(0).Rows(0)("name")
            telCte = ds.Tables(0).Rows(0)("telephone")
        End If
        lblIdCliente.Text = idCte
        lblNombreCliente.Text = nomCte
        lblTelefono.Text = telCte
    End Sub

    Protected Sub btn_get_report_Click(sender As Object, e As EventArgs) Handles btn_get_report.Click
        Dim from_d As String = Replace(from_date.Text & "'", "'", "").ToString()
        Dim to_d As String = Replace(to_date.Text & "'", "'", "").ToString()
        Dim client_id As String = ddl_cliente.SelectedValue.ToString()

        If IsDate(from_d) And IsDate(to_d) And client_id <> "-" Then

            query = "select  "
            query += "	categories.name as Categoria"
            query += "	,sum(qty_picked) as [Cantidad de piezas]"
            query += "	,sum(qty_picked * sold_price) as [$ Total]"
            query += " from sale_order_items"
            query += " inner join sale_order  on sale_order_items.order_id = sale_order.id"
            query += " inner join products on sale_order_items.product_code = products.code"
            query += " inner join categories on products.category = categories.id"
            query += " where sale_order_items.active = 1"
            query += " and sale_order.customer = " + client_id.ToString()
            query += " and status > 4 "
            query += " and status <> 7"
            query += " and cast(convert(varchar, sale_order.date, 101) as date) >= '" + from_d + "' "
            query += " and cast(convert(varchar, sale_order.date, 101) as date) <= '" + to_d + "' "
            query += " group by categories.name"
            query += " having sum(qty_picked) > 0"
            query += " order by sum(qty_picked) desc"
            ds = Dataconnect.GetAll(query)
            hf_qry2.Value = query
            If ds.Tables(0).Rows.Count > 0 Then
                gv_summary.DataSource = ds
                gv_summary.DataBind()
            Else
                gv_summary.DataSource = Nothing
                gv_summary.DataBind()
            End If


            query = "select sale_order.id as [No. Orden], "
            query += " employees.name + ' ' + employees.last_name as [Vendedor], sale_order.date as"
            query += " [Fecha apertura], start_date as [Fecha comienzo surtido], order_status.status as [Status], 'Ver detalles'"
            query += " as Link from sale_order "
            query += " inner join order_status on sale_order.status = order_status.id left join employees on sale_order.vendor = employees.id"
            query += " where sale_order.customer = " + client_id.ToString() + " and cast(convert(varchar, sale_order.date, 101) as date) >= '" + from_d + "'"
            query += " and cast(convert(varchar, sale_order.date, 101) as date) <= '" + to_d + "'"
            query += " order by sale_order.date desc, sale_order.id"
            hf_qry.Value = query
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                gv_results.DataSource = ds
                gv_results.DataBind()
                btn_export.Enabled = True
                lbl_error.Text = ""
                lblOrd.Visible = True
                lblProd.Visible = True
                pnlDatosCliente.Visible = True
                getData(client_id)
            Else
                gv_results.DataSource = Nothing
                gv_results.DataBind()
                btn_export.Enabled = False
                lbl_error.Text = "No existen pedidos para esta seleccion"
                lblOrd.Visible = False
                lblProd.Visible = False
                pnlDatosCliente.Visible = False
            End If

        Else
            btn_export.Enabled = False
            lbl_error.Text = "Ingrese todos los datos"
            lblOrd.Visible = False
            lblProd.Visible = False
            pnlDatosCliente.Visible = False
        End If

    End Sub

    Protected Sub btn_export_Click(sender As Object, e As EventArgs) Handles btn_export.Click
        Dim strFilename As String = "Pedidos_Cliente_" + ddl_cliente.SelectedValue.ToString() + "_" + Now.Date.Day.ToString + "/" + Now.Date.Month.ToString + "/" + Now.Date.Year.ToString

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

            ds = Dataconnect.GetAll(hf_qry2.Value)
            Dim dg2 As System.Web.UI.WebControls.DataGrid = New System.Web.UI.WebControls.DataGrid()
            dg2.DataSource = ds
            dg2.DataBind()

            htmlWrite.Write("Summario")
            dg2.RenderControl(htmlWrite)
            htmlWrite.Write("<br>Pedidos")
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

            e.Row.Cells(5).Attributes("onClick") = String.Format("javascript:window.location='{0}';", Location)
            e.Row.Cells(5).Style("cursor") = "pointer"
            e.Row.Cells(5).Style("color") = "blue"
        End If

    End Sub


End Class
