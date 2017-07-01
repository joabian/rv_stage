Imports System.Data
Imports System.Text
Imports System.Drawing
Imports System.IO
Imports Excel
Imports OfficeOpenXml


Partial Class movimientos_egrees
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As New DataSet
    Public username As String
    Public sendemail As New email_mng


    Protected Sub save_Click(sender As Object, e As System.EventArgs) Handles save.Click
        Dim logevent, rackid, reason, comm, cliente As String
        Dim location_name As String = location.SelectedItem.Text
        Dim location_id As String = location.SelectedValue
        Dim intQty As Integer

        rackid = rack.Text
        reason = type.SelectedItem.Text.ToString()
        If comments.Text <> "" Then
            comm = Replace(comments.Text, "'", "").ToString()
        Else
            comm = ""
        End If
        intQty = Replace(qty.Text, "'", "").ToString()
        cliente = Replace(tbx_cliente.Text & "'", "'", "")

        Dim prod_code As String = Replace(Replace(productId.Text, "'", ""), " ", "").ToString().ToUpper()

        If reason.ToUpper() = "VENTA" And cliente = "" Then
            errorlbl.Text = "Es obligatorio que ingrese el nombre del cliente para ingresar una venta"
            'ElseIf rackid.ToUpper() = "TEMPORAL" Then
            '    errorlbl.Text = "No es posible hacer ventas del rack temporal"
        ElseIf reason.ToUpper() = "AJUSTE INVENTARIO" Then
            If (location_name.ToUpper = "HENEQUEN" And username = "estefania") Or location_name <> "HENEQUEN" Then
                query = "insert into ajustes (username,location,item,rack,qty,notes,create_date,tipo) values ('" + username.ToString() + "','" + location.SelectedItem.Text.ToString() + "','"
                query += prod_code.ToString() + "','" + rackid.ToString() + "','" + intQty.ToString() + "','" + comm.ToString() + "',getdate(),'SALIDA')"
                Dataconnect.runquery(query)

                Dim body As String = bodyHtml(location.SelectedItem.Text, prod_code, intQty, comm)
                Dim distro As String = "samuel.gonzalez@radiadoresvencedores.com"

                sendemail.sendEmail(distro, "Ajuste de Inventario - SALIDA", body)

                errorlbl.Text = "El ajuste quedo grabado con exito, despues de revisarlo se procedera a realizarlo o negarlo"
            Else
                errorlbl.Text = "Usted no tiene acceso a realizar ajustes"
            End If
            

        Else
            query = "select * from stock where product_code = '" + prod_code.ToString() + "' and location = '" + location.SelectedValue.ToString() + "' and rack = '" + rackid.ToString() + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 And intQty > 0 Then
                Dim oldqty As Integer, newqty As Integer
                oldqty = ds.Tables(0).Rows(0)("qty").ToString()
                Dim prod_id As String = ds.Tables(0).Rows(0)("product_id").ToString()
                newqty = oldqty - intQty
                If newqty < 0 Then
                    errorlbl.Text = "No existe suficiente inventario en esta locacion"
                Else
                    If cliente <> "" Then
                        cliente = " Cliente: " + cliente
                    End If
                    query = "update stock set qty = (qty - " + intQty.ToString() + "), last_update = getDate() where product_code = '" + prod_code.ToString() + "' and location = '" + location.SelectedValue.ToString() + "' and rack = '" + rackid.ToString() + "'"
                    query += " delete from stock where qty <= 0"
                    Dataconnect.runquery(query)

                    query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (" + prod_id.ToString().ToUpper() + ", '" + prod_code.ToString().ToUpper() + "', '" + reason.ToString().ToUpper() + "', 'SALIDA', '" + comm.ToString().ToUpper() + cliente.ToString().ToUpper() + "', '" + location.SelectedValue.ToString().ToUpper() + "', '" + rackid.ToString().ToUpper() + "', '" + username.ToString() + "', getDate(), " + intQty.ToString() + ")"
                    Dataconnect.runquery(query)

                    logevent = "Salida de producto: " + prod_code.ToString() + " de la sucursal: " + location.SelectedValue.ToString() + " del rack: " + rackid.ToString() + ", por la cantidad de: " + intQty.ToString() + " dejando el inventario actual en: " + newqty.ToString()
                    queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                    Dataconnect.runquery(queryLog)
                    clearControls()
                    'Response.Redirect("egrees.aspx")
                End If
            Else
                errorlbl.Text = "verifique los datos, esta tratando de ingresar cantidades no validas o el producto no existe en nuestra base de datos"
            End If
        End If
        
    End Sub

    Public Sub clearControls()
        productId.Text = ""
        type.SelectedValue = "VENTA"
        location.SelectedValue = "0"
        rack.Text = ""
        qty.Text = ""
        comments.Text = ""
        tbx_cliente.Text = ""
        lbl_error_file.Text = ""
        invGR.Visible = False
        errorlbl.Text = ""
    End Sub

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        username = Membership.GetUser().UserName

        If Not IsPostBack Then
            populate_ddl_locations()
        End If

        Dim prod As String
        prod = Replace(productId.Text & "'", "'", "").ToString()

        If prod <> "" Then
            query = "select location, rack, qty from stock where product_code = '" + prod.ToString() + "' order by location, qty desc"
            ds = Dataconnect.GetAll(query)
            lblinvent.Text = "Producto en inventario:<br />"

            If ds.Tables(0).Rows.Count > 0 Then
                invGR.Visible = True
                invGR.DataSource = ds
                invGR.DataBind()
            Else
                invGR.Visible = False
                lblinvent.Text = "Producto sin inventario o invalido<br />"
            End If

        End If

    End Sub

    Protected Sub invGR_RowDataBound(ByVal sender As System.Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles invGR.RowDataBound
        Dim sucursal As String
        sucursal = UCase(e.Row.Cells(0).Text)

        Select Case sucursal
            Case "HENEQUEN"
                e.Row.Cells(0).Style("background-color") = "orange"
                e.Row.Cells(0).Style("color") = "white"
            Case "VALENTIN"
                e.Row.Cells(0).Style("background-color") = "blue"
                e.Row.Cells(0).Style("color") = "white"
            Case "GOMEZ MORIN"
                e.Row.Cells(0).Style("background-color") = "yellow"
            Case "TORREON"
                e.Row.Cells(0).Style("background-color") = "green"
                e.Row.Cells(0).Style("color") = "white"
            Case "DURANGO"
                e.Row.Cells(0).Style("background-color") = "red"
                e.Row.Cells(0).Style("color") = "white"
            Case "LEON"
                e.Row.Cells(0).Style("background-color") = "black"
                e.Row.Cells(0).Style("color") = "white"
        End Select

    End Sub

    Public Sub populate_ddl_locations()
        Dim username As String
        Dim location_st, location_alias As String
        username = Membership.GetUser().UserName
        query = "select location,alias from users left join locations on users.location = locations.id where user_name = '" + username + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            location_st = ds.Tables(0).Rows(0)("location").ToString()
            location_alias = ds.Tables(0).Rows(0)("alias").ToString()
            If location_st = "0" Then
                query = "select alias from locations"
            Else
                query = "select alias from locations where id = " + location_st.ToString()
            End If
            ds = Dataconnect.GetAll(query)

            If ds.Tables(0).Rows.Count > 0 Then
                location.DataSource = ds.Tables(0)
                location.DataValueField = "alias"
                location.DataTextField = "alias"
                location.DataBind()
                If location_st <> "0" Then
                    location.SelectedValue = location_alias
                End If
            Else
                location.DataSource = Nothing
                location.DataBind()
            End If
        End If
    End Sub

    'Public Sub readExcel()
    '    SpreadsheetInfo.SetLicense("FREE-LIMITED-KEY")

    '    AddHandler SpreadsheetInfo.FreeLimitReached, Function(sender As Object, e As FreeLimitEventArgs) e.FreeLimitReachedAction = FreeLimitReachedAction.ContinueAsTrial

    '    Dim items As String = ""
    '    'Dim filepath As String = "C:\Users\212331260\Desktop\"
    '    Dim filepath As String = "e:\HostingSpaces\vencedo2\radiadoresvencedores.com\wwwroot\docs"
    '    Dim uploadedFiles As HttpFileCollection = Request.Files
    '    Dim i As Integer = 0
    '    Do Until i = uploadedFiles.Count
    '        Dim userPostedFile As HttpPostedFile = uploadedFiles(i)
    '        Try
    '            If (userPostedFile.ContentLength > 0) Then
    '                Dim filename As String = Replace(System.IO.Path.GetFileName(userPostedFile.FileName), "'", "")
    '                Try
    '                    userPostedFile.SaveAs(filepath & "\" + filename)

    '                    Dim ef As ExcelFile = ExcelFile.Load(filepath & "\" + filename)

    '                    For Each sheet As ExcelWorksheet In ef.Worksheets

    '                        For Each row As ExcelRow In sheet.Rows
    '                            For Each cell As ExcelCell In row.AllocatedCells
    '                                If Not cell.Value Is Nothing Then
    '                                    items += cell.Value.ToString() + "}"
    '                                End If
    '                            Next
    '                            items = items.Substring(0, items.Length - 1)
    '                            items += "]"
    '                        Next
    '                    Next

    '                    File.Delete(filepath & "\" + filename)

    '                    items = items.Substring(0, items.Length - 1)

    '                    remove_items(items)

    '                Catch ex As Exception

    '                End Try
    '            End If
    '        Catch ex As Exception

    '        End Try
    '        i += 1
    '    Loop

    'End Sub

	
    'Public Sub readExcelNew()
    '       'Dim filepath As String = "C:\Users\212331260\Desktop"
    '       Dim filepath As String = "e:\HostingSpaces\vencedo2\radiadoresvencedores.com\wwwroot\docs"
    '       Dim uploadedFiles As HttpFileCollection = Request.Files
    '       Dim i As Integer = 0
    '       Do Until i = uploadedFiles.Count
    '           Dim userPostedFile As HttpPostedFile = uploadedFiles(i)
    '           Try
    '               If (userPostedFile.ContentLength > 0) Then
    '                   Dim filename As String = Replace(System.IO.Path.GetFileName(userPostedFile.FileName), "'", "")
    '				Dim fullpath as string = filepath & "\" & filename
    '                   Try
    '                       userPostedFile.SaveAs(fullpath)

    '                       Dim stream As FileStream = File.Open(fullpath, FileMode.Open, FileAccess.Read)

    '					Dim excelReader As IExcelDataReader = ExcelReaderFactory.CreateOpenXmlReader(stream)
    '                       excelReader.IsFirstRowAsColumnNames = False
    '					Dim result As DataSet = excelReader.AsDataSet()

    '                       'If result.Tables(0).Rows.Count > 0 Then

    '                       '                      For h As Integer = 0 To result.Tables(0).Rows.Count - 1
    '                       '                          For j As Integer = 0 To result.Tables(0).Columns.Count - 1
    '                       '                              items += result.Tables(0).Rows(h)(j).ToString() + "}"
    '                       '                          Next
    '                       '                          items = items.Substring(0, items.Length - 1)
    '                       '                          items += "]"
    '                       '                      Next

    '                       'End If

    '                       File.Delete(fullpath)

    '                       'items = items.Substring(0, items.Length - 1)

    '                       remove_itemsNew(result)

    '                   Catch ex As Exception
    '                       lbl_error_file.Text = ex.Message
    '                   End Try
    '               End If
    '           Catch ex As Exception
    '               lbl_error_file.Text = ex.Message
    '           End Try
    '           i += 1
    '       Loop

    '   End Sub
    Protected Sub leadexcel_Click(sender As Object, e As EventArgs) Handles leadexcel.Click
        'readExcel()
        If type.SelectedValue = "VENTA" And tbx_cliente.Text = "" Then
            errorlbl.Text = "Es obligatorio que ingrese el nombre del cliente para ingresar una venta"
        ElseIf type.SelectedValue = "AJUSTE INVENTARIO" Then
            errorlbl.Text = "Los ajustes de inventario no se pueden realizar masivos"
        Else
            'readExcelNew()
            ReadExcelStream()
        End If

    End Sub

    Public Sub ReadExcelStream()
        Dim sucursal As String
        sucursal = location.SelectedValue.ToString()

        If sucursal <> "Seleccionar..." Then
            If File1.HasFile Then
                If Path.GetExtension(File1.FileName) = ".xlsx" Then
                    Dim excel As New ExcelPackage(File1.FileContent)

                    Dim ws As ExcelWorksheet = excel.Workbook.Worksheets.First()

                    ProcessExcelFile(ws, sucursal)
                Else
                    lbl_error_file.Text = "Only Excel files are allowed"

                End If
            Else
                lbl_error_file.Text = "Select a file"
            End If
        Else
            lbl_error_file.Text = "<br />seleccione Sucursal"
        End If
        
    End Sub

    Public Sub ProcessExcelFile(ByVal ws As ExcelWorksheet, ByVal sucursal As String)
        Dim motivo, error_msg, item, rack, qty, id_record, logevent, cliente, mycliente, fullQuery As String
        error_msg = ""
        Dim qtyleft, qtyOrig As Integer

        motivo = type.SelectedValue.ToString()
        cliente = Replace(tbx_cliente.Text & "'", "'", "")
        Dim username As String = Membership.GetUser().UserName
        If cliente <> "" Then
            mycliente = " Cliente: " & cliente.ToString()
        Else
            mycliente = ""
        End If

        Dim totalCols As Integer = ws.Dimension.[End].Column
        Dim totalRows As Integer = ws.Dimension.[End].Row
        Dim startRow As Integer = 1
        Dim myline As String = ""
        Dim mylineValues() As String
        Dim wsRow As ExcelRange
        fullQuery = ""

        For rowNum As Integer = startRow To totalRows
            wsRow = ws.Cells(rowNum, 1, rowNum, totalCols)
            myline = ""
            For Each cell In wsRow
                myline += cell.Text + ","
            Next
            mylineValues = myline.Split(",")

            item = Replace(Replace(mylineValues(0).ToString(), "'", ""), " ", "").ToUpper()
            qty = mylineValues(2).ToString()
            rack = mylineValues(1).ToString().ToUpper()

            If Not IsNumeric(qty) Or qty = "0" Then
                error_msg += "Campo de Cantidad en 0 o esta incorrecto en item: " + item.ToString() + "<br />"
                'ElseIf rack.ToUpper() = "TEMPORAL" Then
                '    error_msg += "No es posible dar de baja de rack TEMPORAL en linea: " + item.ToString() + "<br />"
            Else
                query = "select * from products where code = '" + item.ToString() + "'"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    Dim prod_id As String = ds.Tables(0).Rows(0)("id").ToString()
                    'verificamos si existe una linea en la orden, para sumarla a la cantidad actual
                    query = "select * from stock where product_code = '" + item.ToString() + "' and rack = '" + rack.ToString() + "' and location = '" + sucursal.ToString() + "' and qty >= " + qty.ToString()
                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        'sumar a la cantidad actual
                        id_record = ds.Tables(0).Rows(0)("id").ToString()
                        qtyOrig = Convert.ToInt32(ds.Tables(0).Rows(0)("qty").ToString())
                        qtyleft = qtyOrig - Convert.ToInt32(qty)

                        fullQuery += " update stock set qty = (qty - " + qty.ToString() + ") where id = " + id_record.ToString()
                        
                        fullQuery += " insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (" + prod_id.ToString().ToUpper() + ", '" + item.ToString().ToUpper() + "', '" + motivo.ToString().ToUpper() + "', 'SALIDA', 'Baja masiva" & mycliente.ToString() + "', '" + sucursal.ToString().ToUpper() + "', '" + rack.ToString().ToUpper() + "', '" + username.ToString() + "', getDate(), " + qty.ToString() + ")"
                        
                        logevent = "Salida de producto: " + item.ToString() + " de la sucursal: " + sucursal.ToString() + " del rack: " + rack.ToString() + ", por la cantidad de: " + qty.ToString() + ", dejando el inventario actual en: " + qtyleft.ToString()

                        fullQuery += " INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"

                    Else
                        error_msg += "No existe suficiente inventario en " + sucursal.ToString() + " rack " + rack.ToString() + " del item: " + item.ToString() + "<br />"
                    End If
                Else
                    error_msg += "El item: " + item.ToString() + " no existe en la base de datos<br />"
                End If
            End If
        Next

        If error_msg <> "" Then
            lbl_error_file.Text = "<br />Antes de continuar corrija los siguiente errores e intente subir de nuevo el archivo completo:<br />" + error_msg
        Else
            fullQuery += " delete from stock where qty <= 0"
            Dataconnect.runquery(fullQuery)

            lbl_error_file.ForeColor = Color.Green
            lbl_error_file.Text = "<br />El archivo se cargo con exito!"
        End If

    End Sub

    Public Sub remove_itemsNew(ByVal list_items As DataSet)
        Dim motivo, sucursal, error_msg, item, rack, qty, id_record, logevent, cliente, mycliente As String
        error_msg = ""
        sucursal = location.SelectedValue.ToString()
        motivo = type.SelectedValue.ToString()
        cliente = Replace(tbx_cliente.Text & "'", "'", "")
        If cliente <> "" Then
            mycliente = " Cliente: " & cliente.ToString()
        Else
            mycliente = ""
        End If

        Dim username As String = Membership.GetUser().UserName

        If sucursal <> "Seleccionar..." Then

            For i = 0 To list_items.Tables(0).Rows.Count - 1

                item = Replace(Replace(list_items.Tables(0).Rows(i)(0).ToString(), "'", ""), " ", "").ToUpper()
                qty = list_items.Tables(0).Rows(i)(2).ToString()
                rack = list_items.Tables(0).Rows(i)(1).ToString()
                'verificamos que sean cantidades numericas
                If Not IsNumeric(qty) Or qty = "0" Then
                    error_msg += "Campo de Cantidad en 0 o esta incorrecto en linea: " + (i + 1).ToString() + "<br />"
                ElseIf rack.ToUpper() = "TEMPORAL" Then
                    error_msg += "No es posible dar de baja de rack TEMPORAL en linea: " + (i + 1).ToString() + "<br />"
                Else
                    query = "select * from products where code = '" + item.ToString() + "'"
                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        Dim prod_id As String = ds.Tables(0).Rows(0)("id").ToString()
                        'verificamos si existe una linea en la orden, para sumarla a la cantidad actual
                        query = "select * from stock where product_code = '" + item.ToString() + "' and rack = '" + rack.ToString() + "' and location = '" + sucursal.ToString() + "'"
                        ds = Dataconnect.GetAll(query)
                        If ds.Tables(0).Rows.Count > 0 Then
                            'sumar a la cantidad actual
                            id_record = ds.Tables(0).Rows(0)("id").ToString()
                            Dim actual_qty As String = ds.Tables(0).Rows(0)("qty").ToString()

                            If Convert.ToInt32(actual_qty) < Convert.ToInt32(qty) Then
                                error_msg += "No existe suficiente inventario en " + sucursal.ToString() + " rack " + rack.ToString() + " del item: " + item.ToString() + "<br />"
                            Else
                                query = "update stock set qty = (qty - " + qty.ToString() + ") where id = " + id_record.ToString()
                                Dataconnect.runquery(query)

                                query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (" + prod_id.ToString().ToUpper() + ", '" + item.ToString().ToUpper() + "', '" + motivo.ToString().ToUpper() + "', 'SALIDA', 'Baja masiva" & mycliente.ToString() + "', '" + sucursal.ToString().ToUpper() + "', '" + rack.ToString().ToUpper() + "', '" + username.ToString() + "', getDate(), " + qty.ToString() + ")"
                                Dataconnect.runquery(query)

                                logevent = "Salida de producto: " + item.ToString() + " de la sucursal: " + sucursal.ToString() + " del rack: " + rack.ToString() + ", por la cantidad de: " + qty.ToString()
                                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                                Dataconnect.runquery(queryLog)

                            End If

                        Else
                            'ingresar nueva linea
                            error_msg += "No existe suficiente inventario en " + sucursal.ToString() + " rack " + rack.ToString() + " del item: " + item.ToString() + "<br />"
                        End If

                        query = " delete from stock where qty <= 0"
                        Dataconnect.runquery(query)

                    Else
                        error_msg += "El item: " + item.ToString() + " no existe en la base de datos<br />"
                    End If
                End If
            Next

            If error_msg <> "" Then
                lbl_error_file.Text = "<br />Corrija los siguiente errores, el resto se bajo con exito:<br />" + error_msg
            Else
                lbl_error_file.ForeColor = Color.Green
                lbl_error_file.Text = "<br />El archivo se cargo con exito!"
            End If

        Else
            lbl_error_file.Text = "<br />seleccione Sucursal"
        End If

    End Sub

    'Public Sub remove_items(ByVal list_items As String)
    '    Dim motivo, sucursal, error_msg, item, rack, qty, id_record, logevent As String
    '    error_msg = ""
    '    Dim item_details() As String
    '    sucursal = location.SelectedValue.ToString()
    '    motivo = type.SelectedValue.ToString()
    '    Dim username As String = Membership.GetUser().UserName

    '    If sucursal <> "0" Then

    '        Dim items_array() As String = list_items.Split("]")
    '        For i = 0 To items_array.Length - 1

    '            item_details = items_array(i).Split("}")
    '            item = Replace(Replace(item_details(0).ToString(), "'", ""), " ", "").ToUpper()

    '            If sucursal = "Rito" Then
    '                qty = "1"
    '                rack = "BOD"
    '            Else
    '                qty = item_details(2).ToString()
    '                rack = item_details(1).ToString()
    '            End If


    '            'verificamos que sean cantidades numericas
    '            If Not IsNumeric(qty) Or qty = "0" Then
    '                error_msg += "Campo de Cantidad en 0 o esta incorrecto en linea: " + (i + 1).ToString() + "<br />"
    '            Else
    '                query = "select * from products where code = '" + item.ToString() + "'"
    '                ds = Dataconnect.GetAll(query)
    '                If ds.Tables(0).Rows.Count > 0 Then
    '                    Dim prod_id As String = ds.Tables(0).Rows(0)("id").ToString()
    '                    'verificamos si existe una linea en la orden, para sumarla a la cantidad actual
    '                    query = "select * from stock where product_code = '" + item.ToString() + "' and rack = '" + rack.ToString() + "' and location = '" + sucursal.ToString() + "'"
    '                    ds = Dataconnect.GetAll(query)
    '                    If ds.Tables(0).Rows.Count > 0 Then
    '                        'sumar a la cantidad actual
    '                        id_record = ds.Tables(0).Rows(0)("id").ToString()
    '                        Dim actual_qty As String = ds.Tables(0).Rows(0)("qty").ToString()

    '                        If Convert.ToInt32(actual_qty) < Convert.ToInt32(qty) Then
    '                            error_msg += "No existe suficiente inventario en " + sucursal.ToString() + " rack " + rack.ToString() + " del item: " + item.ToString() + "<br />"
    '                        Else
    '                            query = "update stock set qty = (qty - " + qty.ToString() + ") where id = " + id_record.ToString()
    '                            query += " delete from stock where qty <= 0"
    '                            'Dataconnect.runquery(query)

    '                            query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (" + prod_id.ToString().ToUpper() + ", '" + item.ToString().ToUpper() + "', '" + motivo.ToString().ToUpper() + "', 'SALIDA', 'Baja masiva', '" + sucursal.ToString().ToUpper() + "', '" + rack.ToString().ToUpper() + "', '" + username.ToString() + "', getDate(), " + qty.ToString() + ")"
    '                            'Dataconnect.runquery(query)

    '                            logevent = "Salida de producto: " + item.ToString() + " de la sucursal: " + sucursal.ToString() + " del rack: " + rack.ToString() + ", por la cantidad de: " + qty.ToString()
    '                            queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
    '                            'Dataconnect.runquery(queryLog)

    '                        End If

    '                    Else
    '                        'ingresar nueva linea
    '                        error_msg += "No existe suficiente inventario en " + sucursal.ToString() + " rack " + rack.ToString() + " del item: " + item.ToString() + "<br />"
    '                    End If
    '                Else
    '                    error_msg += "El item: " + item.ToString() + " no existe en la base de datos<br />"
    '                End If
    '            End If
    '        Next

    '        If error_msg <> "" Then
    '            lbl_error_file.Text = "<br />Corrija los siguiente errores, el resto se bajo con exito:<br />" + error_msg
    '        Else
    '            lbl_error_file.ForeColor = Color.Green
    '            lbl_error_file.Text = "<br />El archivo se cargo con exito!"
    '        End If

    '    Else
    '        lbl_error_file.Text = "<br />seleccione Sucursal"
    '    End If

    'End Sub


    Function bodyHtml(ByVal sucursal As String, ByVal item As String, ByVal qty As String, ByVal notas As String) As String
        Dim html As String = ""

        html += "<h1>Notificacion</h1><br />"
        html += "<h2>Se requiere aprobar un ajuste de inventario</h2><br />"

        html += "<h3><b>Informacion del ajuste</b><br /><br />"
        html += "Tipo: <b>SALIDA</b><br />"
        html += "Sucursal: <b>" + sucursal.ToString() + "</b><br />"
        html += "Producto: <b>" + item.ToString() + "</b><br />"
        html += "Cantidad: <b>" + qty.ToString() + "</b><br />"
        html += "Notas: <b>" + notas.ToString() + "</b><br />"
        html += "Usuario: <b>" + username.ToString() + "</b><br />"
        html += "Fecha requerido: <b>" + Date.Now().ToString("dd/MM/yyyy") + "</b><br /></h3>"

        Return html
    End Function



End Class
