Imports System.Data
Imports OfficeOpenXml
Imports System.IO

Partial Class reportes_transferencias
    Inherits System.Web.UI.Page
    Public query As String
    Public query2 As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet
    Dim ExcelWorksheets As ExcelWorksheet

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            llenarSucursales()
        End If
    End Sub

    Public Sub llenarSucursales()
        query = "SELECT alias FROM locations WHERE transit = 0"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            ddlFromSuc.DataSource = ds.Tables(0)
            ddlFromSuc.DataValueField = "alias"
            ddlFromSuc.DataTextField = "alias"
            ddlFromSuc.DataBind()

            ddlToSuc.DataSource = ds.Tables(0)
            ddlToSuc.DataValueField = "alias"
            ddlToSuc.DataTextField = "alias"
            ddlToSuc.DataBind()
        Else
            ddlFromSuc.DataSource = Nothing
            ddlFromSuc.DataBind()

            ddlToSuc.DataSource = Nothing
            ddlToSuc.DataBind()
        End If
    End Sub

    Protected Sub btnGetReport_Click(sender As Object, e As EventArgs) Handles btnGetReport.Click
        Dim fromSuc, toSuc, codigo, fromDate, toDate As String
        fromDate = Request.Form("from_date").ToString()
        toDate = Request.Form("to_date").ToString()
        codigo = txtCodigo.Text.Replace(" ", "").ToUpper()
        fromSuc = ddlFromSuc.SelectedValue.ToString()
        toSuc = ddlToSuc.SelectedValue.ToString()

        query = "SELECT folio As Folio, codigo As Código, fromSucursal as [De Sucursal], fromRack As [De Rack], "
        query += "toSucursal as [A Sucursal], toRack As [A Rack], "
        query += "cantidad As Cantidad, fechaTransfer As [Fecha], usuario as [Transferencia por:] "
        query += "FROM transferencias "
		
        query += "WHERE "
        If fromSuc <> "0" Then
            query += "fromSucursal = '" + fromSuc + "' AND "
        End If
        If toSuc <> "0" Then
            query += "toSucursal = '" + toSuc + "' AND "
        End If
        If codigo <> "" Then
            query += "codigo = '" + codigo + "' AND "
        End If
        query += "CAST(CONVERT(varchar, fechaTransfer, 102) As datetime) >= '" + fromDate + "' AND "
        query += "CAST(CONVERT(varchar, fechaTransfer, 102) As datetime) <= '" + toDate + "' "
        query += "ORDER BY Fecha DESC"
        ds = Dataconnect.GetAll(query)
        hfQueryExport.Value = query
        If ds.Tables(0).Rows.Count > 0 Then
            gvTransfer.DataSource = ds
            gvTransfer.DataBind()
            btnExport.Enabled = True
            lblTitulo.Visible = True
            lblError.Text = ""
        Else
            gvTransfer.DataSource = Nothing
            gvTransfer.DataBind()
            btnExport.Enabled = False
            lblTitulo.Visible = False
            lblError.Text = "No hay Transferencias para los filtros seleccionados"
        End If
    End Sub

    Protected Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        Dim strFilename As String = "Transfer_Report_" + Now.Date.Day.ToString + "/" + Now.Date.Month.ToString + "/" + Now.Date.Year.ToString

        ds = Dataconnect.GetAll(hfQueryExport.Value)
        If ds.Tables(0).Rows.Count > 0 Then
            Response.AddHeader("content-disposition", "attachment;filename=" & strFilename & ".xls")
            Response.Clear()
            Response.Charset = ""
            Response.ContentType = "application/vnd.ms-excel"
            Response.ContentEncoding = System.Text.Encoding.Unicode
            Response.BinaryWrite(System.Text.Encoding.Unicode.GetPreamble())

            Dim stringWrite As System.IO.StringWriter = New System.IO.StringWriter()
            Dim htmlWrite As System.Web.UI.HtmlTextWriter = New System.Web.UI.HtmlTextWriter(stringWrite)
            Dim dg As System.Web.UI.WebControls.DataGrid = New System.Web.UI.WebControls.DataGrid()
            dg.DataSource = ds
            dg.DataBind()

            htmlWrite.Write("Reporte de Transferencias")
            dg.RenderControl(htmlWrite)
            Response.Write(stringWrite.ToString())

            Response.End()
        End If
    End Sub

End Class