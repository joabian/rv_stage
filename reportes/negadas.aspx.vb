Imports System.Data
Imports OfficeOpenXml
Imports System.IO

Partial Class reportes_negadas
    Inherits System.Web.UI.Page
    Public query As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet
    Dim ExcelWorksheets As ExcelWorksheet

    Public Function getQuery() As String
        Dim from_d As String = ""
        Dim to_d As String = ""
        from_d = Request.Form("from_date")
        to_d = Request.Form("to_date")
        Dim msg As String
        If IsDate(from_d) And IsDate(to_d) Then
            If cbx_existente.Checked = False And cbx_no_existentes.Checked = False Then
                msg = "Ingrese los datos correctos"
            Else
                Dim ex As String = ""

                If cbx_existente.Checked = True And cbx_no_existentes.Checked = True Then
                    ex = ""
                ElseIf cbx_existente.Checked = True And cbx_no_existentes.Checked = False Then
                    ex = " and existe = 'Si'"
                ElseIf cbx_existente.Checked = False And cbx_no_existentes.Checked = True Then
                    ex = " and existe = 'No'"
                End If

                query = "select upper(Codigo) as Código, upper(categories.name) as Categoría, Descripcion as Descripción, upper(Sucursal) as Sucursal, Notas as [Cliente], qty_req as [Cantidad Requerida]"
                query += " ,qty_suc as [Cantidad en Sucursal], qty_tot as [Cantidad Total], existe as [Existe Código]"
                query += " ,Usuario, convert(varchar, row_date, 101) as [Fecha] from negadas "
                query += " left join products on negadas.codigo = products.code"
                query += " left join categories on products.category = categories.id"
                query += " where cast(convert(varchar, row_date, 101) as datetime) >= '" + from_d.ToString() + "' and cast(convert("
                query += "varchar, row_date, 101) as datetime) <= '" + to_d.ToString() + "'"
                query += ex
                msg = query
            End If
        Else
            msg = "Ingrese los datos correctos"
        End If
        Return msg
    End Function

    Protected Sub btn_get_report_Click(sender As Object, e As EventArgs) Handles btn_get_report.Click
        Dim quer As String = getQuery()
        If quer = "Ingrese los datos correctos" Then
            lblerror.Text = quer
        Else
            ds = Dataconnect.GetAll(quer)

            If ds.Tables(0).Rows.Count > 0 Then
                gv_report.DataSource = ds
                gv_report.DataBind()
                lblerror.Text = ""
            Else
                gv_report.DataSource = Nothing
                gv_report.DataBind()
                lblerror.Text = "No existen registros para esta selección"
            End If
        End If
    End Sub


    Public Sub ExportNew(ByVal ds As DataSet)
        Dim strFilename As String = "Negadas_" + Now.Date.Day.ToString + "/" + Now.Date.Month.ToString + "/" + Now.Date.Year.ToString

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

    Protected Sub btn_export_Click(sender As Object, e As EventArgs) Handles btn_export.Click
        Dim quer As String = getQuery()
        If quer = "Ingrese los datos correctos" Then
            lblerror.Text = quer
        Else
            ds = Dataconnect.GetAll(quer)

            If ds.Tables(0).Rows.Count > 0 Then
                ExportNew(ds)
                lblerror.Text = ""
            Else
                lblerror.Text = "No existen registros para esta seleccion"
            End If
        End If

    End Sub
End Class
