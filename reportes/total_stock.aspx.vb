Imports System.Data
Imports OfficeOpenXml
Imports System.IO

Partial Class reportes_total_stock
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Dim ExcelWorksheets As ExcelWorksheet

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        
    End Sub

    Protected Sub Button1_Click(sender As Object, e As System.EventArgs) Handles btn_export.Click
        downloadReport()
        
    End Sub

    Public Sub downloadReport()
        Dim strFilename As String = "Inventario_Completo_" + Now.Date.Day.ToString + "/" + Now.Date.Month.ToString + "/" + Now.Date.Year.ToString

        query = getquery()

        ds = Dataconnect.GetAll(query)

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
                ExcelWorksheets.SetValue(j + 2, m + 1, ds.Tables(0).Rows(j)(m))

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
    'Protected Sub GridView1_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridView1.RowDataBound

    '    If e.Row.RowType = DataControlRowType.Footer Then
    '        e.Row.Cells(3).Text = "Total Items:"
    '        e.Row.Cells(4).Text = ds.Tables(0).Rows(0)("qty").ToString()
    '    End If
    'End Sub

    Protected Sub btn_run_Click(sender As Object, e As EventArgs) Handles btn_run.Click
        query = getquery()
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            gv_stock.DataSource = ds.Tables(0)
            gv_stock.DataBind()
        End If
    End Sub

    Public Function getquery() As String
        If chbx_pivot.Checked = True Then
            query = "DECLARE @columns NVARCHAR(MAX), @sql NVARCHAR(MAX);"
            query += " SET @columns = N'';"
            query += " SELECT @columns += N', p.' + QUOTENAME(location)"
            query += " FROM (SELECT top 100 percent p.location FROM stock AS p"
            query += " GROUP BY p.location order by p.location) AS x;"
            query += " SET @sql = N'"
            query += " select a.*, b.Total from ("
            query += " SELECT p.product_code, p.product_category,' + STUFF(@columns, 1, 2, '') + '"
            query += " FROM ("
            query += " SELECT top 100 percent p.product_code, p.product_category,p.location, p.qty "
            query += " FROM stock AS p order by  p.product_code ) AS j"
            query += " PIVOT"
            query += " (SUM(qty) FOR location IN ('+ STUFF(REPLACE(@columns, ', p.[', ',['), 1, 1, '')+ ')) AS p"
            query += " )a join (select product_code, sum(qty) as total from stock group by product_code"
            query += " )b on a.product_code = b.product_code;';"
            query += " EXEC sp_executesql @sql;"
        Else
            query = "select product_code as Código, min(product_description) as Descripción, product_category as Categoría, sum(qty)"
            query += " as [Total General] from stock group by product_code, product_category"
        End If

        Return query
    End Function
End Class
