Imports System.Data
Imports OfficeOpenXml
Imports System.IO

Partial Class reportes_stock_by_location
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds, dsTot As DataSet
    Public suc As String
    Dim ExcelWorksheets As ExcelWorksheet

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            populate_drop_list()
        End If
        suc = DDL_Location.Text.ToString
        query = "select sum(qty) as total from stock where location = '" + suc.ToString() + "'"
        dsTot = Dataconnect.GetAll(query)

    End Sub

    Public Sub populate_drop_list()
        query = "select * from locations"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            'populate courses list
            DDL_Location.DataSource = ds.Tables(0)
            DDL_Location.DataValueField = "id"
            DDL_Location.DataTextField = "alias"
            DDL_Location.DataBind()

        Else
            'disable button cuz no courses are in the sstem

        End If
    End Sub

    Protected Sub btn_export_Click(sender As Object, e As System.EventArgs) Handles btn_export.Click
        'downloadExcel()
        If DDL_Location.SelectedValue = "-" Then
            lbl_error.Text = "Seleccione Sucursal"
        Else
            lbl_error.Text = ""
            downloadExcelNew()
        End If

    End Sub

    Public Function getQuery() As String
        Dim q As String
        Dim suc As String = DDL_Location.SelectedItem.Text
        Dim suc_id As String = DDL_Location.SelectedValue.ToString()

        If chbx_rack_col.Checked = True Then
            'createPivotTable()
            query = "DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);"
            query += " SET @columns = N'';"
            query += " SELECT @columns += N', p.' + QUOTENAME(rack)"
            query += " FROM (SELECT top 100 percent p.rack FROM stock AS p where p.location = '" + suc.ToString() + "'"
            query += " GROUP BY p.rack order by p.rack) AS x;"
            query += " SET @sql = N'"
            query += " SELECT p.product_code, ' + STUFF(@columns, 1, 2, '') + '"
            query += " FROM ("
            query += " SELECT top 100 percent p.product_code, p.rack, p.qty FROM stock AS p where p.location = ''" + suc.ToString() + "''  order by  p.product_code ) AS j"
            query += " PIVOT"
            query += " (SUM(qty) FOR rack IN ('+ STUFF(REPLACE(@columns, ', p.[', ',['), 1, 1, '')+ ')) AS p;';"
            query += " EXEC sp_executesql @sql;"
        ElseIf chbx_rack.Checked = True Then
            query = "select product_code as modelo, min(product_description) as descripcion, product_category as categoria, sum(qty) as total, location as sucursal, rack"
            query += " from stock where location = '" + suc.ToString() + "' group by product_code, product_category, location, rack order by product_code"
        Else
            '            query = "select product_code as modelo, min(product_description) as descripcion, product_category as categoria, sum(qty) as total, location as sucursal"
            '           query += " from stock where location_id = '" + suc_id.ToString() + "' group by product_code, product_category, location order by product_code"

            query = "select stk.product_code as Codigo,stk.total_inv as 'Qty Total', stk.location as Sucursal,"
            query += " max_min.min_qty as Minimo, max_min.max_qty as Maximo, max_min.volumen as Volumen from "
            query += " (select product_code, sum(qty) as total_inv, location_id, location from stock group by product_code, location, location_id) as stk "
            query += " left join max_min on stk.location_id = max_min.location_id and stk.product_code = max_min.product_code"
            query += " where stk.location_id = " + suc_id.ToString()

        End If
        q = query

        Return q

    End Function

    Public Sub downloadExcelNew()
        suc = DDL_Location.SelectedItem.Text()
        Dim suc_id As String = DDL_Location.SelectedValue

        Dim strFilename As String = "Inventario_de_" + suc.ToString + "_" + Now.Date.Day.ToString + "/" + Now.Date.Month.ToString + "/" + Now.Date.Year.ToString

        ds = Dataconnect.GetAll(getQuery())

        Dim excel As New ExcelPackage()
        'Dim myworksheet As ExcelWorksheets
        ExcelWorksheets = excel.Workbook.Worksheets.Add("Reporte")
        Dim totalCols As Integer = ds.Tables(0).Columns.Count
        Dim totalRows As Integer = ds.Tables(0).Rows.Count
        ExcelWorksheets.Column(4).Style.Numberformat.Format = "0"

        For i = 0 To totalCols - 1
            ExcelWorksheets.SetValue(1, i + 1, ds.Tables(0).Columns(i).ColumnName)
        Next

        For j = 0 To totalRows - 1
            For m = 0 To totalCols - 1

                If Not IsDBNull(ds.Tables(0).Rows(j)(m)) Then
                    Dim val As String = ds.Tables(0).Rows(j)(m)
                    If IsNumeric(val) Then
                        If val = "0" Then
                            ExcelWorksheets.SetValue(j + 2, m + 1, Convert.ToInt32(val))
                        ElseIf Left(val, 1) = "0" Then
                            'ExcelWorksheets.Cells(j + 1, m + 1).Style.Numberformat.Format = "Text"
                            If Left(val, 2) = "0." Then
                                ExcelWorksheets.SetValue(j + 2, m + 1, Convert.ToDouble(val))
                            Else
                                ExcelWorksheets.SetValue(j + 2, m + 1, val)
                            End If
                        Else
                            Dim value As Double
                            If Double.TryParse(val, value) Then
                                ' text has been parsed as value, '
                                ' so you can use value however you see fit '
                                ExcelWorksheets.SetValue(j + 2, m + 1, Convert.ToDouble(val))
                            Else
                                ' text was not a valid double, so you can '
                                ' notify the user or do whatever you want... '
                                ' note that value will be zero in this case '
                                If Right(val, 1) = "+" Then
                                    ExcelWorksheets.SetValue(j + 2, m + 1, val)
                                Else
                                    ExcelWorksheets.SetValue(j + 2, m + 1, Convert.ToInt32(val))
                                End If
                            End If
                        End If
                    ElseIf TypeName(val) = "Date" Then
                        ExcelWorksheets.SetValue(j + 2, m + 1, Convert.ToDateTime(val))
                        ExcelWorksheets.Cells(j + 2, m + 1).Style.Numberformat.Format = "MM/dd/yyyy"
                    Else
                        ExcelWorksheets.SetValue(j + 2, m + 1, val)
                    End If

                End If

            Next
        Next

        Dim memoryStream As New MemoryStream()
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        Response.AddHeader("content-disposition", "attachment;  filename=" + strFilename.ToString() + ".xlsx")
        excel.SaveAs(memoryStream)
        memoryStream.WriteTo(Response.OutputStream)
        Response.Flush()
        Response.End()

    End Sub

    Public Sub createPivotTable()
        Dim ds_products, ds_racks As DataSet
        Dim mytable, tableheaders, tablebody As String
        Dim mydatatable As DataTable
        query = "select distinct product_code from stock where location = '" + suc.ToString() + "'"
        ds_products = Dataconnect.GetAll(query)
        If ds_products.Tables(0).Rows.Count > 0 Then
            mytable = "<table>"
            query = "select distinct rack from stock where location = '" + suc.ToString() + "' order by rack"
            ds_racks = Dataconnect.GetAll(query)
            tableheaders = "<th>Codigo</th>"

            mydatatable.Columns.Add("Codigo")

            If ds_racks.Tables(0).Rows.Count > 0 Then
                Dim rack As String



                For m = 0 To ds_racks.Tables(0).Rows.Count - 1
                    rack = ds_racks.Tables(0).Rows(m)("rack").ToString()
                    tableheaders += "<th>" + rack.ToString() + "</th>"
                    mydatatable.Columns.Add(rack)
                Next

                For i = 0 To ds_products.Tables(0).Rows.Count - 1
                    Dim product_code As String = ds_products.Tables(0).Rows(i)("product_code").ToString()
                    tablebody += "<tr><td>" + product_code.ToString() + "</td>"
                    For j = 0 To ds_racks.Tables(0).Rows.Count - 1
                        rack = ds_racks.Tables(0).Rows(j)("rack").ToString()

                        query = "select qty from stock where location = '" + suc.ToString() + "' and product_code = '" + product_code.ToString() + "' and rack = '" + rack.ToString() + "'"
                        ds = Dataconnect.GetAll(query)
                        If ds.Tables(0).Rows.Count > 0 Then
                            tablebody += "<td>" + ds.Tables(0).Rows(0)("qty").ToString() + "</td>"
                        Else
                            tablebody += "<td></td>"
                        End If
                    Next
                    query = "select sum(qty) as total from stock where location = '" + suc.ToString() + "' and product_code = '" + product_code.ToString() + "'"
                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        tablebody += "<td>" + ds.Tables(0).Rows(0)("total").ToString() + "</td>"
                    Else
                        tablebody += "<td></td>"
                    End If

                    tablebody += "</tr>"
                Next

                mytable += "<tr>" + tableheaders.ToString + "<th>Total</th></tr>" + tablebody.ToString()

                Dim response_string As String
                Response.Clear()
                Response.Buffer = True
                Response.ContentType = "application/vnd.ms-excel"
                Response.Charset = "UTF-8?"
                Response.AddHeader("Content-Disposition", "attachment;filename=Reporte")
                Response.ContentEncoding = Encoding.Default
                response_string = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">"
                response_string += "<font style='font-size:11.0pt;'>"
                response_string += mytable
                response_string += "</font>"
                Response.Write(response_string)
                Response.End()

            End If
        End If

    End Sub

    Public Sub createTable(ByVal ds As DataSet)
        Dim htmlTable As String = "<table border='1' style='border-collapse:collapse' align='center'><tr>"
        For j = 0 To ds.Tables(0).Columns.Count - 1
            htmlTable += "<th>" + ds.Tables(0).Columns(j).ColumnName.ToString() + "</th>"
        Next
        htmlTable += "</tr>"
        For i = 0 To ds.Tables(0).Rows.Count - 1
            htmlTable += "<tr>"
            For m = 0 To ds.Tables(0).Columns.Count - 1
                htmlTable += "<td>" + ds.Tables(0).Rows(i)(m).ToString() + "</td>"
            Next
            htmlTable += "</tr>"

        Next
        htmlTable += "</table>"

        lbl_table.Text = htmlTable

    End Sub

    Protected Sub btn_run_report_Click(sender As Object, e As EventArgs) Handles btn_run_report.Click



        'If chbx_rack.Checked = True Then
        '    query = "select product_code as modelo, min(product_description) as descripcion, product_category as categoria, sum(qty) as total, location as sucursal, rack"
        '    query += " from stock where location = '" + suc.ToString() + "' group by product_code, product_category, location, rack order by product_code"
        'Else
        '    'query = "select product_code as modelo, min(product_description) as descripcion, product_category as categoria, sum(qty) as total, location as sucursal"
        '    'query += " from stock where location = '" + suc.ToString() + "' group by product_code, product_category, location order by product_code"

        '    query = "select stk.product_code as Codigo,stk.total_inv as 'Qty Total', stk.location as Sucursal,"
        '    query += " max_min.min_qty as Minimo, max_min.max_qty as Maximo, max_min.volumen as Volumen from "
        '    query += " (select product_code, sum(qty) as total_inv, location_id, location from stock group by product_code, location, location_id) as stk "
        '    query += " left join max_min on stk.location_id = max_min.location_id and stk.product_code = max_min.product_code"
        '    query += " where stk.location_id = " + suc_id.ToString()

        'End If


        ds = Dataconnect.GetAll(getQuery())
        If ds.Tables(0).Rows.Count > 0 Then
            createTable(ds)
        Else
            lbl_table.Text = ""
        End If


    End Sub

    Protected Sub btn_merc_ceros_Click(sender As Object, e As EventArgs) Handles btn_merc_ceros.Click
        If DDL_Location.SelectedValue = "-" Then
            lbl_error.Text = "Seleccione Sucursal"
        Else
            lbl_error.Text = ""
            bajarMercanciaEnCeros()
        End If
    End Sub

    Public Sub bajarMercanciaEnCeros()
        query = "Select code, description from products where code not in ("
        query += "select product_code from stock where location = '" + DDL_Location.SelectedItem.Text + "')"
        hifd_query.Value = query

        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            createTable(ds)
        Else
            lbl_table.Text = ""
        End If
    End Sub

End Class
