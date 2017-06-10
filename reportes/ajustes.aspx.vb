Imports System.Data
Partial Class reportes_ajustes
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet



    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        query = "select "
        query += " username as 'Requisitor'"
        query += " ,location as 'Sucursal'"
        query += " ,tipo as 'Tipo'"
        query += " ,item as 'Item'"
        query += " ,rack as 'Rack'"
        query += " ,qty as 'Cantidad'"
        query += " ,notes as 'Notas del Requisitor'"
        query += " ,create_date as 'Fecha de Requisición'"
        query += " ,case when approved = 1 then 'Si' else 'No' end as 'Aprobado'"
        query += " ,approved_user as 'Aprobado por'"
        query += " ,approved_date as 'Fecha de Aprobación'"
        query += " ,case when rejected = 1 then 'Si' else 'No' end as 'Rechazado'"
        query += " ,rejected_date as 'Fecha de Rechazo'"
        query += " ,resolved_comments as 'Comentarios de Resolución'"
        query += " from ajustes where create_date > getdate()-7"
        query += " order by create_date desc"
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

            query = "select "
            query += " username as 'Requisitor'"
            query += " ,location as 'Sucursal'"
            query += " ,tipo as 'Tipo'"
            query += " ,item as 'Item'"
            query += " ,rack as 'Rack'"
            query += " ,qty as 'Cantidad'"
            query += " ,notes as 'Notas del Requisitor'"
            query += " ,create_date as 'Fecha de Requisición'"
            query += " ,case when approved = 1 then 'Si' else 'No' end as 'Aprobado'"
            query += " ,approved_user as 'Aprobado por'"
            query += " ,approved_date as 'Fecha de Aprobación'"
            query += " ,case when rejected = 1 then 'Si' else 'No' end as 'Rechazado'"
            query += " ,rejected_date as 'Fecha de Rechazo'"
            query += " ,resolved_comments as 'Comentarios de Resolución'"
            query += " from ajustes where cast(convert(varchar, create_date, 101) as date) >= '" + from_d + "'"
            query += " and cast(convert(varchar, create_date, 101) as date) <= '" + to_d + "'"
            query += " order by create_date desc"
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
