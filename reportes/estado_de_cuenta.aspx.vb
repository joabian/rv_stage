Imports System.Data
Imports System.Globalization

Partial Class reportes_estado_de_cuenta
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds, ds2 As New DataSet

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            populateClientes()
        End If
    End Sub

    Public Sub populateClientes()
        Dim user As String
        user = Membership.GetUser().UserName
        Try
            query = "SELECT location FROM users WHERE user_name = '" + user + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                Dim location As String = ds.Tables(0).Rows(0)("location").ToString()
                Dim location_st As String = ""
                If location <> "0" Then
                    location_st = " AND location = " + location.ToString()
                End If

                query = "SELECT id, name FROM clients WHERE active = 1" + location_st.ToString() + " ORDER BY name"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    ddlCliente.DataSource = ds.Tables(0)
                    ddlCliente.DataTextField = "name"
                    ddlCliente.DataValueField = "id"
                    ddlCliente.DataBind()
                End If
            End If
        Catch ex As Exception
            'MsgBox(ex.Message)
        End Try
    End Sub

    Protected Sub btnGetEdoCta_Click(sender As Object, e As EventArgs) Handles btnGetEdoCta.Click
        Dim fromD As String = Replace(fromDate.Text & "'", "'", "").ToString()
        Dim toD As String = Replace(toDate.Text & "'", "'", "").ToString()
        Dim clientId As String = ddlCliente.SelectedValue.ToString()

        If fromD <> "" And toD <> "" And clientId <> "-" Then
            Try
                lblError.Text = ""
                query = "SELECT sale_order.id As [Id Orden], clients.name As Cliente, CONVERT(varchar, sale_order.date, 101) As [Fecha de Pedido], "
                query += "cants.total_rads As Radiadores, cants.total_tapas As Tapas, cants.total_insumos As [Accesorios e Insumos], pagosCatalogoStatus.statusPago As [Estatus], "
                query += "ISNULL((tots.Total + sale_order.flete), tots.Total) As Total, "
                query += "ISNULL(((tots.Total + sale_order.flete) - datosPagos.payTotal), (tots.Total + ISNULL(sale_order.flete, 0))) As Adeudo, datosPagos.lastPay As [Último Pago] "
                query += "FROM sale_order "
                query += "INNER JOIN clients ON sale_order.customer = clients.id "
                query += "INNER JOIN (Select order_id, "
                query += "SUM(CASE WHEN products.category = 1 THEN qty ELSE 0 END) As total_rads, "
                query += "SUM(Case When products.category = 2 Then qty Else 0 End) As total_tapas, "
                query += "SUM(CASE WHEN products.category = 25 THEN qty ELSE 0 END) As total_insumos "
                query += "FROM sale_order_items "
                query += "INNER JOIN products ON sale_order_items.product_code = products.code "
                query += "INNER JOIN sale_order On order_id= sale_order.id GROUP BY order_id) cants On cants.order_id = sale_order.id "
                query += "INNER JOIN pagosCatalogoStatus ON sale_order.estatus_pago = pagosCatalogoStatus.idStatusPago "
                query += "INNER JOIN (Select order_id, SUM(qty_picked * sold_price) As Total FROM sale_order_items GROUP BY order_id) tots On tots.order_id = sale_order.id "
                query += "LEFT JOIN (SELECT sale_order.id As id, SUM(pagos.pago) As payTotal, MAX(pagos.fechaPago) As lastPay FROM sale_order "
                query += "INNER JOIN pagos On sale_order.id = pagos.idOrden GROUP BY sale_order.id) datosPagos On datosPagos.id = sale_order.id "
                query += "WHERE sale_order.customer = " + clientId.ToString()
                query += "AND CAST(Convert(varchar, sale_order.date, 101) As Date) >= '" + fromD.ToString() + "' "
                query += "AND CAST(convert(varchar, sale_order.date, 101) As date) <= '" + toD.ToString() + "' "
                query += "ORDER BY sale_order.id DESC"
                ds = Dataconnect.GetAll(query)
                hf_qry.Value = query
                If ds.Tables(0).Rows.Count > 0 Then
                    gvEdoCta.DataSource = ds
                    gvEdoCta.DataBind()
                    btnExport.Enabled = True
                    lblTitulo.Visible = True
                Else
                    gvEdoCta.DataSource = Nothing
                    gvEdoCta.DataBind()
                    btnExport.Enabled = False
                    lblTitulo.Visible = False
                    lblError.Text = "No existen órdenes para esta seleccion"
                End If

            Catch ex As Exception
                'MsgBox("Ha ocurrido un error: " + ex.Message)
            End Try
        Else
            btnExport.Enabled = False
            lblError.Text = "Ingrese todos los datos"
        End If
    End Sub

    Protected Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        Dim strFilename As String = "Estado_de_Cuenta_" + ddlCliente.SelectedValue.ToString() + "_" + Now.Date.Day.ToString + "/" + Now.Date.Month.ToString + "/" + Now.Date.Year.ToString

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

            htmlWrite.Write("Estado de Cuenta")
            dg.RenderControl(htmlWrite)
            Response.Write(stringWrite.ToString())

            Response.End()
        End If
    End Sub
End Class
