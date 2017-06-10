Imports System.Data
Partial Class reportes_pedidos_tapa
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet

    Protected Sub btn_get_report_Click(sender As Object, e As EventArgs) Handles btn_get_report.Click
        Dim order_num As String = Replace(order_number.Text & "'", "'", "").ToString()


        If order_num = "" Or Not IsNumeric(order_num) Then
            btn_export.Enabled = False
            lbl_error.Text = "Ingrese los datos correctamente"

        Else

            query = "select item as Código, convert(varchar, scan_date, 101) as Fecha, right(convert(varchar, scan_date, 100),7) as [Hora] "
            query += " from sale_order_each_scan where order_id = '" + order_num + "'"
            query += " order by scan_date"
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
                lbl_error.Text = "No existen datos para esta selección"
            End If
        End If

    End Sub

    Protected Sub btn_export_Click(sender As Object, e As EventArgs) Handles btn_export.Click
        Dim strFilename As String = "Escaneo_por_tapa_pedido_" + order_number.Text

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

    

End Class
