Imports System.Data
Imports System.IO
Imports System.Collections.Generic

Partial Class productos_edit_prod
    Inherits System.Web.UI.Page
    Public query As String
    Public queryLog As String
    Public Dataconnect As New DataConn_login
    Public ds As DataSet
    Public username As String = Membership.GetUser().UserName

    Protected Sub Page_Init(sender As Object, e As System.EventArgs) Handles Me.Init
        If Roles.IsUserInRole("admin") Then
        Else
            Response.Redirect("role_no_access.aspx")
        End If
        
    End Sub

    '8652
    Protected Sub UploadButton_Click(sender As Object, e As EventArgs) Handles UploadButton.Click

        uplFileNew()

        'Dim filepath As String = "e:\HostingSpaces\vencedo2\radiadoresvencedores.com\wwwroot\docs"
        'Dim uploadedFiles As HttpFileCollection = Request.Files
        'Dim i As Integer = 0
        'Do Until i = uploadedFiles.Count
        '    Dim userPostedFile As HttpPostedFile = uploadedFiles(i)
        '    Try
        '        If (userPostedFile.ContentLength > 0) Then
        '            Dim filename As String = Replace(System.IO.Path.GetFileName(userPostedFile.FileName), "'", "")
        '            Dim fullpath As String = filepath & "\" & filename
        '            Try
        '                userPostedFile.SaveAs(fullpath)

        '                Dim stream As FileStream = File.Open(fullpath, FileMode.Open, FileAccess.Read)

        '                Dim excelReader As IExcelDataReader = ExcelReaderFactory.CreateOpenXmlReader(stream)
        '                excelReader.IsFirstRowAsColumnNames = False
        '                Dim result As DataSet = excelReader.AsDataSet()

        '                'If result.Tables(0).Rows.Count > 0 Then

        '                '                      For h As Integer = 0 To result.Tables(0).Rows.Count - 1
        '                '                          For j As Integer = 0 To result.Tables(0).Columns.Count - 1
        '                '                              items += result.Tables(0).Rows(h)(j).ToString() + "}"
        '                '                          Next
        '                '                          items = items.Substring(0, items.Length - 1)
        '                '                          items += "]"
        '                '                      Next

        '                'End If

        '                File.Delete(fullpath)

        '                'items = items.Substring(0, items.Length - 1)

        '                remove_itemsNew(result)

        '            Catch ex As Exception
        '                lbl_error_file.Text = ex.Message
        '            End Try
        '        End If
        '    Catch ex As Exception
        '        lbl_error_file.Text = ex.Message
        '    End Try
        '    i += 1
        'Loop
    End Sub

    Public Sub uplFileOriginal()

        If UploadTest.HasFile = False Then
            lbl_msg_img.Text = "Please first select a file to upload..."
        Else
            Try
                If String.Compare(System.IO.Path.GetExtension(UploadTest.FileName), ".jpg", True) <> 0 Then
                    lbl_msg_img.Text = "Only JPEG (.jpg) documents may be used for a product's pictures."
                Else
                    Dim filePath As String = "e:\HostingSpaces\vencedo2\radiadoresvencedores.com\wwwroot\images\tapas\" & tbx_search.Text.ToString() & ".jpg"
                    If File.Exists(filePath) Then
                        File.Delete(filePath)
                    End If

                    UploadTest.SaveAs(filePath)
                End If
            Catch ex As Exception
                lbl_msg_img.Text = ex.Message.ToString()
            End Try

        End If

    End Sub

    Public Sub uplFileNew()

        'lbl_msg_img.Text = Server.MapPath("~/images/tapas/").ToString()
        
        If UploadTest.HasFile Then
            'Dim fileName As String = Path.GetFileName(UploadTest.PostedFile.FileName)
            Dim ext As String = Path.GetExtension(UploadTest.PostedFile.FileName)
            lbl_msg_img.Text = ext
            If ext.ToUpper() = ".JPG" Then
                UploadTest.PostedFile.SaveAs(Server.MapPath("~/images/tapas/") + tbx_search.Text.ToUpper() + ".jpg")
                lbl_msg_img.ForeColor = Drawing.Color.Green
                lbl_msg_img.Text = "Imagen guardada con exito!"
                img_item.ImageUrl = "~/images/tapas/" + tbx_search.Text.ToUpper() + ".jpg"
            Else
                lbl_msg_img.Text = "Solo son soportados archivos con extencion .jpg"
            End If
            
        End If
    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            populateCategories()
            populateLocations()
        End If
    End Sub

    Public Sub populateCategories()
        query = "select id, name from categories"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            ddl_category2.DataSource = ds.Tables(0)
            ddl_category2.DataValueField = "id"
            ddl_category2.DataTextField = "name"
            ddl_category2.DataBind()
        End If
    End Sub

    Public Sub populateLocations()
        query = "select alias from locations where transit = 0 order by alias"
        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            ddl_locations.DataSource = ds.Tables(0)
            ddl_locations.DataValueField = "alias"
            ddl_locations.DataTextField = "alias"
            ddl_locations.DataBind()
        End If
    End Sub

    Protected Sub edit_product_Click(sender As Object, e As System.EventArgs) Handles edit_product.Click
        Dim newdescription, newmodel, newcost, newlow_inventory, newcategory, logevent, prod_alias As String
        Dim precio_juarez, precio_durango, precio_leon, precio_torreon, precio_mayoreo_juarez, precio_mayoreo_durango, precio_mayoreo_leon, dimensions As String
        Dim precio_mayoreo_torreon, precio_2_juarez, precio_3_juarez, precio_instalado_juarez, precio_dlls_juarez, accesories, install_distribution_flag As String
        Dim fuera_catalogo = chbx_fuera_catalago.Checked
        install_distribution_flag = cb_install_distribution_flag.Checked
        Dim band As Integer = 0

        Dim code As String = Replace(tbx_search.Text & "'", "'", "")
        newdescription = Replace(descriptionTB.Text, "'", "")
        newmodel = Replace(modelTB.Text, "'", "''")
        'newprice = priceTB.Text
        newcost = costTB.Text
        newlow_inventory = low_inventoryTB.Text
        newcategory = ddl_category2.SelectedValue
        dimensions = Replace(tb_dimensions.Text & "'", "'", "")
        accesories = Replace(tb_accesories.Text & "'", "'", "")

        precio_juarez = tbx_precio_juarez.Text
        precio_durango = tbx_precio_durango.Text
        precio_leon = tbx_precio_leon.Text
        precio_torreon = tbx_precio_torreon.Text
        precio_mayoreo_juarez = tbx_precio_mayoreo_juarez.Text
        precio_mayoreo_durango = tbx_precio_mayoreo_durango.Text
        precio_mayoreo_leon = tbx_precio_mayoreo_leon.Text
        precio_mayoreo_torreon = tbx_precio_mayoreo_torreon.Text
        precio_2_juarez = tbx_precio_2_juarez.Text
        precio_3_juarez = tbx_precio_3_juarez.Text
        precio_instalado_juarez = tbx_precio_instalado_juarez.Text
        precio_dlls_juarez = tbx_precio_dlls_juarez.Text
        prod_alias = tbx_alias.Text

        logevent = "Edición del producto con código: " + tbx_search.Text.ToString() + ", campos editados: "

        query = "select top 1"
        query += " description "
        query += ",category "
        query += ",cost "
        query += ",low_inventory "
        query += ",model "
        query += ",isnull(precio_juarez,0) as precio_juarez "
        query += ",isnull(precio_durango,0) as precio_durango "
        query += ",isnull(precio_leon,0) as precio_leon "
        query += ",isnull(precio_torreon,0) as precio_torreon "
        query += ",isnull(precio_mayoreo_juarez,0) as precio_mayoreo_juarez "
        query += ",isnull(precio_mayoreo_durango,0) as precio_mayoreo_durango"
        query += ",isnull(precio_mayoreo_leon,0) as precio_mayoreo_leon "
        query += ",isnull(precio_mayoreo_torreon,0) as precio_mayoreo_torreon "
        query += ",isnull(precio_2_juarez,0) as precio_2_juarez "
        query += ",isnull(precio_3_juarez,0) as precio_3_juarez "
        query += ",isnull(precio_instalado_juarez,0) as precio_instalado_juarez "
        query += ",isnull(precio_dlls_juarez,0) as precio_dlls_juarez "
        query += ",alias"
        query += ",fuera_catalogo"
        query += ",dimensions"
        query += ",accesories"
        query += ",install_distribution_flag"
        query += " from products  "
        query += " WHERE code = '" + code.ToString() + "'"

        ds = Dataconnect.GetAll(query)
        If ds.Tables(0).Rows.Count > 0 Then
            query = ""
            Dim query_stock As String = ""
            If newdescription.ToString() <> ds.Tables(0).Rows(0)("description") Then
                query += " description = '" + Replace(newdescription.ToString() & "'", "'", "") + "', "
                query_stock += " product_description = '" + Replace(newdescription.ToString() & "'", "'", "") + "', "
                logevent += "descripcion, "
                band = 1
            End If
            If newmodel.ToString() <> ds.Tables(0).Rows(0)("model") Then
                query += " model = '" + newmodel.ToString() + "', "
                query_stock += " product_model = '" + newmodel.ToString() + "', "
                logevent += "modelo, "
                band = 1
            End If
            If newcost.ToString() <> ds.Tables(0).Rows(0)("cost") Then
                query += " cost = " + newcost.ToString() + ", "

                logevent += "costo, "
                band = 1
            End If
            If newlow_inventory.ToString() <> ds.Tables(0).Rows(0)("low_inventory") Then
                query += " low_inventory = " + newlow_inventory.ToString() + ", "
                query_stock += " product_low_inventory = " + newlow_inventory.ToString() + ", "

                logevent += "inventario minimo, "
                band = 1
            End If
            If newcategory.ToString() <> ds.Tables(0).Rows(0)("category") Then
                query += " category = " + newcategory.ToString() + ", "
                query_stock += " product_category = '" + ddl_category2.SelectedItem.Text.ToString() + "', "
                logevent += "categoria, "
                band = 1
            End If

            If precio_juarez.ToString() <> ds.Tables(0).Rows(0)("precio_juarez").ToString() Then
                query += " precio_juarez = " + precio_juarez.ToString() + ", "
                logevent += "precio juarez, "
                band = 1
            End If

            If precio_2_juarez.ToString() <> ds.Tables(0).Rows(0)("precio_2_juarez").ToString() Then
                query += " precio_2_juarez = " + precio_2_juarez.ToString() + ", "
                logevent += "precio juarez 2, "
                band = 1
            End If

            If precio_3_juarez.ToString() <> ds.Tables(0).Rows(0)("precio_3_juarez").ToString() Then
                query += " precio_3_juarez = " + precio_3_juarez.ToString() + ", "
                logevent += "precio juarez 3, "
                band = 1
            End If

            If precio_dlls_juarez.ToString() <> ds.Tables(0).Rows(0)("precio_dlls_juarez").ToString() Then
                query += " precio_dlls_juarez = " + precio_dlls_juarez.ToString() + ", "

                logevent += "precio Dlls juarez, "
                band = 1
            End If

            If precio_instalado_juarez.ToString() <> ds.Tables(0).Rows(0)("precio_instalado_juarez").ToString() Then
                query += " precio_instalado_juarez = " + precio_instalado_juarez.ToString() + ", "

                logevent += "Precio Instalado Juarez, "
                band = 1
            End If

            If precio_durango.ToString() <> ds.Tables(0).Rows(0)("precio_durango").ToString() Then
                query += " precio_durango = " + precio_durango.ToString() + ", "

                logevent += "precio durango, "
                band = 1
            End If

            If precio_leon.ToString() <> ds.Tables(0).Rows(0)("precio_leon").ToString() Then
                query += " precio_leon = " + precio_leon.ToString() + ", "

                logevent += "precio leon, "
                band = 1
            End If

            If precio_torreon.ToString() <> ds.Tables(0).Rows(0)("precio_torreon").ToString() Then
                query += " precio_torreon = " + precio_torreon.ToString() + ", "

                logevent += "precio torreon, "
                band = 1
            End If

            If precio_mayoreo_juarez.ToString() <> ds.Tables(0).Rows(0)("precio_mayoreo_juarez").ToString() Then
                query += " precio_mayoreo_juarez = " + precio_mayoreo_juarez.ToString() + ", "

                logevent += "precio mayoreo juárez, "
                band = 1
            End If

            If precio_mayoreo_durango.ToString() <> ds.Tables(0).Rows(0)("precio_mayoreo_durango").ToString() Then
                query += " precio_mayoreo_durango = " + precio_mayoreo_durango.ToString() + ", "

                logevent += "precio mayoreo durango, "
                band = 1
            End If

            If precio_mayoreo_leon.ToString() <> ds.Tables(0).Rows(0)("precio_mayoreo_leon").ToString() Then
                query += " precio_mayoreo_leon = " + precio_mayoreo_leon.ToString() + ", "

                logevent += "precio mayoreo león, "
                band = 1
            End If

            If precio_mayoreo_torreon.ToString() <> ds.Tables(0).Rows(0)("precio_mayoreo_torreon").ToString() Then
                query += " precio_mayoreo_torreon = " + precio_mayoreo_torreon.ToString() + ", "

                logevent += "precio mayoreo torreón, "
                band = 1
            End If

            If prod_alias.ToString() <> ds.Tables(0).Rows(0)("alias").ToString() Then
                query += " alias = '" + prod_alias.ToString() + "', "

                logevent += "alias, "

                'Dim aliasquery As String
                'aliasquery = "update products set alias = '" + code.ToString() + " where code = '" + prod_alias.ToString() + "'"
                'Dataconnect.runquery(aliasquery)

                band = 1
            End If

            If fuera_catalogo <> ds.Tables(0).Rows(0)("fuera_catalogo") Then
                query += " fuera_catalogo = '" + fuera_catalogo.ToString() + "', "
                logevent += "fuera_catalogo, "
                band = 1
            End If

            If install_distribution_flag <> ds.Tables(0).Rows(0)("install_distribution_flag") Then
                query += " install_distribution_flag = '" + install_distribution_flag.ToString() + "', "
                logevent += "install_distribution_flag, "
                band = 1
            End If

            If dimensions.ToString() <> ds.Tables(0).Rows(0)("dimensions").ToString() Then
                query += " dimensions = " + dimensions.ToString() + ", "

                logevent += "dimensions, "
                band = 1
            End If

            If accesories.ToString() <> ds.Tables(0).Rows(0)("accesories").ToString() Then
                query += " accesories = " + accesories.ToString() + ", "

                logevent += "accesories, "
                band = 1
            End If



            logevent = logevent.Substring(0, logevent.Length - 2)

            If band <> 0 Then

                query = "update products set " + query.Substring(0, query.Length - 2) + " where code = '" + code.ToString() + "'"
                If query_stock <> "" Then
                    query += " update stock set " + query_stock.Substring(0, query_stock.Length - 2) + " where product_code = '" + code.ToString() + "'"
                End If

                Dataconnect.runquery(query)

                queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
                Dataconnect.runquery(queryLog)
                populateInfo()
                errorlbl.Text = "¡Cambios guardados!"
                errorlbl.ForeColor = Drawing.Color.Green

            Else
                errorlbl.Text = "No se realizó ningún cambio!"
            End If

        Else
            errorlbl.Text = "Ingrese el código del producto"
        End If

    End Sub

    Protected Sub btn_search_Click(sender As Object, e As EventArgs) Handles btn_search.Click
        populateInfo()
    End Sub

    Public Sub populateInfo()
        Dim code As String = Replace(tbx_search.Text & "'", "'", "").ToString()
        If code = "" Then
            errorlbl.Text = "Ingrese el codigo del producto"
            edit_product.Enabled = False
            btn_rack_edit.Enabled = False
            btn_delete_prod.Enabled = False
        Else
            img_item.ImageUrl = "~/images/tapas/" + code.ToUpper() + ".jpg"
            query = "select top 1"
            query += " code"
            query += ",description "
            query += ",category "
            query += ",cost "
            query += ",low_inventory "
            query += ",model "
            query += ",isnull(precio_juarez,0) as precio_juarez "
            query += ",isnull(precio_durango,0) as precio_durango "
            query += ",isnull(precio_leon,0) as precio_leon "
            query += ",isnull(precio_torreon,0) as precio_torreon "
            query += ",isnull(precio_mayoreo_juarez,0) as precio_mayoreo_juarez "
            query += ",isnull(precio_mayoreo_durango,0) as precio_mayoreo_durango "
            query += ",isnull(precio_mayoreo_leon,0) as precio_mayoreo_leon "
            query += ",isnull(precio_mayoreo_torreon,0) as precio_mayoreo_torreon "
            query += ",isnull(precio_2_juarez,0) as precio_2_juarez "
            query += ",isnull(precio_3_juarez,0) as precio_3_juarez "
            query += ",isnull(precio_instalado_juarez,0) as precio_instalado_juarez "
            query += ",isnull(precio_dlls_juarez,0) as precio_dlls_juarez "
            query += ",alias"
            query += ",fuera_catalogo"
            query += ",dimensions"
            query += ",accesories"
            query += ",install_distribution_flag"
            query += " from products  "
            query += " WHERE code = '" + code.ToString() + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                errorlbl.Text = ""
                codeTB.Text = ds.Tables(0).Rows(0)("code").ToString()
                descriptionTB.Text = ds.Tables(0).Rows(0)("description").ToString()
                modelTB.Text = ds.Tables(0).Rows(0)("model").ToString()
                costTB.Text = ds.Tables(0).Rows(0)("cost").ToString()
                low_inventoryTB.Text = ds.Tables(0).Rows(0)("low_inventory").ToString()
                ddl_category2.SelectedValue = ds.Tables(0).Rows(0)("category").ToString()
                chbx_fuera_catalago.Checked = ds.Tables(0).Rows(0)("fuera_catalogo")
                tbx_precio_juarez.Text = ds.Tables(0).Rows(0)("precio_juarez").ToString()
                tbx_precio_2_juarez.Text = ds.Tables(0).Rows(0)("precio_2_juarez").ToString()
                tbx_precio_3_juarez.Text = ds.Tables(0).Rows(0)("precio_3_juarez").ToString()
                tbx_precio_dlls_juarez.Text = ds.Tables(0).Rows(0)("precio_dlls_juarez").ToString()
                tbx_precio_instalado_juarez.Text = ds.Tables(0).Rows(0)("precio_instalado_juarez").ToString()
                tbx_precio_durango.Text = ds.Tables(0).Rows(0)("precio_durango").ToString()
                tbx_precio_torreon.Text = ds.Tables(0).Rows(0)("precio_torreon").ToString()
                tbx_precio_leon.Text = ds.Tables(0).Rows(0)("precio_leon").ToString()
                tbx_precio_mayoreo_juarez.Text = ds.Tables(0).Rows(0)("precio_mayoreo_juarez").ToString()
                tbx_precio_mayoreo_durango.Text = ds.Tables(0).Rows(0)("precio_mayoreo_durango").ToString()
                tbx_precio_mayoreo_leon.Text = ds.Tables(0).Rows(0)("precio_mayoreo_leon").ToString()
                tbx_precio_mayoreo_torreon.Text = ds.Tables(0).Rows(0)("precio_mayoreo_torreon").ToString()
                tbx_alias.Text = ds.Tables(0).Rows(0)("alias").ToString()
                tb_dimensions.Text = ds.Tables(0).Rows(0)("dimensions").ToString()
                tb_accesories.Text = ds.Tables(0).Rows(0)("accesories").ToString()
                cb_install_distribution_flag.Checked = ds.Tables(0).Rows(0)("install_distribution_flag")

                query = "select location as Sucursal, rack as Rack from default_locators where code = '" + code.ToString() + "'"
                ds = Dataconnect.GetAll(query)
                If ds.Tables(0).Rows.Count > 0 Then
                    gv_default_locators.DataSource = ds.Tables(0)
                    gv_default_locators.DataBind()
                    gv_default_locators.Visible = True
                Else
                    gv_default_locators.Visible = False
                End If
                edit_product.Enabled = True
                btn_rack_edit.Enabled = True
                btn_delete_prod.Enabled = True
            Else
                errorlbl.Text = "Producto inexistente"
                edit_product.Enabled = False
                btn_rack_edit.Enabled = False
                btn_delete_prod.Enabled = False
            End If
        End If
    End Sub

    Protected Sub btn_rack_edit_Click(sender As Object, e As EventArgs) Handles btn_rack_edit.Click
        Dim sucursal As String = ddl_locations.SelectedValue.ToString()
        Dim rack As String = Replace(tbx_new_rack.Text & "'", "'", "").ToUpper()
        Dim code As String = Replace(tbx_search.Text & "'", "'", "").ToUpper()
        If rack = "" Then
            errorlbl.Text = "Ingrese Rack"
        Else
            query = "select id from default_locators where location = '" + sucursal.ToString() + "' and code = '" + code.ToString() + "'"
            ds = Dataconnect.GetAll(query)
            If ds.Tables(0).Rows.Count > 0 Then
                query = "update default_locators set rack = '" + rack.ToString() + "' where id = " + ds.Tables(0).Rows(0)("id").ToString()
            Else
                query = "insert into default_locators (code, location, rack) values ('" + code.ToString() + "','" + sucursal.ToString() + "','" + rack.ToString() + "')"
            End If
            Dataconnect.runquery(query)


            Dim logevent As String = "Edicion del rack por default del producto con codigo: " + tbx_search.Text.ToString() + " valores nuevos: locacion: "
            logevent += sucursal.ToString() + ", rack: " + rack.ToString()
            queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
            Dataconnect.runquery(queryLog)
            populateInfo()
            errorlbl.Text = "cambios guardados!"
            errorlbl.ForeColor = Drawing.Color.Green
        End If

    End Sub

    Protected Sub btn_delete_prod_Click(sender As Object, e As EventArgs) Handles btn_delete_prod.Click
        Dim code As String = Replace(tbx_search.Text & "'", "'", "").ToUpper()
        
        Dim logevent As String = "Eliminacion del producto con codigo: " + code.ToString()

        queryLog = "INSERT INTO logs(user_name, event, date) VALUES ('" + username.ToString() + "', '" + logevent.ToString() + "', getDate())"
        queryLog += " delete from products where code = '" + code.ToString() + "'"
        queryLog += " delete from stock where product_code = '" + code.ToString() + "'"
        Dataconnect.runquery(queryLog)
        populateInfo()
        errorlbl.Text = "cambios guardados!"
        errorlbl.ForeColor = Drawing.Color.Green


    End Sub

End Class
