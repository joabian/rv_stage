Imports System.Data
Imports OfficeOpenXml
Imports System.IO

Partial Class reportes_checadas
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public Sendemail As New email_mng
    Dim ExcelWorksheets As ExcelWorksheet


    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        ''query = "select * from sale_order order by id desc"
        ''ds = Dataconnect.GetAll(query)
        If Not IsPostBack Then
            Dim user As String
            user = Membership.GetUser().UserName
            query = "select position from users where user_name = '" + user + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                Dim pos As String = ds.Tables(0).Rows(0)("position").ToString()

                If pos = "admin" Or pos = "RH" Then
                    btn_export.Enabled = True
                Else
                    Response.Redirect("../no_access.aspx")
                End If
            Else
                Response.Redirect("../no_access.aspx")
            End If
        End If
    End Sub

    Protected Sub btn_export_Click(sender As Object, e As EventArgs) Handles btn_export.Click

        If tbx_myDate.Text <> "" Then
            If Not IsDate(tbx_myDate.Text) Then
                lbl_error.Text = "Ingrese una fecha"
            Else
                Dim strFilename As String = "Checadas_del_dia_" + tbx_myDate.Text

                query = "select "
                query += " PersonID as [NUM EMP]"
                query += " ,name as [NOMBRE]"
                query += " ,last_name AS [APELLIDO]"
                query += " ,CONVERT(VARCHAR, MIN(day), 101) as [FECHA]"
                query += " ,CONVERT(VARCHAR, MIN(day), 108) as [ENTRADA]"
                query += " ,CONVERT(VARCHAR, MAX(day), 108) as [SALIDA]"
                query += " ,CONVERT(VARCHAR, MAX(day) - MIN(day), 108) as [HORAS TRABAJADAS]"
                query += " from checadas"
                query += " left join employees on checadas.PersonID = employees.empid"
                query += " where cast(convert(varchar, checadas.day, 101) as datetime) = '" + tbx_myDate.Text + "'"
                query += " group by PersonID, name, last_name"
                query += " order by PersonID"

                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    Dim excel As New ExcelPackage()
                    'Dim myworksheet As ExcelWorksheets
                    ExcelWorksheets = excel.Workbook.Worksheets.Add(strFilename)
                    Dim totalCols As Integer = ds.Tables(0).Columns.Count
                    Dim totalRows As Integer = ds.Tables(0).Rows.Count
                    'ExcelWorksheets.Column(4).Style.Numberformat.Format = "0"

                    For i = 0 To totalCols - 1
                        ExcelWorksheets.SetValue(1, i + 1, ds.Tables(0).Columns(i).ColumnName)
                    Next

                    For j = 0 To totalRows - 1
                        For m = 0 To totalCols - 1
                            ExcelWorksheets.SetValue(j + 2, m + 1, ds.Tables(0).Rows(j)(m).ToString())
                        Next
                    Next

                    Dim memoryStream As New MemoryStream()
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                    Response.AddHeader("content-disposition", "attachment;  filename=" + strFilename.ToString() + ".xlsx")
                    excel.SaveAs(memoryStream)
                    memoryStream.WriteTo(Response.OutputStream)
                    Response.Flush()
                    Response.End()
                Else
                    lbl_error.Text = "No se encontraron registros"
                End If
                
            End If
        Else
            lbl_error.Text = "Ingrese una fecha"
        End If
        
    End Sub
End Class
