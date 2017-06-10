Imports System.Data

Partial Class usuarios_terminalsql
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet

    Protected Sub Button1_Click(sender As Object, e As System.EventArgs) Handles Button1.Click
        query = txt_query.Text
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            gv_query.DataSource = ds.Tables(0)
            gv_query.DataBind()
        Else
            lbl_error.Text = "No records"
            gv_query.Visible = False
        End If

    End Sub

    Protected Sub Button2_Click(sender As Object, e As System.EventArgs) Handles Button2.Click
        query = txt_query.Text
        Dataconnect.runquery(query)
        Response.Redirect("terminalsql.aspx")
    End Sub

Protected Sub Button3_Click(sender As Object, e As System.EventArgs) Handles Button3.Click
        query = txt_query.Text
        ds = Dataconnect.GetAll_asp(query)
        If ds.Tables(0).Rows.Count > 0 Then
            gv_query.DataSource = ds.Tables(0)
            gv_query.DataBind()
        Else
            lbl_error.Text = "No records"
            gv_query.Visible = False
        End If

    End Sub

    Protected Sub Button4_Click(sender As Object, e As System.EventArgs) Handles Button4.Click
        query = txt_query.Text
        Dataconnect.runquery_asp(query)
        Response.Redirect("terminalsql.aspx")
    End Sub


    'Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
    '    Dim computername As String() = System.Net.Dns.GetHostEntry(System.Web.HttpContext.Current.Request.ServerVariables("remote_addr")).HostName.Split(New Char() {"."c})

    '    Dim computer As String = computername(0)

    '    lbl_compuname.Text = computer.ToString()

    'End Sub

    Protected Sub btn_download_Click(sender As Object, e As EventArgs) Handles btn_download.Click

        query = txt_query.Text

        Dim strFilename As String = "Query_Results"

        Response.AddHeader("content-disposition", "attachment;filename=" & strFilename & ".xls")
        Response.Clear()
        Response.Charset = ""
        Response.ContentType = "application/vnd.ms-excel"

        Dim stringWrite As System.IO.StringWriter = New System.IO.StringWriter()
        Dim htmlWrite As System.Web.UI.HtmlTextWriter = New System.Web.UI.HtmlTextWriter(stringWrite)
        Dim dg As System.Web.UI.WebControls.DataGrid = New System.Web.UI.WebControls.DataGrid()

        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            dg.DataSource = ds
            dg.DataBind()
        Else
            dg.DataSource = Nothing
            dg.DataBind()
        End If

        dg.DataSource = ds.Tables(0)
        dg.DataBind()
        dg.RenderControl(htmlWrite)

        Response.Write(stringWrite.ToString())
        Response.End()

    End Sub
End Class
