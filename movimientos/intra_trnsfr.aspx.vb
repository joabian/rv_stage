Imports System.Data
Imports System.Text
Imports System.Drawing
Imports System.IO
Imports Excel
Imports System.Data.SqlClient

Partial Class movimientos_intra_trnsfr
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public logevent As String
    Public username As String

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            Dim username As String
            Dim loc As String = ""
            Dim loc_id As String = "0"
            username = Membership.GetUser().UserName
            query = "SELECT location, alias FROM users LEFT JOIN locations ON users.location = locations.id WHERE user_name = '" + username + "' "
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                loc = ds.Tables(0).Rows(0)("alias").ToString()
                loc_id = ds.Tables(0).Rows(0)("location").ToString()
                If loc_id = "0" Then
                    query = "SELECT id, alias FROM locations"
                Else
                    query = "SELECT id, alias FROM locations"
                    'query = "select alias from locations where id = " + location_st.ToString()
                End If
            End If

            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                ddl_from_location.DataSource = ds.Tables(0)
                ddl_from_location.DataValueField = "id"
                ddl_from_location.DataTextField = "alias"
                ddl_from_location.DataBind()

                ddl_to_location.DataSource = ds.Tables(0)
                ddl_to_location.DataValueField = "id"
                ddl_to_location.DataTextField = "alias"
                ddl_to_location.DataBind()
            Else
                ddl_from_location.DataSource = Nothing
                ddl_from_location.DataBind()

                ddl_to_location.DataSource = Nothing
                ddl_to_location.DataBind()
            End If

            If loc_id <> "0" Then
                'ddl_from_location.SelectedValue = loc_id
                'ddl_to_location.SelectedValue = loc_id
                ddl_from_location.SelectedValue = loc
                ddl_to_location.SelectedValue = loc
            End If
        Else
            If ddl_from_location.SelectedValue <> ddl_to_location.SelectedValue And ddl_to_location.SelectedValue <> "-" Then
                toRack.Text = "TEMPORAL"
                toRack.Enabled = False
            Else
                toRack.Text = ""
                toRack.Enabled = True
            End If
        End If
    End Sub

    'Protected Sub btn_transfer_Click(sender As Object, e As System.EventArgs) Handles btn_transfer.Click
    '    Dim strModel, strFromRack, strToRack, strQty As String
    '    Dim items_list As String = ""

    '    For i = 1 To 20
    '        Dim model_name, fromRname, toRname, qty_name As String

    '        model_name = "codigo_" + i.ToString()
    '        fromRname = "from_R_" + i.ToString()
    '        toRname = "to_R_" + i.ToString()
    '        qty_name = "qty_" + i.ToString()

    '        strModel = Request.Form(model_name).ToString()
    '        strFromRack = Request.Form(fromRname).ToString()
    '        strQty = Request.Form(qty_name).ToString()
    '        strToRack = Request.Form(toRname).ToString()

    '        If strModel <> "" Then
    '            items_list += strModel.ToString() + "}" + strQty.ToString() + "}" + strFromRack.ToString() + "}" + strToRack.ToString() + "]"
    '        Else
    '            Exit For
    '        End If
    '    Next

    '    items_list = items_list.Substring(0, items_list.Length - 1)

    '    transfer_items(items_list)

    'End Sub

    Protected Sub ddl_from_location_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddl_from_location.SelectedIndexChanged
        validateSelection()
    End Sub

    Protected Sub ddl_to_location_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddl_to_location.SelectedIndexChanged
        validateSelection()
    End Sub

    Sub validateSelection()
        Dim selection As String = ddl_from_location.SelectedValue
        Dim selection2 As String = ddl_to_location.SelectedValue
        'If selection = "-" Or selection2 = "-" Then
        '    btn_transfer.Enabled = False
        'Else
        '    btn_transfer.Enabled = True
        'End If
    End Sub

    Public Sub readExcel()
        Dim items As String = ""
        'Dim filepath As String = "C:\Users\Daniel\Desktop\Nueva carpeta"
        'Dim filepath As String = "e:\HostingSpaces\vencedo2_stage\stage.radiadoresvencedores.com\wwwroot\docs"
        Dim filepath As String = "e:\HostingSpaces\vencedo2\radiadoresvencedores.com\wwwroot\docs"
        Dim uploadedFiles As HttpFileCollection = Request.Files
        Dim i As Integer = 0
        Do Until i = uploadedFiles.Count
            Dim userPostedFile As HttpPostedFile = uploadedFiles(i)
            Try
                If (userPostedFile.ContentLength > 0) Then
                    Dim filename As String = Replace(System.IO.Path.GetFileName(userPostedFile.FileName), "'", "")
                    Dim fullpath As String = filepath & "\" & filename
                    Try
                        userPostedFile.SaveAs(filepath & "\" + filename)

                        Dim stream As FileStream = File.Open(fullpath, FileMode.Open, FileAccess.Read)

                        Dim excelReader As IExcelDataReader = ExcelReaderFactory.CreateOpenXmlReader(stream)
                        excelReader.IsFirstRowAsColumnNames = False
                        Dim result As DataSet = excelReader.AsDataSet()

                        File.Delete(fullpath)

                        transfer_items_from_file(result)

                    Catch ex As Exception
                        lbl_error.Text = "El archivo está vacío"
                    End Try
                Else
                    lbl_error.Text = "Seleccione el archivo de Excel"
                End If
            Catch ex As Exception
                MsgBox(ex.Message)
            End Try
            i += 1
        Loop
    End Sub

    Public Sub transfer_items_from_file(ByVal items_list As DataSet)
        Dim strModel, strFromRack, strToRack, strLocation, strQty, strToLocation As String
        Dim username As String
        'Dim logevent As String
        Dim queryForTemporal = ""
        Dim queryForUpdate = ""
        Dim queryForNewRecord = ""
        Dim queryForLogs = ""
        Dim error_msg = ""
        Dim good_msg = ""

        username = Membership.GetUser().UserName

        'logevent = "Transferencia interna de los siguientes productos:"
        strLocation = ddl_from_location.SelectedItem.Text.ToString()
        strToLocation = ddl_to_location.SelectedItem.Text.ToString()

        If strLocation = "Seleccione..." Or strToLocation = "Seleccione..." Then
            error_msg = "Verifique las Sucursales"
        Else
            For i = 0 To items_list.Tables(0).Rows.Count - 1
                strModel = Replace(items_list.Tables(0).Rows(i)(0).ToString().ToUpper(), " ", "")
                strQty = items_list.Tables(0).Rows(i)(1).ToString()
                strFromRack = items_list.Tables(0).Rows(i)(2).ToString().ToUpper()
                If strLocation = strToLocation Then
                    strToRack = ""
                    Try
                        If items_list.Tables(0).Rows(i)(3).ToString() <> "" Then
                            strToRack = items_list.Tables(0).Rows(i)(3).ToString().ToUpper()
                        End If
                    Catch ex As Exception
                        error_msg += "Indique el Rack al que desea enviar el código: " + strModel + " - línea: " + (i + 1).ToString() + "<br />"
                    End Try
                Else
                    strToRack = "TEMPORAL"
                End If

                If strModel <> "" Then
                    If strFromRack <> "" And strToRack <> "" And strQty <> "" And strFromRack <> strToRack Then
                        If strQty > 0 Then
                            Dim strProdId, strProdDesc, strProdModel, strProd_lowInv, strCategory As String
                            query = "select products.id, categories.name, description, low_inventory, model from products inner join categories on products.category = categories.id where code = '" + strModel.ToString() + "'"
                            ds = Dataconnect.GetAll(query)
                            If ds.Tables(0).Rows.Count > 0 Then 'si existe producto
                                strProdId = ds.Tables(0).Rows(0)("id")
                                strCategory = ds.Tables(0).Rows(0)("name")
                                strProdDesc = ds.Tables(0).Rows(0)("description")
                                strProdModel = ds.Tables(0).Rows(0)("model")
                                strProd_lowInv = ds.Tables(0).Rows(0)("low_inventory")

                                query = "select id, qty from stock where product_id = '" + strProdId.ToString() + "' and location = '" + strLocation.ToString() + "' and rack = '" + strFromRack.ToString() + "'"
                                ds = Dataconnect.GetAll(query)

                                If ds.Tables(0).Rows.Count > 0 Then 'si hay producto en rack de donde se pretende sacar
                                    Dim intFromQty, restFromQty As Integer
                                    Dim strFromStockID As String

                                    intFromQty = ds.Tables(0).Rows(0)("qty")
                                    strFromStockID = ds.Tables(0).Rows(0)("id").ToString()

                                    restFromQty = intFromQty - strQty
                                    If restFromQty >= 0 Then
                                        If strToRack = "TEMPORAL" Then 'nueva opción, meter al rack de diferente fecha
                                            queryForTemporal += "insert into stock (product_id,product_code,product_description,product_model,product_low_inventory,product_category,qty,location,last_update,rack,from_location,location_id) values (" + strProdId.ToString() + ", '" + strModel.ToString().ToUpper() + "', '" + strProdDesc.ToString() + "', "
                                            queryForTemporal += "'" + strProdModel.ToString() + "', " + strProd_lowInv.ToString() + ", '" + strCategory.ToString() + "', " + strQty.ToString()
                                            queryForTemporal += ", '" + strToLocation.ToString() + "', getDate(), '" + strToRack.ToString() + "', '" + strLocation.ToString() + "'," + ddl_to_location.SelectedValue.ToString() + ") "
                                        Else
                                            query = "select id from stock where product_id = '" + strProdId.ToString() + "' and location = '" + strToLocation.ToString() + "' and rack = '" + strToRack.ToString() + "'"
                                            ds = Dataconnect.GetAll(query)
                                            If ds.Tables(0).Rows.Count > 0 Then 'hay producto en rack a donde se pretende ingresar, se suma cantidad original mas cantidad especificada, se resta la cantidad a la cantidad del rack de donde viene el producto
                                                Dim strToStockID As String
                                                strToStockID = ds.Tables(0).Rows(0)("id").ToString()

                                                queryForUpdate += "update stock set qty = qty + " + strQty.ToString() + ", from_location = '" + strLocation.ToString() + "' where id = " + strToStockID.ToString() + " "
                                            Else 'no hay producto en rack a donde se pretende ingresar, se ingresa un nuevo record
                                                queryForNewRecord += "insert into stock (product_id,product_code,product_description,product_model,product_low_inventory,product_category,qty,location,last_update,rack,from_location,location_id) values (" + strProdId.ToString() + ", '" + strModel.ToString().ToUpper() + "', '" + strProdDesc.ToString() + "', "
                                                queryForNewRecord += "'" + strProdModel.ToString() + "', " + strProd_lowInv.ToString() + ", '" + strCategory.ToString() + "', " + strQty.ToString()
                                                queryForNewRecord += ", '" + strToLocation.ToString() + "', getDate(), '" + strToRack.ToString() + "', '" + strLocation.ToString() + "'," + ddl_to_location.SelectedValue.ToString() + ") "
                                            End If
                                        End If
                                        queryForLogs += "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values ("
                                        queryForLogs += strProdId.ToString() + ", '" + strModel.ToString() + "', 'Transferencia', 'Transferencia', 'de :" + strLocation + " a " + strToLocation + "', '"
                                        queryForLogs += strLocation.ToString() + "', '" + strFromRack + "', '" + username + "', getdate(), " + strQty.ToString() + ")"
                                        queryForLogs += " insert into logs values ('" + username + "', 'Trasferencia del producto " + strModel.ToString() + " locacion:" + strLocation + " -> " + strToLocation + ", rack: " + strFromRack.ToString() + " -> " + strToRack.ToString() + " por la cantidad de " + strQty.ToString() + "', getdate())"
                                        queryForLogs += " update stock set qty = qty - " + strQty.ToString() + " where id = " + strFromStockID.ToString()
                                        queryForLogs += " delete from stock where qty <= 0 "

                                        good_msg += "Transferencia exitosa del código: " + strModel + " - línea: " + (i + 1).ToString() + "<br />"
                                    Else 'la cantidad especificada es mayor a lo que queda en el rack
                                        error_msg += "La cantidad especificada excede el inventario del código: " + strModel + ", solo hay " + intFromQty.ToString() + " piezas en el rack " + strFromRack + " - línea: " + (i + 1).ToString() + "<br />"
                                    End If
                                Else 'no hay producto del rack especificado
                                    error_msg += "No hay piezas del producto " + strModel + " en " + strLocation + " dentro del rack " + strFromRack + " - línea: " + (i + 1).ToString() + "<br />"
                                End If
                            Else 'no existe el codigo
                                error_msg += "No existe el producto: " + strModel + " en el sistema - línea: " + (i + 1).ToString() + "<br />"
                            End If
                        Else 'cantidad menor que cero
                            error_msg += "No ingrese cantidades menores o iguales a cero, verifique el código " + strModel + " - línea: " + (i + 1).ToString() + "<br />"
                        End If
                    Else 'error en datos
                        error_msg += "Verifique la información del código " + strModel + " - línea: " + (i + 1).ToString() + "<br />"
                    End If
                Else 'se acaba salto de renglon o ultimo renglon
                End If
            Next
        End If

        If error_msg.ToString() = "" Then 'si no hay mensajes de error, se realizan las transferencias
            Dataconnect.runquery(queryForTemporal)
            Dataconnect.runquery(queryForUpdate)
            Dataconnect.runquery(queryForNewRecord)
            Dataconnect.runquery(queryForLogs)
            lbl_msg.Text = good_msg.ToString()
        Else 'si hay mensajes de error, se muestran y no se hacen las transferencias
            If error_msg = "Verifique las Sucursales" Then
                lbl_error.Text = error_msg.ToString()
            Else
                error_msg += "<br />¡No se realizó ninguna transferencia!"
                lbl_error.Text = error_msg.ToString()
            End If
        End If
        'queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
        'Dataconnect.runquery(queryLog)
        'Response.Redirect("intra_trnsfr.aspx")
    End Sub

    'Public Sub transfer_items(ByVal items_list As String)
    '    Dim items() As String = items_list.Split("]")
    '    Dim strModel, strFromRack, strToRack, strLocation, strQty, error_msg, strToLocation As String
    '    Dim username As String
    '    Dim logevent As String
    '    error_msg = ""
    '    Dim good_msg As String = ""

    '    username = Membership.GetUser().UserName

    '    logevent = "Transferencia interna de los siguientes productos:"
    '    strLocation = ddl_from_location.SelectedItem.Text.ToString()
    '    strToLocation = ddl_to_location.SelectedItem.Text.ToString()

    '    If strLocation = "-" Or strToLocation = "-" Then
    '        error_msg = "verifique las locaciones"
    '    Else
    '        For i = 0 To items.Length - 1
    '            Dim items_det() As String = items(i).Split("}")

    '            strModel = Replace(items_det(0).ToString().ToUpper(), " ", "")
    '            strQty = items_det(1).ToString()
    '            strFromRack = items_det(2).ToString().ToUpper()
    '            If strLocation = strToLocation Then
    '                strToRack = ""
    '                If items_det.Length >= 4 Then
    '                    strToRack = items_det(3).ToString()
    '                Else
    '                    error_msg += "Indique el Rack al que desea enviar el codigo: " + strModel + " - linea: " + (i + 1).ToString() + "<br />"
    '                End If
    '            Else
    '                strToRack = "TEMPORAL"
    '            End If

    '            If strModel <> "" Then
    '                If strFromRack <> "" And strToRack <> "" And strQty <> "" And strFromRack <> strToRack Then
    '                    If strQty > 0 Then
    '                        Dim strProdId, strProdDesc, strProdModel, strProd_lowInv, strCategory As String
    '                        query = "select products.id, categories.name, description, low_inventory, model from products inner join "
    '                        query += " categories on products.category = categories.id where code = '" + strModel.ToString() + "'"
    '                        ds = Dataconnect.GetAll(query)
    '                        If ds.Tables(0).Rows.Count > 0 Then
    '                            'si existe producto
    '                            strProdId = ds.Tables(0).Rows(0)("id")
    '                            strCategory = ds.Tables(0).Rows(0)("name").ToUpper()
    '                            strProdDesc = ds.Tables(0).Rows(0)("description")
    '                            strProdModel = ds.Tables(0).Rows(0)("model").ToUpper()
    '                            strProd_lowInv = ds.Tables(0).Rows(0)("low_inventory")

    '                            query = "select id, qty from stock where product_id = '" + strProdId.ToString()
    '                            query += "' and location = '" + strLocation.ToString() + "' and rack = '" + strFromRack.ToString() + "'"
    '                            ds = Dataconnect.GetAll(query)

    '                            If ds.Tables(0).Rows.Count > 0 Then
    '                                'si hay producto en rack de donde se pretende sacar
    '                                Dim intFromQty, restFromQty As Integer
    '                                Dim strFromStockID As String

    '                                intFromQty = ds.Tables(0).Rows(0)("qty")
    '                                strFromStockID = ds.Tables(0).Rows(0)("id").ToString()

    '                                restFromQty = intFromQty - strQty
    '                                If restFromQty >= 0 Then
    '                                    'se comento debido a que pidieron que se fuera acomulando
    '                                    'If strToRack = "TEMPORAL" Then
    '                                    'If strLocation.ToUpper = "HENEQUEN" Or strLocation.ToUpper = "VALENTIN" Then
    '                                    '    query = "select id from stock where product_id = '" + strProdId.ToString() + "' and location = '" + strToLocation.ToString() + "' and rack = '" + strToRack.ToString() + "'"
    '                                    '    ds = Dataconnect.GetAll(query)

    '                                    '    If ds.Tables(0).Rows.Count > 0 Then
    '                                    '        'Si hay producto en rack a donde se pretende ingresar, se suma cantidad original mas cantidad especificada
    '                                    '        Dim strToStockID As String
    '                                    '        strToStockID = ds.Tables(0).Rows(0)("id").ToString()

    '                                    '        query = "update stock set qty = qty + " + strQty.ToString() + ", from_location = '" + strLocation.ToString() + "', last_update = getdate() where id = " + strToStockID.ToString()
    '                                    '        Dataconnect.runquery(query)

    '                                    '    Else
    '                                    '        'No hay producto en rack a donde se pretende ingresar, se ingresa un nuevo record
    '                                    '        query = "insert into stock (product_id,product_code,product_description,product_model,product_low_inventory,product_category,qty,location,last_update,rack"
    '                                    '        query += " ,from_location,location_id) values (" + strProdId.ToString() + ", '" + strModel.ToString().ToUpper() + "', '" + strProdDesc.ToString() + "', "
    '                                    '        query += "'" + strProdModel.ToString() + "', " + strProd_lowInv.ToString() + ", '" + strCategory.ToString() + "', " + strQty.ToString()
    '                                    '        query += ", '" + strToLocation.ToString() + "', getDate(), '" + strToRack.ToString() + "', '" + strLocation.ToString() + "'," + ddl_to_location.SelectedValue.ToString() + ")"
    '                                    '        Dataconnect.runquery(query)

    '                                    '    End If
    '                                    'Else
    '                                    '    query = "insert into stock (product_id,product_code,product_description,product_model,product_low_inventory,product_category"
    '                                    '    query += ",qty,location,last_update,rack,from_location,location_id) values (" + strProdId.ToString() + ", '" + strModel.ToString().ToUpper()
    '                                    '    query += "', '" + strProdDesc.ToString() + "', '" + strProdModel.ToString() + "', " + strProd_lowInv.ToString() + ", '" + strCategory.ToString() + "', " + strQty.ToString()
    '                                    '    query += ", '" + strToLocation.ToString() + "', getDate(), '" + strToRack.ToString() + "', '" + strLocation.ToString() + "'," + ddl_to_location.SelectedValue.ToString() + ")"
    '                                    '    Dataconnect.runquery(query)
    '                                    'End If

    '                                    'Else
    '                                    query = "select id from stock where product_id = '" + strProdId.ToString() + "' and location = '" + strToLocation.ToString() + "' and rack = '" + strToRack.ToString() + "'"
    '                                    ds = Dataconnect.GetAll(query)

    '                                    If ds.Tables(0).Rows.Count > 0 Then
    '                                        'hay producto en rack a donde se pretende ingresar, se suma cantidad original mas cantidad especificada, se resta la cantidad a la cantidad del rack de donde viene el producto
    '                                        Dim strToStockID As String
    '                                        strToStockID = ds.Tables(0).Rows(0)("id").ToString()

    '                                        query = "update stock set qty = qty + " + strQty.ToString() + ", from_location = '" + strLocation.ToString() + "', last_update = getdate() where id = " + strToStockID.ToString()
    '                                        Dataconnect.runquery(query)

    '                                    Else
    '                                        'no hay producto en rack a donde se pretende ingresar, se ingresa un nuevo record
    '                                        query = "insert into stock (product_id,product_code,product_description,product_model,product_low_inventory,product_category,qty,location,last_update,rack,from_location,location_id) values (" + strProdId.ToString() + ", '" + strModel.ToString().ToUpper() + "', '" + strProdDesc.ToString() + "', "
    '                                        query += "'" + strProdModel.ToString() + "', " + strProd_lowInv.ToString() + ", '" + strCategory.ToString() + "', " + strQty.ToString()
    '                                        query += ", '" + strToLocation.ToString() + "', getDate(), '" + strToRack.ToString() + "', '" + strLocation.ToString() + "'," + ddl_to_location.SelectedValue.ToString() + ")"
    '                                        Dataconnect.runquery(query)

    '                                    End If
    '                                    'End If

    '                                    query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values ("
    '                                    query += strProdId.ToString() + ", '" + strModel.ToString() + "', 'Transferencia', 'Transferencia', 'de :" + strLocation + " a " + strToLocation + "', '"
    '                                    query += strLocation.ToString() + "', '" + strFromRack + "', '" + username + "', getdate(), " + strQty.ToString() + ")"
    '                                    query += " insert into logs values ('" + username + "', 'Trasferencia del producto " + strModel.ToString() + " locacion:" + strLocation + " -> " + strToLocation + ", rack: " + strFromRack.ToString() + " -> " + strToRack.ToString() + " por la cantidad de " + strQty.ToString() + "', getdate())"
    '                                    query += " update stock set qty = qty - " + strQty.ToString() + " where id = " + strFromStockID.ToString()
    '                                    query += " delete from stock where qty <= 0"

    '                                    Dataconnect.runquery(query)

    '                                    good_msg += "Transferencia exitosa del codigo: " + strModel + " - linea: " + (i + 1).ToString() + "<br />"

    '                                Else
    '                                    'la cantidad especificada es mayor a lo que queda en el rack
    '                                    error_msg += "La cantidad especificada excede el inventario del codigo: " + strModel + ", solo hay " + intFromQty.ToString() + " piezas en el rack " + strFromRack + " - linea: " + (i + 1).ToString() + "<br />"
    '                                End If
    '                            Else
    '                                'no hay producto del rack especificado
    '                                error_msg += "No hay piezas del producto " + strModel + " en " + strLocation + " dentro del rack " + strFromRack + " - linea: " + (i + 1).ToString() + "<br />"
    '                            End If
    '                        Else
    '                            'no existe el codigo
    '                            error_msg += "No existe el producto: " + strModel + " en el sistema - linea: " + (i + 1).ToString() + "<br />"
    '                        End If
    '                    Else
    '                        'cantidad menor que cero
    '                        error_msg += "No ingrese cantidades menores a cero verifique el codigo " + strModel + " - linea: " + (i + 1).ToString() + "<br />"
    '                    End If
    '                Else
    '                    'error en datos
    '                    error_msg += "Verifique la informacion del codigo " + strModel + " - linea: " + (i + 1).ToString() + "<br />"
    '                End If
    '            Else
    '                'se acaba salto de renglon o ultimo renglon
    '            End If
    '        Next
    '    End If

    '    lbl_error.Text = error_msg.ToString()
    '    lbl_msg.Text = good_msg.ToString()

    '    'queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
    '    'Dataconnect.runquery(queryLog)

    '    'Response.Redirect("intra_trnsfr.aspx")
    'End Sub

    Protected Sub leadexcel_Click(sender As Object, e As EventArgs) Handles leadexcel.Click
        readExcel()
    End Sub

End Class