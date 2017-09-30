Imports System.Data

Partial Class reportes_ajustes
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        query = "SELECT username As 'Requisitor', location As 'Sucursal', tipo As 'Tipo', item As 'Item', rack As 'Rack', qty As 'Cantidad', "
        query += "notes As 'Notas del Requisitor', create_date As 'Fecha de Requisición', "
        query += "CASE WHEN (approved Is NULL AND rejected Is NULL) THEN 'PENDIENTE' ELSE "
        query += "CASE WHEN (approved = 1 AND rejected Is NULL) THEN 'APROBADO' ELSE "
        query += "CASE WHEN (approved Is NULL AND rejected = 1) THEN 'RECHAZADO' END END END As 'Estatus', "
        query += "CASE WHEN (approved_date Is NULL AND rejected_date Is NULL) THEN NULL ELSE "
        query += "CASE WHEN (approved_date Is Not NULL AND rejected_date Is NULL) THEN approved_date ELSE "
        query += "CASE WHEN (approved_date Is NULL AND rejected_date Is Not NULL) THEN rejected_date END END END As 'Fecha de Resolución', "
        query += "approved_user As 'Resuelto por', "
        query += "resolved_comments As 'Comentarios de Resolución' "
        query += "FROM ajustes "
        query += "WHERE create_date > getdate() - 7 "
        query += "ORDER By create_date DESC "
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
    End Sub

    Protected Sub btn_get_report_Click(sender As Object, e As EventArgs) Handles btn_get_report.Click
        Dim from_d As String = Replace(from_date.Text & "'", "'", "").ToString()
        Dim to_d As String = Replace(to_date.Text & "'", "'", "").ToString()

        If IsDate(from_d) And IsDate(to_d) Then
            query = "SELECT username As 'Requisitor', location As 'Sucursal', tipo As 'Tipo', item As 'Item', rack As 'Rack', qty As 'Cantidad', "
            query += "notes As 'Notas del Requisitor', create_date As 'Fecha de Requisición', "
            query += "CASE WHEN (approved IS NULL AND rejected IS NULL) THEN 'PENDIENTE' ELSE "
            query += "CASE WHEN (approved = 1 AND rejected IS NULL) THEN 'APROBADO' ELSE "
            query += "CASE WHEN (approved IS NULL AND rejected = 1) THEN 'RECHAZADO' END END END As 'Estatus', "
            query += "CASE WHEN (approved_date IS NULL AND rejected_date IS NULL) THEN NULL ELSE "
            query += "CASE WHEN (approved_date IS NOT NULL AND rejected_date IS NULL) THEN approved_date ELSE "
            query += "CASE WHEN (approved_date IS NULL AND rejected_date IS NOT NULL) THEN rejected_date END END END As 'Fecha de Resolución', "
            query += "approved_user As 'Resuelto por', "
            query += "resolved_comments As 'Comentarios de Resolución' "
            query += "FROM ajustes "
            query += "WHERE CAST(CONVERT(varchar, create_date, 101) As date) >= '" + from_d + "' "
            query += "AND CAST(CONVERT(varchar, create_date, 101) As date) <= '" + to_d + "' "
            query += "ORDER BY create_date DESC"
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
                lbl_error.Text = "No existen ajustes para esta selección"
            End If
        Else
            btn_export.Enabled = False
            lbl_error.Text = "Formato de fechas incorrecto"
        End If
    End Sub

    Protected Sub btn_export_Click(sender As Object, e As EventArgs) Handles btn_export.Click
        Dim strFilename As String = "Ajustes_" + Now.Date.Day.ToString + "-" + Now.Date.Month.ToString + "-" + Now.Date.Year.ToString

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
