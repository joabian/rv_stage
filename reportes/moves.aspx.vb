Imports System.Data
Imports OfficeOpenXml
Imports System.IO

Partial Class reportes_moves
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet
    Dim ExcelWorksheets As ExcelWorksheet

    Protected Sub Button1_Click(sender As Object, e As System.EventArgs) Handles Button1.Click
        If IsDate(Request.Form("from_date").ToString()) And IsDate(Request.Form("to_date").ToString()) Then
            Dim Inv_from As Date = Convert.ToDateTime(Request.Form("from_date").ToString())
            Dim Inv_to As Date = Convert.ToDateTime(Request.Form("to_date").ToString())
            Dim type_query, loc_query, reason, reason_q As String
            Dim type As String = typeDDL.SelectedValue.ToString()
            reason = ddl_rason.SelectedValue.ToString()

            If type <> "0" Then
                type_query = " and type = '" + type.ToString() + "' "
            Else
                type_query = ""
            End If

            If reason <> "0" Then
                reason_q = " and reason = '" + reason.ToString() + "' "
            Else
                reason_q = ""
            End If

            Dim location As String = ddl_locations.SelectedValue.ToString()

            If location <> "0" Then
                loc_query = " and location = '" + location + "' "
            Else
                loc_query = ""
            End If

            Dim tbx_query As String = ""
            If tbx_codigo.Text <> "" Then
                tbx_query = " and product_code = '" + Replace(tbx_codigo.Text & "'", "'", "").ToString() + "'"
            End If

            query = "select UPPER(product_code) as [Codigo], UPPER(categories.name) as [Categoria],UPPER(reason) as [Razon], UPPER(type) as [Tipo], UPPER(comments) as [Comentarios], UPPER(location)"
            query += " as [Sucursal], rack, [user] as [usuario], CONVERT(VARCHAR, row_date, 101) as [Fecha], qty as [Cantidad] from moves inner join products on moves.product_code = products.code inner join categories on products.category = categories.id where"
            query += " cast(convert(varchar, row_date, 101) as datetime) >= '" + Inv_from.ToString() + "' and cast(convert("
            query += "varchar, row_date, 101) as datetime) <= '" + Inv_to.ToString() + "' " + type_query.ToString()
            query += loc_query.ToString() + reason_q.ToString()
            query += tbx_query.ToString()
            query += " order by row_date"

            hifd_query.Value = query
            ds = Dataconnect.GetAll(query)

            If ds.Tables(0).Rows.Count > 0 Then
                ExportNew(ds)
                lblerro.Text = ""
            Else

                lblerro.Text = "No existen movimientos para esta seleccion"
            End If
        Else
            lblerro.Text = "formato de fechas incorrecto"
        End If

    End Sub


    Public Sub ExportNew(ByVal ds As DataSet)
        Dim strFilename As String = "Movimientos_" + Now.Date.Day.ToString + "/" + Now.Date.Month.ToString + "/" + Now.Date.Year.ToString

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

    Protected Sub btn_get_report_Click(sender As Object, e As EventArgs) Handles btn_get_report.Click
        Dim from_d As String = ""
        Dim to_d As String = ""
        from_d = Request.Form("from_date")
        to_d = Request.Form("to_date")

        If IsDate(from_d) And IsDate(to_d) Then
            'Dim Inv_from As Date = Convert.ToDateTime(Request.Form("from_date").ToString())
            'Dim Inv_to As Date = Convert.ToDateTime(Request.Form("to_date").ToString())
            Dim type_query, loc_query, reason, reason_q As String
            Dim type As String = typeDDL.SelectedValue.ToString()
            reason = ddl_rason.SelectedValue.ToString()

            If type <> "0" Then
                type_query = " and type = '" + type + "' "
            Else
                type_query = ""
            End If

            If reason <> "0" Then
                reason_q = " and reason = '" + reason.ToString() + "' "
            Else
                reason_q = ""
            End If

            Dim location As String = ddl_locations.SelectedValue.ToString()

            If location <> "0" Then
                loc_query = " and location = '" + location + "' "
            Else
                loc_query = ""
            End If

            Dim tbx_query As String = ""
            If tbx_codigo.Text <> "" Then
                tbx_query = " and product_code = '" + Replace(tbx_codigo.Text & "'", "'", "").ToString() + "'"
            End If


            query = "select product_code as [Código], categories.name as [Categoría],reason as [Razón], type as [Tipo], comments as [Comentarios], location"
            query += " as [Sucursal], rack as [Rack], [user] as [Usuario], row_date as [Fecha], qty as [Cantidad] from moves inner join products on moves.product_code = products.code inner join categories on products.category = categories.id where"
            query += " cast(convert(varchar, row_date, 101) as datetime) >= '" + from_d.ToString() + "' and cast(convert("
            query += "varchar, row_date, 101) as datetime) <= '" + to_d.ToString() + "' " + type_query.ToString()
            query += loc_query.ToString() + reason_q.ToString()
            query += tbx_query.ToString()
            query += " order by row_date"


            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                movesGV.DataSource = ds
                movesGV.DataBind()
                lblerro.Text = ""
            Else
                movesGV.DataSource = Nothing
                movesGV.DataBind()
                lblerro.Text = "No existen movimientos para esta seleccíón"
            End If

        Else
            lblerro.Text = "Formato de fechas incorrecto"
        End If
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            populate_ddl_locations()
        End If
    End Sub

    Public Sub populate_ddl_locations()
        query = "select alias from locations where transit = 0"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            ddl_locations.DataSource = ds.Tables(0)
            ddl_locations.DataValueField = "alias"
            ddl_locations.DataTextField = "alias"
            ddl_locations.DataBind()
        Else
            ddl_locations.DataSource = Nothing
            ddl_locations.DataBind()
        End If
    End Sub

End Class
