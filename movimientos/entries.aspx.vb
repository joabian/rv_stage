Imports System.Data
Imports System.Text
Imports System.Drawing
Imports System.IO
Imports Excel
Imports OfficeOpenXml

Partial Class movimientos_entries
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public username As String
    Public sendemail As New email_mng

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        username = Membership.GetUser().UserName
        If Not IsPostBack Then
            populate_ddl_locations()
        End If

    End Sub

    Public Sub populate_ddl_locations()
        Dim location_st, location_alias As String

        query = "select location,alias from users left join locations on users.location = locations.id where user_name = '" + username + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            location_st = ds.Tables(0).Rows(0)("location").ToString()
            location_alias = ds.Tables(0).Rows(0)("alias").ToString()
            If location_st = "0" Then
                query = "select id, alias from locations"
            Else
                query = "select id, alias from locations where id = " + location_st.ToString()
            End If
            ds = Dataconnect.GetAll(query)

            If ds.Tables(0).Rows.Count > 0 Then
                location.DataSource = ds.Tables(0)
                location.DataValueField = "id"
                location.DataTextField = "alias"
                location.DataBind()
                If location_st <> "0" Then
                    location.SelectedValue = location_st
                End If
            Else
                location.DataSource = Nothing
                location.DataBind()
            End If
        End If

    End Sub

    Protected Sub save_Click(sender As Object, e As System.EventArgs) Handles save.Click
        Dim logevent As String
        Dim newqty As Integer
        Dim rackid As String
        Dim reason As String
        Dim comm As String
        Dim prod_code As String = Replace(Replace(productId.Text, "'", ""), " ", "").ToString().ToUpper()
        Dim intProduct_id As Integer
        Dim intQty As Integer
        Dim location_name As String = location.SelectedItem.Text
        rackid = rack.Text
        reason = type.SelectedItem.Text.ToString()
        If comments.Text <> "" Then
            comm = Replace(comments.Text, "'", "''").ToString()
        Else
            comm = ""
        End If
        intQty = Replace(qty.Text, "'", "").ToString()

        query = "select * from products where code = '" + prod_code.ToString() + "'"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            If intQty <= 0 Then
                errorlbl.Text = "Verifique los datos, esta tratando de ingresar cantidades no validas"
            ElseIf reason = "AJUSTE INVENTARIO" Then
                If (location_name.ToUpper = "HENEQUEN" And username = "estefania") Or location_name <> "HENEQUEN" Then
                    query = "insert into ajustes (username,location,item,rack,qty,notes,create_date,tipo) values ('" + username.ToString() + "','" + location.SelectedItem.Text.ToString() + "','"
                    query += prod_code.ToString() + "','" + rackid.ToString() + "','" + intQty.ToString() + "','" + comm.ToString() + "',getdate(),'ENTRADA')"
                    Dataconnect.runquery(query)

                    Dim body As String = bodyHtml(location.SelectedValue, prod_code, intQty, comm)
                    Dim distro As String = "joabian.alvarez@gmail.com,samuel.gonzalez@radiadoresvencedores.com"

                    sendemail.sendEmail(distro, "Ajuste de Inventario - ENTRADA", body)

                    errorlbl.Text = "El ajuste quedo grabado con exito, despues de revisarlo se procedera a realizarlo o negarlo"
                Else
                    errorlbl.Text = "Usted no tiene acceso a realizar ajustes"
                End If
                
            Else
                intProduct_id = ds.Tables(0).Rows(0)("id").ToString()
                query = "select * from stock where product_code = '" + prod_code.ToString() + "' and location_id = '" + location.SelectedValue.ToString() + "' and rack = '" + rackid.ToString() + "'"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    Dim oldqty As Integer
                    oldqty = ds.Tables(0).Rows(0)("qty").ToString()

                    newqty = oldqty + intQty

                    query = "update stock set qty = (qty + " + intQty.ToString() + "), last_update = getDate() where product_code = '" + prod_code.ToString() + "' and location_id = '" + location.SelectedValue.ToString() + "' and rack = '" + rackid.ToString() + "'"
                    Dataconnect.runquery(query)

                    logevent = "Entrada de producto: " + prod_code.ToString() + " de la sucursal: " + location.SelectedItem.Text.ToString() + " en el rack: " + rackid.ToString() + " por la cantidad de: " + intQty.ToString() + " dejando el inventario actual en: " + newqty.ToString()

                    queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                    Dataconnect.runquery(queryLog)
                Else
                    query = "insert into stock (product_id,product_code,product_description,product_model,product_low_inventory,product_category,qty,location,last_update,rack,from_location,location_id) select products.id, products.code, products.description, products.model,"
                    query += " products.low_inventory, categories.name, " + intQty.ToString() + ", '" + location.SelectedItem.Text.ToString()
                    query += "', getDate(), '" + rackid.ToString().ToUpper() + "', 'ENTRADA', '" + location.SelectedValue.ToString().ToUpper() + "' from products inner join categories on products.category"
                    query += " = categories.id where products.id = " + intProduct_id.ToString().ToUpper()
                    Dataconnect.runquery(query)

                    logevent = "Ingreso producto al inventario de la sucursal: " + location.SelectedItem.Text.ToString() + " en el rack: " + rackid.ToString() + ", producto: " + prod_code.ToString() + ", cantidad: " + intQty.ToString() + " dejando el inventario en: " + intQty.ToString()

                    queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                    Dataconnect.runquery(queryLog)
                End If
                query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (" + intProduct_id.ToString().ToUpper() + ", '" + prod_code.ToString().ToUpper() + "', '" + reason.ToString().ToUpper() + "', 'ENTRADA', '" + comm.ToString().ToUpper() + "', '" + location.SelectedItem.Text.ToString().ToUpper() + "', '" + rackid.ToString().ToUpper() + "', '" + username.ToString() + "', getDate(), " + intQty.ToString() + ")"
                Dataconnect.runquery(query)
                Response.Redirect("entries.aspx")
            End If
        Else
            errorlbl.Text = "Verifique los datos, el producto no existe en nuestra base de datos"
        End If

    End Sub

    Public Sub readExcelNew()
        Dim items As String = ""
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
                        userPostedFile.SaveAs(fullpath)

                        Dim stream As FileStream = File.Open(fullpath, FileMode.Open, FileAccess.Read)
                        Dim excelReader As IExcelDataReader = ExcelReaderFactory.CreateOpenXmlReader(stream)
                        excelReader.IsFirstRowAsColumnNames = False
                        Dim result As DataSet = excelReader.AsDataSet()

                        File.Delete(filepath & "\" + filename)

                        add_itemsNew(result)

                    Catch ex As Exception
                        lbl_error_file.Text = ex.Message
                    End Try
                End If
            Catch ex As Exception
                lbl_error_file.Text = ex.Message
            End Try
            i += 1
        Loop

    End Sub

    Protected Sub leadexcel_Click(sender As Object, e As EventArgs) Handles leadexcel.Click
        If type.SelectedValue = "AJUSTE INVENTARIO" Then
            lbl_error_file.Text = "Los ajustes de inventario no se pueden realizar masivos"
        Else
            readExcelNew()
        End If

    End Sub


    Public Sub add_itemsNew(ByVal list_items As DataSet)
        Dim motivo, sucursal, sucursal_id, error_msg, item, rack, qty, id_record, logevent As String
        error_msg = ""
        sucursal_id = location.SelectedValue.ToString()
        sucursal = location.SelectedItem.Text.ToString()
        motivo = type.SelectedValue.ToString()

        If sucursal <> "-" Then

            For i = 0 To list_items.Tables(0).Rows.Count - 1

                item = Replace(Replace(list_items.Tables(0).Rows(i)(0).ToString(), "'", ""), " ", "").ToUpper()
                qty = list_items.Tables(0).Rows(i)(2).ToString()
                rack = list_items.Tables(0).Rows(i)(1).ToString()

                'verificamos que sean cantidades numericas
                If Not IsNumeric(qty) Or qty = "0" Or item = "" Or rack = "" Then
                    error_msg += "Verifique que todos los datos esten correctos en linea: " + (i + 1).ToString() + "<br />"
                Else
                    query = "select * from products where code = '" + item.ToString() + "'"
                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        Dim prod_id As String = ds.Tables(0).Rows(0)("id").ToString()
                        'verificamos si existe una linea en la orden, para sumarla a la cantidad actual
                        query = "select * from stock where product_code = '" + item.ToString() + "' and rack = '" + rack.ToString() + "' and location_id = '" + sucursal_id.ToString() + "'"
                        ds = Dataconnect.GetAll(query)
                        If ds.Tables(0).Rows.Count > 0 Then
                            'sumar a la cantidad actual
                            id_record = ds.Tables(0).Rows(0)("id").ToString()

                            query = "update stock set qty = (qty + " + qty.ToString() + ") where id = " + id_record.ToString()
                            Dataconnect.runquery(query)

                            query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (" + prod_id.ToString().ToUpper() + ", '" + item.ToString().ToUpper() + "', '" + motivo.ToString().ToUpper() + "', 'ENTRADA', 'Alta masiva', '" + sucursal.ToString().ToUpper() + "', '" + rack.ToString().ToUpper() + "', '" + username.ToString() + "', getDate(), " + qty.ToString() + ")"
                            Dataconnect.runquery(query)

                            logevent = "Entrada de producto: " + item.ToString() + " en la sucursal: " + sucursal.ToString() + " al rack: " + rack.ToString() + ", por la cantidad de: " + qty.ToString()
                            queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                            Dataconnect.runquery(queryLog)
                        Else
                            'ingresar nueva linea
                            query = "insert into stock (product_id,product_code,product_description,product_model,product_low_inventory,product_category,qty,location,last_update,rack,from_location,location_id) select products.id, products.code, products.description, products.model,"
                            query += " products.low_inventory, categories.name, " + qty.ToString() + ", '" + sucursal.ToString().ToUpper()
                            query += "', getDate(), '" + rack.ToString().ToUpper() + "', 'ENTRADA', '" + sucursal_id.ToString() + "' from products inner join categories on products.category"
                            query += " = categories.id where products.id = " + prod_id.ToString()
                            Dataconnect.runquery(query)

                            query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (" + prod_id.ToString().ToUpper() + ", '" + item.ToString().ToUpper() + "', '" + motivo.ToString().ToUpper() + "', 'ENTRADA', 'Alta masiva', '" + sucursal.ToString().ToUpper() + "', '" + rack.ToString().ToUpper() + "', '" + username.ToString() + "', getDate(), " + qty.ToString() + ")"
                            Dataconnect.runquery(query)

                            logevent = "Entrada de producto: " + item.ToString() + " en la sucursal: " + sucursal.ToString() + " al rack: " + rack.ToString() + ", por la cantidad de: " + qty.ToString()
                            queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                            Dataconnect.runquery(queryLog)
                        End If
                    Else
                        error_msg += "El item: " + item.ToString() + " no existe en la base de datos<br />"
                    End If
                End If
            Next

            If error_msg <> "" Then
                lbl_error_file.Text = "<br />Corrija los siguiente errores, el resto se ingreso con exito:<br />" + error_msg
            Else
                lbl_error_file.ForeColor = Color.Green
                lbl_error_file.Text = "<br />El archivo se cargo con exito!"
            End If

        Else
            lbl_error_file.Text = "<br />seleccione Sucursal"
        End If

    End Sub


    Public Sub add_items(ByVal list_items As String)
        Dim motivo, sucursal, sucursal_id, error_msg, item, rack, qty, id_record, logevent As String
        error_msg = ""
        Dim item_details() As String
        sucursal = location.SelectedItem.Text.ToString()
        sucursal_id = location.SelectedValue.ToString()
        motivo = type.SelectedValue.ToString()


        If sucursal <> "-" Then

            Dim items_array() As String = list_items.Split("]")
            For i = 0 To items_array.Length - 1

                item_details = items_array(i).Split("}")
                item = Replace(Replace(item_details(0).ToString(), "'", ""), " ", "").ToUpper()
                qty = item_details(2).ToString()
                rack = item_details(1).ToString()


                'verificamos que sean cantidades numericas
                If Not IsNumeric(qty) Or qty = "0" Then
                    error_msg += "Campo de Cantidad en 0 o esta incorrecto en linea: " + (i + 1).ToString() + "<br />"
                Else
                    query = "select * from products where code = '" + item.ToString() + "'"
                    ds = Dataconnect.GetAll(query)
                    If ds.Tables(0).Rows.Count > 0 Then
                        Dim prod_id As String = ds.Tables(0).Rows(0)("id").ToString()
                        'verificamos si existe una linea en la orden, para sumarla a la cantidad actual
                        query = "select * from stock where product_code = '" + item.ToString() + "' and rack = '" + rack.ToString() + "' and location_id = '" + sucursal_id.ToString() + "'"
                        ds = Dataconnect.GetAll(query)
                        If ds.Tables(0).Rows.Count > 0 Then
                            'sumar a la cantidad actual
                            id_record = ds.Tables(0).Rows(0)("id").ToString()
                            Dim actual_qty As String = ds.Tables(0).Rows(0)("qty").ToString()

                            query = "update stock set qty = (qty + " + qty.ToString() + ") where id = " + id_record.ToString()
                            Dataconnect.runquery(query)

                            query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (" + prod_id.ToString().ToUpper() + ", '" + item.ToString().ToUpper() + "', '" + motivo.ToString().ToUpper() + "', 'ENTRADA', 'Alta masiva', '" + sucursal.ToString().ToUpper() + "', '" + rack.ToString().ToUpper() + "', '" + username.ToString() + "', getDate(), " + qty.ToString() + ")"
                            Dataconnect.runquery(query)

                            logevent = "Entrada de producto: " + item.ToString() + " en la sucursal: " + sucursal.ToString() + " al rack: " + rack.ToString() + ", por la cantidad de: " + qty.ToString()
                            queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                            Dataconnect.runquery(queryLog)


                        Else
                            'ingresar nueva linea

                            query = "insert into stock (product_id,product_code,product_description,product_model,product_low_inventory,product_category,qty,location,last_update,rack,from_location,location_id) select products.id, products.code, products.description, products.model,"
                            query += " products.low_inventory, categories.name, " + qty.ToString() + ", '" + sucursal.ToString().ToUpper()
                            query += "', getDate(), '" + rack.ToString().ToUpper() + "', 'Entrada', '" + sucursal_id.ToString() + "' from products inner join categories on products.category"
                            query += " = categories.id where products.id = " + prod_id.ToString()
                            Dataconnect.runquery(query)

                            query = "insert into moves (product_id,product_code,reason,type,comments,location,rack,[user],row_date,qty) values (" + prod_id.ToString().ToUpper() + ", '" + item.ToString().ToUpper() + "', '" + motivo.ToString().ToUpper() + "', 'ENTRADA', 'Alta masiva', '" + sucursal.ToString().ToUpper() + "', '" + rack.ToString().ToUpper() + "', '" + username.ToString() + "', getDate(), " + qty.ToString() + ")"
                            Dataconnect.runquery(query)

                            logevent = "Entrada de producto: " + item.ToString() + " en la sucursal: " + sucursal.ToString().ToUpper() + " al rack: " + rack.ToString().ToUpper() + ", por la cantidad de: " + qty.ToString()
                            queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                            Dataconnect.runquery(queryLog)

                        End If
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


    Function bodyHtml(ByVal sucursal As String, ByVal item As String, ByVal qty As String, ByVal notas As String) As String
        Dim html As String = ""

        html += "<h1>Notificacion</h1><br />"
        html += "<h2>Se requiere aprobar un ajuste de inventario</h2><br />"

        html += "<h3><b>Informacion del ajuste</b><br /><br />"
        html += "Tipo: <b>ENTRADA</b><br />"
        html += "Sucursal: <b>" + sucursal.ToString() + "</b><br />"
        html += "Producto: <b>" + item.ToString() + "</b><br />"
        html += "Cantidad: <b>" + qty.ToString() + "</b><br />"
        html += "Notas: <b>" + notas.ToString() + "</b><br />"
        html += "Usuario: <b>" + username.ToString() + "</b><br />"
        html += "Fecha requerido: <b>" + Date.Now().ToString("dd/MM/yyyy") + "</b><br /></h3>"

        Return html
    End Function



End Class
