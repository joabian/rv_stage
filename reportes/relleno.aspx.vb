Imports System.Data
Imports System.Text
Imports System.Drawing
Imports OfficeOpenXml
Imports System.IO
Imports Excel

Partial Class reportes_relleno
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public logevent As String
    Public username As String
    Dim ExcelWorksheets As ExcelWorksheet

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim username As String
            Dim location_st As String = "0"
            Dim location_st_name As String = ""
            username = Membership.GetUser().UserName
            query = "select location, alias from users left join locations on users.location = locations.id where user_name = '" + username + "' "
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                location_st_name = ds.Tables(0).Rows(0)("alias").ToString()
                location_st = ds.Tables(0).Rows(0)("location").ToString()
                If location_st = "0" Then
                    query = "select alias from locations"
                Else
                    query = "select alias from locations"
                    'query = "select alias from locations where id = " + location_st.ToString()
                End If
            End If

            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                ddl_from_location.DataSource = ds.Tables(0)
                ddl_from_location.DataValueField = "alias"
                ddl_from_location.DataTextField = "alias"
                ddl_from_location.DataBind()

                ddl_to_location.DataSource = ds.Tables(0)
                ddl_to_location.DataValueField = "alias"
                ddl_to_location.DataTextField = "alias"
                ddl_to_location.DataBind()

            Else
                ddl_from_location.DataSource = Nothing
                ddl_from_location.DataBind()

                ddl_to_location.DataSource = Nothing
                ddl_to_location.DataBind()
            End If

            If location_st <> "0" Then
                ddl_from_location.SelectedValue = location_st_name
                ddl_to_location.SelectedValue = location_st_name
                btn_run.Enabled = True
            End If

        Else

        End If
    End Sub





    Protected Sub btn_run_Click(sender As Object, e As EventArgs) Handles btn_run.Click

        If ddl_from_location.SelectedValue = "0" Or ddl_to_location.SelectedValue = "0" Or ddl_from_location.SelectedValue = ddl_to_location.SelectedValue Then
            lbl_error.Text = "Seleccione las sucursales"
        Else
            lbl_error.Text = ""
            query = "select a.product_code as [Producto], a.product_category as [Categoria], qtyA as [Cantidad en " + ddl_from_location.SelectedItem.Text + "]"
            query += " ,case when a.product_category = 'radiador' then 1 else (qtyA/2) end as [Cantidad para pedir]"
            query += " from ("
            query += " select product_code, sum(qty) as qtyA, max(product_category) as product_category from stock where location = '" + ddl_from_location.SelectedItem.Text + "' and product_category in ('tapa','radiador') group by product_code)a"
            query += " left join ("
            query += " select product_code, sum(qty) as qtyB, max(product_category) as product_category from stock where location = '" + ddl_to_location.SelectedItem.Text + "' and product_category in ('tapa','radiador') group by product_code)b"
            query += " on a.product_code = b.product_code"
            query += " where qtyA > 1 and qtyB is null"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                ExportNew(ds)

            Else

            End If
        End If


    End Sub



    Public Sub ExportNew(ByVal ds As DataSet)
        Dim strFilename As String = "Relleno_" + Now.Date.Day.ToString + "/" + Now.Date.Month.ToString + "/" + Now.Date.Year.ToString

        Dim excel As New ExcelPackage()
        'Dim myworksheet As ExcelWorksheets
        ExcelWorksheets = excel.Workbook.Worksheets.Add(strFilename.ToString())
        Dim totalCols As Integer = ds.Tables(0).Columns.Count
        Dim totalRows As Integer = ds.Tables(0).Rows.Count

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

        'ExcelWorksheets.Column(8).Style.Numberformat.Format = "MM/dd/yyyy"

        Dim memoryStream As New MemoryStream()
        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        Response.AddHeader("content-disposition", "attachment;  filename=" + strFilename.ToString() + ".xlsx")
        excel.SaveAs(memoryStream)
        memoryStream.WriteTo(Response.OutputStream)
        Response.Flush()
        Response.End()
    End Sub

    Protected Sub btn_run_ventas_Click(sender As Object, e As EventArgs) Handles btn_run_ventas.Click
        If ddl_from_location.SelectedValue = "0" Or ddl_to_location.SelectedValue = "0" Or ddl_from_location.SelectedValue = ddl_to_location.SelectedValue Then
            lbl_error.Text = "Seleccione las sucursales"
        Else
            lbl_error.Text = ""
            query = "select"
            query += " product_code as [Producto]"
            query += " ,product_category as [Categoria]"
            query += " ,qtyventa as [cantidad vendida]"
            query += " ,qtyStockHenequen as [Cantidad en " + ddl_to_location.SelectedValue + "]"
            query += " ,qtyStockValentin as [cantidad en " + ddl_from_location.SelectedValue + "]"
            query += " ,case when qtyStockValentin >= (qtyventa + 2) then qtyventa"
            query += " else (qtyStockValentin - 2) end as [Cantidad para pedir]"
            query += " from ("
            query += " select moves.product_code, sum(qty) as qtyventa, isnull(max(st.qtyC), 0) as qtyStockHenequen, max(stv.qtyC) as qtyStockValentin,  max(stv.product_category) as product_category"
            query += " from moves "
            query += " left join ("
            query += " select product_code, sum(qty) as qtyC from stock where location = '" + ddl_to_location.SelectedValue + "' and product_category in ('tapa','radiador') group by product_code"
            query += " )st on moves.product_code = st.product_code"
            query += " inner join ("
            query += " select product_code, sum(qty) as qtyC, max(product_category) as product_category from stock where location = '" + ddl_from_location.SelectedValue + "' and product_category in ('tapa','radiador') group by product_code"
            query += " )stv on moves.product_code = stv.product_code"
            query += " where moves.reason = 'venta' and moves.location = '" + ddl_to_location.SelectedValue + "' and cast(convert(varchar, moves.row_date, 101) as datetime) >= cast(convert(varchar, getdate()-7, 101) as datetime)"
            query += " group by moves.product_code"
            query += " )a where qtyventa > qtyStockHenequen and qtyStockValentin > 2"

            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                ExportNew(ds)

            Else

            End If
        End If
    End Sub
End Class
