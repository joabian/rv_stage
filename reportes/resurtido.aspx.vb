Imports System.Data
Imports OfficeOpenXml
Imports System.IO

Partial Class reportes_resurtido
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds, dsTot As DataSet
    Public suc As String
    Dim ExcelWorksheets As ExcelWorksheet

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        'If Not IsPostBack Then
        '    populate_drop_list()
        'End If
        'suc = DDL_Location.Text.ToString
        'query = "select sum(qty) as total from stock where location = '" + suc.ToString() + "'"
        'dsTot = Dataconnect.GetAll(query)

    End Sub

    'Public Sub populate_drop_list()
    '    query = "select * from locations"
    '    ds = Dataconnect.GetAll(query)
    '    If ds.Tables(0).Rows.Count > 0 Then
    '        'populate courses list
    '        DDL_Location.DataSource = ds.Tables(0)
    '        DDL_Location.DataValueField = "id"
    '        DDL_Location.DataTextField = "alias"
    '        DDL_Location.DataBind()

    '    Else
    '        'disable button cuz no courses are in the sstem

    '    End If
    'End Sub

    'Protected Sub btn_export_Click(sender As Object, e As System.EventArgs) Handles btn_export.Click
    '    'downloadExcel()
    '    If DDL_Location.SelectedValue = "-" Then
    '        lbl_error.Text = "Seleccione Sucursal"
    '    Else
    '        lbl_error.Text = ""
    '        downloadExcelNew()
    '    End If

    'End Sub

    'Public Sub downloadExcelNew()
    '    suc = DDL_Location.SelectedItem.Text()
    '    Dim suc_id As String = DDL_Location.SelectedValue

    '    Dim strFilename As String = "Resurtido_para_" + suc.ToString + "_" + Now.Date.Day.ToString + "/" + Now.Date.Month.ToString + "/" + Now.Date.Year.ToString

    '    query = "select stk.product_code,stk.total_inv, stk.location, "
    '    query += " max_min.min_qty as minimo, max_min.max_qty as maximo, max_min.volumen as volumen"
    '    query += " ,max_min.max_qty - stk.total_inv as 'Piezas faltantes'"
    '    query += " ,CEILING((max_min.max_qty - stk.total_inv)/cast(products.tam_caja as float)) as 'Cajas a Resurtir'"
    '    query += " from "
    '    query += " (select product_code, sum(qty) as total_inv, location_id, location from stock where rack = 'ALMACEN' group by product_code, location, location_id) as stk "
    '    query += " inner join max_min on stk.location_id = max_min.location_id and stk.product_code = max_min.product_code"
    '    query += " inner join products on stk.product_code = products.code"
    '    query += " where stk.location_id = " + suc_id.ToString + " and products.tam_caja is not null"
    '    query += " and max_min.min_qty > stk.total_inv"
    '    query += " order by max_min.max_qty - stk.total_inv desc"

    '    ds = Dataconnect.GetAll(query)

    '    Dim excel As New ExcelPackage()
    '    'Dim myworksheet As ExcelWorksheets
    '    ExcelWorksheets = excel.Workbook.Worksheets.Add("Reporte")
    '    Dim totalCols As Integer = ds.Tables(0).Columns.Count
    '    Dim totalRows As Integer = ds.Tables(0).Rows.Count
    '    ExcelWorksheets.Column(4).Style.Numberformat.Format = "0"

    '    For i = 0 To totalCols - 1
    '        ExcelWorksheets.SetValue(1, i + 1, ds.Tables(0).Columns(i).ColumnName)
    '    Next

    '    For j = 0 To totalRows - 1
    '        For m = 0 To totalCols - 1

    '            If Not IsDBNull(ds.Tables(0).Rows(j)(m)) Then
    '                Dim val As String = ds.Tables(0).Rows(j)(m)
    '                If IsNumeric(val) Then
    '                    If val = "0" Then
    '                        ExcelWorksheets.SetValue(j + 2, m + 1, Convert.ToInt32(val))
    '                    ElseIf Left(val, 1) = "0" Then
    '                        'ExcelWorksheets.Cells(j + 1, m + 1).Style.Numberformat.Format = "Text"
    '                        If Left(val, 2) = "0." Then
    '                            ExcelWorksheets.SetValue(j + 2, m + 1, Convert.ToDouble(val))
    '                        Else
    '                            ExcelWorksheets.SetValue(j + 2, m + 1, val)
    '                        End If
    '                    Else
    '                        Dim value As Double
    '                        If Double.TryParse(val, value) Then
    '                            ' text has been parsed as value, '
    '                            ' so you can use value however you see fit '
    '                            ExcelWorksheets.SetValue(j + 2, m + 1, Convert.ToDouble(val))
    '                        Else
    '                            ' text was not a valid double, so you can '
    '                            ' notify the user or do whatever you want... '
    '                            ' note that value will be zero in this case '
    '                            If Right(val, 1) = "+" Then
    '                                ExcelWorksheets.SetValue(j + 2, m + 1, val)
    '                            Else
    '                                ExcelWorksheets.SetValue(j + 2, m + 1, Convert.ToInt32(val))
    '                            End If
    '                        End If
    '                    End If
    '                ElseIf TypeName(val) = "Date" Then
    '                    ExcelWorksheets.SetValue(j + 2, m + 1, Convert.ToDateTime(val))
    '                    ExcelWorksheets.Cells(j + 2, m + 1).Style.Numberformat.Format = "MM/dd/yyyy"
    '                Else
    '                    ExcelWorksheets.SetValue(j + 2, m + 1, val)
    '                End If

    '            End If

    '        Next
    '    Next

    '    Dim memoryStream As New MemoryStream()
    '    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    '    Response.AddHeader("content-disposition", "attachment;  filename=" + strFilename.ToString() + ".xlsx")
    '    excel.SaveAs(memoryStream)
    '    memoryStream.WriteTo(Response.OutputStream)
    '    Response.Flush()
    '    Response.End()

    'End Sub

    'Protected Sub btn_run_report_Click(sender As Object, e As EventArgs) Handles btn_run_report.Click
    '    Dim suc As String = DDL_Location.SelectedItem.Text
    '    Dim suc_id As String = DDL_Location.SelectedValue.ToString()

    '    query = "select stk.product_code as codigo,stk.total_inv as QTY,"
    '    query += " max_min.min_qty as minimo, max_min.max_qty as maximo, max_min.volumen as volumen"
    '    query += " ,max_min.max_qty - stk.total_inv as 'Piezas faltantes'"
    '    query += " ,CEILING((max_min.max_qty - stk.total_inv)/cast(products.tam_caja as float)) as 'Cajas a Resurtir'"
    '    query += " from "
    '    query += " (select product_code, sum(qty) as total_inv, location_id, location from stock where rack = 'ALMACEN' group by product_code, location, location_id) as stk "
    '    query += " inner join max_min on stk.location_id = max_min.location_id and stk.product_code = max_min.product_code"
    '    query += " inner join products on stk.product_code = products.code"
    '    query += " where stk.location_id = " + suc_id.ToString + " and products.tam_caja is not null"
    '    query += " and max_min.min_qty > stk.total_inv"
    '    query += " order by max_min.max_qty - stk.total_inv desc"

    '    ds = Dataconnect.GetAll(query)
    '    If ds.Tables(0).Rows.Count > 0 Then
    '        'GridView1.DataSource = ds.Tables(0)
    '        'GridView1.DataBind()
    '        createTable(ds)
    '    Else
    '        'GridView1.DataSource = Nothing
    '        'GridView1.DataBind()
    '        lbl_table.Text = "No data"
    '    End If


    'End Sub

    'Public Sub createTable(ByVal ds As DataSet)
    '    Dim htmlTable As String = "<table border='1' style='border-collapse:collapse'><tr>"
    '    For j = 0 To ds.Tables(0).Columns.Count - 1
    '        htmlTable += "<th>" + ds.Tables(0).Columns(j).ColumnName.ToString() + "</th>"
    '    Next
    '    htmlTable += "<th>Locaciones adicionales " + DDL_Location.SelectedItem.Text + "</th><th>Otras Sucursales</th></tr>"
    '    For i = 0 To ds.Tables(0).Rows.Count - 1
    '        htmlTable += "<tr>"
    '        For m = 0 To ds.Tables(0).Columns.Count - 1
    '            htmlTable += "<td>" + ds.Tables(0).Rows(i)(m).ToString() + "</td>"
    '        Next
    '        htmlTable += "<td>"

    '        Dim prod As String = ds.Tables(0).Rows(i)("codigo").ToString()
    '        query = "select rack, qty from stock where rack <> 'ALMACEN' and product_code = '" + prod.ToString() + "' and location = '" + DDL_Location.SelectedItem.Text.ToString() + "'"
    '        dsTot = Dataconnect.GetAll(query)
    '        If dsTot.Tables(0).Rows.Count > 0 Then
    '            For y = 0 To dsTot.Tables(0).Rows.Count - 1
    '                htmlTable += dsTot.Tables(0).Rows(y)("rack").ToString.ToUpper + " = " + dsTot.Tables(0).Rows(y)("qty").ToString() + ", "
    '            Next
    '        End If
    '        htmlTable += "</td><td>"

    '        query = "select location, sum(qty) as tot from stock where product_code = '" + prod.ToString() + "' and location <> '" + DDL_Location.SelectedItem.Text.ToString() + "'"
    '        query += " group by location"
    '        dsTot = Dataconnect.GetAll(query)
    '        If dsTot.Tables(0).Rows.Count > 0 Then
    '            For y = 0 To dsTot.Tables(0).Rows.Count - 1
    '                htmlTable += dsTot.Tables(0).Rows(y)("location").ToString.ToUpper + " = " + dsTot.Tables(0).Rows(y)("tot").ToString() + ", "
    '            Next
    '        End If
    '        htmlTable += "</td>"

    '        htmlTable += "<td>"
    '        htmlTable += "<img src='../images/icons/arrowLeft.png' style='cursor:pointer; width:15px;' onClick='showTransferDiv(""" + ds.Tables(0).Rows(i)("Codigo").ToString() + """);' />"
    '        htmlTable += "</td>"
    '        htmlTable += "</tr>"


    '    Next
    '    htmlTable += "</table>"

    '    lbl_table.Text = htmlTable

    'End Sub

End Class
